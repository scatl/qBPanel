import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/settings/server/setting/behavior/behavior_settings_ui_state.dart';
import 'package:qbpanel/settings/server/setting/behavior/behavior_settings_view_model.dart';
import 'package:qbpanel/widget/dropdown_field.dart';
import 'package:qbpanel/settings/widget/settings_group_card.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';
import 'package:qbpanel/settings/widget/settings_switch_tile.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';

/// WebUI「行为」选项。
class BehaviorSettingsPage extends ConsumerStatefulWidget {
  const BehaviorSettingsPage({
    super.key,
    required this.serverId,
  });

  final int serverId;

  @override
  ConsumerState<BehaviorSettingsPage> createState() =>
      _BehaviorSettingsPageState();
}

class _BehaviorSettingsPageState extends ConsumerState<BehaviorSettingsPage> {
  final _fileLogPathController = TextEditingController();
  final _fileLogMaxSizeController = TextEditingController();
  final _fileLogAgeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _fileLogPathController.dispose();
    _fileLogMaxSizeController.dispose();
    _fileLogAgeController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final ok = await ref.read(behaviorSettingsProvider.notifier).load();
    if (!mounted || !ok) return;
    final ui = ref.read(behaviorSettingsProvider);
    _fileLogPathController.text = ui.fileLogPath;
    _fileLogMaxSizeController.text = '${ui.fileLogMaxSize}';
    _fileLogAgeController.text = '${ui.fileLogAge}';
  }

  Future<void> _onSave() async {
    FocusScope.of(context).unfocus();
    final ui = ref.read(behaviorSettingsProvider);
    if (!ui.ready || ui.saving) return;

    final vm = ref.read(behaviorSettingsProvider.notifier);
    vm.setFileLogPath(_fileLogPathController.text);
    vm.setFileLogMaxSizeText(_fileLogMaxSizeController.text);
    vm.setFileLogAgeText(_fileLogAgeController.text);

    LoadingDialog.show(context, message: context.l10n.saving);
    await Future<void>.delayed(Duration.zero);

    final error = await vm.save();

    if (!mounted) return;
    LoadingDialog.dismiss(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error == null ? context.l10n.saved : context.l10n.saveFailed(error)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(behaviorSettingsProvider);
    final vm = ref.read(behaviorSettingsProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;
    final logEnabled = ui.fileLogEnabled;
    final canEdit = ui.ready && !ui.saving;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.qbSetBehavior),
        actions: [
          IconButton(
            tooltip: context.l10n.actionSave,
            icon: const Icon(Icons.save),
            onPressed: canEdit ? _onSave : null,
          ),
        ],
      ),
      body: EmptyStateHost(
        state: ui.emptyState,
        onRetry: _load,
        padding: const EdgeInsets.all(24),
        builder: (context) => ListView(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 24 + bottomSafe),
                  children: [
                    SettingsGroupCard(
                      title: context.l10n.settingsLanguage,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: DropdownField<String>(
                        label: context.l10n.qbWebUiLanguage,
                        value: ui.locale,
                        enabled: canEdit,
                        items: [
                          if (!BehaviorLocaleOption.contains(ui.locale))
                            DropdownMenuItem(
                              value: ui.locale,
                              child: Text(ui.locale),
                            ),
                          for (final item in BehaviorLocaleOption.options)
                            DropdownMenuItem(
                              value: item.code,
                              child: Text(item.label),
                            ),
                        ],
                        onChanged: vm.setLocale,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      title: context.l10n.transferList,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: SettingsSwitchTile(
                        title: context.l10n.confirmTorrentDeletion,
                        value: ui.confirmTorrentDeletion,
                        onChanged:
                            canEdit ? vm.setConfirmTorrentDeletion : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: SettingsSwitchTile(
                        title: context.l10n.showExternalIp,
                        value: ui.statusBarExternalIp,
                        onChanged: canEdit ? vm.setStatusBarExternalIp : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      title: context.l10n.logFile,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SettingsSwitchTile(
                            title: context.l10n.enableLogFile,
                            value: ui.fileLogEnabled,
                            onChanged: canEdit ? vm.setFileLogEnabled : null,
                          ),
                          TextField(
                            controller: _fileLogPathController,
                            enabled: canEdit && logEnabled,
                            minLines: 1,
                            maxLines: 3,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: context.l10n.savePath,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SettingsSwitchTile(
                            title: context.l10n.backupLogWhenLarger,
                            value: ui.fileLogBackupEnabled,
                            onChanged: canEdit && logEnabled
                                ? vm.setFileLogBackupEnabled
                                : null,
                          ),
                          TextField(
                            controller: _fileLogMaxSizeController,
                            enabled: canEdit &&
                                logEnabled &&
                                ui.fileLogBackupEnabled,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              suffixText: 'KiB',
                            ),
                          ),
                          const SizedBox(height: 8),
                          SettingsSwitchTile(
                            title: context.l10n.deleteOldBackupLogs,
                            value: ui.fileLogDeleteOld,
                            onChanged: canEdit && logEnabled
                                ? vm.setFileLogDeleteOld
                                : null,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _fileLogAgeController,
                                  enabled: canEdit &&
                                      logEnabled &&
                                      ui.fileLogDeleteOld,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    labelText: context.l10n.logAge,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<BehaviorLogAgeType>(
                                  value: ui.fileLogAgeType,
                                  isDense: true,
                                  menuMaxHeight: 360,
                                  borderRadius: BorderRadius.circular(8),
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: scheme.onSurface,
                                  ),
                                  items: [
                                    for (final item
                                        in BehaviorLogAgeType.values)
                                      DropdownMenuItem(
                                        value: item,
                                        child: Text(item.label(context.l10n)),
                                      ),
                                  ],
                                  onChanged: canEdit &&
                                          logEnabled &&
                                          ui.fileLogDeleteOld
                                      ? (value) {
                                          if (value == null) return;
                                          vm.setFileLogAgeType(value);
                                        }
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: SettingsSwitchTile(
                        title: context.l10n.logPerformanceWarning,
                        value: ui.performanceWarning,
                        onChanged: canEdit ? vm.setPerformanceWarning : null,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
