import 'dart:io';

import 'package:image/image.dart' as img;

/// Source: user-provided PNG (read-only).
const _sourcePath = r'E:\AndroidProject\qBPanel\assets\icons\qbpanel_icon2.png';

/// Android 12+ splash spec: 1152×1152, artwork inside a 768px circle.
/// Near-square side ≤ 768/√2 ≈ 543, otherwise the circle mask clips it square.
const _android12SplashSize = 1152;
const _android12SplashInner = 540;

/// Desktop: inset the mark so it reads slightly smaller on the launcher.
const _launcherPadRatio = 0.06;
const _launcherPadBg = (0x15, 0x89, 0x7C);

void main() {
  final sourceFile = File(_sourcePath);
  if (!sourceFile.existsSync()) {
    stderr.writeln('Missing source icon: $_sourcePath');
    exit(1);
  }

  final source = img.decodeImage(sourceFile.readAsBytesSync());
  if (source == null) {
    stderr.writeln('Failed to decode source');
    exit(1);
  }

  const launcherPath =
      r'E:\AndroidProject\qBPanel\assets\icons\qbpanel_launcher.png';
  const adaptivePath =
      r'E:\AndroidProject\qBPanel\assets\icons\qbpanel_adaptive_fg.png';
  const splashPath =
      r'E:\AndroidProject\qBPanel\assets\icons\qbpanel_splash.png';

  final logo = _knockoutOuterLight(source);

  _exportPaddedOpaque(
    logo,
    outPath: launcherPath,
    padRatio: _launcherPadRatio,
    background: _launcherPadBg,
  );
  File(launcherPath).copySync(adaptivePath);

  // Keep the original silhouette only: punch out the light canvas corners.
  // Do not apply any extra round-rect / squircle clip.
  _exportSplash(
    logo,
    outPath: splashPath,
    size: _android12SplashSize,
    inner: _android12SplashInner,
  );

  stdout.writeln(
    'Wrote qbpanel_launcher.png, qbpanel_adaptive_fg.png, qbpanel_splash.png',
  );
}

void _exportPaddedOpaque(
  img.Image source, {
  required String outPath,
  required double padRatio,
  required (int, int, int) background,
}) {
  const size = 1024;
  final pad = (size * padRatio).round();
  final inner = size - pad * 2;
  final (bgR, bgG, bgB) = background;

  final scaled = img.copyResize(
    source,
    width: inner,
    height: inner,
    interpolation: img.Interpolation.cubic,
  );

  final canvas = img.Image(width: size, height: size, numChannels: 4);
  for (var y = 0; y < size; y++) {
    for (var x = 0; x < size; x++) {
      canvas.setPixelRgba(x, y, bgR, bgG, bgB, 255);
    }
  }

  for (var y = 0; y < scaled.height; y++) {
    for (var x = 0; x < scaled.width; x++) {
      final p = scaled.getPixel(x, y);
      final a = p.a.toInt();
      if (a == 0) continue;
      if (a == 255) {
        canvas.setPixelRgba(pad + x, pad + y, p.r, p.g, p.b, 255);
        continue;
      }
      final t = a / 255.0;
      canvas.setPixelRgba(
        pad + x,
        pad + y,
        (p.r.toInt() * t + bgR * (1 - t)).round(),
        (p.g.toInt() * t + bgG * (1 - t)).round(),
        (p.b.toInt() * t + bgB * (1 - t)).round(),
        255,
      );
    }
  }

  _writePng(canvas, outPath);
}

/// Flood-fill near-white pixels connected to the canvas corners.
/// Keeps inner whites (the "qb" glyph and badge).
img.Image _knockoutOuterLight(img.Image source) {
  final w = source.width;
  final h = source.height;
  final out = img.Image(width: w, height: h, numChannels: 4);
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      final p = source.getPixel(x, y);
      out.setPixelRgba(x, y, p.r, p.g, p.b, 255);
    }
  }

  final visited = List<bool>.filled(w * h, false);
  final queue = <int>[];

  void tryEnqueue(int x, int y) {
    if (x < 0 || y < 0 || x >= w || y >= h) return;
    final i = y * w + x;
    if (visited[i]) return;
    if (!_isOuterLight(out.getPixel(x, y))) return;
    visited[i] = true;
    queue.add(i);
  }

  tryEnqueue(0, 0);
  tryEnqueue(w - 1, 0);
  tryEnqueue(0, h - 1);
  tryEnqueue(w - 1, h - 1);

  var qi = 0;
  while (qi < queue.length) {
    final i = queue[qi++];
    final x = i % w;
    final y = i ~/ w;
    out.setPixelRgba(x, y, 0, 0, 0, 0);
    for (var dy = -1; dy <= 1; dy++) {
      for (var dx = -1; dx <= 1; dx++) {
        if (dx == 0 && dy == 0) continue;
        tryEnqueue(x + dx, y + dy);
      }
    }
  }
  return out;
}

bool _isOuterLight(img.Pixel p) {
  if (p.a.toInt() < 16) return true;
  final r = p.r.toInt();
  final g = p.g.toInt();
  final b = p.b.toInt();
  final maxc = r > g ? (r > b ? r : b) : (g > b ? g : b);
  final minc = r < g ? (r < b ? r : b) : (g < b ? g : b);
  return maxc > 210 && (maxc - minc) < 40;
}

void _exportSplash(
  img.Image source, {
  required String outPath,
  required int size,
  required int inner,
}) {
  final pad = (size - inner) ~/ 2;

  final scaled = img.copyResize(
    source,
    width: inner,
    height: inner,
    interpolation: img.Interpolation.cubic,
  );

  final canvas = img.Image(width: size, height: size, numChannels: 4);
  for (var y = 0; y < size; y++) {
    for (var x = 0; x < size; x++) {
      canvas.setPixelRgba(x, y, 0, 0, 0, 0);
    }
  }

  for (var y = 0; y < scaled.height; y++) {
    for (var x = 0; x < scaled.width; x++) {
      final p = scaled.getPixel(x, y);
      final a = p.a.toInt();
      if (a == 0) continue;
      canvas.setPixelRgba(pad + x, pad + y, p.r, p.g, p.b, a);
    }
  }

  _writePng(canvas, outPath);
}

void _writePng(img.Image image, String outPath) {
  final tmp = File('$outPath.tmp');
  final out = File(outPath);
  tmp.writeAsBytesSync(img.encodePng(image));
  if (out.existsSync()) out.deleteSync();
  tmp.renameSync(outPath);
}
