import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/entity/response/torrent_info_response.dart';
import 'package:qbpanel/detail/general/speed/speed_chart_period.dart';
import 'package:qbpanel/detail/general/speed/speed_sample.dart';
import 'package:qbpanel/detail/general/speed/torrent_speed_history_ui_state.dart';
import 'package:qbpanel/detail/general/speed/torrent_speed_ring_buffer.dart';

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
    if (state.period == period) return;
    state = state.copyWith(period: period);
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
      );
    }

    _buffers.removeWhere((key, _) => !activeKeys.contains(key));
    state = state.copyWith(revision: state.revision + 1);
  }

  List<SpeedSample> chartSamples({
    required int? serverId,
    required String hash,
    SpeedChartPeriod? period,
  }) {
    if (serverId == null || hash.isEmpty || _serverId != serverId) {
      return const [];
    }
    final buffer = _buffers[_key(serverId, hash)];
    if (buffer == null) return const [];
    return buffer.samplesWithin(
      (period ?? state.period).window,
      DateTime.now(),
    );
  }

  static String _key(int serverId, String hash) => '$serverId:$hash';
}
