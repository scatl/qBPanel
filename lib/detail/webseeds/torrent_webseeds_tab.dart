import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/detail/webseeds/add_webseeds_dialog.dart';
import 'package:qbpanel/detail/webseeds/torrent_webseeds_view_model.dart';
import 'package:qbpanel/detail/webseeds/webseed_action_dialog.dart';
import 'package:qbpanel/detail/webseeds/widget/torrent_webseed_item.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';
import 'package:qbpanel/widget/page_insets.dart';

class TorrentWebSeedsTab extends ConsumerWidget {
  const TorrentWebSeedsTab({super.key, required this.torrentHash});

  final String torrentHash;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(torrentWebSeedsProvider(torrentHash));
    final vm = ref.read(torrentWebSeedsProvider(torrentHash).notifier);

    final header = _WebSeedsHeader(
      onAdd: () => AddWebSeedsDialog.show(context: context, viewModel: vm),
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
            emptyTitle: context.l10n.noHttpSeeds,
            emptySubtitle: context.l10n.noHttpSeedsHint,
            emptyIcon: Icons.source_outlined,
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 24 + bottomSafe),
              itemCount: ui.webSeeds.length,
              itemBuilder: (context, index) {
                final webSeed = ui.webSeeds[index];
                return TorrentWebSeedItem(
                  key: ValueKey(webSeed.url),
                  webSeed: webSeed,
                  onLongPress: () => WebSeedActionDialog.show(
                    context: context,
                    webSeed: webSeed,
                    viewModel: vm,
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

class _WebSeedsHeader extends StatelessWidget {
  const _WebSeedsHeader({required this.onAdd});

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
          label: Text(context.l10n.addHttpSeed),
        ),
      ),
    );
  }
}
