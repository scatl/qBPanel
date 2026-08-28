import 'package:qbpanel/l10n/app_localizations.dart';

enum SpeedChartPeriod {
  s30(Duration(seconds: 30)),
  min1(Duration(minutes: 1)),
  min5(Duration(minutes: 5)),
  min10(Duration(minutes: 10)),
  min30(Duration(minutes: 30));

  const SpeedChartPeriod(this.window);

  final Duration window;

  String label(AppLocalizations l10n) => switch (this) {
        SpeedChartPeriod.s30 => l10n.speedPeriod30s,
        SpeedChartPeriod.min1 => l10n.speedPeriod1m,
        SpeedChartPeriod.min5 => l10n.speedPeriod5m,
        SpeedChartPeriod.min10 => l10n.speedPeriod10m,
        SpeedChartPeriod.min30 => l10n.speedPeriod30m,
      };
}
