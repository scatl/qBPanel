enum SpeedChartPeriod {
  s30(Duration(seconds: 30), '30 秒'),
  min1(Duration(minutes: 1), '1 分钟'),
  min5(Duration(minutes: 5), '5 分钟'),
  min10(Duration(minutes: 10), '10 分钟'),
  min30(Duration(minutes: 30), '30 分钟');

  const SpeedChartPeriod(this.window, this.label);

  final Duration window;
  final String label;
}
