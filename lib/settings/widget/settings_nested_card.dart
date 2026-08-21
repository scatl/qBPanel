import 'package:flutter/material.dart';

/// WebUI 嵌套 fieldset：标题在卡片内，用于分组内的子区块。
class SettingsNestedCard extends StatelessWidget {
  const SettingsNestedCard({
    super.key,
    this.title,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(12, 0, 12, 8),
  });

  /// 静态标题（如「添加重复种子时」）。若 legend 本身是开关，可留空并在 [child] 内放开关。
  final String? title;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.only(top: 8),
      elevation: 0,
      color: scheme.surface.withValues(alpha: 0.55),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: scheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
              child: Text(
                title!,
                style: textTheme.titleSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}
