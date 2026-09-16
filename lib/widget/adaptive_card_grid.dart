import 'package:flutter/material.dart';
import 'package:qbpanel/home/list_layout_mode.dart';
import 'package:qbpanel/widget/page_insets.dart';

const kAdaptiveGridBreakpoint = 600.0;
const kAdaptiveGridSpacing = 8.0;
const kAdaptiveGridTargetExtent = 220.0;

bool useAdaptiveGrid(double width) => width >= kAdaptiveGridBreakpoint;

ListLayoutMode adaptiveListLayout(double width) =>
    useAdaptiveGrid(width) ? ListLayoutMode.grid : ListLayoutMode.list;

/// 宽屏网格：按约 220dp 估算列数后再减一列。
int adaptiveGridColumnCount(double width) {
  final contentWidth = width - PageInsets.horizontal * 2;
  final estimated =
      ((contentWidth + kAdaptiveGridSpacing) /
              (kAdaptiveGridTargetExtent + kAdaptiveGridSpacing))
          .ceil()
          .clamp(2, 12);
  return (estimated - 1).clamp(2, 12);
}

/// 按列分行的卡片网格。行高随内容变化。
///
/// [stretch] 为 true 时同行卡片等高（首页种子）；为 false 时各卡片保持自身高度，
/// 适合可展开项，避免展开一张时把邻居撑出大块空白底。
class AdaptiveCardGrid extends StatelessWidget {
  const AdaptiveCardGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.crossAxisCount,
    this.padding,
    this.spacing = kAdaptiveGridSpacing,
    this.stretch = true,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int crossAxisCount;
  final EdgeInsetsGeometry? padding;
  final double spacing;
  final bool stretch;

  @override
  Widget build(BuildContext context) {
    final columns = crossAxisCount.clamp(1, 12);
    final rowCount = (itemCount + columns - 1) ~/ columns;
    return ListView.builder(
      padding: padding,
      itemCount: rowCount,
      itemBuilder: (context, rowIndex) {
        return AdaptiveCardRow(
          startIndex: rowIndex * columns,
          itemCount: itemCount,
          crossAxisCount: columns,
          spacing: spacing,
          stretch: stretch,
          isLastRow: rowIndex == rowCount - 1,
          itemBuilder: (index) => itemBuilder(context, index),
        );
      },
    );
  }
}

/// 网格中的一行；[stretch] 时同行等高。
class AdaptiveCardRow extends StatelessWidget {
  const AdaptiveCardRow({
    super.key,
    required this.startIndex,
    required this.itemCount,
    required this.crossAxisCount,
    required this.itemBuilder,
    this.spacing = kAdaptiveGridSpacing,
    this.stretch = true,
    this.isLastRow = false,
  });

  final int startIndex;
  final int itemCount;
  final int crossAxisCount;
  final Widget Function(int index) itemBuilder;
  final double spacing;
  final bool stretch;
  final bool isLastRow;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      crossAxisAlignment: stretch
          ? CrossAxisAlignment.stretch
          : CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < crossAxisCount; i++) ...[
          if (i > 0) SizedBox(width: spacing),
          Expanded(
            child: startIndex + i < itemCount
                ? itemBuilder(startIndex + i)
                : const SizedBox.shrink(),
          ),
        ],
      ],
    );
    return Padding(
      padding: EdgeInsets.only(bottom: isLastRow ? 0 : spacing),
      child: stretch ? IntrinsicHeight(child: row) : row,
    );
  }
}
