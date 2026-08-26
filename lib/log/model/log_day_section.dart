class LogDaySection<T> {
  const LogDaySection({
    required this.day,
    required this.dateLabel,
    required this.entries,
  });

  final DateTime day;
  final String dateLabel;
  final List<T> entries;
}
