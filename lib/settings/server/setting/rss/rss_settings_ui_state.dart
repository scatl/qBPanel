import 'package:qbpanel/widget/empty/empty_state.dart';

/// WebUI「RSS」页状态。
class RssSettingsUiState {
  const RssSettingsUiState({
    this.emptyState = const EmptyState.content(),
    this.saving = false,
    this.rssProcessingEnabled = false,
    this.rssRefreshInterval = 30,
    this.rssFetchDelay = 2,
    this.rssMaxArticlesPerFeed = 50,
    this.rssAutoDownloadingEnabled = false,
    this.rssDownloadRepackProperEpisodes = true,
    this.rssSmartEpisodeFilters = '',
    this.presentKeys = const {},
  });

  final EmptyState emptyState;
  final bool saving;

  /// `rss_processing_enabled`
  final bool rssProcessingEnabled;

  /// `rss_refresh_interval`（分钟）
  final int rssRefreshInterval;

  /// `rss_fetch_delay`（秒）
  final int rssFetchDelay;

  /// `rss_max_articles_per_feed`
  final int rssMaxArticlesPerFeed;

  /// `rss_auto_downloading_enabled`
  final bool rssAutoDownloadingEnabled;

  /// `rss_download_repack_proper_episodes`
  final bool rssDownloadRepackProperEpisodes;

  /// `rss_smart_episode_filters`
  final String rssSmartEpisodeFilters;

  final Set<String> presentKeys;

  bool hasPref(String key) => presentKeys.contains(key);

  bool get ready => emptyState.ready;

  RssSettingsUiState copyWith({
    EmptyState? emptyState,
    bool? saving,
    bool? rssProcessingEnabled,
    int? rssRefreshInterval,
    int? rssFetchDelay,
    int? rssMaxArticlesPerFeed,
    bool? rssAutoDownloadingEnabled,
    bool? rssDownloadRepackProperEpisodes,
    String? rssSmartEpisodeFilters,
    Set<String>? presentKeys,
  }) {
    return RssSettingsUiState(
      emptyState: emptyState ?? this.emptyState,
      saving: saving ?? this.saving,
      rssProcessingEnabled:
          rssProcessingEnabled ?? this.rssProcessingEnabled,
      rssRefreshInterval: rssRefreshInterval ?? this.rssRefreshInterval,
      rssFetchDelay: rssFetchDelay ?? this.rssFetchDelay,
      rssMaxArticlesPerFeed:
          rssMaxArticlesPerFeed ?? this.rssMaxArticlesPerFeed,
      rssAutoDownloadingEnabled:
          rssAutoDownloadingEnabled ?? this.rssAutoDownloadingEnabled,
      rssDownloadRepackProperEpisodes: rssDownloadRepackProperEpisodes ??
          this.rssDownloadRepackProperEpisodes,
      rssSmartEpisodeFilters:
          rssSmartEpisodeFilters ?? this.rssSmartEpisodeFilters,
      presentKeys: presentKeys ?? this.presentKeys,
    );
  }
}
