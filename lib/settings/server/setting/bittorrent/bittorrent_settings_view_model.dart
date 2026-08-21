import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/entity/response/app_preferences_response.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/settings/server/setting/bittorrent/bittorrent_settings_ui_state.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

final bittorrentSettingsProvider =
    NotifierProvider<BittorrentSettingsViewModel, BittorrentSettingsUiState>(
  BittorrentSettingsViewModel.new,
);

class BittorrentSettingsViewModel
    extends Notifier<BittorrentSettingsUiState> {
  @override
  BittorrentSettingsUiState build() => const BittorrentSettingsUiState();

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
    final ratioEnabled = data.maxRatioEnabled ?? false;
    final ratio = data.maxRatio ?? -1;
    final seedingEnabled = data.maxSeedingTimeEnabled ?? false;
    final seedingTime = data.maxSeedingTime ?? -1;
    final inactiveEnabled = data.maxInactiveSeedingTimeEnabled ?? false;
    final inactiveTime = data.maxInactiveSeedingTime ?? -1;

    state = state.copyWith(
      emptyState: const EmptyState.content(),
      dht: data.dht ?? true,
      pex: data.pex ?? true,
      lsd: data.lsd ?? true,
      encryption: BittorrentEncryption.fromApi(data.encryption),
      anonymousMode: data.anonymousMode ?? false,
      maxActiveCheckingTorrents: data.maxActiveCheckingTorrents ?? 1,
      queueingEnabled: data.queueingEnabled ?? false,
      maxActiveDownloads: data.maxActiveDownloads ?? 3,
      maxActiveUploads: data.maxActiveUploads ?? 3,
      maxActiveTorrents: data.maxActiveTorrents ?? 5,
      dontCountSlowTorrents: data.dontCountSlowTorrents ?? false,
      slowTorrentDlRateThreshold: data.slowTorrentDlRateThreshold ?? 2,
      slowTorrentUlRateThreshold: data.slowTorrentUlRateThreshold ?? 2,
      slowTorrentInactiveTimer: data.slowTorrentInactiveTimer ?? 60,
      maxRatioEnabled: ratioEnabled,
      maxRatio: ratioEnabled && ratio >= 0 ? ratio : 1,
      maxSeedingTimeEnabled: seedingEnabled,
      maxSeedingTime: seedingEnabled && seedingTime >= 0 ? seedingTime : 1440,
      maxInactiveSeedingTimeEnabled: inactiveEnabled,
      maxInactiveSeedingTime:
          inactiveEnabled && inactiveTime >= 0 ? inactiveTime : 1440,
      maxRatioAct: BittorrentMaxRatioAct.fromApi(data.maxRatioAct),
      addTrackersEnabled: data.addTrackersEnabled ?? false,
      addTrackers: data.addTrackers ?? '',
      addTrackersFromUrlEnabled: data.addTrackersFromUrlEnabled ?? false,
      addTrackersUrl: data.addTrackersUrl ?? '',
      addTrackersUrlList: data.addTrackersUrlList ?? '',
    );
    return true;
  }

  void setDht(bool value) => state = state.copyWith(dht: value);
  void setPex(bool value) => state = state.copyWith(pex: value);
  void setLsd(bool value) => state = state.copyWith(lsd: value);
  void setEncryption(BittorrentEncryption value) {
    state = state.copyWith(encryption: value);
  }

  void setAnonymousMode(bool value) {
    state = state.copyWith(anonymousMode: value);
  }

  void setMaxActiveCheckingTorrents(int value) {
    state = state.copyWith(maxActiveCheckingTorrents: value);
  }

  void setQueueingEnabled(bool value) {
    state = state.copyWith(queueingEnabled: value);
  }

  void setMaxActiveDownloads(int value) {
    state = state.copyWith(maxActiveDownloads: value);
  }

  void setMaxActiveUploads(int value) {
    state = state.copyWith(maxActiveUploads: value);
  }

  void setMaxActiveTorrents(int value) {
    state = state.copyWith(maxActiveTorrents: value);
  }

  void setDontCountSlowTorrents(bool value) {
    state = state.copyWith(dontCountSlowTorrents: value);
  }

  void setSlowTorrentDlRateThreshold(int value) {
    state = state.copyWith(slowTorrentDlRateThreshold: value);
  }

  void setSlowTorrentUlRateThreshold(int value) {
    state = state.copyWith(slowTorrentUlRateThreshold: value);
  }

  void setSlowTorrentInactiveTimer(int value) {
    state = state.copyWith(slowTorrentInactiveTimer: value);
  }

  void setMaxRatioEnabled(bool value) {
    state = state.copyWith(maxRatioEnabled: value);
  }

  void setMaxRatio(double value) {
    state = state.copyWith(maxRatio: value);
  }

  void setMaxSeedingTimeEnabled(bool value) {
    state = state.copyWith(maxSeedingTimeEnabled: value);
  }

  void setMaxSeedingTime(int value) {
    state = state.copyWith(maxSeedingTime: value);
  }

  void setMaxInactiveSeedingTimeEnabled(bool value) {
    state = state.copyWith(maxInactiveSeedingTimeEnabled: value);
  }

  void setMaxInactiveSeedingTime(int value) {
    state = state.copyWith(maxInactiveSeedingTime: value);
  }

  void setMaxRatioAct(BittorrentMaxRatioAct value) {
    state = state.copyWith(maxRatioAct: value);
  }

  void setAddTrackersEnabled(bool value) {
    state = state.copyWith(addTrackersEnabled: value);
  }

  void setAddTrackers(String value) {
    state = state.copyWith(addTrackers: value);
  }

  void setAddTrackersFromUrlEnabled(bool value) {
    state = state.copyWith(addTrackersFromUrlEnabled: value);
  }

  void setAddTrackersUrl(String value) {
    state = state.copyWith(addTrackersUrl: value);
  }

  /// 成功返回 `null`。
  Future<String?> save() async {
    if (state.saving) return null;

    if (state.maxActiveCheckingTorrents < -1) {
      return '最大活跃检查 Torrent 数必须大于 -1';
    }
    if (state.queueingEnabled) {
      if (state.maxActiveDownloads < -1) {
        return '最大活动的下载数必须大于 -1';
      }
      if (state.maxActiveUploads < -1) {
        return '最大活动的上传数必须大于 -1';
      }
      if (state.maxActiveTorrents < -1) {
        return '最大活动的 torrent 数必须大于 -1';
      }
      if (state.slowTorrentDlRateThreshold < 1) {
        return '下载速度阈值必须大于 0';
      }
      if (state.slowTorrentUlRateThreshold < 1) {
        return '上传速度阈值必须大于 0';
      }
      if (state.slowTorrentInactiveTimer < 1) {
        return 'Torrent 非活动计时器必须大于 0';
      }
    }
    if (state.maxRatioEnabled && state.maxRatio < 0) {
      return '分享率限制不能为负数';
    }
    if (state.maxSeedingTimeEnabled && state.maxSeedingTime < 0) {
      return '做种时间限制不能为负数';
    }
    if (state.maxInactiveSeedingTimeEnabled &&
        state.maxInactiveSeedingTime < 0) {
      return '不活跃做种时间限制不能为负数';
    }

    state = state.copyWith(saving: true);
    final payload = <String, dynamic>{
      'dht': state.dht,
      'pex': state.pex,
      'lsd': state.lsd,
      'encryption': state.encryption.apiValue,
      'anonymous_mode': state.anonymousMode,
      'max_active_checking_torrents': state.maxActiveCheckingTorrents,
      'queueing_enabled': state.queueingEnabled,
      'max_active_downloads': state.maxActiveDownloads,
      'max_active_uploads': state.maxActiveUploads,
      'max_active_torrents': state.maxActiveTorrents,
      'dont_count_slow_torrents': state.dontCountSlowTorrents,
      'slow_torrent_dl_rate_threshold': state.slowTorrentDlRateThreshold,
      'slow_torrent_ul_rate_threshold': state.slowTorrentUlRateThreshold,
      'slow_torrent_inactive_timer': state.slowTorrentInactiveTimer,
      'max_ratio_enabled': state.maxRatioEnabled,
      'max_ratio': state.maxRatioEnabled ? state.maxRatio : -1,
      'max_seeding_time_enabled': state.maxSeedingTimeEnabled,
      'max_seeding_time':
          state.maxSeedingTimeEnabled ? state.maxSeedingTime : -1,
      'max_inactive_seeding_time_enabled': state.maxInactiveSeedingTimeEnabled,
      'max_inactive_seeding_time': state.maxInactiveSeedingTimeEnabled
          ? state.maxInactiveSeedingTime
          : -1,
      'max_ratio_act': state.maxRatioAct.apiValue,
      'add_trackers_enabled': state.addTrackersEnabled,
      'add_trackers': state.addTrackers,
      'add_trackers_from_url_enabled': state.addTrackersFromUrlEnabled,
      'add_trackers_url': state.addTrackersUrl.trim(),
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
