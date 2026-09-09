class TorrentSpeedHistoryUiState {
  const TorrentSpeedHistoryUiState({this.periodIndex = 0, this.revision = 0});

  /// 当前选中的时间窗下标（0–4），窗口时长由刷新间隔决定。
  final int periodIndex;

  /// 每次写入采样 +1，供详情曲线 watch 刷新。
  final int revision;

  TorrentSpeedHistoryUiState copyWith({int? periodIndex, int? revision}) {
    return TorrentSpeedHistoryUiState(
      periodIndex: periodIndex ?? this.periodIndex,
      revision: revision ?? this.revision,
    );
  }
}
