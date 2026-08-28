import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/add/add_torrent_ui_state.dart';
import 'package:qbpanel/settings/server/setting/downloads/downloads_settings_ui_state.dart';
import 'package:qbpanel/settings/server/setting/downloads/downloads_settings_view_model.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/dropdown_field.dart';
import 'package:qbpanel/settings/widget/settings_group_card.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';
import 'package:qbpanel/settings/widget/settings_nested_card.dart';
import 'package:qbpanel/settings/widget/settings_switch_tile.dart';
import 'package:qbpanel/widget/dialog/confirm_dialog.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';

/// WebUI「下载」选项。
class DownloadsSettingsPage extends ConsumerStatefulWidget {
  const DownloadsSettingsPage({
    super.key,
    required this.serverId,
  });

  final int serverId;

  @override
  ConsumerState<DownloadsSettingsPage> createState() =>
      _DownloadsSettingsPageState();
}

class _DownloadsSettingsPageState extends ConsumerState<DownloadsSettingsPage> {
  final _savePathController = TextEditingController();
  final _tempPathController = TextEditingController();
  final _exportDirController = TextEditingController();
  final _exportDirFinController = TextEditingController();
  final _excludedFileNamesController = TextEditingController();
  final _mailSenderController = TextEditingController();
  final _mailEmailController = TextEditingController();
  final _mailSmtpController = TextEditingController();
  final _mailUsernameController = TextEditingController();
  final _mailPasswordController = TextEditingController();
  final _autorunAddedController = TextEditingController();
  final _autorunFinishedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _savePathController.dispose();
    _tempPathController.dispose();
    _exportDirController.dispose();
    _exportDirFinController.dispose();
    _excludedFileNamesController.dispose();
    _mailSenderController.dispose();
    _mailEmailController.dispose();
    _mailSmtpController.dispose();
    _mailUsernameController.dispose();
    _mailPasswordController.dispose();
    _autorunAddedController.dispose();
    _autorunFinishedController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final ok = await ref.read(downloadsSettingsProvider.notifier).load();
    if (!mounted || !ok) return;
    final ui = ref.read(downloadsSettingsProvider);
    _savePathController.text = ui.savePath;
    _tempPathController.text = ui.tempPath;
    _exportDirController.text = ui.exportDir;
    _exportDirFinController.text = ui.exportDirFin;
    _excludedFileNamesController.text = ui.excludedFileNames;
    _mailSenderController.text = ui.mailNotificationSender;
    _mailEmailController.text = ui.mailNotificationEmail;
    _mailSmtpController.text = ui.mailNotificationSmtp;
    _mailUsernameController.text = ui.mailNotificationUsername;
    _mailPasswordController.text = ui.mailNotificationPassword;
    _autorunAddedController.text = ui.autorunOnTorrentAddedProgram;
    _autorunFinishedController.text = ui.autorunProgram;
  }

  void _syncTextFieldsToVm() {
    final vm = ref.read(downloadsSettingsProvider.notifier);
    vm.setSavePath(_savePathController.text);
    vm.setTempPath(_tempPathController.text);
    vm.setExportDir(_exportDirController.text);
    vm.setExportDirFin(_exportDirFinController.text);
    vm.setExcludedFileNames(_excludedFileNamesController.text);
    vm.setMailNotificationSender(_mailSenderController.text);
    vm.setMailNotificationEmail(_mailEmailController.text);
    vm.setMailNotificationSmtp(_mailSmtpController.text);
    vm.setMailNotificationUsername(_mailUsernameController.text);
    vm.setMailNotificationPassword(_mailPasswordController.text);
    vm.setAutorunOnTorrentAddedProgram(_autorunAddedController.text);
    vm.setAutorunProgram(_autorunFinishedController.text);
  }

  Future<void> _onSave() async {
    FocusScope.of(context).unfocus();
    final ui = ref.read(downloadsSettingsProvider);
    if (!ui.ready || ui.saving || ui.testingEmail) return;

    _syncTextFieldsToVm();
    LoadingDialog.show(context, message: context.l10n.saving);
    await Future<void>.delayed(Duration.zero);

    final error = await ref.read(downloadsSettingsProvider.notifier).save();
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error == null ? context.l10n.saved : context.l10n.saveFailed(error))),
    );
  }

  Future<void> _onSendTestEmail() async {
    FocusScope.of(context).unfocus();
    final ui = ref.read(downloadsSettingsProvider);
    if (!ui.ready || ui.saving || ui.testingEmail) return;

    final confirmed = await ConfirmDialog.show(
      context,
      title: context.l10n.sendTestEmail,
      message: context.l10n.confirmSendTestEmail,
      confirmText: context.l10n.actionSend,
    );
    if (confirmed != true || !mounted) return;

    _syncTextFieldsToVm();
    LoadingDialog.show(context, message: context.l10n.sending);
    await Future<void>.delayed(Duration.zero);

    final error =
        await ref.read(downloadsSettingsProvider.notifier).sendTestEmail();
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error == null ? context.l10n.testEmailSent : context.l10n.sendFailed(error)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(downloadsSettingsProvider);
    final vm = ref.read(downloadsSettingsProvider.notifier);
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;
    final canEdit = ui.ready && !ui.saving && !ui.testingEmail;
    final mailEnabled = ui.mailNotificationEnabled;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.qbSetDownloads),
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
                      title: context.l10n.whenAddingTorrent,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DropdownField<TorrentContentLayout>(
                            label: context.l10n.torrentContentLayout,
                            value: ui.contentLayout,
                            enabled: canEdit,
                            items: [
                              for (final item in TorrentContentLayout.values)
                                DropdownMenuItem(
                                  value: item,
                                  child: Text(item.label(context.l10n)),
                                ),
                            ],
                            onChanged: vm.setContentLayout,
                          ),
                          SettingsSwitchTile(
                            title: context.l10n.addToTopOfQueue,
                            value: ui.addToTopOfQueue,
                            onChanged: canEdit ? vm.setAddToTopOfQueue : null,
                          ),
                          SettingsSwitchTile(
                            title: context.l10n.doNotStartDownload,
                            value: ui.addStoppedEnabled,
                            onChanged:
                                canEdit ? vm.setAddStoppedEnabled : null,
                          ),
                          DropdownField<TorrentStopCondition>(
                            label: context.l10n.torrentStopCondition,
                            value: ui.stopCondition,
                            enabled: canEdit,
                            items: [
                              for (final item in TorrentStopCondition.values)
                                DropdownMenuItem(
                                  value: item,
                                  child: Text(item.label(context.l10n)),
                                ),
                            ],
                            onChanged: vm.setStopCondition,
                          ),
                          SettingsNestedCard(
                            title: context.l10n.whenDuplicateTorrent,
                            child: Column(
                              children: [
                                SettingsSwitchTile(
                                  title: context.l10n.mergeTrackers,
                                  value: ui.mergeTrackers,
                                  onChanged:
                                      canEdit ? vm.setMergeTrackers : null,
                                ),
                                SettingsSwitchTile(
                                  title: context.l10n.deleteTorrentFileWhenDone,
                                  value: ui.autoDeleteTorrentFile,
                                  onChanged: canEdit
                                      ? vm.setAutoDeleteTorrentFile
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Column(
                        children: [
                          SettingsSwitchTile(
                            title: context.l10n.preallocateAll,
                            value: ui.preallocateAll,
                            onChanged: canEdit ? vm.setPreallocateAll : null,
                          ),
                          SettingsSwitchTile(
                            title: context.l10n.appendIncompleteExt,
                            value: ui.incompleteFilesExt,
                            onChanged:
                                canEdit ? vm.setIncompleteFilesExt : null,
                          ),
                          SettingsSwitchTile(
                            title: context.l10n.keepUnwantedInFolder,
                            value: ui.useUnwantedFolder,
                            onChanged:
                                canEdit ? vm.setUseUnwantedFolder : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      title: context.l10n.saveManagement,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DropdownField<bool>(
                            label: context.l10n.defaultTmmMode,
                            value: ui.autoTmmEnabled,
                            enabled: canEdit,
                            items: [
                              DropdownMenuItem(
                                value: false,
                                child: Text(context.l10n.addModeManual),
                              ),
                              DropdownMenuItem(
                                value: true,
                                child: Text(context.l10n.addModeAutomatic),
                              ),
                            ],
                            onChanged: vm.setAutoTmmEnabled,
                          ),
                          DropdownField<bool>(
                            label: context.l10n.whenTorrentCategoryChanged,
                            value: ui.torrentChangedTmmEnabled,
                            enabled: canEdit,
                            items: [
                              for (final item in DownloadsTmmAction.values)
                                DropdownMenuItem(
                                  value: item.apiValue,
                                  child: Text(item.torrentLabel(context.l10n)),
                                ),
                            ],
                            onChanged: vm.setTorrentChangedTmmEnabled,
                          ),
                          DropdownField<bool>(
                            label: context.l10n.whenDefaultSavePathChanged,
                            value: ui.savePathChangedTmmEnabled,
                            enabled: canEdit,
                            items: [
                              for (final item in DownloadsTmmAction.values)
                                DropdownMenuItem(
                                  value: item.apiValue,
                                  child: Text(item.affectedLabel(context.l10n)),
                                ),
                            ],
                            onChanged: vm.setSavePathChangedTmmEnabled,
                          ),
                          DropdownField<bool>(
                            label: context.l10n.whenCategorySavePathChanged,
                            value: ui.categoryChangedTmmEnabled,
                            enabled: canEdit,
                            items: [
                              for (final item in DownloadsTmmAction.values)
                                DropdownMenuItem(
                                  value: item.apiValue,
                                  child: Text(item.affectedLabel(context.l10n)),
                                ),
                            ],
                            onChanged: vm.setCategoryChangedTmmEnabled,
                          ),
                          SettingsSwitchTile(
                            title: context.l10n.useCategoryPathsInManualMode,
                            value: ui.useCategoryPathsInManualMode,
                            onChanged: canEdit
                                ? vm.setUseCategoryPathsInManualMode
                                : null,
                          ),
                          TextField(
                            controller: _savePathController,
                            enabled: canEdit,
                            minLines: 1,
                            maxLines: 3,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: context.l10n.defaultSavePath,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SettingsSwitchTile(
                            title: context.l10n.saveIncompleteTorrentsTo,
                            value: ui.tempPathEnabled,
                            onChanged: canEdit ? vm.setTempPathEnabled : null,
                          ),
                          TextField(
                            controller: _tempPathController,
                            enabled: canEdit && ui.tempPathEnabled,
                            minLines: 1,
                            maxLines: 3,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 8),
                          SettingsSwitchTile(
                            title: context.l10n.copyTorrentFilesTo,
                            value: ui.exportDirEnabled,
                            onChanged: canEdit ? vm.setExportDirEnabled : null,
                          ),
                          TextField(
                            controller: _exportDirController,
                            enabled: canEdit && ui.exportDirEnabled,
                            minLines: 1,
                            maxLines: 3,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 8),
                          SettingsSwitchTile(
                            title: context.l10n.copyFinishedTorrentFilesTo,
                            value: ui.exportDirFinEnabled,
                            onChanged:
                                canEdit ? vm.setExportDirFinEnabled : null,
                          ),
                          TextField(
                            controller: _exportDirFinController,
                            enabled: canEdit && ui.exportDirFinEnabled,
                            minLines: 1,
                            maxLines: 3,
                            textInputAction: TextInputAction.next,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SettingsSwitchTile(
                            title: context.l10n.excludedFileNames,
                            value: ui.excludedFileNamesEnabled,
                            onChanged: canEdit
                                ? vm.setExcludedFileNamesEnabled
                                : null,
                          ),
                          TextField(
                            controller: _excludedFileNamesController,
                            enabled: canEdit && ui.excludedFileNamesEnabled,
                            minLines: 4,
                            maxLines: 8,
                            decoration: InputDecoration(
                              hintText: context.l10n.oneRulePerLine,
                              alignLabelWithHint: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SettingsSwitchTile(
                            title: context.l10n.emailOnTorrentCompletion,
                            value: ui.mailNotificationEnabled,
                            onChanged: canEdit
                                ? vm.setMailNotificationEnabled
                                : null,
                          ),
                          TextField(
                            controller: _mailSenderController,
                            enabled: canEdit && mailEnabled,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: context.l10n.mailSender,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _mailEmailController,
                            enabled: canEdit && mailEnabled,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: context.l10n.mailRecipient,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _mailSmtpController,
                            enabled: canEdit && mailEnabled,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: context.l10n.smtpServer,
                              hintText: 'smtp.example.com:465',
                            ),
                          ),
                          SettingsSwitchTile(
                            title: context.l10n.smtpRequiresSsl,
                            value: ui.mailNotificationSslEnabled,
                            onChanged: canEdit && mailEnabled
                                ? vm.setMailNotificationSslEnabled
                                : null,
                          ),
                          SettingsNestedCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SettingsSwitchTile(
                                  title: context.l10n.authentication,
                                  value: ui.mailNotificationAuthEnabled,
                                  onChanged: canEdit && mailEnabled
                                      ? vm.setMailNotificationAuthEnabled
                                      : null,
                                ),
                                TextField(
                                  controller: _mailUsernameController,
                                  enabled: canEdit &&
                                      mailEnabled &&
                                      ui.mailNotificationAuthEnabled,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: context.l10n.username,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _mailPasswordController,
                                  enabled: canEdit &&
                                      mailEnabled &&
                                      ui.mailNotificationAuthEnabled,
                                  obscureText: true,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    labelText: context.l10n.password,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FilledButton.tonal(
                              onPressed: canEdit && mailEnabled
                                  ? _onSendTestEmail
                                  : null,
                              child: Text(context.l10n.sendTestEmail),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      title: context.l10n.runExternalProgram,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SettingsSwitchTile(
                            title: context.l10n.runOnTorrentAdded,
                            value: ui.autorunOnTorrentAddedEnabled,
                            onChanged: canEdit
                                ? vm.setAutorunOnTorrentAddedEnabled
                                : null,
                          ),
                          TextField(
                            controller: _autorunAddedController,
                            enabled:
                                canEdit && ui.autorunOnTorrentAddedEnabled,
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: context.l10n.autorunExampleHint,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SettingsSwitchTile(
                            title: context.l10n.runOnTorrentFinished,
                            value: ui.autorunEnabled,
                            onChanged: canEdit ? vm.setAutorunEnabled : null,
                          ),
                          TextField(
                            controller: _autorunFinishedController,
                            enabled: canEdit && ui.autorunEnabled,
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: context.l10n.autorunExampleHint,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            context.l10n.autorunParametersHint,
                            style: textTheme.bodySmall?.copyWith(
                              color: scheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
