import 'package:flutter/material.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';

/// 通用 Loading Dialog：指示器与文案垂直排列，背景高斯模糊 + 统一进入动画。
abstract final class LoadingDialog {
  LoadingDialog._();

  static bool _visible = false;

  /// 展示 loading。已展示时再次调用会被忽略。
  ///
  /// 不要 `await` 返回的 Future（会等到 [dismiss] 才结束）。
  static Future<void> show(
    BuildContext context, {
    String? message,
    bool barrierDismissible = false,
  }) {
    if (_visible) return Future.value();
    _visible = true;

    return showGeneralDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: BlurDialogMotion.duration,
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return PopScope(
          canPop: barrierDismissible,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) _visible = false;
          },
          child: BlurDialogScaffold(
            animation: animation,
            onBarrierTap: barrierDismissible
                ? () => Navigator.of(ctx).pop()
                : null,
            panelConstraints: const BoxConstraints(
              minWidth: 132,
              maxWidth: 220,
            ),
            child: _LoadingContent(message: message ?? ctx.l10n.loading),
          ),
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
    ).whenComplete(() {
      _visible = false;
    });
  }

  /// 关闭当前 loading（若未展示则忽略）。
  static void dismiss(BuildContext context) {
    if (!_visible) return;
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
    _visible = false;
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: scheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          message,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: scheme.onSurface,
          ),
        ),
      ],
    );
  }
}
