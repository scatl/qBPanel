import 'package:flutter/material.dart';
import 'package:qbpanel/api/entity/response/torrent_info_response.dart';
import 'package:qbpanel/l10n/app_localizations.dart';

/// Web 侧栏「状态」14 项。id 与 qB WebUI `selected_filter` 一致。
enum TorrentStatusFilter {
  all('all', Icons.apps_outlined),
  downloading('downloading', Icons.keyboard_double_arrow_down),
  seeding('seeding', Icons.keyboard_double_arrow_up),
  completed('completed', Icons.check),
  running('running', Icons.play_circle_outline),
  stopped('stopped', Icons.stop_circle_outlined),
  active('active', Icons.swap_vert),
  inactive('inactive', Icons.swap_vert),
  stalled('stalled', Icons.pause),
  stalledUploading('stalled_uploading', Icons.keyboard_double_arrow_up),
  stalledDownloading('stalled_downloading', Icons.keyboard_double_arrow_down),
  checking('checking', Icons.sync),
  moving('moving', Icons.gps_fixed),
  errored('errored', Icons.error_outline);

  const TorrentStatusFilter(this.apiValue, this.icon);

  /// WebUI / 后续筛选用的内部 id。
  final String apiValue;
  final IconData icon;

  String label(AppLocalizations l10n) => switch (this) {
        TorrentStatusFilter.all => l10n.filterAll,
        TorrentStatusFilter.downloading => l10n.filterDownloading,
        TorrentStatusFilter.seeding => l10n.filterSeeding,
        TorrentStatusFilter.completed => l10n.filterCompleted,
        TorrentStatusFilter.running => l10n.filterRunning,
        TorrentStatusFilter.stopped => l10n.filterStopped,
        TorrentStatusFilter.active => l10n.filterActive,
        TorrentStatusFilter.inactive => l10n.filterInactive,
        TorrentStatusFilter.stalled => l10n.filterStalled,
        TorrentStatusFilter.stalledUploading => l10n.filterStalledUploading,
        TorrentStatusFilter.stalledDownloading => l10n.filterStalledDownloading,
        TorrentStatusFilter.checking => l10n.filterChecking,
        TorrentStatusFilter.moving => l10n.filterMoving,
        TorrentStatusFilter.errored => l10n.filterErrored,
      };

  /// 对齐 WebUI `dynamicTable.js` 的 `applyFilter`（状态维）。
  bool matches(TorrentInfoResponse torrent) {
    final state = torrent.state?.apiValue ?? '';
    switch (this) {
      case TorrentStatusFilter.all:
        return true;
      case TorrentStatusFilter.downloading:
        return state == 'downloading' || state.contains('DL');
      case TorrentStatusFilter.seeding:
        return state == 'uploading' ||
            state == 'forcedUP' ||
            state == 'stalledUP' ||
            state == 'queuedUP' ||
            state == 'checkingUP';
      case TorrentStatusFilter.completed:
        return state == 'uploading' || state.contains('UP');
      case TorrentStatusFilter.stopped:
        return state.contains('stopped');
      case TorrentStatusFilter.running:
        return !state.contains('stopped');
      case TorrentStatusFilter.stalled:
        return state == 'stalledUP' || state == 'stalledDL';
      case TorrentStatusFilter.stalledUploading:
        return state == 'stalledUP';
      case TorrentStatusFilter.stalledDownloading:
        return state == 'stalledDL';
      case TorrentStatusFilter.active:
      case TorrentStatusFilter.inactive:
        final isActive = state == 'stalledDL'
            ? (torrent.upspeed ?? 0) > 0
            : state == 'metaDL' ||
                state == 'forcedMetaDL' ||
                state == 'downloading' ||
                state == 'forcedDL' ||
                state == 'uploading' ||
                state == 'forcedUP';
        return this == TorrentStatusFilter.active ? isActive : !isActive;
      case TorrentStatusFilter.checking:
        return state == 'checkingUP' ||
            state == 'checkingDL' ||
            state == 'checkingResumeData';
      case TorrentStatusFilter.moving:
        return state == 'moving';
      case TorrentStatusFilter.errored:
        return state == 'error' ||
            state == 'unknown' ||
            state == 'missingFiles';
    }
  }
}
