import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/entity/response/app_preferences_response.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/settings/server/setting/behavior/behavior_settings_ui_state.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

final behaviorSettingsProvider =
    NotifierProvider<BehaviorSettingsViewModel, BehaviorSettingsUiState>(
  BehaviorSettingsViewModel.new,
);

class BehaviorSettingsViewModel extends Notifier<BehaviorSettingsUiState> {
  @override
  BehaviorSettingsUiState build() => const BehaviorSettingsUiState();

  /// 拉取当前服务器 preferences 写入 [state]。成功返回 `true`。
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
        emptyState: EmptyState.error(error ?? ref.read(appLocalizationsProvider).loadSettingsFailed),
      );
      return false;
    }

    final data = prefs!;
    state = state.copyWith(
      emptyState: const EmptyState.content(),
      locale: data.locale?.trim().isNotEmpty == true
          ? data.locale!.trim()
          : state.locale,
      confirmTorrentDeletion:
          data.confirmTorrentDeletion ?? state.confirmTorrentDeletion,
      statusBarExternalIp:
          data.statusBarExternalIp ?? state.statusBarExternalIp,
      fileLogEnabled: data.fileLogEnabled ?? state.fileLogEnabled,
      fileLogPath: data.fileLogPath ?? '',
      fileLogBackupEnabled:
          data.fileLogBackupEnabled ?? state.fileLogBackupEnabled,
      fileLogMaxSize: data.fileLogMaxSize ?? 65,
      fileLogDeleteOld: data.fileLogDeleteOld ?? state.fileLogDeleteOld,
      fileLogAge: data.fileLogAge ?? 1,
      fileLogAgeType: BehaviorLogAgeType.fromApi(data.fileLogAgeType),
      performanceWarning: data.performanceWarning ?? state.performanceWarning,
    );
    return true;
  }

  void setLocale(String value) {
    state = state.copyWith(locale: value);
  }

  void setConfirmTorrentDeletion(bool value) {
    state = state.copyWith(confirmTorrentDeletion: value);
  }

  void setStatusBarExternalIp(bool value) {
    state = state.copyWith(statusBarExternalIp: value);
  }

  void setFileLogEnabled(bool value) {
    state = state.copyWith(fileLogEnabled: value);
  }

  void setFileLogPath(String value) {
    state = state.copyWith(fileLogPath: value);
  }

  void setFileLogBackupEnabled(bool value) {
    state = state.copyWith(fileLogBackupEnabled: value);
  }

  void setFileLogMaxSizeText(String value) {
    final parsed = int.tryParse(value.trim());
    if (parsed == null) return;
    state = state.copyWith(fileLogMaxSize: parsed);
  }

  void setFileLogDeleteOld(bool value) {
    state = state.copyWith(fileLogDeleteOld: value);
  }

  void setFileLogAgeText(String value) {
    final parsed = int.tryParse(value.trim());
    if (parsed == null) return;
    state = state.copyWith(fileLogAge: parsed);
  }

  void setFileLogAgeType(BehaviorLogAgeType value) {
    state = state.copyWith(fileLogAgeType: value);
  }

  void setPerformanceWarning(bool value) {
    state = state.copyWith(performanceWarning: value);
  }

  /// 保存行为相关 preferences。成功返回 `null`，失败返回错误文案。
  Future<String?> save() async {
    if (state.saving) return null;

    if (state.fileLogEnabled &&
        state.fileLogBackupEnabled &&
        state.fileLogMaxSize < 1) {
      return ref.read(appLocalizationsProvider).invalidLogBackupSize;
    }
    if (state.fileLogEnabled &&
        state.fileLogDeleteOld &&
        state.fileLogAge < 1) {
      return ref.read(appLocalizationsProvider).invalidLogRetention;
    }

    state = state.copyWith(saving: true);
    final payload = <String, dynamic>{
      'locale': state.locale,
      'confirm_torrent_deletion': state.confirmTorrentDeletion,
      'status_bar_external_ip': state.statusBarExternalIp,
      'file_log_enabled': state.fileLogEnabled,
      'file_log_path': state.fileLogPath.trim(),
      'file_log_backup_enabled': state.fileLogBackupEnabled,
      'file_log_max_size': state.fileLogMaxSize,
      'file_log_delete_old': state.fileLogDeleteOld,
      'file_log_age': state.fileLogAge,
      'file_log_age_type': state.fileLogAgeType.apiValue,
      'performance_warning': state.performanceWarning,
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

    state = state.copyWith(saving: false);
    return error;
  }
}
