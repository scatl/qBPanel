import 'package:qbpanel/l10n/app_localizations.dart';
import 'package:qbpanel/util/byte_format.dart';

/// 详情「普通」tab 文案，对齐 WebUI `prop-general.js`。
String formatDetailProgress(double? progress) {
  final percent = (progress ?? 0).clamp(0.0, 1.0) * 100;
  if (percent >= 99.95) return '100%';
  return '${percent.toStringAsFixed(1)}%';
}

String formatAvailability(double? value) {
  if (value == null || value < 0) return '';
  return value.toStringAsFixed(3);
}

String formatDurationSeconds(int? seconds, AppLocalizations l10n) {
  if (seconds == null || seconds < 0) return '—';
  if (seconds >= 8640000) return '∞';
  return formatLocalizedDuration(
    seconds,
    l10n,
    includeRemainingSeconds: true,
  );
}

String formatTimeActive(int? elapsed, int? seeding, AppLocalizations l10n) {
  final base = formatDurationSeconds(elapsed, l10n);
  if (seeding != null && seeding > 0) {
    return l10n.formatSeedingSuffix(base, formatDurationSeconds(seeding, l10n));
  }
  return base;
}

String formatConnections(int? current, int? limit, AppLocalizations l10n) {
  final n = current ?? 0;
  if (limit == null || limit < 0) return l10n.formatConnectionsUnlimited(n);
  return l10n.formatConnectionsLimited(n, limit);
}

String formatWithSession(int? total, int? session, AppLocalizations l10n) {
  return l10n.formatSession(formatBytes(total), formatBytes(session));
}

String formatSpeedAvg(int? current, int? average, AppLocalizations l10n) {
  return l10n.formatSpeedAvg(formatSpeed(current), formatSpeed(average));
}

String formatSpeedLimit(int? limit) {
  if (limit == null || limit < 0) return '∞';
  return formatSpeed(limit);
}

String formatCountTotal(int? current, int? total, AppLocalizations l10n) {
  return l10n.formatCountTotal(current ?? 0, total ?? 0);
}

String formatShareNumber(double? value) {
  if (value == null || value < 0) return '∞';
  return value.toStringAsFixed(2);
}

String formatUnixDate(int? seconds, {String unknown = '—'}) {
  if (seconds == null || seconds < 0) return unknown;
  final dt = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  String two(int n) => n.toString().padLeft(2, '0');
  return '${dt.year}-${two(dt.month)}-${two(dt.day)} '
      '${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
}

String formatPieces(
  int? count,
  int? pieceSize,
  int? have,
  AppLocalizations l10n,
) {
  if (count == null || count < 0) return '';
  return l10n.formatPieces(count, formatBytes(pieceSize), have ?? 0);
}

String formatPrivate(
  bool? hasMetadata,
  bool? isPrivate,
  AppLocalizations l10n,
) {
  if (hasMetadata != true) return l10n.notAvailable;
  if (isPrivate == null) return l10n.notAvailable;
  return isPrivate ? l10n.yes : l10n.no;
}

String formatInfoHash(String? hash, AppLocalizations l10n) {
  if (hash == null || hash.isEmpty) return l10n.notAvailable;
  return hash;
}
