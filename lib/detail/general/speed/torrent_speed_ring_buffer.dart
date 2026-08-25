import 'package:qbpanel/detail/general/speed/speed_sample.dart';

/// 每个种子保留约 30 分钟内的采样（首页约 1.5s 一拍）。
class TorrentSpeedRingBuffer {
  final List<SpeedSample> _samples = [];

  void push(SpeedSample sample) {
    _samples.add(sample);
    final cutoff = sample.at.subtract(const Duration(minutes: 30, seconds: 2));
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
