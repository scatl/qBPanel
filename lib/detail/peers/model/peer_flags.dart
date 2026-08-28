import 'package:qbpanel/l10n/app_localizations.dart';

/// 与 qBittorrent `PeerInfo::determineFlags` 一致。
List<(String, String)> peerFlagLegend(AppLocalizations l10n) => [
      ('D', l10n.peerFlagD),
      ('d', l10n.peerFlagd),
      ('U', l10n.peerFlagU),
      ('u', l10n.peerFlagu),
      ('K', l10n.peerFlagK),
      ('?', l10n.peerFlagQuestion),
      ('O', l10n.peerFlagO),
      ('S', l10n.peerFlagS),
      ('I', l10n.peerFlagI),
      ('H', l10n.peerFlagH),
      ('X', l10n.peerFlagX),
      ('L', l10n.peerFlagL),
      ('E', l10n.peerFlagE),
      ('e', l10n.peerFlage),
      ('P', l10n.peerFlagP),
      ('h', l10n.peerFlagh),
    ];
