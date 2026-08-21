import 'package:flutter/material.dart';
import 'package:qbpanel/settings/widget/setting_subtitle.dart';
import 'package:qbpanel/widget/page_insets.dart';

/// 设置页分组卡片，标题在卡片外。
class SettingsGroupCard extends StatelessWidget {
  const SettingsGroupCard({
    super.key,
    required this.child,
    this.title,
    this.padding,
  });

  final Widget child;
  final String? title;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final body = Padding(
      padding: const EdgeInsets.symmetric(horizontal: PageInsets.horizontal),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: padding == null
            ? child
            : Padding(padding: padding!, child: child),
      ),
    );
    if (title == null) return body;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: PageInsets.content,
          child: SettingSubtitle(title!),
        ),
        const SizedBox(height: 8),
        body,
      ],
    );
  }
}
