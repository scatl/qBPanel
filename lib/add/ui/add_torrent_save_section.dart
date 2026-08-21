import 'package:flutter/material.dart';
import 'package:qbpanel/add/add_torrent_ui_state.dart';
import 'package:qbpanel/add/add_torrent_view_model.dart';
import 'package:qbpanel/add/ui/add_torrent_card.dart';
import 'package:qbpanel/widget/check_row.dart';

class AddTorrentSaveSection extends StatelessWidget {
  const AddTorrentSaveSection({
    super.key,
    required this.ui,
    required this.viewModel,
    required this.savePathController,
    required this.incompletePathController,
  });

  final AddTorrentUiState ui;
  final AddTorrentViewModel viewModel;
  final TextEditingController savePathController;
  final TextEditingController incompletePathController;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final autoTmm = ui.isAutoTmm;
    final incompleteEnabled = !autoTmm && ui.useIncompletePath;

    return AddTorrentCard(
      title: '保存在',
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('种子管理模式', style: textTheme.bodyMedium),
          const SizedBox(height: 8),
          SegmentedButton<TorrentManagementMode>(
            showSelectedIcon: false,
            segments: [
              for (final mode in TorrentManagementMode.values)
                ButtonSegment(value: mode, label: Text(mode.label)),
            ],
            selected: {ui.managementMode},
            onSelectionChanged: (value) =>
                viewModel.setManagementMode(value.first),
          ),
          const SizedBox(height: 16),
          Text('保存文件到', style: textTheme.bodyMedium),
          const SizedBox(height: 8),
          TextField(
            controller: savePathController,
            enabled: !autoTmm,
            minLines: 1,
            maxLines: 3,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: autoTmm ? '由自动管理决定' : '保存路径',
            ),
          ),
          CheckRow(
            label: '对不完整的种子使用另一个路径',
            value: ui.useIncompletePath,
            enabled: !autoTmm,
            onChanged: viewModel.setUseIncompletePath,
          ),
          TextField(
            controller: incompletePathController,
            enabled: incompleteEnabled,
            minLines: 1,
            maxLines: 3,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: incompleteEnabled ? '不完整种子保存路径' : '未启用',
            ),
          ),
        ],
      ),
    );
  }
}
