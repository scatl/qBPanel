import 'package:qbpanel/widget/empty/empty_state.dart';

/// WebUI「BitTorrent」页状态。
class BittorrentSettingsUiState {
  const BittorrentSettingsUiState({
    this.emptyState = const EmptyState.content(),
    this.saving = false,
    this.dht = true,
    this.pex = true,
    this.lsd = true,
    this.encryption = BittorrentEncryption.allow,
    this.anonymousMode = false,
    this.maxActiveCheckingTorrents = 1,
    this.queueingEnabled = false,
    this.maxActiveDownloads = 3,
    this.maxActiveUploads = 3,
    this.maxActiveTorrents = 5,
    this.dontCountSlowTorrents = false,
    this.slowTorrentDlRateThreshold = 2,
    this.slowTorrentUlRateThreshold = 2,
    this.slowTorrentInactiveTimer = 60,
    this.maxRatioEnabled = false,
    this.maxRatio = 1,
    this.maxSeedingTimeEnabled = false,
    this.maxSeedingTime = 1440,
    this.maxInactiveSeedingTimeEnabled = false,
    this.maxInactiveSeedingTime = 1440,
    this.maxRatioAct = BittorrentMaxRatioAct.stop,
    this.addTrackersEnabled = false,
    this.addTrackers = '',
    this.addTrackersFromUrlEnabled = false,
    this.addTrackersUrl = '',
    this.addTrackersUrlList = '',
  });

  final EmptyState emptyState;
  final bool saving;

  final bool dht;
  final bool pex;
  final bool lsd;
  final BittorrentEncryption encryption;
  final bool anonymousMode;
  final int maxActiveCheckingTorrents;

  final bool queueingEnabled;
  final int maxActiveDownloads;
  final int maxActiveUploads;
  final int maxActiveTorrents;
  final bool dontCountSlowTorrents;
  final int slowTorrentDlRateThreshold;
  final int slowTorrentUlRateThreshold;
  final int slowTorrentInactiveTimer;

  final bool maxRatioEnabled;
  final double maxRatio;
  final bool maxSeedingTimeEnabled;
  final int maxSeedingTime;
  final bool maxInactiveSeedingTimeEnabled;
  final int maxInactiveSeedingTime;
  final BittorrentMaxRatioAct maxRatioAct;

  final bool addTrackersEnabled;
  final String addTrackers;
  final bool addTrackersFromUrlEnabled;
  final String addTrackersUrl;
  final String addTrackersUrlList;

  bool get ready => emptyState.ready;

  BittorrentSettingsUiState copyWith({
    EmptyState? emptyState,
    bool? saving,
    bool? dht,
    bool? pex,
    bool? lsd,
    BittorrentEncryption? encryption,
    bool? anonymousMode,
    int? maxActiveCheckingTorrents,
    bool? queueingEnabled,
    int? maxActiveDownloads,
    int? maxActiveUploads,
    int? maxActiveTorrents,
    bool? dontCountSlowTorrents,
    int? slowTorrentDlRateThreshold,
    int? slowTorrentUlRateThreshold,
    int? slowTorrentInactiveTimer,
    bool? maxRatioEnabled,
    double? maxRatio,
    bool? maxSeedingTimeEnabled,
    int? maxSeedingTime,
    bool? maxInactiveSeedingTimeEnabled,
    int? maxInactiveSeedingTime,
    BittorrentMaxRatioAct? maxRatioAct,
    bool? addTrackersEnabled,
    String? addTrackers,
    bool? addTrackersFromUrlEnabled,
    String? addTrackersUrl,
    String? addTrackersUrlList,
  }) {
    return BittorrentSettingsUiState(
      emptyState: emptyState ?? this.emptyState,
      saving: saving ?? this.saving,
      dht: dht ?? this.dht,
      pex: pex ?? this.pex,
      lsd: lsd ?? this.lsd,
      encryption: encryption ?? this.encryption,
      anonymousMode: anonymousMode ?? this.anonymousMode,
      maxActiveCheckingTorrents:
          maxActiveCheckingTorrents ?? this.maxActiveCheckingTorrents,
      queueingEnabled: queueingEnabled ?? this.queueingEnabled,
      maxActiveDownloads: maxActiveDownloads ?? this.maxActiveDownloads,
      maxActiveUploads: maxActiveUploads ?? this.maxActiveUploads,
      maxActiveTorrents: maxActiveTorrents ?? this.maxActiveTorrents,
      dontCountSlowTorrents:
          dontCountSlowTorrents ?? this.dontCountSlowTorrents,
      slowTorrentDlRateThreshold:
          slowTorrentDlRateThreshold ?? this.slowTorrentDlRateThreshold,
      slowTorrentUlRateThreshold:
          slowTorrentUlRateThreshold ?? this.slowTorrentUlRateThreshold,
      slowTorrentInactiveTimer:
          slowTorrentInactiveTimer ?? this.slowTorrentInactiveTimer,
      maxRatioEnabled: maxRatioEnabled ?? this.maxRatioEnabled,
      maxRatio: maxRatio ?? this.maxRatio,
      maxSeedingTimeEnabled:
          maxSeedingTimeEnabled ?? this.maxSeedingTimeEnabled,
      maxSeedingTime: maxSeedingTime ?? this.maxSeedingTime,
      maxInactiveSeedingTimeEnabled:
          maxInactiveSeedingTimeEnabled ?? this.maxInactiveSeedingTimeEnabled,
      maxInactiveSeedingTime:
          maxInactiveSeedingTime ?? this.maxInactiveSeedingTime,
      maxRatioAct: maxRatioAct ?? this.maxRatioAct,
      addTrackersEnabled: addTrackersEnabled ?? this.addTrackersEnabled,
      addTrackers: addTrackers ?? this.addTrackers,
      addTrackersFromUrlEnabled:
          addTrackersFromUrlEnabled ?? this.addTrackersFromUrlEnabled,
      addTrackersUrl: addTrackersUrl ?? this.addTrackersUrl,
      addTrackersUrlList: addTrackersUrlList ?? this.addTrackersUrlList,
    );
  }
}

/// `encryption`
enum BittorrentEncryption {
  allow('允许加密', 0),
  require('强制加密', 1),
  disable('禁用加密', 2);

  const BittorrentEncryption(this.label, this.apiValue);
  final String label;
  final int apiValue;

  static BittorrentEncryption fromApi(int? value) {
    for (final item in values) {
      if (item.apiValue == value) return item;
    }
    return BittorrentEncryption.allow;
  }
}

/// `max_ratio_act`（选项顺序与 WebUI 一致）
enum BittorrentMaxRatioAct {
  stop('停止 torrent', 0),
  remove('删除 torrent', 1),
  removeAndFiles('删除 torrent 及所属文件', 3),
  superSeeding('为 torrent 启用超级做种', 2);

  const BittorrentMaxRatioAct(this.label, this.apiValue);
  final String label;
  final int apiValue;

  static BittorrentMaxRatioAct fromApi(int? value) {
    for (final item in values) {
      if (item.apiValue == value) return item;
    }
    return BittorrentMaxRatioAct.stop;
  }
}
