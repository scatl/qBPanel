import 'package:flutter/material.dart';
import 'package:qbpanel/add/add_torrent_ui_state.dart';
import 'package:qbpanel/add/add_torrent_view_model.dart';
import 'package:qbpanel/add/ui/add_torrent_card.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
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
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final autoTmm = ui.isAutoTmm;
    final incompleteEnabled = !autoTmm && ui.useIncompletePath;

    return AddTorrentCard(
      title: l10n.saveTo,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.torrentManagementMode, style: textTheme.bodyMedium),
          const SizedBox(height: 8),
          SegmentedButton<TorrentManagementMode>(
            showSelectedIcon: false,
            segments: [
              for (final mode in TorrentManagementMode.values)
                ButtonSegment(value: mode, label: Text(mode.label(context.l10n))),
            ],
            selected: {ui.managementMode},
            onSelectionChanged: (value) =>
                viewModel.setManagementMode(value.first),
          ),
          const SizedBox(height: 16),
          Text(l10n.saveFilesTo, style: textTheme.bodyMedium),
          const SizedBox(height: 8),
          TextField(
            controller: savePathController,
            enabled: !autoTmm,
            minLines: 1,
            maxLines: 3,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: autoTmm ? l10n.autoTmmDecides : l10n.savePath,
            ),
          ),
          CheckRow(
            label: l10n.incompleteTorrentPath,
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
              hintText: incompleteEnabled
                  ? l10n.incompleteSavePath
                  : l10n.notEnabled,
            ),
          ),
        ],
      ),
    );
  }
}
