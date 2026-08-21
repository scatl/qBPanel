import 'package:flutter/material.dart';

/// 设置页开关行（卡片内 `contentPadding: zero`）。
class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: textTheme.bodyLarge),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: textTheme.bodySmall?.copyWith(color: scheme.outline),
            ),
      value: value,
      onChanged: onChanged,
    );
  }
}
