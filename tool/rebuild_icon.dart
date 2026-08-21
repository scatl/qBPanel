import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

/// Restore ORIGINAL mark; control size via padding.
/// Adaptive foreground uses transparent bg so Android doesn't shrink a white square.
void main() {
  final sourcePath =
      r'C:\Users\sca_tl\.cursor\projects\e-AndroidProject-qBPanel\assets\qbpanel_icon.png';
  final sourceFile = File(sourcePath);
  if (!sourceFile.existsSync()) {
    stderr.writeln('Missing original icon: $sourcePath');
    exit(1);
  }

  final source = img.decodeImage(sourceFile.readAsBytesSync());
  if (source == null) {
    stderr.writeln('Failed to decode source');
    exit(1);
  }

  final logoLayer = img.Image(
    width: source.width,
    height: source.height,
    numChannels: 4,
  );
  var minX = source.width;
  var minY = source.height;
  var maxX = 0;
  var maxY = 0;

  for (var y = 0; y < source.height; y++) {
    for (var x = 0; x < source.width; x++) {
      final p = source.getPixel(x, y);
      final r = p.r.toInt();
      final g = p.g.toInt();
      final b = p.b.toInt();
      final a = p.a.toInt();

      final isLogo = a > 8 &&
          g > 60 &&
          g > r + 15 &&
          r < 140 &&
          b < 160 &&
          (r + g + b) < 430;

      if (isLogo) {
        logoLayer.setPixelRgba(x, y, r, g, b, 255);
        if (x < minX) minX = x;
        if (y < minY) minY = y;
        if (x > maxX) maxX = x;
        if (y > maxY) maxY = y;
      } else {
        logoLayer.setPixelRgba(x, y, 0, 0, 0, 0);
      }
    }
  }

  if (maxX <= minX || maxY <= minY) {
    stderr.writeln('Failed to find logo pixels');
    exit(1);
  }

  const margin = 4;
  minX = math.max(0, minX - margin);
  minY = math.max(0, minY - margin);
  maxX = math.min(source.width - 1, maxX + margin);
  maxY = math.min(source.height - 1, maxY + margin);

  final cropped = img.copyCrop(
    logoLayer,
    x: minX,
    y: minY,
    width: maxX - minX + 1,
    height: maxY - minY + 1,
  );

  // Desktop / adaptive: slightly smaller mark
  _writeIcon(
    cropped,
    outPath: r'E:\AndroidProject\qBPanel\assets\icons\qbpanel_launcher.png',
    padRatio: 0.18,
    transparentBg: false,
  );
  _writeIcon(
    cropped,
    outPath: r'E:\AndroidProject\qBPanel\assets\icons\qbpanel_adaptive_fg.png',
    padRatio: 0.20,
    transparentBg: true,
  );
  // Splash: more padding for Android 12 circle
  _writeIcon(
    cropped,
    outPath: r'E:\AndroidProject\qBPanel\assets\icons\qbpanel_splash.png',
    padRatio: 0.24,
    transparentBg: false,
  );
}

void _writeIcon(
  img.Image cropped, {
  required String outPath,
  required double padRatio,
  required bool transparentBg,
}) {
  const outSize = 1024;
  final content = (outSize * (1 - padRatio * 2)).round();
  final scale = math.min(content / cropped.width, content / cropped.height);
  final logoW = math.max(1, (cropped.width * scale).round());
  final logoH = math.max(1, (cropped.height * scale).round());

  final hi = img.copyResize(
    cropped,
    width: logoW * 2,
    height: logoH * 2,
    interpolation: img.Interpolation.average,
  );
  final logo = img.copyResize(
    hi,
    width: logoW,
    height: logoH,
    interpolation: img.Interpolation.average,
  );

  final out = img.Image(width: outSize, height: outSize, numChannels: 4);
  if (transparentBg) {
    img.fill(out, color: img.ColorRgba8(0, 0, 0, 0));
  } else {
    img.fill(out, color: img.ColorRgba8(255, 255, 255, 255));
  }

  final dx = ((outSize - logoW) / 2).round();
  final dy = ((outSize - logoH) / 2).round();
  img.compositeImage(out, logo, dstX: dx, dstY: dy);

  // For opaque launcher/splash, force non-logo to pure white
  if (!transparentBg) {
    for (final p in out) {
      if (p.a < 16) {
        p
          ..r = 255
          ..g = 255
          ..b = 255
          ..a = 255;
      } else {
        final r = p.r.toInt();
        final g = p.g.toInt();
        final b = p.b.toInt();
        final isLogo = g > 60 && g > r + 10 && r < 150 && (r + g + b) < 450;
        if (!isLogo) {
          p
            ..r = 255
            ..g = 255
            ..b = 255
            ..a = 255;
        }
      }
    }
  }

  File(outPath).writeAsBytesSync(img.encodePng(out));
  stdout.writeln(
    'Wrote $outPath (pad=${(padRatio * 100).round()}%, transparent=$transparentBg)',
  );
}
