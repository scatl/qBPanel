import 'package:flutter/material.dart';

/// 日志列表按日分组的标题；[filled] 为 true 时使用页面背景色（吸顶 overlay）。
class LogDateHeader extends StatelessWidget {
  const LogDateHeader({
    super.key,
    required this.label,
    this.filled = false,
  });

  final String label;
  final bool filled;

  static const height = 40.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final content = SizedBox(
      height: height,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            label,
            style: textTheme.titleSmall?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );

    if (!filled) return content;

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: content,
    );
  }
}
