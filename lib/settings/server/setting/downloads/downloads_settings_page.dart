import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/add/add_torrent_ui_state.dart';
import 'package:qbpanel/settings/server/setting/downloads/downloads_settings_ui_state.dart';
import 'package:qbpanel/settings/server/setting/downloads/downloads_settings_view_model.dart';
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
    LoadingDialog.show(context, message: '保存中…');
    await Future<void>.delayed(Duration.zero);

    final error = await ref.read(downloadsSettingsProvider.notifier).save();
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error == null ? '已保存' : '保存失败：$error')),
    );
  }

  Future<void> _onSendTestEmail() async {
    FocusScope.of(context).unfocus();
    final ui = ref.read(downloadsSettingsProvider);
    if (!ui.ready || ui.saving || ui.testingEmail) return;

    final confirmed = await ConfirmDialog.show(
      context,
      title: '发送测试邮件',
      message: '测试邮件会使用服务器已保存的邮件设置发送。'
          '继续前将先保存当前本页设置（含邮件相关项），确定继续吗？',
      confirmText: '发送',
    );
    if (confirmed != true || !mounted) return;

    _syncTextFieldsToVm();
    LoadingDialog.show(context, message: '发送中…');
    await Future<void>.delayed(Duration.zero);

    final error =
        await ref.read(downloadsSettingsProvider.notifier).sendTestEmail();
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error == null ? '测试邮件已发送' : '发送失败：$error'),
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
        title: const Text('下载'),
        actions: [
          IconButton(
            tooltip: '保存',
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
                      title: '添加 torrent 时',
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DropdownField<TorrentContentLayout>(
                            label: 'Torrent 内容布局',
                            value: ui.contentLayout,
                            enabled: canEdit,
                            items: [
                              for (final item in TorrentContentLayout.values)
                                DropdownMenuItem(
                                  value: item,
                                  child: Text(item.label),
                                ),
                            ],
                            onChanged: vm.setContentLayout,
                          ),
                          SettingsSwitchTile(
                            title: '添加到队列顶部',
                            value: ui.addToTopOfQueue,
                            onChanged: canEdit ? vm.setAddToTopOfQueue : null,
                          ),
                          SettingsSwitchTile(
                            title: '不要自动开始下载',
                            value: ui.addStoppedEnabled,
                            onChanged:
                                canEdit ? vm.setAddStoppedEnabled : null,
                          ),
                          DropdownField<TorrentStopCondition>(
                            label: 'Torrent 停止条件',
                            value: ui.stopCondition,
                            enabled: canEdit,
                            items: [
                              for (final item in TorrentStopCondition.values)
                                DropdownMenuItem(
                                  value: item,
                                  child: Text(item.label),
                                ),
                            ],
                            onChanged: vm.setStopCondition,
                          ),
                          SettingsNestedCard(
                            title: '添加重复种子时',
                            child: Column(
                              children: [
                                SettingsSwitchTile(
                                  title: '合并 tracker 到现有 torrent',
                                  value: ui.mergeTrackers,
                                  onChanged:
                                      canEdit ? vm.setMergeTrackers : null,
                                ),
                                SettingsSwitchTile(
                                  title: '完成后删除 .torrent 文件',
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
                            title: '为所有文件预分配磁盘空间',
                            value: ui.preallocateAll,
                            onChanged: canEdit ? vm.setPreallocateAll : null,
                          ),
                          SettingsSwitchTile(
                            title: '为不完整的文件添加扩展名 .!qB',
                            value: ui.incompleteFilesExt,
                            onChanged:
                                canEdit ? vm.setIncompleteFilesExt : null,
                          ),
                          SettingsSwitchTile(
                            title: '将未选中的文件保留在 ".unwanted" 文件夹中',
                            value: ui.useUnwantedFolder,
                            onChanged:
                                canEdit ? vm.setUseUnwantedFolder : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      title: '保存管理',
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DropdownField<bool>(
                            label: '默认 Torrent 管理模式',
                            value: ui.autoTmmEnabled,
                            enabled: canEdit,
                            items: const [
                              DropdownMenuItem(
                                value: false,
                                child: Text('手动'),
                              ),
                              DropdownMenuItem(
                                value: true,
                                child: Text('自动'),
                              ),
                            ],
                            onChanged: vm.setAutoTmmEnabled,
                          ),
                          DropdownField<bool>(
                            label: '当 Torrent 分类修改时',
                            value: ui.torrentChangedTmmEnabled,
                            enabled: canEdit,
                            items: [
                              for (final item in DownloadsTmmAction.values)
                                DropdownMenuItem(
                                  value: item.apiValue,
                                  child: Text(item.torrentLabel),
                                ),
                            ],
                            onChanged: vm.setTorrentChangedTmmEnabled,
                          ),
                          DropdownField<bool>(
                            label: '当默认保存路径修改时',
                            value: ui.savePathChangedTmmEnabled,
                            enabled: canEdit,
                            items: [
                              for (final item in DownloadsTmmAction.values)
                                DropdownMenuItem(
                                  value: item.apiValue,
                                  child: Text(item.affectedLabel),
                                ),
                            ],
                            onChanged: vm.setSavePathChangedTmmEnabled,
                          ),
                          DropdownField<bool>(
                            label: '当分类保存路径修改时',
                            value: ui.categoryChangedTmmEnabled,
                            enabled: canEdit,
                            items: [
                              for (final item in DownloadsTmmAction.values)
                                DropdownMenuItem(
                                  value: item.apiValue,
                                  child: Text(item.affectedLabel),
                                ),
                            ],
                            onChanged: vm.setCategoryChangedTmmEnabled,
                          ),
                          SettingsSwitchTile(
                            title: '在手动模式下使用分类路径',
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
                            decoration: const InputDecoration(
                              labelText: '默认保存路径',
                            ),
                          ),
                          const SizedBox(height: 8),
                          SettingsSwitchTile(
                            title: '保存未完成的 torrent 到',
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
                            title: '复制 .torrent 文件到',
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
                            title: '复制下载完成的 .torrent 文件到',
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
                            title: '排除的文件名',
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
                            decoration: const InputDecoration(
                              hintText: '每行一个规则',
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
                            title: '下载完成时发送电子邮件通知',
                            value: ui.mailNotificationEnabled,
                            onChanged: canEdit
                                ? vm.setMailNotificationEnabled
                                : null,
                          ),
                          TextField(
                            controller: _mailSenderController,
                            enabled: canEdit && mailEnabled,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: '发件人',
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _mailEmailController,
                            enabled: canEdit && mailEnabled,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: '收件人',
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _mailSmtpController,
                            enabled: canEdit && mailEnabled,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'SMTP 服务器',
                              hintText: 'smtp.example.com:465',
                            ),
                          ),
                          SettingsSwitchTile(
                            title: '该服务器需要安全链接（SSL）',
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
                                  title: '验证',
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
                                  decoration: const InputDecoration(
                                    labelText: '用户名',
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
                                  decoration: const InputDecoration(
                                    labelText: '密码',
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
                              child: const Text('发送测试邮件'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      title: '运行外部程序',
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SettingsSwitchTile(
                            title: '新增 Torrent 时运行',
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
                            decoration: const InputDecoration(
                              hintText: '例如："%N"',
                            ),
                          ),
                          const SizedBox(height: 8),
                          SettingsSwitchTile(
                            title: 'torrent 完成时运行',
                            value: ui.autorunEnabled,
                            onChanged: canEdit ? vm.setAutorunEnabled : null,
                          ),
                          TextField(
                            controller: _autorunFinishedController,
                            enabled: canEdit && ui.autorunEnabled,
                            minLines: 1,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: '例如："%N"',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '支持的参数（区分大小写）：\n'
                            '%N：Torrent 名称，%L：分类，%G：标签（以逗号分隔），'
                            '%F：内容路径，%R：根目录，%D：保存路径，'
                            '%C：文件数，%Z：Torrent 大小（字节），'
                            '%T：Tracker，%I/%J：Info hash，%K：ID，%M：备注\n'
                            '提示：使用引号将参数扩起以防止文本被空白符分割（例如："%N"）',
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
