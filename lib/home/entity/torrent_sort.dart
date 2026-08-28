import 'package:qbpanel/api/entity/response/torrent_info_response.dart';
import 'package:qbpanel/api/entity/response/torrent_state.dart';
import 'package:qbpanel/l10n/app_localizations.dart';

/// qB 用 `8640000` 秒表示未知/无限 ETA。
const _unknownEta = 8640000;

/// 首页列表排序键。不含分类。
enum TorrentSortKey {
  state,
  name,
  progress,
  size,
  downloadSpeed,
  uploadSpeed,
  downloaded,
  uploaded,
  eta,
  amountLeft,
  ratio,
  addedOn,
  completionOn,
  lastActivity,
  numSeeds,
  numLeechs,
  availability,
  priority,
  timeActive,
  seedingTime;

  String label(AppLocalizations l10n) => switch (this) {
        TorrentSortKey.state => l10n.sortState,
        TorrentSortKey.name => l10n.sortName,
        TorrentSortKey.progress => l10n.sortProgress,
        TorrentSortKey.size => l10n.sortSize,
        TorrentSortKey.downloadSpeed => l10n.sortDownloadSpeed,
        TorrentSortKey.uploadSpeed => l10n.sortUploadSpeed,
        TorrentSortKey.downloaded => l10n.sortDownloaded,
        TorrentSortKey.uploaded => l10n.sortUploaded,
        TorrentSortKey.eta => l10n.sortEta,
        TorrentSortKey.amountLeft => l10n.sortAmountLeft,
        TorrentSortKey.ratio => l10n.sortRatio,
        TorrentSortKey.addedOn => l10n.sortAddedOn,
        TorrentSortKey.completionOn => l10n.sortCompletionOn,
        TorrentSortKey.lastActivity => l10n.sortLastActivity,
        TorrentSortKey.numSeeds => l10n.sortNumSeeds,
        TorrentSortKey.numLeechs => l10n.sortNumLeechs,
        TorrentSortKey.availability => l10n.sortAvailability,
        TorrentSortKey.priority => l10n.sortPriority,
        TorrentSortKey.timeActive => l10n.sortTimeActive,
        TorrentSortKey.seedingTime => l10n.sortSeedingTime,
      };

  int compare(
    TorrentInfoResponse a,
    TorrentInfoResponse b, {
    required bool ascending,
  }) {
    final pinned = _pinLast(a, b);
    if (pinned != 0) return pinned;
    final raw = _compareValues(a, b);
    return ascending ? raw : -raw;
  }

  /// 未知/未完成等固定沉底，不受升降序翻转。
  int _pinLast(TorrentInfoResponse a, TorrentInfoResponse b) {
    switch (this) {
      case TorrentSortKey.eta:
        return _pin(a, b, _etaUnknown);
      case TorrentSortKey.completionOn:
        return _pin(a, b, (t) => (t.completionOn ?? 0) <= 0);
      case TorrentSortKey.lastActivity:
        return _pin(a, b, (t) => (t.lastActivity ?? 0) <= 0);
      case TorrentSortKey.name:
        return _pin(a, b, (t) => t.name == null || t.name!.isEmpty);
      default:
        return 0;
    }
  }

  int _compareValues(TorrentInfoResponse a, TorrentInfoResponse b) {
    switch (this) {
      case TorrentSortKey.state:
        return _stateRank(a.state).compareTo(_stateRank(b.state));
      case TorrentSortKey.name:
        return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
      case TorrentSortKey.progress:
        return (a.progress ?? 0).compareTo(b.progress ?? 0);
      case TorrentSortKey.size:
        return (a.size ?? a.totalSize ?? 0).compareTo(b.size ?? b.totalSize ?? 0);
      case TorrentSortKey.downloadSpeed:
        return (a.dlspeed ?? 0).compareTo(b.dlspeed ?? 0);
      case TorrentSortKey.uploadSpeed:
        return (a.upspeed ?? 0).compareTo(b.upspeed ?? 0);
      case TorrentSortKey.downloaded:
        return (a.downloaded ?? 0).compareTo(b.downloaded ?? 0);
      case TorrentSortKey.uploaded:
        return (a.uploaded ?? 0).compareTo(b.uploaded ?? 0);
      case TorrentSortKey.eta:
        return a.eta!.compareTo(b.eta!);
      case TorrentSortKey.amountLeft:
        return (a.amountLeft ?? 0).compareTo(b.amountLeft ?? 0);
      case TorrentSortKey.ratio:
        return (a.ratio ?? 0).compareTo(b.ratio ?? 0);
      case TorrentSortKey.addedOn:
        return (a.addedOn ?? 0).compareTo(b.addedOn ?? 0);
      case TorrentSortKey.completionOn:
        return a.completionOn!.compareTo(b.completionOn!);
      case TorrentSortKey.lastActivity:
        return a.lastActivity!.compareTo(b.lastActivity!);
      case TorrentSortKey.numSeeds:
        return (a.numSeeds ?? 0).compareTo(b.numSeeds ?? 0);
      case TorrentSortKey.numLeechs:
        return (a.numLeechs ?? 0).compareTo(b.numLeechs ?? 0);
      case TorrentSortKey.availability:
        return (a.availability ?? 0).compareTo(b.availability ?? 0);
      case TorrentSortKey.priority:
        return (a.priority ?? 0).compareTo(b.priority ?? 0);
      case TorrentSortKey.timeActive:
        return (a.timeActive ?? 0).compareTo(b.timeActive ?? 0);
      case TorrentSortKey.seedingTime:
        return (a.seedingTime ?? 0).compareTo(b.seedingTime ?? 0);
    }
  }
}

bool _etaUnknown(TorrentInfoResponse t) {
  final eta = t.eta;
  return eta == null || eta < 0 || eta >= _unknownEta;
}

int _pin(
  TorrentInfoResponse a,
  TorrentInfoResponse b,
  bool Function(TorrentInfoResponse t) isLast,
) {
  final aLast = isLast(a);
  final bLast = isLast(b);
  if (aLast == bLast) return 0;
  return aLast ? 1 : -1;
}

/// 升序：下载中 → 做种 → 停止 → 错误。
int _stateRank(TorrentState? state) {
  switch (state) {
    case TorrentState.downloading:
      return 0;
    case TorrentState.forcedDL:
      return 1;
    case TorrentState.metaDL:
      return 2;
    case TorrentState.forcedMetaDL:
      return 3;
    case TorrentState.stalledDL:
      return 4;
    case TorrentState.queuedDL:
      return 5;
    case TorrentState.allocating:
      return 6;
    case TorrentState.checkingDL:
      return 7;
    case TorrentState.checkingResumeData:
      return 8;
    case TorrentState.moving:
      return 9;
    case TorrentState.uploading:
      return 20;
    case TorrentState.forcedUP:
      return 21;
    case TorrentState.stalledUP:
      return 22;
    case TorrentState.queuedUP:
      return 23;
    case TorrentState.checkingUP:
      return 24;
    case TorrentState.stoppedDL:
      return 40;
    case TorrentState.stoppedUP:
      return 41;
    case TorrentState.error:
      return 60;
    case TorrentState.missingFiles:
      return 61;
    case TorrentState.unknown:
    case null:
      return 80;
  }
}
