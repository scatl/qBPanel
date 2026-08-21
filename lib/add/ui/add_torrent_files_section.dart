import 'package:flutter/material.dart';
import 'package:qbpanel/add/add_torrent_ui_state.dart';
import 'package:qbpanel/add/add_torrent_view_model.dart';
import 'package:qbpanel/add/ui/add_torrent_card.dart';
import 'package:qbpanel/detail/content/widget/torrent_content_tree.dart';

class AddTorrentFilesSection extends StatelessWidget {
  const AddTorrentFilesSection({
    super.key,
    required this.ui,
    required this.viewModel,
    this.onRetry,
  });

  final AddTorrentUiState ui;
  final AddTorrentViewModel viewModel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final hasFiles = ui.fileRoots.isNotEmpty;
    return AddTorrentCard(
      title: '文件',
      wrapInCard: !hasFiles,
      padding: hasFiles ? null : const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: hasFiles
          ? TorrentContentTree(
              roots: ui.fileRoots,
              collapsedPaths: ui.collapsedPaths,
              showTransferStats: false,
              onToggle: viewModel.toggleExpand,
              onPriorityChanged: viewModel.setFilePriority,
            )
          : _placeholder(context),
    );
  }

  Widget _placeholder(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (ui.isMetadataLoading) {
      return Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text(
            '正在获取元数据…',
            style: textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    }

    if (ui.metadataStatus == AddTorrentMetadataStatus.failed) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ui.metadataError == null
                ? '获取元数据失败'
                : '获取元数据失败：${ui.metadataError}',
            style: textTheme.bodyMedium?.copyWith(color: scheme.error),
          ),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('重试')),
        ],
      );
    }

    return Text(
      ui.hasSource ? '暂无文件' : '导入种子后显示文件列表',
      style: textTheme.bodyMedium?.copyWith(
        color: scheme.onSurfaceVariant,
      ),
    );
  }
}
