import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/detail/general/speed/speed_chart_period.dart';
import 'package:qbpanel/detail/general/speed/speed_cumulative_average.dart';
import 'package:qbpanel/detail/general/speed/speed_sample.dart';
import 'package:qbpanel/detail/general/speed/torrent_speed_history_view_model.dart';
import 'package:qbpanel/home/home_page_view_model.dart';

const _downloadColor = Color(0xFF049C08);
const _uploadColor = Color(0xFF3399FF);

class TorrentSpeedChart extends ConsumerWidget {
  const TorrentSpeedChart({super.key, required this.torrentHash});

  final String torrentHash;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyUi = ref.watch(torrentSpeedHistoryProvider);
    final serverId = ref.watch(
      homePageProvider.select((s) => s.activeServer?.id),
    );
    final samples = ref
        .read(torrentSpeedHistoryProvider.notifier)
        .chartSamples(
          serverId: serverId,
          hash: torrentHash,
          period: historyUi.period,
        );

    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '速度',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        _PeriodSelector(selected: historyUi.period),
        const SizedBox(height: 8),
        Container(
          height: 132,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scheme.outlineVariant),
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
          ),
          child: samples.length < 2
              ? Center(
                  child: Text(
                    '采样中…',
                    style: textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                )
              : RepaintBoundary(
                  child: CustomPaint(
                    painter: _SpeedChartPainter(
                      samples: samples,
                      period: historyUi.period,
                      scheme: scheme,
                      textTheme: textTheme,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: const [
            _LegendLine(color: _downloadColor, label: '下载'),
            _LegendLine(color: _uploadColor, label: '上传'),
            _LegendLine(color: _downloadColor, label: '下载平均', dashed: true),
            _LegendLine(color: _uploadColor, label: '上传平均', dashed: true),
          ],
        ),
      ],
    );
  }
}

class _PeriodSelector extends ConsumerWidget {
  const _PeriodSelector({required this.selected});

