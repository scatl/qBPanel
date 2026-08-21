import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/add/add_torrent_ui_state.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/entity/response/app_preferences_response.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/settings/server/setting/downloads/downloads_settings_ui_state.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

final downloadsSettingsProvider =
    NotifierProvider<DownloadsSettingsViewModel, DownloadsSettingsUiState>(
  DownloadsSettingsViewModel.new,
);

class DownloadsSettingsViewModel extends Notifier<DownloadsSettingsUiState> {
  @override
  DownloadsSettingsUiState build() => const DownloadsSettingsUiState();

  Future<bool> load() async {
    state = state.copyWith(emptyState: const EmptyState.loading());
    String? error;
    AppPreferencesResponse? prefs;
    await ref
        .read(apiClientProvider)
        .get(
          ApiPath.application.preferences,
          parser: jsonParser(AppPreferencesResponse.fromJson),
        )
        .onSuccess((data) => prefs = data)
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });

    if (prefs == null) {
      state = state.copyWith(
        emptyState: EmptyState.error(error ?? '加载设置失败'),
      );
      return false;
    }

    final data = prefs!;
    final exportDir = data.exportDir ?? '';
    final exportDirFin = data.exportDirFin ?? '';
    state = state.copyWith(
      emptyState: const EmptyState.content(),
      contentLayout: TorrentContentLayout.fromApi(data.torrentContentLayout),
      addToTopOfQueue: data.addToTopOfQueue ?? false,
      addStoppedEnabled: data.addStoppedEnabled ?? false,
      stopCondition: TorrentStopCondition.fromApi(data.torrentStopCondition),
      mergeTrackers: data.mergeTrackers ?? false,
      autoDeleteTorrentFile: (data.autoDeleteMode ?? 0) != 0,
      preallocateAll: data.preallocateAll ?? false,
      incompleteFilesExt: data.incompleteFilesExt ?? false,
      useUnwantedFolder: data.useUnwantedFolder ?? false,
      autoTmmEnabled: data.autoTmmEnabled ?? false,
      torrentChangedTmmEnabled: data.torrentChangedTmmEnabled ?? true,
      savePathChangedTmmEnabled: data.savePathChangedTmmEnabled ?? false,
      categoryChangedTmmEnabled: data.categoryChangedTmmEnabled ?? false,
      useCategoryPathsInManualMode:
          data.useCategoryPathsInManualMode ?? false,
      savePath: data.savePath ?? '',
      tempPathEnabled: data.tempPathEnabled ?? false,
      tempPath: data.tempPath ?? '',
      exportDirEnabled: exportDir.trim().isNotEmpty,
      exportDir: exportDir,
      exportDirFinEnabled: exportDirFin.trim().isNotEmpty,
      exportDirFin: exportDirFin,
      excludedFileNamesEnabled: data.excludedFileNamesEnabled ?? false,
      excludedFileNames: data.excludedFileNames ?? '',
      mailNotificationEnabled: data.mailNotificationEnabled ?? false,
      mailNotificationSender: data.mailNotificationSender ?? '',
      mailNotificationEmail: data.mailNotificationEmail ?? '',
      mailNotificationSmtp: data.mailNotificationSmtp ?? '',
      mailNotificationSslEnabled: data.mailSslOrEncryptionEnabled,
      mailNotificationAuthEnabled: data.mailNotificationAuthEnabled ?? false,
      mailNotificationUsername: data.mailNotificationUsername ?? '',
      mailNotificationPassword: data.mailNotificationPassword ?? '',
      autorunOnTorrentAddedEnabled:
          data.autorunOnTorrentAddedEnabled ?? false,
      autorunOnTorrentAddedProgram:
          data.autorunOnTorrentAddedProgram ?? '',
      autorunEnabled: data.autorunEnabled ?? false,
      autorunProgram: data.autorunProgram ?? '',
    );
    return true;
  }

  void setContentLayout(TorrentContentLayout value) {
    state = state.copyWith(contentLayout: value);
  }

  void setAddToTopOfQueue(bool value) {
    state = state.copyWith(addToTopOfQueue: value);
  }

  void setAddStoppedEnabled(bool value) {
    state = state.copyWith(addStoppedEnabled: value);
  }

  void setStopCondition(TorrentStopCondition value) {
    state = state.copyWith(stopCondition: value);
  }

  void setMergeTrackers(bool value) {
    state = state.copyWith(mergeTrackers: value);
  }

  void setAutoDeleteTorrentFile(bool value) {
    state = state.copyWith(autoDeleteTorrentFile: value);
  }

  void setPreallocateAll(bool value) {
    state = state.copyWith(preallocateAll: value);
  }

  void setIncompleteFilesExt(bool value) {
    state = state.copyWith(incompleteFilesExt: value);
  }

  void setUseUnwantedFolder(bool value) {
    state = state.copyWith(useUnwantedFolder: value);
  }

  void setAutoTmmEnabled(bool value) {
    state = state.copyWith(autoTmmEnabled: value);
  }

  void setTorrentChangedTmmEnabled(bool value) {
    state = state.copyWith(torrentChangedTmmEnabled: value);
  }

  void setSavePathChangedTmmEnabled(bool value) {
    state = state.copyWith(savePathChangedTmmEnabled: value);
  }

  void setCategoryChangedTmmEnabled(bool value) {
    state = state.copyWith(categoryChangedTmmEnabled: value);
  }

  void setUseCategoryPathsInManualMode(bool value) {
    state = state.copyWith(useCategoryPathsInManualMode: value);
  }

  void setSavePath(String value) {
    state = state.copyWith(savePath: value);
  }

  void setTempPathEnabled(bool value) {
    state = state.copyWith(tempPathEnabled: value);
  }

  void setTempPath(String value) {
    state = state.copyWith(tempPath: value);
  }

  void setExportDirEnabled(bool value) {
    state = state.copyWith(exportDirEnabled: value);
  }

  void setExportDir(String value) {
    state = state.copyWith(exportDir: value);
  }

  void setExportDirFinEnabled(bool value) {
    state = state.copyWith(exportDirFinEnabled: value);
  }

  void setExportDirFin(String value) {
    state = state.copyWith(exportDirFin: value);
  }

  void setExcludedFileNamesEnabled(bool value) {
    state = state.copyWith(excludedFileNamesEnabled: value);
  }

  void setExcludedFileNames(String value) {
    state = state.copyWith(excludedFileNames: value);
  }

  void setMailNotificationEnabled(bool value) {
    state = state.copyWith(mailNotificationEnabled: value);
  }

  void setMailNotificationSender(String value) {
    state = state.copyWith(mailNotificationSender: value);
  }

  void setMailNotificationEmail(String value) {
    state = state.copyWith(mailNotificationEmail: value);
  }

  void setMailNotificationSmtp(String value) {
    state = state.copyWith(mailNotificationSmtp: value);
  }

  void setMailNotificationSslEnabled(bool value) {
    state = state.copyWith(mailNotificationSslEnabled: value);
  }

  void setMailNotificationAuthEnabled(bool value) {
    state = state.copyWith(mailNotificationAuthEnabled: value);
  }

  void setMailNotificationUsername(String value) {
    state = state.copyWith(mailNotificationUsername: value);
  }

  void setMailNotificationPassword(String value) {
    state = state.copyWith(mailNotificationPassword: value);
  }

  void setAutorunOnTorrentAddedEnabled(bool value) {
    state = state.copyWith(autorunOnTorrentAddedEnabled: value);
  }

  void setAutorunOnTorrentAddedProgram(String value) {
    state = state.copyWith(autorunOnTorrentAddedProgram: value);
  }

  void setAutorunEnabled(bool value) {
    state = state.copyWith(autorunEnabled: value);
  }

  void setAutorunProgram(String value) {
    state = state.copyWith(autorunProgram: value);
  }

  /// 先把当前邮件相关设置写入服务器，再请求测试邮件。
  Future<String?> sendTestEmail() async {
    if (state.testingEmail || state.saving) return null;
    if (!state.mailNotificationEnabled) {
      return '请先启用邮件通知';
    }

    state = state.copyWith(testingEmail: true);
    final saveError = await save(keepBusy: true);
    if (saveError != null) {
      state = state.copyWith(testingEmail: false);
      return saveError;
    }

    String? error;
    await ref
        .read(apiClientProvider)
        .post(
          ApiPath.application.sendTestEmail,
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });

    state = state.copyWith(testingEmail: false);
    return error;
  }

  /// 成功返回 `null`。
  Future<String?> save({bool keepBusy = false}) async {
    if (state.saving && !keepBusy) return null;
    if (state.savePath.trim().isEmpty) {
      return '请填写默认保存路径';
    }

    if (!keepBusy) {
      state = state.copyWith(saving: true);
    }

    final ssl = state.mailNotificationSslEnabled;
    final payload = <String, dynamic>{
      'torrent_content_layout': state.contentLayout.apiValue,
      'add_to_top_of_queue': state.addToTopOfQueue,
      'add_stopped_enabled': state.addStoppedEnabled,
      'torrent_stop_condition': state.stopCondition.apiValue,
      'merge_trackers': state.mergeTrackers,
      'auto_delete_mode': state.autoDeleteTorrentFile ? 1 : 0,
      'preallocate_all': state.preallocateAll,
      'incomplete_files_ext': state.incompleteFilesExt,
      'use_unwanted_folder': state.useUnwantedFolder,
      'auto_tmm_enabled': state.autoTmmEnabled,
      'torrent_changed_tmm_enabled': state.torrentChangedTmmEnabled,
      'save_path_changed_tmm_enabled': state.savePathChangedTmmEnabled,
      'category_changed_tmm_enabled': state.categoryChangedTmmEnabled,
      'use_category_paths_in_manual_mode': state.useCategoryPathsInManualMode,
      'save_path': state.savePath.trim(),
      'temp_path_enabled': state.tempPathEnabled,
      'temp_path': state.tempPath.trim(),
      'export_dir':
          state.exportDirEnabled ? state.exportDir.trim() : '',
      'export_dir_fin':
          state.exportDirFinEnabled ? state.exportDirFin.trim() : '',
      'excluded_file_names_enabled': state.excludedFileNamesEnabled,
      'excluded_file_names': state.excludedFileNames,
      'mail_notification_enabled': state.mailNotificationEnabled,
      'mail_notification_sender': state.mailNotificationSender.trim(),
      'mail_notification_email': state.mailNotificationEmail.trim(),
      'mail_notification_smtp': state.mailNotificationSmtp.trim(),
      'mail_notification_ssl_enabled': ssl,
      'mail_notification_encryption_type': ssl ? 'SMTPS' : 'None',
      'mail_notification_auth_enabled': state.mailNotificationAuthEnabled,
      'mail_notification_username': state.mailNotificationUsername.trim(),
      'mail_notification_password': state.mailNotificationPassword,
      'autorun_on_torrent_added_enabled': state.autorunOnTorrentAddedEnabled,
      'autorun_on_torrent_added_program':
          state.autorunOnTorrentAddedProgram.trim(),
      'autorun_enabled': state.autorunEnabled,
      'autorun_program': state.autorunProgram.trim(),
    };

    String? error;
    await ref
        .read(apiClientProvider)
        .post(
          ApiPath.application.setPreferences,
          data: {'json': jsonEncode(payload)},
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });

    if (!keepBusy) {
      state = state.copyWith(saving: false);
    }
    return error;
  }
}
