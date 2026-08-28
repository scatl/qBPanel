import 'package:flutter/material.dart';
import 'package:qbpanel/add/add_torrent_ui_state.dart';
import 'package:qbpanel/add/add_torrent_view_model.dart';
import 'package:qbpanel/add/ui/add_torrent_card.dart';
import 'package:qbpanel/detail/content/widget/torrent_content_tree.dart';
import 'package:qbpanel/l10n/context_l10n.dart';

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
      title: context.l10n.sortFiles,
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
    final l10n = context.l10n;
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
            l10n.fetchingMetadata,
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
                ? l10n.metadataFailed
                : l10n.metadataFailedWithError(ui.metadataError!),
            style: textTheme.bodyMedium?.copyWith(color: scheme.error),
          ),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: Text(l10n.actionRetry)),
        ],
      );
    }

    return Text(
      ui.hasSource ? l10n.noFiles : l10n.filesAfterImport,
      style: textTheme.bodyMedium?.copyWith(
        color: scheme.onSurfaceVariant,
      ),
    );
  }
}
