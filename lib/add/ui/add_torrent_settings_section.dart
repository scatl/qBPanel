import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qbpanel/add/add_torrent_ui_state.dart';
import 'package:qbpanel/add/add_torrent_view_model.dart';
import 'package:qbpanel/add/ui/add_torrent_card.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
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
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return AddTorrentCard(
      title: l10n.addTorrentSettings,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: renameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: l10n.renameTitle,
              hintText: l10n.optional,
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.category, style: textTheme.bodyMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: Text(l10n.filterUncategorized),
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
          Text(l10n.tags, style: textTheme.bodyMedium),
          const SizedBox(height: 8),
          if (tags.isEmpty)
            Text(
              l10n.noTags,
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
            label: l10n.contentLayout,
            value: ui.contentLayout,
            items: [
              for (final item in TorrentContentLayout.values)
                DropdownMenuItem(value: item, child: Text(item.label(context.l10n))),
            ],
            onChanged: viewModel.setContentLayout,
          ),
          DropdownField<TorrentStopCondition>(
            label: l10n.stopCondition,
            value: ui.stopCondition,
            items: [
              for (final item in TorrentStopCondition.values)
                DropdownMenuItem(value: item, child: Text(item.label(context.l10n))),
            ],
            onChanged: viewModel.setStopCondition,
          ),
          CheckRow(
            label: l10n.startTorrent,
            value: ui.startTorrent,
            onChanged: viewModel.setStartTorrent,
          ),
          CheckRow(
            label: l10n.addToTopOfQueue,
            value: ui.addToTopOfQueue,
            onChanged: viewModel.setAddToTopOfQueue,
          ),
          CheckRow(
            label: l10n.skipHashCheck,
            value: ui.skipHashCheck,
            onChanged: viewModel.setSkipHashCheck,
          ),
          CheckRow(
            label: l10n.sequentialDownload,
            value: ui.sequentialDownload,
            onChanged: viewModel.setSequentialDownload,
          ),
          CheckRow(
            label: l10n.firstLastPiece,
            value: ui.firstLastPiecePrio,
            onChanged: viewModel.setFirstLastPiecePrio,
          ),
          CheckRow(
            label: l10n.limitDownloadRate,
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
                decoration: InputDecoration(
                  hintText: l10n.ssDlRateLimit,
                  suffixText: 'KiB/s',
                ),
              ),
            ),
          CheckRow(
            label: l10n.limitUploadRate,
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
                decoration: InputDecoration(
                  hintText: l10n.ssUpRateLimit,
                  suffixText: 'KiB/s',
                ),
              ),
            )
        ],
      ),
    );
  }
}
