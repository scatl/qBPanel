import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/detail/general/speed/speed_chart_period.dart';
import 'package:qbpanel/detail/general/speed/speed_cumulative_average.dart';
import 'package:qbpanel/detail/general/speed/speed_sample.dart';
import 'package:qbpanel/detail/general/speed/torrent_speed_history_view_model.dart';
import 'package:qbpanel/home/home_page_view_model.dart';
import 'package:qbpanel/http/poll_settings.dart';
import 'package:qbpanel/l10n/context_l10n.dart';

const _downloadColor = Color(0xFF049C08);
const _uploadColor = Color(0xFF3399FF);

class TorrentSpeedChart extends ConsumerWidget {
  const TorrentSpeedChart({super.key, required this.torrentHash});

  final String torrentHash;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyUi = ref.watch(torrentSpeedHistoryProvider);
    final pollInterval = ref.watch(pollIntervalProvider);
    final periods = speedChartPeriodsFor(pollInterval.chartWindows);
    final period = periods[historyUi.periodIndex.clamp(0, periods.length - 1)];
    final serverId = ref.watch(
      homePageProvider.select((s) => s.activeServer?.id),
    );
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.speed,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        _PeriodSelector(selected: period, periods: periods),
        const SizedBox(height: 8),
        _SpeedChartCanvas(
          serverId: serverId,
          torrentHash: torrentHash,
          period: period,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            _LegendLine(color: _downloadColor, label: context.l10n.download),
            _LegendLine(color: _uploadColor, label: context.l10n.upload),
            _LegendLine(
              color: _downloadColor,
              label: context.l10n.downloadAvg,
              dashed: true,
            ),
            _LegendLine(
              color: _uploadColor,
              label: context.l10n.uploadAvg,
              dashed: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _SpeedChartCanvas extends ConsumerStatefulWidget {
  const _SpeedChartCanvas({
    required this.serverId,
    required this.torrentHash,
    required this.period,
  });

  final int? serverId;
  final String torrentHash;
  final SpeedChartPeriod period;

  @override
  ConsumerState<_SpeedChartCanvas> createState() => _SpeedChartCanvasState();
}

class _SpeedChartCanvasState extends ConsumerState<_SpeedChartCanvas> {
  int? _scrubIndex;

  /// 非 null 表示已横滑离开「最新」：窗口右端固定，曲线不跟新采样。
  DateTime? _pinnedViewEnd;

  @override
  void didUpdateWidget(covariant _SpeedChartCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.period != widget.period ||
        oldWidget.serverId != widget.serverId ||
        oldWidget.torrentHash != widget.torrentHash) {
      _pinnedViewEnd = null;
      _scrubIndex = null;
    }
  }

  DateTime? _resolvedPinnedEnd() {
    final pinned = _pinnedViewEnd;
    if (pinned == null) return null;

    final bounds = ref
        .read(torrentSpeedHistoryProvider.notifier)
        .sampleBounds(serverId: widget.serverId, hash: widget.torrentHash);
    if (bounds == null) return null;

    final window = widget.period.window;
    final minEnd = bounds.oldest.add(window);
    final latest = bounds.newest;
    if (!minEnd.isBefore(latest)) return null;

    var end = pinned;
    if (end.isBefore(minEnd)) end = minEnd;
    if (!end.isBefore(latest.subtract(_liveSnapDistance))) return null;
    return end;
  }

  List<SpeedSample> _samplesForDisplay(DateTime? pinnedEnd) {
    return ref
        .read(torrentSpeedHistoryProvider.notifier)
        .chartSamples(
          serverId: widget.serverId,
          hash: widget.torrentHash,
          period: widget.period,
          end: pinnedEnd,
        );
  }

  List<SpeedSample> _averageSamplesForDisplay(DateTime? pinnedEnd) {
    return ref
        .read(torrentSpeedHistoryProvider.notifier)
        .chartAverageSamples(
          serverId: widget.serverId,
          hash: widget.torrentHash,
          period: widget.period,
          end: pinnedEnd,
        );
  }

  DateTime _viewEndOf(List<SpeedSample> samples, DateTime? pinnedEnd) {
    return pinnedEnd ??
        (samples.isNotEmpty ? samples.last.at : DateTime.now());
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details, Size size) {
    final textTheme = Theme.of(context).textTheme;
    final layout = _SpeedChartLayout.compute(size, textTheme);
    if (layout == null) return;

    final history = ref.read(torrentSpeedHistoryProvider.notifier);
    final bounds = history.sampleBounds(
      serverId: widget.serverId,
      hash: widget.torrentHash,
    );
    if (bounds == null) return;

    final window = widget.period.window;
    final windowMs = window.inMilliseconds;
    if (windowMs <= 0 || layout.chartRect.width <= 0) return;

    // 右滑看更早，左滑看更新。
    final deltaMs =
        (-details.delta.dx / layout.chartRect.width * windowMs).round();
    if (deltaMs == 0) return;

    final latest = bounds.newest;
    final minEnd = bounds.oldest.add(window);
    if (!minEnd.isBefore(latest)) {
      if (_pinnedViewEnd != null) {
        setState(() {
          _pinnedViewEnd = null;
          _scrubIndex = null;
        });
      }
      return;
    }

    final currentEnd = _pinnedViewEnd ?? latest;
    var next = currentEnd.add(Duration(milliseconds: deltaMs));
    if (next.isBefore(minEnd)) next = minEnd;

    if (!next.isBefore(latest.subtract(_liveSnapDistance))) {
      if (_pinnedViewEnd != null) {
        setState(() {
          _pinnedViewEnd = null;
          _scrubIndex = null;
        });
      }
      return;
    }

    if (_pinnedViewEnd == next) return;
    setState(() {
      _pinnedViewEnd = next;
      _scrubIndex = null;
    });
  }

  Duration get _liveSnapDistance {
    final poll = ref.read(pollIntervalProvider).duration;
    final half = Duration(microseconds: poll.inMicroseconds ~/ 2);
    return half < const Duration(milliseconds: 500)
        ? const Duration(milliseconds: 500)
        : half;
  }

  void _scrubAtGlobal(
    BuildContext hitContext,
    Offset global,
    Size size,
    TextTheme textTheme,
    List<SpeedSample> samples,
    DateTime viewEnd,
  ) {
    final box = hitContext.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    _scrubAt(box.globalToLocal(global), size, textTheme, samples, viewEnd);
  }

  void _scrubAt(
    Offset local,
    Size size,
    TextTheme textTheme,
    List<SpeedSample> samples,
    DateTime viewEnd,
  ) {
    if (samples.length < 2) return;
    final layout = _SpeedChartLayout.compute(size, textTheme);
    if (layout == null) return;
    final index = _nearestSampleIndex(
      localX: local.dx,
      chartRect: layout.chartRect,
      samples: samples,
      period: widget.period,
      viewEnd: viewEnd,
    );
    if (index == _scrubIndex) return;
    setState(() => _scrubIndex = index);
  }

  void _clearScrub() {
    if (_scrubIndex == null) return;
    setState(() => _scrubIndex = null);
  }

  @override
  Widget build(BuildContext context) {
    // 跟新时依赖 revision；钉住历史窗口时仍 watch，但不把新采样画进当前窗。
    ref.watch(torrentSpeedHistoryProvider);

    final pinnedEnd = _resolvedPinnedEnd();
    if (pinnedEnd != _pinnedViewEnd) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _pinnedViewEnd == pinnedEnd) return;
        setState(() => _pinnedViewEnd = pinnedEnd);
      });
    }

    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final samples = _samplesForDisplay(pinnedEnd);
    final avgSamples = samples.length < 2
        ? const <SpeedSample>[]
        : _averageSamplesForDisplay(pinnedEnd);
    final scrubIndex = samples.length < 2
        ? null
        : (_scrubIndex != null && _scrubIndex! >= samples.length
              ? samples.length - 1
              : _scrubIndex);

    final viewEnd = _viewEndOf(samples, pinnedEnd);
    final scrub = scrubIndex == null ||
            scrubIndex >= avgSamples.length
        ? null
        : (instant: samples[scrubIndex], average: avgSamples[scrubIndex]);

    return Container(
      height: 148,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
      ),
      child: samples.length < 2
          ? Center(
              child: Text(
                context.l10n.sampling,
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final size = Size(constraints.maxWidth, constraints.maxHeight);
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  // 图表内横滑浏览历史；会占用横向手势，避免与 Tab 切页抢。
                  onHorizontalDragUpdate: (d) =>
                      _onHorizontalDragUpdate(d, size),
                  onLongPressStart: (d) {
                    _scrubAt(
                      d.localPosition,
                      size,
                      textTheme,
                      samples,
                      viewEnd,
                    );
                  },
                  onLongPressMoveUpdate: (d) {
                    _scrubAtGlobal(
                      context,
                      d.globalPosition,
                      size,
                      textTheme,
                      samples,
                      viewEnd,
                    );
                  },
                  onLongPressEnd: (_) => _clearScrub(),
                  onLongPressCancel: _clearScrub,
                  child: Stack(
                    children: [
                      RepaintBoundary(
                        child: CustomPaint(
                          painter: _SpeedChartPainter(
                            samples: samples,
                            averageSamples: avgSamples,
                            period: widget.period,
                            viewEnd: viewEnd,
                            scheme: scheme,
                            textTheme: textTheme,
                            scrubIndex: scrubIndex,
                          ),
                          child: const SizedBox.expand(),
                        ),
                      ),
                      if (scrub != null)
                        _ScrubTooltip(
                          chartSize: size,
                          textTheme: textTheme,
                          scheme: scheme,
                          samples: samples,
                          period: widget.period,
                          viewEnd: viewEnd,
                          scrubIndex: scrubIndex!,
                          time: scrub.instant.at,
                          download: scrub.instant.download,
                          upload: scrub.instant.upload,
                          downloadAvg: scrub.average.download,
                          uploadAvg: scrub.average.upload,
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _ScrubTooltip extends StatelessWidget {
  const _ScrubTooltip({
    required this.chartSize,
    required this.textTheme,
    required this.scheme,
    required this.samples,
    required this.period,
    required this.viewEnd,
    required this.scrubIndex,
    required this.time,
    required this.download,
    required this.upload,
    required this.downloadAvg,
    required this.uploadAvg,
  });

  final Size chartSize;
  final TextTheme textTheme;
  final ColorScheme scheme;
  final List<SpeedSample> samples;
  final SpeedChartPeriod period;
  final DateTime viewEnd;
  final int scrubIndex;
  final DateTime time;
  final int download;
  final int upload;
  final int downloadAvg;
  final int uploadAvg;

  @override
  Widget build(BuildContext context) {
    final layout = _SpeedChartLayout.compute(chartSize, textTheme);
    if (layout == null) return const SizedBox.shrink();

    final windowStart = viewEnd.subtract(period.window);
    final windowMs = period.window.inMilliseconds;
    final t =
        samples[scrubIndex].at.difference(windowStart).inMilliseconds /
        windowMs;
    final x =
        layout.chartRect.left + t.clamp(0.0, 1.0) * layout.chartRect.width;

    const tooltipWidth = 128.0;
    const gap = 8.0;
    const edgePad = 8.0;
    final minLeft = edgePad;
    final maxLeft = math.max(minLeft, chartSize.width - tooltipWidth - edgePad);
    // Prefer right of the scrub line; flip to left when that would cover it.
    final placeOnLeft = x + gap + tooltipWidth > chartSize.width - edgePad;
    final left = (placeOnLeft ? x - gap - tooltipWidth : x + gap)
        .clamp(minLeft, maxLeft)
        .toDouble();
    final style = textTheme.labelSmall?.copyWith(
      color: scheme.onSurface,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    return Positioned(
      left: left,
      top: 8,
      width: tooltipWidth,
      child: Material(
        color: scheme.surfaceContainerHigh.withValues(alpha: 0.94),
        elevation: 2,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: DefaultTextStyle(
            style: style ?? const TextStyle(fontSize: 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatChartTime(time),
                  style: style?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                _ScrubValueRow(
                  color: _downloadColor,
                  label: context.l10n.download,
                  value: formatChartSpeed(download),
                ),
                _ScrubValueRow(
                  color: _uploadColor,
                  label: context.l10n.upload,
                  value: formatChartSpeed(upload),
                ),
                _ScrubValueRow(
                  color: _downloadColor,
                  label: context.l10n.downloadAvg,
                  value: formatChartSpeed(downloadAvg),
                  dashed: true,
                ),
                _ScrubValueRow(
                  color: _uploadColor,
                  label: context.l10n.uploadAvg,
                  value: formatChartSpeed(uploadAvg),
                  dashed: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScrubValueRow extends StatelessWidget {
  const _ScrubValueRow({
    required this.color,
    required this.label,
    required this.value,
    this.dashed = false,
  });

  final Color color;
  final String label;
  final String value;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          SizedBox(
            width: 12,
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
          Expanded(child: Text(label)),
          Text(value),
        ],
      ),
    );
  }
}

class _PeriodSelector extends ConsumerWidget {
  const _PeriodSelector({required this.selected, required this.periods});

  final SpeedChartPeriod selected;
  final List<SpeedChartPeriod> periods;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final period in periods)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: ChoiceChip(
                label: Text(period.label(context.l10n)),
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

class _SpeedChartLayout {
  const _SpeedChartLayout({required this.chartRect});

  final Rect chartRect;

  static const yAxisLabelLeft = 4.0;
  static const yAxisRight = 34.0;
  static const timeAxisReserve = 16.0;

  static _SpeedChartLayout? compute(Size size, TextTheme textTheme) {
    final labelStyle = textTheme.labelSmall?.copyWith(fontSize: 10);
    final labelPainter = TextPainter(
      text: TextSpan(text: '0B/s', style: labelStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    final topPad = 8 + labelPainter.height;
    final chartRect = Rect.fromLTWH(
      yAxisRight + 4,
      topPad,
      size.width - yAxisRight - 8,
      size.height - topPad - timeAxisReserve,
    );
    if (chartRect.width <= 0 || chartRect.height <= 0) return null;
    return _SpeedChartLayout(chartRect: chartRect);
  }
}

int _nearestSampleIndex({
  required double localX,
  required Rect chartRect,
  required List<SpeedSample> samples,
  required SpeedChartPeriod period,
  required DateTime viewEnd,
}) {
  final windowMs = period.window.inMilliseconds;
  if (windowMs <= 0 || samples.isEmpty) return 0;
  final t = ((localX - chartRect.left) / chartRect.width).clamp(0.0, 1.0);
  final windowStart = viewEnd.subtract(period.window);
  final target = windowStart.add(
    Duration(milliseconds: (t * windowMs).round()),
  );

  var best = 0;
  var bestDiff = samples.first.at.difference(target).abs();
  for (var i = 1; i < samples.length; i++) {
    final diff = samples[i].at.difference(target).abs();
    if (diff < bestDiff) {
      best = i;
      bestDiff = diff;
    }
  }
  return best;
}

/// 图表速度短格式。
String formatChartSpeed(int bytesPerSec) {
  if (bytesPerSec <= 0) return '0B/s';
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

String formatChartTime(DateTime time) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(time.hour)}:${two(time.minute)}:${two(time.second)}';
}

class _SpeedChartPainter extends CustomPainter {
  _SpeedChartPainter({
    required this.samples,
    required this.averageSamples,
    required this.period,
    required this.viewEnd,
    required this.scheme,
    required this.textTheme,
    this.scrubIndex,
  });

  final List<SpeedSample> samples;
  final List<SpeedSample> averageSamples;
  final SpeedChartPeriod period;
  final DateTime viewEnd;
  final ColorScheme scheme;
  final TextTheme textTheme;
  final int? scrubIndex;

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.length < 2) return;

    final avgSamples = averageSamples.isEmpty
        ? cumulativeAverageSamples(samples)
        : averageSamples;
    final windowStart = viewEnd.subtract(period.window);
    final maxSpeed = _maxSpeed(samples, avgSamples);

    final labelStyle = textTheme.labelSmall?.copyWith(
      color: scheme.onSurfaceVariant,
      fontSize: 10,
    );
    final labelPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    final topLabel = formatChartSpeed(maxSpeed);
    labelPainter.text = TextSpan(
      text: topLabel,
      style: labelStyle?.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
    labelPainter.layout();
    final topPad = 8 + labelPainter.height;
    final chartRect = Rect.fromLTWH(
      _SpeedChartLayout.yAxisRight + 4,
      topPad,
      size.width - _SpeedChartLayout.yAxisRight - 8,
      size.height - topPad - _SpeedChartLayout.timeAxisReserve,
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
    final labelX = math.max(
      _SpeedChartLayout.yAxisLabelLeft,
      _SpeedChartLayout.yAxisRight - labelPainter.width,
    );
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
        math.max(
          _SpeedChartLayout.yAxisLabelLeft,
          _SpeedChartLayout.yAxisRight - labelPainter.width,
        ),
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

    _drawTimeAxis(
      canvas,
      chartRect: chartRect,
      windowStart: windowStart,
      viewEnd: viewEnd,
      labelStyle: labelStyle?.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );

    final index = scrubIndex;
    if (index != null && index >= 0 && index < samples.length) {
      final windowMs = period.window.inMilliseconds;
      if (windowMs > 0) {
        final t =
            samples[index].at.difference(windowStart).inMilliseconds / windowMs;
        final x = chartRect.left + t.clamp(0.0, 1.0) * chartRect.width;
        final scrubPaint = Paint()
          ..color = scheme.onSurface.withValues(alpha: 0.45)
          ..strokeWidth = 1;
        canvas.drawLine(
          Offset(x, chartRect.top),
          Offset(x, chartRect.bottom),
          scrubPaint,
        );
      }
    }
  }

  void _drawTimeAxis(
    Canvas canvas, {
    required Rect chartRect,
    required DateTime windowStart,
    required DateTime viewEnd,
    TextStyle? labelStyle,
  }) {
    final mid = windowStart.add(
      Duration(milliseconds: period.window.inMilliseconds ~/ 2),
    );
    final labels = [
      (formatChartTime(windowStart), chartRect.left, TextAlign.left),
      (formatChartTime(mid), chartRect.center.dx, TextAlign.center),
      (formatChartTime(viewEnd), chartRect.right, TextAlign.right),
    ];
    final painter = TextPainter(textDirection: TextDirection.ltr);
    for (final (text, anchorX, align) in labels) {
      painter.text = TextSpan(text: text, style: labelStyle);
      painter.layout();
      final x = switch (align) {
        TextAlign.left => anchorX,
        TextAlign.right => anchorX - painter.width,
        _ => anchorX - painter.width / 2,
      };
      painter.paint(canvas, Offset(x, chartRect.bottom + 2));
    }
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
      final speed = math.max(0, valueOf(sample));
      final y =
          chartRect.bottom -
          (maxSpeed <= 0 ? 0 : speed / maxSpeed) * chartRect.height;
      points.add(Offset(x, y.clamp(chartRect.top, chartRect.bottom)));
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

  /// 单调三次样条（Fritsch–Carlson）：光滑且不越过相邻采样点，避免 0 以下过冲。
  Path _buildSmoothPath(List<Offset> points) {
    if (points.length < 3) return _buildLinePath(points);

    final n = points.length;
    final dx = List<double>.filled(n - 1, 0);
    final delta = List<double>.filled(n - 1, 0);
    for (var i = 0; i < n - 1; i++) {
      dx[i] = points[i + 1].dx - points[i].dx;
      delta[i] = dx[i].abs() < 1e-9
          ? 0
          : (points[i + 1].dy - points[i].dy) / dx[i];
    }

    final m = List<double>.filled(n, 0);
    m[0] = delta[0];
    m[n - 1] = delta[n - 2];
    for (var i = 1; i < n - 1; i++) {
      if (delta[i - 1] * delta[i] <= 0) {
        m[i] = 0;
      } else {
        m[i] = (delta[i - 1] + delta[i]) / 2;
      }
    }

    for (var i = 0; i < n - 1; i++) {
      if (delta[i].abs() < 1e-12) {
        m[i] = 0;
        m[i + 1] = 0;
        continue;
      }
      final a = m[i] / delta[i];
      final b = m[i + 1] / delta[i];
      final s = a * a + b * b;
      if (s > 9) {
        final t = 3 / math.sqrt(s);
        m[i] = t * a * delta[i];
        m[i + 1] = t * b * delta[i];
      }
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 0; i < n - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final h = dx[i] / 3;
      path.cubicTo(
        p0.dx + h,
        p0.dy + m[i] * h,
        p1.dx - h,
        p1.dy - m[i + 1] * h,
        p1.dx,
        p1.dy,
      );
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

  @override
  bool shouldRepaint(covariant _SpeedChartPainter oldDelegate) {
    return oldDelegate.samples != samples ||
        oldDelegate.averageSamples != averageSamples ||
        oldDelegate.period != period ||
        oldDelegate.viewEnd != viewEnd ||
        oldDelegate.scheme != scheme ||
        oldDelegate.scrubIndex != scrubIndex;
  }
}
