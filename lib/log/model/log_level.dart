import 'package:qbpanel/l10n/app_localizations.dart';

/// qBittorrent 日志级别（`/api/v2/log/main` 的 `type` 字段）。
enum LogLevel {
  normal(1),
  info(2),
  warning(4),
  critical(8);

  const LogLevel(this.typeValue);

  final int typeValue;

  String label(AppLocalizations l10n) => switch (this) {
        LogLevel.normal => l10n.logLevelNormal,
        LogLevel.info => l10n.logLevelInfo,
        LogLevel.warning => l10n.logLevelWarning,
        LogLevel.critical => l10n.logLevelCritical,
      };

  static const all = {LogLevel.normal, LogLevel.info, LogLevel.warning, LogLevel.critical};

  static LogLevel fromTypeValue(int value) {
    return switch (value) {
      2 => LogLevel.info,
      4 => LogLevel.warning,
      8 => LogLevel.critical,
      _ => LogLevel.normal,
    };
  }
}
