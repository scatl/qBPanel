import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';

/// WebUI `PiecesBar`：已下蓝、正在下绿，按 piece 映射到像素。
class PiecesProgressBar extends StatelessWidget {
  const PiecesProgressBar({super.key, required this.pieces});

  final List<int> pieces;

  @override
  Widget build(BuildContext context) {
    return _PiecesBarFrame(painter: _ProgressPainter(pieces));
  }
}

/// WebUI `AvailabilityBar`：相对最大值的棕→绿→青→蓝热力。
class PiecesAvailabilityBar extends StatelessWidget {
  const PiecesAvailabilityBar({super.key, required this.availability});

  final List<int> availability;

  @override
  Widget build(BuildContext context) {
    return _PiecesBarFrame(painter: _AvailabilityPainter(availability));
  }
}

class _PiecesBarFrame extends StatelessWidget {
  const _PiecesBarFrame({required this.painter});

  final CustomPainter painter;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 18,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.outline),
      ),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: painter,
          isComplex: true,
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

const _downloadingColor = Color(0xFF049C08);
const _haveColor = Color(0xFF4D8CC9);
const _transparent = Color(0x00000000);
const _maxCanvasWidth = 4096;
const _statusDownloading = 1;
const _statusDownloaded = 2;

int _columnCount(double width, int pieceCount) {
  if (pieceCount <= 0 || width <= 0) return 0;
  return math.min(width.round(), math.min(pieceCount, _maxCanvasWidth));
}

double _ratio01(double raw, double ratio) {
  if (ratio <= 0) return 0;
  return math.min(1, (raw / ratio * 100).round() / 100);
}

/// 半透明蓝/绿叠在透明底上（再画到浅色页面），不要烤成不透明深色。
Color _progressColor(double downloading, double downloaded) {
  var color = _transparent;
  if (downloading > 0) {
    color = _srcOver(color, _downloadingColor.withValues(alpha: downloading));
  }
  if (downloaded > 0) {
    color = _srcOver(color, _haveColor.withValues(alpha: downloaded));
  }
  return color;
}

Color _srcOver(Color dst, Color src) {
  final sa = src.a;
  if (sa == 0) return dst;
  final da = dst.a * (1 - sa);
  final a = sa + da;
  if (a == 0) return _transparent;
  return Color.from(
    alpha: a,
    red: (src.r * sa + dst.r * da) / a,
    green: (src.g * sa + dst.g * da) / a,
    blue: (src.b * sa + dst.b * da) / a,
  );
}

void _drawColorRuns(
  Canvas canvas,
  Size size,
  int cols,
  Color Function(int x) colorAt,
) {
  final colWidth = size.width / cols;
  var start = 0;
  var last = colorAt(0);
  final paint = Paint();
  for (var x = 1; x <= cols; x++) {
    final current = x < cols ? colorAt(x) : null;
    if (current == last) continue;
    if (last.a != 0) {
      paint.color = last;
      canvas.drawRect(
        Rect.fromLTWH(start * colWidth, 0, (x - start) * colWidth, size.height),
        paint,
      );
    }
    if (current == null) break;
    last = current;
    start = x;
  }
}

class _ProgressPainter extends CustomPainter {
  _ProgressPainter(this.pieces);

  final List<int> pieces;

  @override
  void paint(Canvas canvas, Size size) {
    final cols = _columnCount(size.width, pieces.length);
    if (cols <= 0) return;

    var minStatus = 1 << 30;
    var maxStatus = 0;
    for (final status in pieces) {
      if (status > maxStatus) maxStatus = status;
      if (status < minStatus) minStatus = status;
    }
    if (maxStatus == 0) return;
    if (minStatus == _statusDownloaded) {
      canvas.drawRect(Offset.zero & size, Paint()..color = _haveColor);
      return;
    }

    final ratio = pieces.length / cols;
    final downloading = Float64List(cols);
    final downloaded = Float64List(cols);
    _accumulatePieces(
      length: pieces.length,
      cols: cols,
      ratio: ratio,
      add: (index, col, overlap) {
        final status = pieces[index];
        if (status == _statusDownloading) downloading[col] += overlap;
        if (status == _statusDownloaded) downloaded[col] += overlap;
      },
    );

    _drawColorRuns(canvas, size, cols, (x) {
      return _progressColor(
        _ratio01(downloading[x], ratio),
        _ratio01(downloaded[x], ratio),
      );
    });
  }

  @override
  bool shouldRepaint(covariant _ProgressPainter oldDelegate) {
    return !identical(oldDelegate.pieces, pieces);
  }
}

class _AvailabilityPainter extends CustomPainter {
  _AvailabilityPainter(this.availability);

  final List<int> availability;
  final List<Color?> _hslCache = List<Color?>.filled(101, null);

  @override
  void paint(Canvas canvas, Size size) {
    if (availability.isEmpty) return;
    var maxAvail = 0;
    for (final value in availability) {
      if (value > maxAvail) maxAvail = value;
    }
    if (maxAvail == 0) return;

    final cols = _columnCount(size.width, availability.length);
    if (cols <= 0) return;

    final ratio = availability.length / cols;
    final total = Float64List(cols);
    final weight = Float64List(cols);
    _accumulatePieces(
      length: availability.length,
      cols: cols,
      ratio: ratio,
      add: (index, col, overlap) {
        total[col] += availability[index] * overlap;
        weight[col] += overlap;
      },
    );

    _drawColorRuns(canvas, size, cols, (x) {
      final avg = weight[x] > 0 ? total[x] / weight[x] : 0.0;
      final t = ((avg / maxAvail) * 100).round().clamp(0, 100);
      return _hslCache[t] ??= _availabilityColor(t / 100);
    });
  }

  Color _availabilityColor(double t) {
    final clamped = t.clamp(0.0, 1.0);
    return HSLColor.fromAHSL(
      1,
      210 * clamped,
      0.55 * clamped,
      0.50 + 0.05 * clamped,
    ).toColor();
  }

  @override
  bool shouldRepaint(covariant _AvailabilityPainter oldDelegate) {
    return !identical(oldDelegate.availability, availability);
  }
}

/// 每个 piece 只扫一遍，按与列的重叠宽度累加。总复杂度 O(n + cols)。
void _accumulatePieces({
  required int length,
  required int cols,
  required double ratio,
  required void Function(int index, int col, double overlap) add,
}) {
  if (length <= 0 || cols <= 0 || ratio <= 0) return;
  for (var i = 0; i < length; i++) {
    final start = i.toDouble();
    final end = i + 1.0;
    var col = (start / ratio).floor();
    if (col < 0) col = 0;
    while (col < cols) {
      final colFrom = col * ratio;
      if (colFrom >= end) break;
      final overlap = math.min(end, colFrom + ratio) - math.max(start, colFrom);
      if (overlap > 0) add(i, col, overlap);
      col++;
    }
  }
}
