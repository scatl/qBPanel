import 'package:flutter/material.dart';
import 'package:qbpanel/widget/blur_scrim.dart';

/// 模糊弹层共用动画参数（Loading / Confirm / Sheet 等）。
abstract final class BlurDialogMotion {
  static const duration = Duration(milliseconds: 320);
  static const curve = Curves.easeOutCubic;
  static const reverseCurve = Curves.easeInCubic;
  static const beginScale = 0.92;
  static const blurSigma = 10.0;
  static const scrimAlpha = 0.32;
}

/// 输入 / 表单 Dialog 宽屏上限。右键菜单等请继续用 [showAdaptiveCardPopup] 自己的 maxWidth。
const kFormDialogMaxWidth = 420.0;

/// 窄屏约占屏宽 86%，宽屏封顶 [maxWidth]。
BoxConstraints formDialogConstraints(
  BuildContext context, {
  double maxWidth = kFormDialogMaxWidth,
  double fraction = 0.86,
}) {
  final width = (MediaQuery.sizeOf(context).width * fraction).clamp(
    0.0,
    maxWidth,
  );
  return BoxConstraints.tightFor(width: width);
}

/// 背景模糊 + 淡入压暗 + 内容淡入缩放。
class BlurDialogScaffold extends StatelessWidget {
  const BlurDialogScaffold({
    super.key,
    required this.animation,
    required this.child,
    this.onBarrierTap,
    this.panelConstraints,
    this.panelPadding = const EdgeInsets.symmetric(
      horizontal: 28,
      vertical: 24,
    ),
    this.anchor,
  });

  final Animation<double> animation;
  final Widget child;
  final VoidCallback? onBarrierTap;
  final BoxConstraints? panelConstraints;
  final EdgeInsetsGeometry panelPadding;

  /// 非 null 时把面板贴在该全局坐标旁（右键菜单）；否则居中。
  final Offset? anchor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final curved = CurvedAnimation(
      parent: animation,
      curve: BlurDialogMotion.curve,
      reverseCurve: BlurDialogMotion.reverseCurve,
    );
    final scale = Tween<double>(
      begin: BlurDialogMotion.beginScale,
      end: 1,
    ).animate(curved);

    final viewInsets = MediaQuery.viewInsetsOf(context);
    final padding = MediaQuery.paddingOf(context);
    final maxPanelHeight =
        MediaQuery.sizeOf(context).height -
        viewInsets.bottom -
        padding.vertical -
        24;
    final constraints =
        (panelConstraints ?? const BoxConstraints(minWidth: 132, maxWidth: 220))
            .copyWith(maxHeight: maxPanelHeight);

    final panel = FadeTransition(
      opacity: curved,
      child: ScaleTransition(
        scale: scale,
        child: ConstrainedBox(
          constraints: constraints,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: scheme.shadow.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: scheme.surfaceContainerHigh.withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: Padding(padding: panelPadding, child: child),
            ),
          ),
        ),
      ),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        FadeTransition(
          opacity: curved,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onBarrierTap,
            child: const BlurScrim(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: viewInsets.bottom),
          child: anchor == null
              ? Center(child: panel)
              : CustomSingleChildLayout(
                  delegate: _AnchorLayoutDelegate(
                    anchor: anchor!,
                    padding: padding + const EdgeInsets.all(8),
                  ),
                  child: panel,
                ),
        ),
      ],
    );
  }
}

/// 优先出现在锚点右下方；溢出则翻到左侧 / 上方，并夹在安全区内。
class _AnchorLayoutDelegate extends SingleChildLayoutDelegate {
  _AnchorLayoutDelegate({required this.anchor, required this.padding});

  final Offset anchor;
  final EdgeInsets padding;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final maxW = (constraints.maxWidth - padding.horizontal).clamp(
      0.0,
      constraints.maxWidth,
    );
    final maxH = (constraints.maxHeight - padding.vertical).clamp(
      0.0,
      constraints.maxHeight,
    );
    return BoxConstraints(maxWidth: maxW, maxHeight: maxH);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    const gap = 4.0;
    final minX = padding.left;
    final minY = padding.top;
    final maxX = (size.width - childSize.width - padding.right).clamp(
      minX,
      size.width,
    );
    final maxY = (size.height - childSize.height - padding.bottom).clamp(
      minY,
      size.height,
    );

    var x = anchor.dx + gap;
    var y = anchor.dy + gap;
    if (x > maxX) x = anchor.dx - childSize.width - gap;
    if (y > maxY) y = anchor.dy - childSize.height - gap;
    return Offset(x.clamp(minX, maxX), y.clamp(minY, maxY));
  }

  @override
  bool shouldRelayout(covariant _AnchorLayoutDelegate oldDelegate) {
    return oldDelegate.anchor != anchor || oldDelegate.padding != padding;
  }
}
