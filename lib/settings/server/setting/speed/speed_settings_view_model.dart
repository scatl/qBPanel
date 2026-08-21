import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/entity/response/app_preferences_response.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/settings/server/setting/speed/speed_settings_ui_state.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

final speedSettingsProvider =
    NotifierProvider<SpeedSettingsViewModel, SpeedSettingsUiState>(
  SpeedSettingsViewModel.new,
);

class SpeedSettingsViewModel extends Notifier<SpeedSettingsUiState> {
  @override
  SpeedSettingsUiState build() => const SpeedSettingsUiState();

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
    state = state.copyWith(
      emptyState: const EmptyState.content(),
      upLimitKib: _bytesToKib(data.upLimit),
      dlLimitKib: _bytesToKib(data.dlLimit),
      altUpLimitKib: _bytesToKib(data.altUpLimit),
      altDlLimitKib: _bytesToKib(data.altDlLimit),
      limitUtpRate: data.limitUtpRate ?? true,
      limitTcpOverhead: data.limitTcpOverhead ?? false,
      limitLanPeers: data.limitLanPeers ?? true,
      schedulerEnabled: data.schedulerEnabled ?? false,
      scheduleFromHour: _clampHour(data.scheduleFromHour, 8),
      scheduleFromMin: _clampMin(data.scheduleFromMin, 0),
      scheduleToHour: _clampHour(data.scheduleToHour, 20),
      scheduleToMin: _clampMin(data.scheduleToMin, 0),
      schedulerDays: SpeedSchedulerDays.fromApi(data.schedulerDays),
    );
    return true;
  }

  void setUpLimitKib(int value) {
    state = state.copyWith(upLimitKib: value);
  }

  void setDlLimitKib(int value) {
    state = state.copyWith(dlLimitKib: value);
  }

  void setAltUpLimitKib(int value) {
    state = state.copyWith(altUpLimitKib: value);
  }

  void setAltDlLimitKib(int value) {
    state = state.copyWith(altDlLimitKib: value);
  }

  void setLimitUtpRate(bool value) {
    state = state.copyWith(limitUtpRate: value);
  }

  void setLimitTcpOverhead(bool value) {
    state = state.copyWith(limitTcpOverhead: value);
  }

  void setLimitLanPeers(bool value) {
    state = state.copyWith(limitLanPeers: value);
  }

  void setSchedulerEnabled(bool value) {
    state = state.copyWith(schedulerEnabled: value);
  }

  void setScheduleFrom({required int hour, required int minute}) {
    state = state.copyWith(
      scheduleFromHour: hour,
      scheduleFromMin: minute,
    );
  }

  void setScheduleTo({required int hour, required int minute}) {
    state = state.copyWith(
      scheduleToHour: hour,
      scheduleToMin: minute,
    );
  }

  void setSchedulerDays(SpeedSchedulerDays value) {
    state = state.copyWith(schedulerDays: value);
  }

  /// 成功返回 `null`。
  Future<String?> save() async {
    if (state.saving) return null;
    if (state.upLimitKib < 0 ||
        state.dlLimitKib < 0 ||
        state.altUpLimitKib < 0 ||
        state.altDlLimitKib < 0) {
      return '速度限制必须大于等于 0（0 为无限制）';
    }

    state = state.copyWith(saving: true);
    final payload = <String, dynamic>{
      'up_limit': _kibToBytes(state.upLimitKib),
      'dl_limit': _kibToBytes(state.dlLimitKib),
      'alt_up_limit': _kibToBytes(state.altUpLimitKib),
      'alt_dl_limit': _kibToBytes(state.altDlLimitKib),
      'limit_utp_rate': state.limitUtpRate,
      'limit_tcp_overhead': state.limitTcpOverhead,
      'limit_lan_peers': state.limitLanPeers,
      'scheduler_enabled': state.schedulerEnabled,
      'schedule_from_hour': state.scheduleFromHour,
      'schedule_from_min': state.scheduleFromMin,
      'schedule_to_hour': state.scheduleToHour,
      'schedule_to_min': state.scheduleToMin,
      'scheduler_days': state.schedulerDays.apiValue,
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

  static int _bytesToKib(int? bytes) {
    if (bytes == null || bytes <= 0) return 0;
    return (bytes / 1024).round();
  }

  static int _kibToBytes(int kib) {
    if (kib <= 0) return 0;
    return kib * 1024;
  }

  static int _clampHour(int? value, int fallback) {
    final n = value ?? fallback;
    if (n < 0 || n > 23) return fallback;
    return n;
  }

  static int _clampMin(int? value, int fallback) {
    final n = value ?? fallback;
    if (n < 0 || n > 59) return fallback;
    return n;
  }
}
