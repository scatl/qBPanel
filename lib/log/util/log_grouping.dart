import 'package:qbpanel/log/model/log_day_section.dart';
import 'package:qbpanel/log/util/log_date_label.dart';

/// 将已按 id 降序排列的条目按本地日历日分组（日期组亦为新到旧）。
List<LogDaySection<T>> groupLogEntriesByDay<T>(
  List<T> entries,
  int Function(T entry) timestampSeconds,
) {
  if (entries.isEmpty) return const [];

  final buckets = <DateTime, List<T>>{};
  for (final entry in entries) {
    final day = logLocalDayFromTimestamp(timestampSeconds(entry));
    buckets.putIfAbsent(day, () => []).add(entry);
  }

  final days = buckets.keys.toList()..sort((a, b) => b.compareTo(a));
  return [
    for (final day in days)
      LogDaySection(
        day: day,
        dateLabel: formatLogDateLabel(day),
        entries: buckets[day]!,
      ),
  ];
}
