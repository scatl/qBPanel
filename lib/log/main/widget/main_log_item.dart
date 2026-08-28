import 'package:flutter/material.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/log/model/log_level_colors.dart';
import 'package:qbpanel/log/model/log_main_entry.dart';
import 'package:qbpanel/log/widget/log_item_meta_row.dart';
import 'package:qbpanel/widget/page_insets.dart';

class MainLogItem extends StatelessWidget {
  const MainLogItem({super.key, required this.entry});

  final LogMainEntry entry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final levelColor = entry.level.resolveColor(scheme);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PageInsets.horizontal,
        0,
        PageInsets.horizontal,
        8,
      ),
      child: Material(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LogItemMetaRow(
                id: entry.id,
                timestamp: entry.timestamp,
                trailing: Text(
                  entry.level.label(context.l10n),
                  style: textTheme.labelSmall?.copyWith(
                    color: levelColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                entry.message,
                style: textTheme.bodyMedium?.copyWith(color: levelColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
