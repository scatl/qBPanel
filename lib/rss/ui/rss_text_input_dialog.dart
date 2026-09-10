import 'package:flutter/material.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';

/// 单字段文本输入对话框，返回 trim 后的字符串。
abstract final class RssTextInputDialog {
  RssTextInputDialog._();

  static Future<String?> show(
    BuildContext context, {
    required String title,
    String? message,
    String? label,
    String? hint,
    String? initialValue,
    int minLines = 1,
    int maxLines = 1,
    String? emptyError,
  }) {
    return showGeneralDialog<String>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: BlurDialogMotion.duration,
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return _RssTextInputDialogBody(
          animation: animation,
          title: title,
          message: message,
          label: label,
          hint: hint,
          initialValue: initialValue,
          minLines: minLines,
          maxLines: maxLines,
          emptyError: emptyError,
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
    );
  }
}

class _RssTextInputDialogBody extends StatefulWidget {
  const _RssTextInputDialogBody({
    required this.animation,
    required this.title,
    this.message,
    this.label,
    this.hint,
    this.initialValue,
    this.minLines = 1,
    this.maxLines = 1,
    this.emptyError,
  });

  final Animation<double> animation;
  final String title;
  final String? message;
  final String? label;
  final String? hint;
  final String? initialValue;
  final int minLines;
  final int maxLines;
  final String? emptyError;

  @override
  State<_RssTextInputDialogBody> createState() =>
      _RssTextInputDialogBodyState();
}

class _RssTextInputDialogBodyState extends State<_RssTextInputDialogBody> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onConfirm() {
    FocusScope.of(context).unfocus();
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _error = widget.emptyError ?? context.l10n.rssNameRequired);
      return;
    }
    Navigator.of(context).pop(text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dialogWidth = MediaQuery.sizeOf(context).width * 0.86;

    return BlurDialogScaffold(
      animation: widget.animation,
      onBarrierTap: () => Navigator.of(context).pop(),
      panelConstraints: BoxConstraints.tightFor(width: dialogWidth),
      panelPadding: const EdgeInsets.fromLTRB(24, 22, 24, 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              style: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
            ),
            if (widget.message != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.message!,
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              autofocus: true,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              textInputAction: widget.maxLines > 1
                  ? TextInputAction.newline
                  : TextInputAction.done,
              onSubmitted: widget.maxLines > 1 ? null : (_) => _onConfirm(),
              decoration: InputDecoration(
                labelText: widget.label,
                hintText: widget.hint,
                errorText: _error,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.actionCancel),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _onConfirm,
                  child: Text(l10n.actionSave),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
