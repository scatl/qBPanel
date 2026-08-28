import 'package:qbpanel/l10n/app_localizations.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

/// WebUI「速度」页状态。速率单位为 KiB/s，`0` 表示无限制。
class SpeedSettingsUiState {
  const SpeedSettingsUiState({
    this.emptyState = const EmptyState.content(),
    this.saving = false,
    this.upLimitKib = 0,
    this.dlLimitKib = 0,
    this.altUpLimitKib = 0,
    this.altDlLimitKib = 0,
    this.limitUtpRate = true,
    this.limitTcpOverhead = false,
    this.limitLanPeers = true,
    this.schedulerEnabled = false,
    this.scheduleFromHour = 8,
    this.scheduleFromMin = 0,
    this.scheduleToHour = 20,
    this.scheduleToMin = 0,
    this.schedulerDays = SpeedSchedulerDays.everyDay,
  });

  final EmptyState emptyState;
  final bool saving;

  final int upLimitKib;
  final int dlLimitKib;
  final int altUpLimitKib;
  final int altDlLimitKib;

  final bool limitUtpRate;
  final bool limitTcpOverhead;
  final bool limitLanPeers;

  final bool schedulerEnabled;
  final int scheduleFromHour;
  final int scheduleFromMin;
  final int scheduleToHour;
  final int scheduleToMin;
  final SpeedSchedulerDays schedulerDays;

  bool get ready => emptyState.ready;

  SpeedSettingsUiState copyWith({
    EmptyState? emptyState,
    bool? saving,
    int? upLimitKib,
    int? dlLimitKib,
    int? altUpLimitKib,
    int? altDlLimitKib,
    bool? limitUtpRate,
    bool? limitTcpOverhead,
    bool? limitLanPeers,
    bool? schedulerEnabled,
    int? scheduleFromHour,
    int? scheduleFromMin,
    int? scheduleToHour,
    int? scheduleToMin,
    SpeedSchedulerDays? schedulerDays,
  }) {
    return SpeedSettingsUiState(
      emptyState: emptyState ?? this.emptyState,
      saving: saving ?? this.saving,
      upLimitKib: upLimitKib ?? this.upLimitKib,
      dlLimitKib: dlLimitKib ?? this.dlLimitKib,
      altUpLimitKib: altUpLimitKib ?? this.altUpLimitKib,
      altDlLimitKib: altDlLimitKib ?? this.altDlLimitKib,
      limitUtpRate: limitUtpRate ?? this.limitUtpRate,
      limitTcpOverhead: limitTcpOverhead ?? this.limitTcpOverhead,
      limitLanPeers: limitLanPeers ?? this.limitLanPeers,
      schedulerEnabled: schedulerEnabled ?? this.schedulerEnabled,
      scheduleFromHour: scheduleFromHour ?? this.scheduleFromHour,
      scheduleFromMin: scheduleFromMin ?? this.scheduleFromMin,
      scheduleToHour: scheduleToHour ?? this.scheduleToHour,
      scheduleToMin: scheduleToMin ?? this.scheduleToMin,
      schedulerDays: schedulerDays ?? this.schedulerDays,
    );
  }
}

/// `scheduler_days`
enum SpeedSchedulerDays {
  everyDay(0),
  weekdays(1),
  weekends(2),
  monday(3),
  tuesday(4),
  wednesday(5),
  thursday(6),
  friday(7),
  saturday(8),
  sunday(9);

  const SpeedSchedulerDays(this.apiValue);
  final int apiValue;

  String label(AppLocalizations l10n) => switch (this) {
        SpeedSchedulerDays.everyDay => l10n.schedulerEveryDay,
        SpeedSchedulerDays.weekdays => l10n.schedulerWeekdays,
        SpeedSchedulerDays.weekends => l10n.schedulerWeekends,
        SpeedSchedulerDays.monday => l10n.schedulerMonday,
        SpeedSchedulerDays.tuesday => l10n.schedulerTuesday,
        SpeedSchedulerDays.wednesday => l10n.schedulerWednesday,
        SpeedSchedulerDays.thursday => l10n.schedulerThursday,
        SpeedSchedulerDays.friday => l10n.schedulerFriday,
        SpeedSchedulerDays.saturday => l10n.schedulerSaturday,
        SpeedSchedulerDays.sunday => l10n.schedulerSunday,
      };

  static SpeedSchedulerDays fromApi(int? value) {
    for (final item in values) {
      if (item.apiValue == value) return item;
    }
    return SpeedSchedulerDays.everyDay;
  }
}
