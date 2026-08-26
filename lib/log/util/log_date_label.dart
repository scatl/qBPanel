String formatLogDateLabel(DateTime day) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(day.year, day.month, day.day);
  if (target == today) return '今天';
  if (target == today.subtract(const Duration(days: 1))) return '昨天';
  String two(int n) => n.toString().padLeft(2, '0');
  return '${day.year}-${two(day.month)}-${two(day.day)}';
}

DateTime logLocalDayFromTimestamp(int timestampSeconds) {
  final dt = DateTime.fromMillisecondsSinceEpoch(timestampSeconds * 1000);
  return DateTime(dt.year, dt.month, dt.day);
}
