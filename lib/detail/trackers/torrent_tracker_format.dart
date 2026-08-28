import 'package:flutter/material.dart';
import 'package:qbpanel/detail/general/torrent_general_format.dart';
import 'package:qbpanel/l10n/app_localizations.dart';

String trackerStatusLabel({
  required int? status,
  required bool updating,
  required AppLocalizations l10n,
}) {
  if (updating || status == 3) return l10n.trackerUpdating;
  return switch (status) {
    0 => l10n.trackerDisabled,
    1 => l10n.trackerNotContacted,
    2 => l10n.trackerWorking,
    4 => l10n.trackerNotWorking,
    5 => l10n.trackerError,
    6 => l10n.trackerUnreachable,
    _ => '—',
  };
}

Color trackerStatusColor(
  ColorScheme scheme, {
  required int? status,
  required bool updating,
}) {
  if (updating || status == 3) return scheme.primary;
  return switch (status) {
    2 => scheme.tertiary,
    4 || 5 || 6 => scheme.error,
    _ => scheme.onSurfaceVariant,
  };
}

/// WebUI：`< 0` 显示 N/A。
String formatTrackerCount(int? value) {
  if (value == null || value < 0) return 'N/A';
  return '$value';
}

/// `next_announce` / `min_announce` 为 Unix 秒，展示剩余时间。
String formatAnnounceRemaining(int? unixSeconds, AppLocalizations l10n) {
  if (unixSeconds == null) return '—';
  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final remain = unixSeconds - now;
  return formatDurationSeconds(remain < 0 ? 0 : remain, l10n);
}
