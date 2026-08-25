import 'package:qbpanel/detail/general/speed/speed_chart_period.dart';

class TorrentSpeedHistoryUiState {
  const TorrentSpeedHistoryUiState({
    this.period = SpeedChartPeriod.s30,
    this.revision = 0,
  });

  final SpeedChartPeriod period;

  /// 每次写入采样 +1，供详情曲线 watch 刷新。
  final int revision;

  TorrentSpeedHistoryUiState copyWith({
    SpeedChartPeriod? period,
    int? revision,
  }) {
    return TorrentSpeedHistoryUiState(
      period: period ?? this.period,
      revision: revision ?? this.revision,
    );
  }
}
