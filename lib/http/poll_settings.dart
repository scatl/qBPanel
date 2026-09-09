import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/l10n/app_localizations.dart';
import 'package:qbpanel/storage/sp_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 应用轮询间隔。每种间隔对应 5 个速度曲线时间窗口，使最短窗大约 20 个采样点。
enum PollInterval {
  s1(Duration(seconds: 1)),
  ms1500(Duration(milliseconds: 1500)),
  s3(Duration(seconds: 3)),
  s5(Duration(seconds: 5));

  const PollInterval(this.duration);

  final Duration duration;

  /// 详情速度曲线的 5 档时间窗，随刷新间隔拉长，避免采样过稀或过密。
  List<Duration> get chartWindows => switch (this) {
    PollInterval.s1 => const [
      Duration(seconds: 20),
      Duration(minutes: 1),
      Duration(minutes: 5),
      Duration(minutes: 10),
      Duration(minutes: 20),
    ],
    PollInterval.ms1500 => const [
      Duration(seconds: 30),
      Duration(minutes: 1),
      Duration(minutes: 5),
      Duration(minutes: 10),
      Duration(minutes: 30),
    ],
    PollInterval.s3 => const [
      Duration(minutes: 1),
      Duration(minutes: 2),
      Duration(minutes: 10),
      Duration(minutes: 20),
      Duration(hours: 1),
    ],
    PollInterval.s5 => const [
      Duration(minutes: 2),
      Duration(minutes: 5),
      Duration(minutes: 15),
      Duration(minutes: 30),
      Duration(hours: 2),
    ],
  };

  Duration get maxChartWindow => chartWindows.last;

  String label(AppLocalizations l10n) => switch (this) {
    PollInterval.s1 => l10n.settingsPollInterval1s,
    PollInterval.ms1500 => l10n.settingsPollInterval1_5s,
    PollInterval.s3 => l10n.settingsPollInterval3s,
    PollInterval.s5 => l10n.settingsPollInterval5s,
  };

  static PollInterval parse(String? raw) {
    return PollInterval.values.firstWhere(
      (m) => m.name == raw,
      orElse: () => PollInterval.ms1500,
    );
  }
}

final pollIntervalProvider =
    NotifierProvider<PollIntervalController, PollInterval>(
      PollIntervalController.new,
    );

class PollIntervalController extends Notifier<PollInterval> {
  @override
  PollInterval build() {
    Future.microtask(_restore);
    return PollInterval.ms1500;
  }

  Future<void> _restore() async {
    final sp = await SharedPreferences.getInstance();
    state = PollInterval.parse(sp.getString(SpKey.poll.keyInterval));
  }

  Future<void> setInterval(PollInterval interval) async {
    state = interval;
    final sp = await SharedPreferences.getInstance();
    await sp.setString(SpKey.poll.keyInterval, interval.name);
  }
}
