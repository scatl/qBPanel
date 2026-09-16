import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/entity/response/torrent_state.dart';
import 'package:qbpanel/detail/torrent_detail_view_model.dart';
import 'package:qbpanel/detail/trackers/add_trackers_dialog.dart';
import 'package:qbpanel/detail/trackers/torrent_trackers_view_model.dart';
import 'package:qbpanel/detail/trackers/tracker_action_dialog.dart';
import 'package:qbpanel/detail/trackers/widget/torrent_tracker_item.dart';
import 'package:qbpanel/home/list_layout_mode.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/adaptive_card_grid.dart';
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
    final width = MediaQuery.sizeOf(context).width;
    final layout = adaptiveListLayout(width);
    final isGrid = layout == ListLayoutMode.grid;

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
            child: isGrid
                ? AdaptiveCardGrid(
                    padding: EdgeInsets.fromLTRB(
                      PageInsets.horizontal,
                      0,
                      PageInsets.horizontal,
                      24 + bottomSafe,
                    ),
                    itemCount: ui.trackers.length,
                    crossAxisCount: adaptiveGridColumnCount(width),
                    itemBuilder: (context, index) {
                      final tracker = ui.trackers[index];
                      return TorrentTrackerItem(
                        key: ValueKey(tracker.url),
                        tracker: tracker,
                        layout: layout,
                        onLongPress: (position) => TrackerActionDialog.show(
                          context: context,
                          tracker: tracker,
                          viewModel: vm,
                          canReannounce: canReannounce,
                          position: position,
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 24 + bottomSafe),
                    itemCount: ui.trackers.length,
                    itemBuilder: (context, index) {
                      final tracker = ui.trackers[index];
                      return TorrentTrackerItem(
                        key: ValueKey(tracker.url),
                        tracker: tracker,
                        onLongPress: (position) => TrackerActionDialog.show(
                          context: context,
                          tracker: tracker,
                          viewModel: vm,
                          canReannounce: canReannounce,
                          position: position,
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
