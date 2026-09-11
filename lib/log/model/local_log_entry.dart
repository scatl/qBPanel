/// 本地 `app_debug.log` 一行：`ISO8601 [tag] message`
class LocalLogEntry {
  const LocalLogEntry({
    required this.id,
    required this.timestamp,
    required this.tag,
    required this.message,
  });

  /// 文件内行号（从 0 起，旧 → 新）。
  final int id;
  final DateTime timestamp;
  final String tag;
  final String message;

  int get timestampSeconds => timestamp.millisecondsSinceEpoch ~/ 1000;

  static final _linePattern = RegExp(r'^(\S+)\s+\[([^\]]+)\]\s*(.*)$');

  static LocalLogEntry parse(int id, String line) {
    final match = _linePattern.firstMatch(line);
    if (match == null) {
      return LocalLogEntry(
        id: id,
        timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        tag: 'raw',
        message: line,
      );
    }
    final ts = DateTime.tryParse(match.group(1)!);
    return LocalLogEntry(
      id: id,
      timestamp: ts ?? DateTime.fromMillisecondsSinceEpoch(0),
      tag: match.group(2) ?? 'raw',
      message: match.group(3) ?? '',
    );
  }
}
