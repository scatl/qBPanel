import 'package:qbpanel/util/byte_format.dart';

/// 详情「普通」tab 文案，对齐 WebUI `prop-general.js`。
String formatDetailProgress(double? progress) {
  final percent = (progress ?? 0).clamp(0.0, 1.0) * 100;
  if (percent >= 99.95) return '100%';
  return '${percent.toStringAsFixed(1)}%';
}

String formatAvailability(double? value) {
  if (value == null || value < 0) return '';
  return value.toStringAsFixed(3);
}

String formatDurationSeconds(int? seconds) {
  if (seconds == null || seconds < 0) return '—';
  if (seconds >= 8640000) return '∞';
  if (seconds < 60) return '$seconds 秒';
  final minutes = seconds ~/ 60;
  if (minutes < 60) {
    final remain = seconds % 60;
    return remain == 0 ? '$minutes 分钟' : '$minutes 分钟 $remain 秒';
  }
  final hours = minutes ~/ 60;
  final remainMinutes = minutes % 60;
  if (hours < 24) {
    return remainMinutes == 0 ? '$hours 小时' : '$hours 小时 $remainMinutes 分';
  }
  final days = hours ~/ 24;
  final remainHours = hours % 24;
  return remainHours == 0 ? '$days 天' : '$days 天 $remainHours 小时';
}

String formatTimeActive(int? elapsed, int? seeding) {
  final base = formatDurationSeconds(elapsed);
  if (seeding != null && seeding > 0) {
    return '$base (做种 ${formatDurationSeconds(seeding)})';
  }
  return base;
}

String formatConnections(int? current, int? limit) {
  final n = current ?? 0;
  if (limit == null || limit < 0) return '$n (最多 ∞)';
  return '$n (最多 $limit)';
}

String formatWithSession(int? total, int? session) {
  return '${formatBytes(total)} (本次 ${formatBytes(session)})';
}

String formatSpeedAvg(int? current, int? average) {
  return '${formatSpeed(current)} (平均 ${formatSpeed(average)})';
}

String formatSpeedLimit(int? limit) {
  if (limit == null || limit < 0) return '∞';
  return formatSpeed(limit);
}

String formatCountTotal(int? current, int? total) {
  return '${current ?? 0} (共 ${total ?? 0})';
}

String formatShareNumber(double? value) {
  if (value == null || value < 0) return '∞';
  return value.toStringAsFixed(2);
}

String formatUnixDate(int? seconds, {String unknown = '—'}) {
  if (seconds == null || seconds < 0) return unknown;
  final dt = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  String two(int n) => n.toString().padLeft(2, '0');
  return '${dt.year}-${two(dt.month)}-${two(dt.day)} '
      '${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
}

String formatPieces(int? count, int? pieceSize, int? have) {
  if (count == null || count < 0) return '';
  return '$count × ${formatBytes(pieceSize)} (已完成 ${have ?? 0})';
}

String formatPrivate(bool? hasMetadata, bool? isPrivate) {
  if (hasMetadata != true) return 'N/A';
  if (isPrivate == null) return 'N/A';
  return isPrivate ? '是' : '否';
}

String formatInfoHash(String? hash) {
  if (hash == null || hash.isEmpty) return 'N/A';
  return hash;
}
