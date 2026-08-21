import 'package:flutter/material.dart';
import 'package:qbpanel/detail/general/torrent_general_format.dart';

String trackerStatusLabel({required int? status, required bool updating}) {
  if (updating || status == 3) return '正在更新...';
  return switch (status) {
    0 => '已禁用',
    1 => '尚未联系',
    2 => '工作',
    4 => '未工作',
    5 => 'Tracker 错误',
    6 => '无法访问',
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
String formatAnnounceRemaining(int? unixSeconds) {
  if (unixSeconds == null) return '—';
  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final remain = unixSeconds - now;
  return formatDurationSeconds(remain < 0 ? 0 : remain);
}
