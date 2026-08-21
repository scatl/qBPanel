import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qbpanel/add/add_torrent_ui_state.dart';
import 'package:qbpanel/add/add_torrent_view_model.dart';
import 'package:qbpanel/add/ui/add_torrent_card.dart';
import 'package:qbpanel/widget/check_row.dart';
import 'package:qbpanel/widget/dropdown_field.dart';

class AddTorrentSettingsSection extends StatelessWidget {
  const AddTorrentSettingsSection({
    super.key,
    required this.ui,
    required this.viewModel,
    required this.renameController,
    required this.dlLimitController,
    required this.upLimitController,
    required this.categories,
    required this.tags,
  });

  final AddTorrentUiState ui;
  final AddTorrentViewModel viewModel;
  final TextEditingController renameController;
  final TextEditingController dlLimitController;
  final TextEditingController upLimitController;
  final List<String> categories;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return AddTorrentCard(
      title: '种子设置',
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: renameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: '重命名',
              hintText: '可选',
            ),
          ),
          const SizedBox(height: 16),
          Text('分类', style: textTheme.bodyMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('未分类'),
                selected: ui.category.isEmpty,
                onSelected: (_) => viewModel.setCategory(''),
              ),
              for (final name in categories)
                FilterChip(
                  label: Text(name),
                  selected: ui.category == name,
                  onSelected: (selected) {
                    viewModel.setCategory(selected ? name : '');
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text('标签', style: textTheme.bodyMedium),
          const SizedBox(height: 8),
          if (tags.isEmpty)
            Text(
              '暂无标签',
              style: textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final name in tags)
                  FilterChip(
                    label: Text(name),
                    selected: ui.selectedTags.contains(name),
                    onSelected: (_) => viewModel.toggleTag(name),
                  ),
              ],
            ),
          const SizedBox(height: 8),
          DropdownField<TorrentContentLayout>(
            label: '内容布局',
            value: ui.contentLayout,
            items: [
              for (final item in TorrentContentLayout.values)
                DropdownMenuItem(value: item, child: Text(item.label)),
            ],
            onChanged: viewModel.setContentLayout,
          ),
          DropdownField<TorrentStopCondition>(
            label: '停止条件',
            value: ui.stopCondition,
            items: [
              for (final item in TorrentStopCondition.values)
                DropdownMenuItem(value: item, child: Text(item.label)),
            ],
            onChanged: viewModel.setStopCondition,
          ),
          CheckRow(
            label: '开始 Torrent',
            value: ui.startTorrent,
            onChanged: viewModel.setStartTorrent,
          ),
          CheckRow(
            label: '添加到队列顶部',
            value: ui.addToTopOfQueue,
            onChanged: viewModel.setAddToTopOfQueue,
          ),
          CheckRow(
            label: '跳过哈希校验',
            value: ui.skipHashCheck,
            onChanged: viewModel.setSkipHashCheck,
          ),
          CheckRow(
            label: '按顺序下载',
            value: ui.sequentialDownload,
            onChanged: viewModel.setSequentialDownload,
          ),
          CheckRow(
            label: '先下载首尾文件块',
            value: ui.firstLastPiecePrio,
            onChanged: viewModel.setFirstLastPiecePrio,
          ),
          CheckRow(
            label: '限制下载速率',
            value: ui.limitDownloadRate,
            onChanged: viewModel.setLimitDownloadRate,
          ),
          if (ui.limitDownloadRate)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextField(
                controller: dlLimitController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: '下载限速',
                  suffixText: 'KiB/s',
                ),
              ),
            ),
          CheckRow(
            label: '限制上传速率',
            value: ui.limitUploadRate,
            onChanged: viewModel.setLimitUploadRate,
          ),
          if (ui.limitUploadRate)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextField(
                controller: upLimitController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: '上传限速',
                  suffixText: 'KiB/s',
                ),
              ),
            )
        ],
      ),
    );
  }
}
