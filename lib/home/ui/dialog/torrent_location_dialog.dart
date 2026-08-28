import 'package:flutter/material.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';

class TorrentLocationDialog extends StatefulWidget {
  const TorrentLocationDialog({
    super.key,
    required this.animation,
    required this.initialPath,
    required this.autoTmm,
  });

  final Animation<double> animation;
  final String initialPath;
  final bool autoTmm;

  /// 返回新路径；取消为 `null`。
  static Future<String?> show(
    BuildContext context, {
    required String initialPath,
    required bool autoTmm,
  }) {
    return showGeneralDialog<String>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: BlurDialogMotion.duration,
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return TorrentLocationDialog(
          animation: animation,
          initialPath: initialPath,
          autoTmm: autoTmm,
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
    );
  }

  @override
  State<TorrentLocationDialog> createState() => _TorrentLocationDialogState();
}

class _TorrentLocationDialogState extends State<TorrentLocationDialog> {
  late final TextEditingController _controller;
  String? _pathError;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialPath);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onConfirm() {
    FocusScope.of(context).unfocus();
    final path = _controller.text.trim();
    if (path.isEmpty) {
      setState(() => _pathError = context.l10n.enterSavePath);
      return;
    }
    Navigator.of(context).pop(path);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dialogWidth = MediaQuery.sizeOf(context).width * 0.85;

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
              l10n.setSaveLocation,
              style: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              autofocus: true,
              minLines: 1,
              maxLines: 3,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _onConfirm(),
              onChanged: (_) {
                if (_pathError != null) setState(() => _pathError = null);
              },
              decoration: InputDecoration(
                labelText: l10n.savePath,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                errorText: _pathError,
              ),
            ),
            if (widget.autoTmm) ...[
              const SizedBox(height: 12),
              Text(
                l10n.autoTmmLocationHint,
                style: textTheme.bodySmall?.copyWith(color: scheme.tertiary),
              ),
            ],
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
                  child: Text(l10n.actionOk),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
