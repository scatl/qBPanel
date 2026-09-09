import 'package:qbpanel/detail/general/speed/speed_sample.dart';

/// 每个种子保留「当前刷新间隔最长曲线窗口」内的采样。
class TorrentSpeedRingBuffer {
  final List<SpeedSample> _samples = [];

  void push(SpeedSample sample, {required Duration retainFor}) {
    _samples.add(sample);
    final cutoff = sample.at.subtract(retainFor + const Duration(seconds: 2));
    while (_samples.isNotEmpty && _samples.first.at.isBefore(cutoff)) {
      _samples.removeAt(0);
    }
  }

  List<SpeedSample> samplesWithin(Duration window, DateTime now) {
    if (_samples.isEmpty) return const [];
    final from = now.subtract(window);
    return [
      for (final sample in _samples)
        if (!sample.at.isBefore(from)) sample,
    ];
  }
}
