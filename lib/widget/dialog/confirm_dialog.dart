import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';

/// 通用确认对话框：可自定义标题 / 内容 / 按钮文案，进入动画 + 背景模糊。
abstract final class ConfirmDialog {
  ConfirmDialog._();

  /// 返回 `true` 确认、`false` 取消；点遮罩关闭时为 `false`（若允许）。
  ///
  /// [confirmCountdownSeconds] > 0 时，确认按钮需倒计时结束后才可点击。
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    String? message,
    Widget? content,
    String? cancelText,
    String? confirmText,
    bool barrierDismissible = true,
    /// 确认按钮使用 error 色（删除等危险操作）
    bool destructive = false,
    int confirmCountdownSeconds = 0,
  }) {
    assert(
      message != null || content != null,
      'ConfirmDialog: 请提供 message 或 content',
    );

    return showGeneralDialog<bool>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: BlurDialogMotion.duration,
      pageBuilder: (ctx, animation, secondaryAnimation) {
        final l10n = ctx.l10n;
        return BlurDialogScaffold(
          animation: animation,
          onBarrierTap: barrierDismissible
              ? () => Navigator.of(ctx).pop(false)
              : null,
          panelConstraints: const BoxConstraints(
            minWidth: 280,
            maxWidth: 320,
          ),
          panelPadding: const EdgeInsets.fromLTRB(24, 22, 24, 16),
          child: _ConfirmContent(
            title: title,
            message: message,
            content: content,
            cancelText: cancelText ?? l10n.actionCancel,
            confirmText: confirmText ?? l10n.actionOk,
            destructive: destructive,
            confirmCountdownSeconds: confirmCountdownSeconds,
          ),
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
    );
  }
}

class _ConfirmContent extends StatefulWidget {
  const _ConfirmContent({
    required this.title,
    required this.cancelText,
    required this.confirmText,
    required this.destructive,
    required this.confirmCountdownSeconds,
    this.message,
    this.content,
  });

  final String title;
  final String? message;
  final Widget? content;
  final String cancelText;
  final String confirmText;
  final bool destructive;
  final int confirmCountdownSeconds;

  @override
  State<_ConfirmContent> createState() => _ConfirmContentState();
}

class _ConfirmContentState extends State<_ConfirmContent> {
  late int _remain;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remain = widget.confirmCountdownSeconds;
    if (_remain > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          _remain -= 1;
          if (_remain <= 0) {
            _remain = 0;
            timer.cancel();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final canConfirm = _remain <= 0;
    final confirmLabel = canConfirm
        ? widget.confirmText
        : '${widget.confirmText} ($_remain)';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.title,
          style: textTheme.titleLarge?.copyWith(
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        if (widget.content != null)
          widget.content!
        else
          Text(
            widget.message!,
            style: textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(widget.cancelText),
            ),
            const SizedBox(width: 8),
            FilledButton(
              style: widget.destructive
                  ? FilledButton.styleFrom(
                      backgroundColor: scheme.error,
                      foregroundColor: scheme.onError,
                    )
                  : null,
              onPressed: canConfirm
                  ? () => Navigator.of(context).pop(true)
                  : null,
              child: Text(confirmLabel),
            ),
          ],
        ),
      ],
    );
  }
}
