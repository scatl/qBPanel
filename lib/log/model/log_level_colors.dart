import 'package:flutter/material.dart';
import 'package:qbpanel/log/model/log_level.dart';

/// 各级别日志的前景色（对齐 qBittorrent WebUI 语义色）。
extension LogLevelColors on LogLevel {
  Color resolveColor(ColorScheme scheme) {
    return switch (this) {
      LogLevel.normal => scheme.onSurface,
      LogLevel.info => scheme.primary,
      LogLevel.warning => const Color(0xFFE65100),
      LogLevel.critical => scheme.error,
    };
  }
}
