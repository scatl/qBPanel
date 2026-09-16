import 'package:flutter/material.dart';
import 'package:qbpanel/home/list_layout_mode.dart';
import 'package:qbpanel/log/model/local_log_entry.dart';
import 'package:qbpanel/log/widget/log_item_meta_row.dart';
import 'package:qbpanel/widget/page_insets.dart';

class LocalLogItem extends StatelessWidget {
  const LocalLogItem({
    super.key,
    required this.entry,
    this.layout = ListLayoutMode.list,
  });

  final LocalLogEntry entry;
  final ListLayoutMode layout;

  bool get _grid => layout == ListLayoutMode.grid;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final card = Material(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: _grid
          ? Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: _body(textTheme, scheme),
              ),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: _body(textTheme, scheme),
            ),
    );

    if (_grid) return card;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PageInsets.horizontal,
        0,
        PageInsets.horizontal,
        8,
      ),
      child: card,
    );
  }

  Widget _body(TextTheme textTheme, ColorScheme scheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LogItemMetaRow(
          id: entry.id,
          timestamp: entry.timestampSeconds,
          trailing: Text(
            entry.tag,
            style: textTheme.labelSmall?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(entry.message, style: textTheme.bodyMedium),
      ],
    );
  }
}
