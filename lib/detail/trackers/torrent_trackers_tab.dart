import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/entity/response/torrent_state.dart';
import 'package:qbpanel/detail/torrent_detail_view_model.dart';
import 'package:qbpanel/detail/trackers/add_trackers_dialog.dart';
import 'package:qbpanel/detail/trackers/torrent_trackers_view_model.dart';
import 'package:qbpanel/detail/trackers/tracker_action_dialog.dart';
import 'package:qbpanel/detail/trackers/widget/torrent_tracker_item.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';
import 'package:qbpanel/widget/page_insets.dart';

class TorrentTrackersTab extends ConsumerWidget {
  const TorrentTrackersTab({super.key, required this.torrentHash});

  final String torrentHash;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(torrentTrackersProvider(torrentHash));
    final vm = ref.read(torrentTrackersProvider(torrentHash).notifier);
    final listState = ref.watch(
      torrentDetailProvider(torrentHash).select((s) => s.listState),
    );
    final canReannounce =
        listState != TorrentState.stoppedDL &&
        listState != TorrentState.stoppedUP;

    final header = _TrackersHeader(
      onAdd: () => AddTrackersDialog.show(context: context, viewModel: vm),
    );

    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        Expanded(
          child: EmptyStateHost(
            state: ui.emptyState,
            onRetry: vm.retry,
            emptyTitle: context.l10n.noTrackers,
            emptySubtitle: context.l10n.noTrackersHint,
            emptyIcon: Icons.dns_outlined,
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 24 + bottomSafe),
              itemCount: ui.trackers.length,
              itemBuilder: (context, index) {
                final tracker = ui.trackers[index];
                return TorrentTrackerItem(
                  key: ValueKey(tracker.url),
                  tracker: tracker,
                  expanded: ui.expandedUrls.contains(tracker.url),
                  onToggleExpand: () => vm.toggleExpand(tracker.url),
                  onLongPress: () => TrackerActionDialog.show(
                    context: context,
                    tracker: tracker,
                    viewModel: vm,
                    canReannounce: canReannounce,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _TrackersHeader extends StatelessWidget {
  const _TrackersHeader({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PageInsets.horizontal,
        4,
        PageInsets.horizontal,
        0,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add, size: 20),
          label: Text(context.l10n.addTracker),
        ),
      ),
    );
  }
}
