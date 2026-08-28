import 'package:flutter/material.dart';
import 'package:qbpanel/api/entity/response/torrent_info_response.dart';
import 'package:qbpanel/api/entity/response/torrent_state.dart';
import 'package:qbpanel/l10n/app_localizations.dart';

/// 长按菜单里随种子状态变化的显隐。
///
/// 开始 / 停止 / 强制启动对齐桌面端 `TransferListWidget::displayListMenu`。
class TorrentActionAvailability {
  const TorrentActionAvailability({
    required this.showStart,
    required this.showStop,
    required this.showForceStart,
    required this.canReannounce,
    required this.showSuperSeeding,
    required this.isCompleted,
  });

  final bool showStart;
  final bool showStop;
  final bool showForceStart;
  final bool canReannounce;
  final bool showSuperSeeding;
  /// `progress >= 1`，与 Web 右击「已下载完」一致。
  final bool isCompleted;

  factory TorrentActionAvailability.of(TorrentInfoResponse torrent) {
    final state = torrent.state;
    final forceStart = torrent.forceStart == true;
    final isStopped =
        state == TorrentState.stoppedDL || state == TorrentState.stoppedUP;
    final isError =
        state == TorrentState.error || state == TorrentState.missingFiles;
    final isChecking =
        state == TorrentState.checkingDL ||
        state == TorrentState.checkingUP ||
        state == TorrentState.checkingResumeData;
    final isQueued =
        state == TorrentState.queuedDL || state == TorrentState.queuedUP;

    final bool showStart;
    final bool showStop;
    final bool showForceStart;
    if (isStopped || isError) {
      showStart = true;
      showStop = false;
      showForceStart = true;
    } else if (isChecking) {
      showStart = true;
      showStop = true;
      showForceStart = true;
    } else if (forceStart) {
      showStart = true;
      showStop = true;
      showForceStart = false;
    } else {
      showStart = false;
      showStop = true;
      showForceStart = true;
    }

    final isCompleted = (torrent.progress ?? 0) >= 1;
    return TorrentActionAvailability(
      showStart: showStart,
      showStop: showStop,
      showForceStart: showForceStart,
      canReannounce: !isStopped && !isChecking && !isQueued && !isError,
      showSuperSeeding: isCompleted && torrent.hasMetadata != false,
      isCompleted: isCompleted,
    );
  }
}

class TorrentCopyItem {
  const TorrentCopyItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}

List<TorrentCopyItem> torrentCopyItems(
  TorrentInfoResponse torrent,
  AppLocalizations l10n,
) {
  final items = <TorrentCopyItem>[];
  void add(String label, String? value, IconData icon) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return;
    items.add(TorrentCopyItem(label: label, value: text, icon: icon));
  }

  add(l10n.sortName, torrent.name, Icons.drive_file_rename_outline);
  add(l10n.magnetLink, torrent.magnetUri, Icons.link);
  add('Hash v1', torrent.infohashV1, Icons.tag);
  add('Hash v2', torrent.infohashV2, Icons.tag);
  add('Torrent ID', torrent.hash, Icons.fingerprint);
  add(l10n.comment, torrent.comment, Icons.notes_outlined);
  add(l10n.contentPath, torrent.contentPath, Icons.folder_outlined);
  return items;
}
