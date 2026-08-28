import 'package:flutter/material.dart';
import 'package:qbpanel/detail/content/torrent_content_node.dart';
import 'package:qbpanel/detail/content/torrent_content_view_model.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/dialog/rename_dialog.dart';

abstract final class RenameContentDialog {
  static Future<void> show({
    required BuildContext context,
    required TorrentContentViewModel viewModel,
    required TorrentContentNode node,
  }) {
    final l10n = context.l10n;
    return RenameDialog.show(
      context: context,
      initialName: node.name,
      labelText: node.isFolder ? l10n.folderName : l10n.fileName,
      description: node.isFolder
          ? l10n.renameFolderHint
          : l10n.renameFileHint,
      selectStemOnly: !node.isFolder,
      onSubmit: (name) => viewModel.rename(node, name),
    );
  }
}
