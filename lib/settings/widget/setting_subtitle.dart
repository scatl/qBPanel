import 'package:flutter/material.dart';

/// 区块大标题：与设置项标题同字号，用 primary 区分分组。
class SettingSectionTitle extends StatelessWidget {
  const SettingSectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(
        color: scheme.primary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

/// 选项小标题：比区块大标题更小、颜色更淡
class SettingSubtitle extends StatelessWidget {
  const SettingSubtitle(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: color ?? scheme.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
