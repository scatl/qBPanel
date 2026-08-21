import 'package:flutter/material.dart';
import 'package:qbpanel/api/entity/response/torrent_info_response.dart';

/// Web 侧栏「状态」14 项。id 与 qB WebUI `selected_filter` 一致。
enum TorrentStatusFilter {
  all('all', '全部', Icons.apps_outlined),
  downloading('downloading', '下载', Icons.keyboard_double_arrow_down),
  seeding('seeding', '做种', Icons.keyboard_double_arrow_up),
  completed('completed', '完成', Icons.check),
  running('running', '正运行', Icons.play_circle_outline),
  stopped('stopped', '已停止', Icons.stop_circle_outlined),
  active('active', '活动', Icons.swap_vert),
  inactive('inactive', '空闲', Icons.swap_vert),
  stalled('stalled', '暂停', Icons.pause),
  stalledUploading('stalled_uploading', '上传已暂停', Icons.keyboard_double_arrow_up),
  stalledDownloading('stalled_downloading', '下载已暂停', Icons.keyboard_double_arrow_down),
  checking('checking', '正在检查', Icons.sync),
  moving('moving', '正在移动', Icons.gps_fixed),
  errored('errored', '错误', Icons.error_outline);

  const TorrentStatusFilter(this.apiValue, this.displayText, this.icon);

  /// WebUI / 后续筛选用的内部 id。
  final String apiValue;

  final String displayText;
  final IconData icon;

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
