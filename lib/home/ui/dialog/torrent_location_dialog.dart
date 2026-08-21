import 'package:flutter/material.dart';
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
      setState(() => _pathError = '请输入保存路径');
      return;
    }
    Navigator.of(context).pop(path);
  }

  @override
  Widget build(BuildContext context) {
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
              '设置保存位置',
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
                labelText: '保存路径',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                errorText: _pathError,
              ),
            ),
            if (widget.autoTmm) ...[
              const SizedBox(height: 12),
              Text(
                '已开启自动种子管理。确定后将关闭自动管理，并改用上面的手动路径。',
                style: textTheme.bodySmall?.copyWith(color: scheme.tertiary),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('取消'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _onConfirm,
                  child: const Text('确定'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
