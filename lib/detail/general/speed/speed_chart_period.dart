import 'package:qbpanel/l10n/app_localizations.dart';

/// 详情速度曲线的时间窗口。具体 5 档随 [PollInterval] 变化。
class SpeedChartPeriod {
  const SpeedChartPeriod(this.window);

  final Duration window;

  String label(AppLocalizations l10n) {
    final seconds = window.inSeconds;
    if (seconds <= 0) return l10n.emDash;
    if (seconds < 60) return l10n.durationSeconds(seconds);
    if (seconds % 3600 == 0) return l10n.durationHours(seconds ~/ 3600);
    if (seconds % 60 == 0) return l10n.durationMinutes(seconds ~/ 60);
    return l10n.durationMinutesSeconds(seconds ~/ 60, seconds % 60);
  }

  @override
  bool operator ==(Object other) =>
      other is SpeedChartPeriod && other.window == window;

  @override
  int get hashCode => window.hashCode;
}

List<SpeedChartPeriod> speedChartPeriodsFor(List<Duration> windows) {
  return [for (final window in windows) SpeedChartPeriod(window)];
}
