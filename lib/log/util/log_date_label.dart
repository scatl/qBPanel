import 'package:qbpanel/l10n/app_localizations.dart';

String formatLogDateLabel(DateTime day, AppLocalizations l10n) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(day.year, day.month, day.day);
  if (target == today) return l10n.logToday;
  if (target == today.subtract(const Duration(days: 1))) return l10n.logYesterday;
  String two(int n) => n.toString().padLeft(2, '0');
  return '${day.year}-${two(day.month)}-${two(day.day)}';
}

DateTime logLocalDayFromTimestamp(int timestampSeconds) {
  final dt = DateTime.fromMillisecondsSinceEpoch(timestampSeconds * 1000);
  return DateTime(dt.year, dt.month, dt.day);
}
