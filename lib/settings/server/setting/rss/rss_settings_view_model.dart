import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/entity/response/app_preferences_response.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/settings/server/setting/pref_keys.dart';
import 'package:qbpanel/settings/server/setting/rss/rss_settings_ui_state.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

final rssSettingsProvider =
    NotifierProvider<RssSettingsViewModel, RssSettingsUiState>(
  RssSettingsViewModel.new,
);

class RssSettingsViewModel extends Notifier<RssSettingsUiState> {
  @override
  RssSettingsUiState build() => const RssSettingsUiState();

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
        emptyState: EmptyState.error(
          error ?? ref.read(appLocalizationsProvider).loadSettingsFailed,
        ),
      );
      return false;
    }

    final data = prefs!;
    state = state.copyWith(
      emptyState: const EmptyState.content(),
      rssProcessingEnabled: data.rssProcessingEnabled ?? false,
      rssRefreshInterval: data.rssRefreshInterval ?? 30,
      rssFetchDelay: data.rssFetchDelay ?? 2,
      rssMaxArticlesPerFeed: data.rssMaxArticlesPerFeed ?? 50,
      rssAutoDownloadingEnabled: data.rssAutoDownloadingEnabled ?? false,
      rssDownloadRepackProperEpisodes:
          data.rssDownloadRepackProperEpisodes ?? true,
      rssSmartEpisodeFilters: data.rssSmartEpisodeFilters ?? '',
      presentKeys: data.presentKeys,
    );
    return true;
  }

  void setRssProcessingEnabled(bool value) {
    state = state.copyWith(rssProcessingEnabled: value);
  }

  void setRssAutoDownloadingEnabled(bool value) {
    state = state.copyWith(rssAutoDownloadingEnabled: value);
  }

  void setRssDownloadRepackProperEpisodes(bool value) {
    state = state.copyWith(rssDownloadRepackProperEpisodes: value);
  }

  void applyTextFields({
    required int rssRefreshInterval,
    required int rssFetchDelay,
    required int rssMaxArticlesPerFeed,
    required String rssSmartEpisodeFilters,
  }) {
    state = state.copyWith(
      rssRefreshInterval: rssRefreshInterval,
      rssFetchDelay: rssFetchDelay,
      rssMaxArticlesPerFeed: rssMaxArticlesPerFeed,
      rssSmartEpisodeFilters: rssSmartEpisodeFilters,
    );
  }

  /// 成功返回 `null`。
  Future<String?> save() async {
    if (state.saving) return null;

    state = state.copyWith(saving: true);
    final payload = pickPrefs(state.presentKeys, <String, dynamic>{
      'rss_processing_enabled': state.rssProcessingEnabled,
      'rss_refresh_interval': state.rssRefreshInterval,
      'rss_fetch_delay': state.rssFetchDelay,
      'rss_max_articles_per_feed': state.rssMaxArticlesPerFeed,
      'rss_auto_downloading_enabled': state.rssAutoDownloadingEnabled,
      'rss_download_repack_proper_episodes':
          state.rssDownloadRepackProperEpisodes,
      'rss_smart_episode_filters': state.rssSmartEpisodeFilters,
    });

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
