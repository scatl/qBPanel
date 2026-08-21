import 'package:flutter/material.dart';
import 'package:qbpanel/widget/sheet/blur_modal_bottom_sheet.dart';

/// 标题一行、当前选项一行；整行可点，弹出选项列表。
/// [compact] 时标题与选项同一行，用于塞进水平布局。
class DropdownField<T> extends StatelessWidget {
  const DropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.enabled = true,
    this.compact = false,
  });

  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T> onChanged;
  final bool enabled;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final valueColor = enabled
        ? scheme.outline
        : scheme.outline.withValues(alpha: 0.38);

    final titleStyle = textTheme.bodyLarge?.copyWith(
      color: enabled ? null : scheme.onSurface.withValues(alpha: 0.38),
    );
    final valueStyle = textTheme.bodyMedium?.copyWith(color: valueColor);
    final child = compact
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: titleStyle),
              const SizedBox(width: 8),
              Text(_labelOf(value), style: valueStyle),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: titleStyle),
              const SizedBox(height: 4),
              Text(_labelOf(value), style: valueStyle),
            ],
          );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => _openPicker(context) : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: compact
              ? const EdgeInsets.symmetric(vertical: 8, horizontal: 4)
              : const EdgeInsets.symmetric(vertical: 8),
          child: child,
        ),
      ),
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    final selected = await showBlurModalBottomSheet<T>(
      context: context,
      builder: (ctx) => _DropdownSheet<T>(
        title: label,
        value: value,
        items: items,
      ),
    );
    if (selected == null || selected == value) return;
    onChanged(selected);
  }

  String _labelOf(T value) {
    for (final item in items) {
      if (item.value == value) return _itemLabel(item);
    }
    return value.toString();
  }
}

class _DropdownSheet<T> extends StatelessWidget {
  const _DropdownSheet({
    required this.title,
    required this.value,
    required this.items,
  });

  final String title;
  final T value;
  final List<DropdownMenuItem<T>> items;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.7;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                color: scheme.primary,
              ),
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final selected = item.value == value;
                return ListTile(
                  title: Text(_itemLabel(item)),
                  trailing: selected
                      ? Icon(Icons.check, color: scheme.primary)
                      : null,
                  onTap: () => Navigator.of(context).pop(item.value),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

String _itemLabel<T>(DropdownMenuItem<T> item) {
  final child = item.child;
  if (child is Text) {
    return child.data ?? child.textSpan?.toPlainText() ?? '';
  }
  return item.value?.toString() ?? '';
}
