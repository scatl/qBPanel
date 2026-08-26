import 'package:qbpanel/api/entity/response/json_read.dart';

class LogPeerEntry {
  const LogPeerEntry({
    required this.id,
    required this.ip,
    required this.timestamp,
    required this.blocked,
    required this.reason,
  });

  final int id;
  final String ip;
  final int timestamp;
  final bool blocked;
  final String reason;

  factory LogPeerEntry.fromJson(Map<String, dynamic> json) {
    return LogPeerEntry(
      id: readInt(json['id']) ?? 0,
      ip: readString(json['ip']) ?? '',
      timestamp: readInt(json['timestamp']) ?? 0,
      blocked: readBool(json['blocked']) ?? false,
      reason: readString(json['reason']) ?? '',
    );
  }
}

List<LogPeerEntry> parseLogPeerList(dynamic data) {
  if (data is! List) return const [];
  return [
    for (final item in data)
      if (item is Map) LogPeerEntry.fromJson(Map<String, dynamic>.from(item)),
  ];
}
