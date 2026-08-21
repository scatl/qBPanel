import 'package:flutter/material.dart';
import 'package:qbpanel/detail/content/torrent_content_node.dart';
import 'package:qbpanel/detail/content/torrent_content_view_model.dart';
import 'package:qbpanel/widget/dialog/rename_dialog.dart';

abstract final class RenameContentDialog {
  static Future<void> show({
    required BuildContext context,
    required TorrentContentViewModel viewModel,
    required TorrentContentNode node,
  }) {
    return RenameDialog.show(
      context: context,
      initialName: node.name,
      labelText: node.isFolder ? '文件夹名称' : '文件名称',
      description: node.isFolder
          ? '修改的是服务器上这个文件夹的名称，其中的文件路径会一起变更。'
          : '修改的是服务器上这个文件的名称，磁盘路径会一起变更。',
      selectStemOnly: !node.isFolder,
      onSubmit: (name) => viewModel.rename(node, name),
    );
  }
}
