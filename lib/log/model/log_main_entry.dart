import 'package:qbpanel/api/entity/response/json_read.dart';
import 'package:qbpanel/log/model/log_level.dart';

class LogMainEntry {
  const LogMainEntry({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.level,
  });

  final int id;
  final String message;
  final int timestamp;
  final LogLevel level;

  factory LogMainEntry.fromJson(Map<String, dynamic> json) {
    return LogMainEntry(
      id: readInt(json['id']) ?? 0,
      message: readString(json['message']) ?? '',
      timestamp: readInt(json['timestamp']) ?? 0,
      level: LogLevel.fromTypeValue(readInt(json['type']) ?? 1),
    );
  }
}

List<LogMainEntry> parseLogMainList(dynamic data) {
  if (data is! List) return const [];
  return [
    for (final item in data)
      if (item is Map) LogMainEntry.fromJson(Map<String, dynamic>.from(item)),
  ];
}
