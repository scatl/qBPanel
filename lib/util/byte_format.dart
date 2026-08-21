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

/// qB 常用 `8640000` 秒表示未知/无限。
String formatEta(int? seconds) {
  if (seconds == null || seconds < 0 || seconds >= 8640000) return '—';
  if (seconds < 60) return '$seconds 秒';
  final minutes = seconds ~/ 60;
  if (minutes < 60) return '$minutes 分钟';
  final hours = minutes ~/ 60;
  final remainMinutes = minutes % 60;
  if (hours < 24) {
    return remainMinutes == 0 ? '$hours 小时' : '$hours 小时 $remainMinutes 分';
  }
  final days = hours ~/ 24;
  final remainHours = hours % 24;
  return remainHours == 0 ? '$days 天' : '$days 天 $remainHours 小时';
}

String formatRatio(double? ratio) {
  if (ratio == null || ratio < 0) return '—';
  if (ratio >= 9999) return '∞';
  return ratio.toStringAsFixed(2);
}
