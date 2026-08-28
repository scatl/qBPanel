import 'package:qbpanel/l10n/app_localizations.dart';

/// qBittorrent 5.0 种子 `state`（`/torrents/info` 与 `sync/maindata` 单项相同）。
///
/// 取值见本地文档 [Get torrent list](docs/qbittorrent/WebUI-API-(qBittorrent-5.0).md)。
enum TorrentState {
  error('error'),
  missingFiles('missingFiles'),
  uploading('uploading'),
  stoppedUP('stoppedUP'),
  queuedUP('queuedUP'),
  stalledUP('stalledUP'),
  checkingUP('checkingUP'),
  forcedUP('forcedUP'),
  allocating('allocating'),
  downloading('downloading'),
  metaDL('metaDL'),
  forcedMetaDL('forcedMetaDL'),
  stoppedDL('stoppedDL'),
  queuedDL('queuedDL'),
  stalledDL('stalledDL'),
  checkingDL('checkingDL'),
  forcedDL('forcedDL'),
  checkingResumeData('checkingResumeData'),
  moving('moving'),
  unknown('unknown');

  const TorrentState(this.apiValue);

  /// 接口 JSON 字符串。
  final String apiValue;

  /// 列表/详情展示文案。
  String label(AppLocalizations l10n) => switch (this) {
        TorrentState.error => l10n.torrentStateError,
        TorrentState.missingFiles => l10n.torrentStateMissingFiles,
        TorrentState.uploading => l10n.torrentStateUploading,
        TorrentState.stoppedUP => l10n.torrentStateStoppedUp,
        TorrentState.queuedUP => l10n.torrentStateQueuedUp,
        TorrentState.stalledUP => l10n.torrentStateStalledUp,
        TorrentState.checkingUP => l10n.torrentStateCheckingUp,
        TorrentState.forcedUP => l10n.torrentStateForcedUp,
        TorrentState.allocating => l10n.torrentStateAllocating,
        TorrentState.downloading => l10n.torrentStateDownloading,
        TorrentState.metaDL => l10n.torrentStateMetaDl,
        TorrentState.forcedMetaDL => l10n.torrentStateForcedMetaDl,
        TorrentState.stoppedDL => l10n.torrentStateStoppedDl,
        TorrentState.queuedDL => l10n.torrentStateQueuedDl,
        TorrentState.stalledDL => l10n.torrentStateStalledDl,
        TorrentState.checkingDL => l10n.torrentStateCheckingDl,
        TorrentState.forcedDL => l10n.torrentStateForcedDl,
        TorrentState.checkingResumeData => l10n.torrentStateCheckingResumeData,
        TorrentState.moving => l10n.torrentStateMoving,
        TorrentState.unknown => l10n.torrentStateUnknown,
      };

  /// 解析接口字段；缺省返回 `null`（便于增量 merge）；无法识别则为 [unknown]。
  static TorrentState? fromApi(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final s in TorrentState.values) {
      if (s.apiValue == raw) return s;
    }
    return TorrentState.unknown;
  }
}
