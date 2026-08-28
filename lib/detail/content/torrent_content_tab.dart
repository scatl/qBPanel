import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/detail/content/rename_content_dialog.dart';
import 'package:qbpanel/detail/content/torrent_content_node.dart';
import 'package:qbpanel/detail/content/torrent_content_view_model.dart';
import 'package:qbpanel/detail/content/widget/torrent_content_tree.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';

class TorrentContentTab extends ConsumerWidget {
  const TorrentContentTab({super.key, required this.torrentHash});

  final String torrentHash;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(torrentContentProvider(torrentHash));
    final vm = ref.read(torrentContentProvider(torrentHash).notifier);

    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;
    return EmptyStateHost(
      state: ui.emptyState,
      onRetry: vm.retry,
      emptyTitle: context.l10n.noFiles,
      emptySubtitle: context.l10n.noFilesHint,
      emptyIcon: Icons.folder_off_outlined,
      child: ListView(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 24 + bottomSafe),
        children: [
          TorrentContentTree(
            roots: ui.roots,
            collapsedPaths: ui.collapsedPaths,
            onToggle: vm.toggleExpand,
            onPriorityChanged: (node, priority) =>
                _setPriority(context, vm, node, priority),
            onLongPress: (node) => RenameContentDialog.show(
              context: context,
              viewModel: vm,
              node: node,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _setPriority(
  BuildContext context,
  TorrentContentViewModel vm,
  TorrentContentNode node,
  int priority,
) async {
  final error = await vm.setPriority(node, priority);
  if (error == null || !context.mounted) return;
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(context.l10n.priorityFailed(error))));
}