  final SpeedChartPeriod selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final period in SpeedChartPeriod.values)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: ChoiceChip(
                label: Text(period.label),
                visualDensity: VisualDensity.compact,
                selected: selected == period,
                onSelected: (_) {
                  ref
                      .read(torrentSpeedHistoryProvider.notifier)
                      .setPeriod(period);
                },
                selectedColor: scheme.primaryContainer,
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: selected == period
                      ? scheme.onPrimaryContainer
                      : scheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LegendLine extends StatelessWidget {
  const _LegendLine({
    required this.color,
    required this.label,
    this.dashed = false,
  });

  final Color color;
  final String label;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 18,
          height: 2,
          child: dashed
              ? CustomPaint(painter: _DashedLinePainter(color: color))
              : DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    const dash = 4.0;
    const gap = 3.0;
    var x = 0.0;
    final y = size.height / 2;
    while (x < size.width) {
      final end = math.min(x + dash, size.width);
      canvas.drawLine(Offset(x, y), Offset(end, y), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _SpeedChartPainter extends CustomPainter {
  _SpeedChartPainter({
    required this.samples,
    required this.period,
    required this.scheme,
    required this.textTheme,
  });

  final List<SpeedSample> samples;
  final SpeedChartPeriod period;
  final ColorScheme scheme;
  final TextTheme textTheme;

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.length < 2) return;

    final avgSamples = cumulativeAverageSamples(samples);
    final now = samples.last.at;
    final windowStart = now.subtract(period.window);
    final maxSpeed = _maxSpeed(samples, avgSamples);

    final labelStyle = textTheme.labelSmall?.copyWith(
      color: scheme.onSurfaceVariant,
      fontSize: 10,
    );
    final labelPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    final topLabel = _formatChartSpeed(maxSpeed);
    labelPainter.text = TextSpan(
      text: topLabel,
      style: labelStyle?.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
    labelPainter.layout();
    const yAxisLabelLeft = 4.0;
    const yAxisRight = 34.0;
    final chartRect = Rect.fromLTWH(
      yAxisRight + 4,
      8 + labelPainter.height,
      size.width - yAxisRight - 8,
      size.height - 16 - labelPainter.height,
    );
    if (chartRect.width <= 0 || chartRect.height <= 0) return;

    final gridPaint = Paint()
      ..color = scheme.outlineVariant.withValues(alpha: 0.55)
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = chartRect.top + chartRect.height * i / 4;
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
    }

    labelPainter.text = TextSpan(
      text: topLabel,
      style: labelStyle?.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
    labelPainter.layout();
    final labelX = math.max(yAxisLabelLeft, yAxisRight - labelPainter.width);
    labelPainter.paint(canvas, Offset(labelX, chartRect.top - 2));
    labelPainter.text = TextSpan(
      text: '0B/s',
      style: labelStyle?.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
    labelPainter.layout();
    labelPainter.paint(
      canvas,
      Offset(
        math.max(yAxisLabelLeft, yAxisRight - labelPainter.width),
        chartRect.bottom - labelPainter.height,
      ),
    );

    _drawSeries(
      canvas,
      chartRect,
      windowStart,
      maxSpeed,
      avgSamples,
      (s) => s.download,
      _downloadColor,
      dashed: true,
    );
    _drawSeries(
      canvas,
      chartRect,
      windowStart,
      maxSpeed,
      avgSamples,
      (s) => s.upload,
      _uploadColor,
      dashed: true,
    );
    _drawSeries(
      canvas,
      chartRect,
      windowStart,
      maxSpeed,
      samples,
      (s) => s.download,
      _downloadColor,
    );
    _drawSeries(
      canvas,
      chartRect,
      windowStart,
      maxSpeed,
      samples,
      (s) => s.upload,
      _uploadColor,
    );
  }

  void _drawSeries(
    Canvas canvas,
    Rect chartRect,
    DateTime windowStart,
    int maxSpeed,
    List<SpeedSample> samples,
    int Function(SpeedSample) valueOf,
    Color color, {
    bool dashed = false,
  }) {
    final windowMs = period.window.inMilliseconds;
    if (windowMs <= 0) return;

    final points = <Offset>[];
    for (final sample in samples) {
      final t = sample.at.difference(windowStart).inMilliseconds / windowMs;
      final x = chartRect.left + t.clamp(0.0, 1.0) * chartRect.width;
      final speed = valueOf(sample);
      final y =
          chartRect.bottom -
          (maxSpeed <= 0 ? 0 : speed / maxSpeed) * chartRect.height;
      points.add(Offset(x, y));
    }
    if (points.isEmpty) return;

    final path = dashed ? _buildLinePath(points) : _buildSmoothPath(points);

    final paint = Paint()
      ..color = color.withValues(alpha: dashed ? 0.85 : 1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = dashed ? 1.25 : 1.5
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    if (dashed) {
      _drawDashedPath(canvas, path, paint);
    } else {
      canvas.drawPath(path, paint);
    }
  }

  Path _buildLinePath(List<Offset> points) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    return path;
  }

  /// Catmull-Rom 转 cubic，只影响绘制，不改采样数据。
  Path _buildSmoothPath(List<Offset> points) {
    if (points.length < 3) return _buildLinePath(points);

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 0; i < points.length - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[i];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = i + 2 < points.length ? points[i + 2] : p2;
      final cp1 = Offset(
        p1.dx + (p2.dx - p0.dx) / 6,
        p1.dy + (p2.dy - p0.dy) / 6,
      );
      final cp2 = Offset(
        p2.dx - (p3.dx - p1.dx) / 6,
        p2.dy - (p3.dy - p1.dy) / 6,
      );
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }
    return path;
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dash = 4.0;
    const gap = 3.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = math.min(distance + dash, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dash + gap;
      }
    }
  }

  int _maxSpeed(List<SpeedSample> instant, List<SpeedSample> average) {
    var max = 0;
    for (final sample in instant) {
      max = math.max(max, sample.download);
      max = math.max(max, sample.upload);
    }
    for (final sample in average) {
      max = math.max(max, sample.download);
      max = math.max(max, sample.upload);
    }
    if (max <= 0) return 12;
    return _niceMax(max);
  }

  int _niceMax(int value) {
    if (value <= 12) return 12;
    if (value <= 100) return ((value + 3) ~/ 4) * 4;
    if (value <= 1024) return ((value + 63) ~/ 64) * 64;
    var unit = 1024.0;
    var scaled = value / unit;
    while (scaled >= 1024) {
      unit *= 1024;
      scaled = value / unit;
    }
    final step = scaled <= 10 ? 2.0 : (scaled <= 100 ? 20.0 : 40.0);
    return ((scaled / step).ceil() * step * unit).round();
  }

  /// 图表 Y 轴用短格式，避免 `12.0 MB/s` 占过宽。
  static String _formatChartSpeed(int bytesPerSec) {
    if (bytesPerSec <= 0) return '0';
    const suffixes = ['B', 'K', 'M', 'G'];
    var value = bytesPerSec.toDouble();
    var unit = 0;
    while (value >= 1024 && unit < suffixes.length - 1) {
      value /= 1024;
      unit++;
    }
    final digits = unit == 0 ? 0 : (value >= 100 ? 0 : (value >= 10 ? 1 : 2));
    final number = value.toStringAsFixed(digits);
    if (unit == 0) return '${number}B/s';
    return '$number${suffixes[unit]}/s';
  }

  @override
  bool shouldRepaint(covariant _SpeedChartPainter oldDelegate) {
    return oldDelegate.samples != samples ||
        oldDelegate.period != period ||
        oldDelegate.scheme != scheme;
  }
}
