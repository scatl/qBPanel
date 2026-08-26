/// qBittorrent 日志级别（`/api/v2/log/main` 的 `type` 字段）。
enum LogLevel {
  normal(1, '普通'),
  info(2, '信息'),
  warning(4, '警告'),
  critical(8, '严重');

  const LogLevel(this.typeValue, this.label);

  final int typeValue;
  final String label;

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
