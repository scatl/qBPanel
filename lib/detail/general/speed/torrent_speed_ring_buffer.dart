import 'package:qbpanel/detail/general/speed/speed_sample.dart';

/// 每个种子保留「当前刷新间隔最长曲线窗口」内的采样。
class TorrentSpeedRingBuffer {
  final List<SpeedSample> _samples = [];

  DateTime? get oldestAt => _samples.isEmpty ? null : _samples.first.at;

  DateTime? get newestAt => _samples.isEmpty ? null : _samples.last.at;

  void push(SpeedSample sample, {required Duration retainFor}) {
    _samples.add(sample);
    final cutoff = sample.at.subtract(retainFor + const Duration(seconds: 2));
    while (_samples.isNotEmpty && _samples.first.at.isBefore(cutoff)) {
      _samples.removeAt(0);
    }
  }

  /// 返回不晚于 [end] 的全部采样（整段缓冲历史到该时刻）。
  List<SpeedSample> samplesUpTo(DateTime end) {
    if (_samples.isEmpty) return const [];
    return [
      for (final sample in _samples)
        if (!sample.at.isAfter(end)) sample,
    ];
  }

  /// [end] 为窗口右端；返回 `(end - window, end]` 内采样。
  List<SpeedSample> samplesWithin(Duration window, DateTime end) {
    if (_samples.isEmpty) return const [];
    final from = end.subtract(window);
    return [
      for (final sample in _samples)
        if (!sample.at.isBefore(from) && !sample.at.isAfter(end)) sample,
    ];
  }
}
