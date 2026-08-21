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
  });

  final Animation<double> animation;
  final Widget child;
  final VoidCallback? onBarrierTap;
  final BoxConstraints? panelConstraints;
  final EdgeInsetsGeometry panelPadding;

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
    final maxPanelHeight =
        MediaQuery.sizeOf(context).height -
        viewInsets.bottom -
        MediaQuery.paddingOf(context).vertical -
        24;
    final constraints =
        (panelConstraints ?? const BoxConstraints(minWidth: 132, maxWidth: 220))
            .copyWith(maxHeight: maxPanelHeight);

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
          child: Center(
            child: FadeTransition(
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
                      color: scheme.surfaceContainerHigh.withValues(
                        alpha: 0.96,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      clipBehavior: Clip.antiAlias,
                      child: Padding(padding: panelPadding, child: child),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
