import 'package:qbpanel/l10n/app_localizations.dart';

/// 体积与速率展示（接口单位为 bytes / bytes/s）。
String formatBytes(int? bytes, {int? fractionDigits}) {
  if (bytes == null || bytes < 0) return '—';
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  var value = bytes.toDouble();
  var unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit++;
  }
  final digits = unit == 0
      ? 0
      : (fractionDigits ?? (value >= 10 ? 1 : 2));
  return '${value.toStringAsFixed(digits)} ${units[unit]}';
}

String formatSpeed(int? bytesPerSec) => '${formatBytes(bytesPerSec ?? 0)}/s';

String formatProgress(double? progress) {
  final p = (progress ?? 0).clamp(0.0, 1.0);
  final percent = p * 100;
  if (percent >= 99.95) return '100%';
  if (percent >= 10) return '${percent.toStringAsFixed(0)}%';
  return '${percent.toStringAsFixed(1)}%';
}

/// 把秒格式化为短时长（ETA / 详情共用）。
String formatLocalizedDuration(
  int seconds,
  AppLocalizations l10n, {
  bool includeRemainingSeconds = false,
}) {
  if (seconds < 60) return l10n.durationSeconds(seconds);
  final minutes = seconds ~/ 60;
  if (minutes < 60) {
    final remain = seconds % 60;
    if (!includeRemainingSeconds || remain == 0) {
      return l10n.durationMinutes(minutes);
    }
    return l10n.durationMinutesSeconds(minutes, remain);
  }
  final hours = minutes ~/ 60;
  final remainMinutes = minutes % 60;
  if (hours < 24) {
    return remainMinutes == 0
        ? l10n.durationHours(hours)
        : l10n.durationHoursMinutes(hours, remainMinutes);
  }
  final days = hours ~/ 24;
  final remainHours = hours % 24;
  return remainHours == 0
      ? l10n.durationDays(days)
      : l10n.durationDaysHours(days, remainHours);
}

/// qB 常用 `8640000` 秒表示未知/无限。
String formatEta(int? seconds, AppLocalizations l10n) {
  if (seconds == null || seconds < 0 || seconds >= 8640000) return '—';
  return formatLocalizedDuration(seconds, l10n);
}

String formatRatio(double? ratio) {
  if (ratio == null || ratio < 0) return '—';
  if (ratio >= 9999) return '∞';
  return ratio.toStringAsFixed(2);
}
