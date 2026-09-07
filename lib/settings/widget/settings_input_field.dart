import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 设置项标题在输入框上方；框内只用 [hintText]，不用 floating [InputDecoration.labelText]。
class SettingsInputField extends StatelessWidget {
  const SettingsInputField({
    super.key,
    required this.label,
    required this.controller,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.hintText,
    this.suffix,
    this.trailing,
    this.keyboardType,
    this.inputFormatters,
    this.minLines,
    this.maxLines = 1,
    this.textInputAction,
    this.fieldKey,
  });

  final String label;
  final TextEditingController controller;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final String? hintText;
  final String? suffix;
  final Widget? trailing;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? minLines;
  final int maxLines;
  final TextInputAction? textInputAction;
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final titleColor =
        enabled ? null : scheme.onSurface.withValues(alpha: 0.38);
    final multiline = (minLines ?? 1) > 1 || maxLines > 1;

    final field = TextField(
      key: fieldKey,
      controller: controller,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      minLines: minLines,
      maxLines: maxLines,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        hintText: hintText,
        alignLabelWithHint: multiline,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.bodyLarge?.copyWith(color: titleColor)),
        const SizedBox(height: 4),
        if (suffix == null && trailing == null)
          field
        else
          Row(
            crossAxisAlignment: multiline
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Expanded(child: field),
              if (suffix != null) ...[
                const SizedBox(width: 8),
                Text(
                  suffix!,
                  style: textTheme.bodyMedium?.copyWith(color: scheme.outline),
                ),
              ],
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
      ],
    );
  }
}
