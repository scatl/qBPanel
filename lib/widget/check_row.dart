import 'package:flutter/material.dart';

/// 去掉热区内边距、与同级文字左对齐的 [Checkbox]。
class AlignedCheckbox extends StatelessWidget {
  const AlignedCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Checkbox.width,
      height: Checkbox.width,
      child: OverflowBox(
        maxWidth: 32,
        maxHeight: 32,
        alignment: Alignment.center,
        child: Checkbox(
          value: value,
          onChanged: onChanged == null
              ? null
              : (next) => onChanged!(next ?? false),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }
}

/// 左侧勾选 + 文案；勾选框与同级文字左对齐。
class CheckRow extends StatelessWidget {
  const CheckRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.trailing,
  });

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final canTap = enabled && onChanged != null;

    return InkWell(
      onTap: canTap ? () => onChanged!(!value) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            AlignedCheckbox(
              value: value,
              onChanged: canTap ? onChanged : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: textTheme.bodyLarge?.copyWith(
                  color: canTap
                      ? null
                      : scheme.onSurface.withValues(alpha: 0.38),
                ),
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
