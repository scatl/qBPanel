import 'package:flutter/material.dart';
import 'package:qbpanel/detail/content/torrent_content_node.dart';
import 'package:qbpanel/detail/general/torrent_general_format.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/util/byte_format.dart';
import 'package:qbpanel/widget/page_insets.dart';

/// 每一层竖线占用的宽度。
const _treeLevelWidth = 20.0;

/// 从竖线接到卡片的横线长度。
const _treeBranchWidth = 12.0;

/// 卡片外侧上下间距；画在 gutter 里，兄弟节点的竖线才能连上。
const _itemGap = 6.0;

/// 卡片内上内边距 + 图标半径，横线对准文件/文件夹图标中心。
const _branchMidY = _itemGap + 14.0 + 10.0;

class TorrentContentItem extends StatelessWidget {
  const TorrentContentItem({
    super.key,
    required this.row,
    this.expanded = false,
    this.isLast = true,
    this.ancestorContinues = const [],
    this.showTransferStats = true,
    this.onToggleExpand,
    this.onPriorityChanged,
    this.onLongPress,
  });

  final TorrentContentRow row;
  final bool expanded;
  final bool isLast;
  final List<bool> ancestorContinues;
  final bool showTransferStats;
  final VoidCallback? onToggleExpand;
  final ValueChanged<int>? onPriorityChanged;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final node = row.node;
    final progress = node.progress.clamp(0.0, 1.0);
    final complete = progress >= 0.9995;
    final indicatorColor = complete ? scheme.tertiary : scheme.primary;
    final showTree = row.depth > 0;
    final gutterWidth = showTree
        ? row.depth * _treeLevelWidth + _treeBranchWidth
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PageInsets.horizontal),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showTree)
              SizedBox(
                width: gutterWidth,
                child: CustomPaint(
                  painter: _TreeLinePainter(
                    depth: row.depth,
                    isLast: isLast,
                    ancestorContinues: ancestorContinues,
                    color: scheme.outline.withValues(alpha: 0.35),
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: _itemGap),
                child: Material(
                  color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: node.isFolder ? onToggleExpand : null,
                    onLongPress: onLongPress,
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Icon(
                                node.isFolder
                                    ? (expanded
                                          ? Icons.folder_open_outlined
                                          : Icons.folder_outlined)
                                    : Icons.insert_drive_file_outlined,
                                size: 20,
                                color: scheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  node.name,
                                  style: textTheme.titleSmall,
                                ),
                              ),
                              if (node.isFolder)
                                AnimatedRotation(
                                  turns: expanded ? 0.5 : 0,
                                  duration: const Duration(milliseconds: 220),
                                  curve: Curves.easeOutCubic,
                                  child: Icon(
                                    Icons.expand_more,
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (showTransferStats) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 3,
                                      color: indicatorColor,
                                      backgroundColor:
                                          scheme.surfaceContainerHighest,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  formatProgress(progress),
                                  style: textTheme.labelLarge?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
                          Wrap(
                            spacing: 16,
                            runSpacing: 6,
                            children: [
                              _StatText(
                                label: l10n.sortSize,
                                value: formatBytes(node.size),
                              ),
                              if (showTransferStats) ...[
                                _StatText(
                                  label: l10n.remaining,
                                  value: formatBytes(node.remaining),
                                ),
                                _StatText(
                                  label: l10n.availability,
                                  value: node.availability < 0
                                      ? '—'
                                      : formatAvailability(node.availability),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 12),
                          _PrioritySegmentedButton(
                            priority: node.priority,
                            enabled: onPriorityChanged != null,
                            onChanged: onPriorityChanged,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TreeLinePainter extends CustomPainter {
  const _TreeLinePainter({
    required this.depth,
    required this.isLast,
    required this.ancestorContinues,
    required this.color,
  });

  final int depth;
  final bool isLast;
  final List<bool> ancestorContinues;
  final Color color;

  static double _xForLevel(int level) =>
      level * _treeLevelWidth + _treeLevelWidth / 2;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    for (var i = 0; i < ancestorContinues.length; i++) {
      if (!ancestorContinues[i]) continue;
      final x = _xForLevel(i);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    final x = _xForLevel(depth - 1);
    final midY = _branchMidY.clamp(0.0, size.height);
    canvas.drawLine(
      Offset(x, 0),
      Offset(x, isLast ? midY : size.height),
      paint,
    );
    canvas.drawLine(Offset(x, midY), Offset(size.width, midY), paint);
  }

  @override
  bool shouldRepaint(covariant _TreeLinePainter oldDelegate) {
    return depth != oldDelegate.depth ||
        isLast != oldDelegate.isLast ||
        color != oldDelegate.color ||
        !_listEquals(ancestorContinues, oldDelegate.ancestorContinues);
  }

  static bool _listEquals(List<bool> a, List<bool> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

const _priorityValues = [0, 1, 6, 7];

class _PrioritySegmentedButton extends StatelessWidget {
  const _PrioritySegmentedButton({
    required this.priority,
    required this.enabled,
    this.onChanged,
  });

  final int priority;
  final bool enabled;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mixed = priority == mixedFilePriority;
    final values = [..._priorityValues, if (mixed) mixedFilePriority];
    return SegmentedButton<int>(
      showSelectedIcon: false,
      expandedInsets: EdgeInsets.zero,
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 4),
        ),
        textStyle: WidgetStatePropertyAll(textTheme.labelMedium),
      ),
      segments: [
        for (final value in values)
          ButtonSegment(
            value: value,
            label: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                filePriorityLabel(value, context.l10n),
                maxLines: 1,
                softWrap: false,
              ),
            ),
            enabled: enabled,
          ),
      ],
      selected: {priority},
      onSelectionChanged: enabled
          ? (value) {
              if (value.isEmpty) return;
              final next = value.first;
              if (next == mixedFilePriority) return;
              onChanged?.call(next);
            }
          : null,
    );
  }
}

class _StatText extends StatelessWidget {
  const _StatText({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label ',
            style: textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          TextSpan(
            text: value,
            style: textTheme.bodySmall?.copyWith(color: scheme.onSurface),
          ),
        ],
      ),
    );
  }
}
