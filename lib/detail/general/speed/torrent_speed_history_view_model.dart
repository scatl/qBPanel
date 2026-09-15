import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/entity/response/torrent_info_response.dart';
import 'package:qbpanel/detail/general/speed/speed_chart_period.dart';
import 'package:qbpanel/detail/general/speed/speed_cumulative_average.dart';
import 'package:qbpanel/detail/general/speed/speed_sample.dart';
import 'package:qbpanel/detail/general/speed/torrent_speed_history_ui_state.dart';
import 'package:qbpanel/detail/general/speed/torrent_speed_ring_buffer.dart';
import 'package:qbpanel/http/poll_settings.dart';

final torrentSpeedHistoryProvider =
    NotifierProvider<TorrentSpeedHistoryViewModel, TorrentSpeedHistoryUiState>(
      TorrentSpeedHistoryViewModel.new,
    );

class TorrentSpeedHistoryViewModel
    extends Notifier<TorrentSpeedHistoryUiState> {
  final Map<String, TorrentSpeedRingBuffer> _buffers = {};
  int? _serverId;

  @override
  TorrentSpeedHistoryUiState build() => const TorrentSpeedHistoryUiState();

  void setPeriod(SpeedChartPeriod period) {
    final windows = ref.read(pollIntervalProvider).chartWindows;
    final index = windows.indexWhere((window) => window == period.window);
    final next = index < 0 ? 0 : index;
    if (state.periodIndex == next) return;
    state = state.copyWith(periodIndex: next);
  }

  void clear() {
    _buffers.clear();
    _serverId = null;
    state = state.copyWith(revision: state.revision + 1);
  }

  void recordAll({
    required int serverId,
    required Map<String, TorrentInfoResponse> torrents,
    DateTime? at,
  }) {
    if (torrents.isEmpty) return;
    final now = at ?? DateTime.now();
    final retainFor = ref.read(pollIntervalProvider).maxChartWindow;

    if (_serverId != serverId) {
      _buffers.clear();
      _serverId = serverId;
    }

    final activeKeys = <String>{};
    for (final entry in torrents.entries) {
      final key = _key(serverId, entry.key);
      activeKeys.add(key);
      final torrent = entry.value;
      (_buffers[key] ??= TorrentSpeedRingBuffer()).push(
        SpeedSample(
          at: now,
          download: torrent.dlspeed ?? 0,
          upload: torrent.upspeed ?? 0,
        ),
        retainFor: retainFor,
      );
    }

    _buffers.removeWhere((key, _) => !activeKeys.contains(key));
    state = state.copyWith(revision: state.revision + 1);
  }

  List<SpeedSample> chartSamples({
    required int? serverId,
    required String hash,
    SpeedChartPeriod? period,
    DateTime? end,
  }) {
    final buffer = _bufferFor(serverId: serverId, hash: hash);
    if (buffer == null) return const [];
    final window = (period ?? _periodOfState()).window;
    return buffer.samplesWithin(window, end ?? DateTime.now());
  }

  /// 可见窗内的平均曲线：从缓冲最早采样起累计平均，再裁到当前时间窗。
  List<SpeedSample> chartAverageSamples({
    required int? serverId,
    required String hash,
    SpeedChartPeriod? period,
    DateTime? end,
  }) {
    final buffer = _bufferFor(serverId: serverId, hash: hash);
    if (buffer == null) return const [];
    final at = end ?? DateTime.now();
    final history = buffer.samplesUpTo(at);
    if (history.isEmpty) return const [];
    final allAvg = cumulativeAverageSamples(history);
    final window = (period ?? _periodOfState()).window;
    final from = at.subtract(window);
    return [
      for (final sample in allAvg)
        if (!sample.at.isBefore(from) && !sample.at.isAfter(at)) sample,
    ];
  }

  /// 该种子缓冲区内最早 / 最新采样时间；无数据时返回 null。
  ({DateTime oldest, DateTime newest})? sampleBounds({
    required int? serverId,
    required String hash,
  }) {
    final buffer = _bufferFor(serverId: serverId, hash: hash);
    final oldest = buffer?.oldestAt;
    final newest = buffer?.newestAt;
    if (oldest == null || newest == null) return null;
    return (oldest: oldest, newest: newest);
  }

  TorrentSpeedRingBuffer? _bufferFor({
    required int? serverId,
    required String hash,
  }) {
    if (serverId == null || hash.isEmpty || _serverId != serverId) {
      return null;
    }
    return _buffers[_key(serverId, hash)];
  }

  SpeedChartPeriod _periodOfState() {
    final windows = ref.read(pollIntervalProvider).chartWindows;
    final index = state.periodIndex.clamp(0, windows.length - 1);
    return SpeedChartPeriod(windows[index]);
  }

  static String _key(int serverId, String hash) => '$serverId:$hash';
}
