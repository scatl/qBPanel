import 'package:flutter/material.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/log/model/log_level.dart';
import 'package:qbpanel/log/model/log_level_colors.dart';
import 'package:qbpanel/widget/page_insets.dart';

class LogLevelFilterBar extends StatelessWidget {
  const LogLevelFilterBar({
    super.key,
    required this.enabledLevels,
    required this.onToggle,
  });

  final Set<LogLevel> enabledLevels;
  final ValueChanged<LogLevel> onToggle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        PageInsets.horizontal,
        16,
        PageInsets.horizontal,
        8,
      ),
      child: Row(
        children: [
          for (final level in LogLevel.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _LevelFilterChip(
                level: level,
                levelColor: level.resolveColor(scheme),
                textTheme: textTheme,
                selected: enabledLevels.contains(level),
                onToggle: () => onToggle(level),
              ),
            ),
        ],
      ),
    );
  }
}

class _LevelFilterChip extends StatelessWidget {
  const _LevelFilterChip({
    required this.level,
    required this.levelColor,
    required this.textTheme,
    required this.selected,
    required this.onToggle,
  });

  final LogLevel level;
  final Color levelColor;
  final TextTheme textTheme;
  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final labelColor = selected
        ? levelColor
        : levelColor.withValues(alpha: level == LogLevel.normal ? 0.7 : 0.85);

    return FilterChip(
      label: Text(
        level.label(context.l10n),
        style: textTheme.labelLarge?.copyWith(
          color: labelColor,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onToggle(),
      selectedColor: Color.alphaBlend(
        levelColor.withValues(alpha: 0.22),
        scheme.surfaceContainerHighest,
      ),
      side: BorderSide(
        color: selected
            ? levelColor.withValues(alpha: 0.85)
            : levelColor.withValues(alpha: 0.4),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
