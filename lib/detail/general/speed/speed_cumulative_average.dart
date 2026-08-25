import 'package:qbpanel/detail/general/speed/speed_sample.dart';

/// 从时间窗内第一个采样到当前点，对瞬时速度做累计算术平均。
List<SpeedSample> cumulativeAverageSamples(List<SpeedSample> samples) {
  if (samples.isEmpty) return const [];
  final out = <SpeedSample>[];
  var sumDl = 0;
  var sumUp = 0;
  for (var i = 0; i < samples.length; i++) {
    sumDl += samples[i].download;
    sumUp += samples[i].upload;
    final count = i + 1;
    out.add(
      SpeedSample(
        at: samples[i].at,
        download: sumDl ~/ count,
        upload: sumUp ~/ count,
      ),
    );
  }
  return out;
}
