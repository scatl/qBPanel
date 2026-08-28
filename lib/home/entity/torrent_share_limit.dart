import 'package:qbpanel/api/entity/response/torrent_info_response.dart';
import 'package:qbpanel/l10n/app_localizations.dart';

/// 分享率限制：`-2` 用全局，`-1` 不限。
enum TorrentShareLimitMode { global, unlimited, custom }

enum TorrentShareLimitAction {
  useDefault('Default'),
  stop('Stop'),
  remove('Remove'),
  removeWithContent('RemoveWithContent'),
  enableSuperSeeding('EnableSuperSeeding');

  const TorrentShareLimitAction(this.apiValue);

  final String apiValue;

  String label(AppLocalizations l10n) => switch (this) {
        TorrentShareLimitAction.useDefault => l10n.shareLimitUseDefault,
        TorrentShareLimitAction.stop => l10n.shareLimitStop,
        TorrentShareLimitAction.remove => l10n.shareLimitRemove,
        TorrentShareLimitAction.removeWithContent =>
          l10n.shareLimitRemoveWithContent,
        TorrentShareLimitAction.enableSuperSeeding =>
          l10n.shareLimitSuperSeeding,
      };

  static TorrentShareLimitAction parse(String? raw) {
    switch (raw) {
      case 'Stop':
      case '0':
        return stop;
      case 'Remove':
      case '1':
        return remove;
      case 'RemoveWithContent':
      case '2':
        return removeWithContent;
      case 'EnableSuperSeeding':
      case '3':
        return enableSuperSeeding;
      default:
        return useDefault;
    }
  }
}

class TorrentShareLimit {
  TorrentShareLimit._();

  static const global = -2;
  static const unlimited = -1;

  /// qB 5.2+ 的 `setShareLimits` 必须带 `shareLimitAction`。
  static bool supportsAction(TorrentInfoResponse torrent) {
    return torrent.shareLimitAction != null || torrent.shareLimitsMode != null;
  }

  static TorrentShareLimitMode modeOf(TorrentInfoResponse torrent) {
    final ratio = torrent.ratioLimit ?? global;
    final seeding = torrent.seedingTimeLimit ?? global;
    final inactive = torrent.inactiveSeedingTimeLimit ?? global;
    if (ratio == global && seeding == global && inactive == global) {
      return TorrentShareLimitMode.global;
    }
    if (ratio == unlimited && seeding == unlimited && inactive == unlimited) {
      return TorrentShareLimitMode.unlimited;
    }
    return TorrentShareLimitMode.custom;
  }

  /// `torrents/info` 的做种时限是秒；`setShareLimits` 要分钟。
  static int? minutesOf(int? seconds) {
    if (seconds == null || seconds <= 0) return null;
    final minutes = seconds ~/ 60;
    return minutes <= 0 ? 1 : minutes;
  }
}
