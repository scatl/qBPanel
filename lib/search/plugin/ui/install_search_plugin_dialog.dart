import 'package:flutter/material.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';

class InstallSearchPluginDialog extends StatefulWidget {
  const InstallSearchPluginDialog({
    super.key,
    required this.animation,
  });

  final Animation<double> animation;

  static Future<String?> show(BuildContext context) {
    return showGeneralDialog<String>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: BlurDialogMotion.duration,
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return InstallSearchPluginDialog(animation: animation);
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
    );
  }

  @override
  State<InstallSearchPluginDialog> createState() =>
      _InstallSearchPluginDialogState();
}

class _InstallSearchPluginDialogState extends State<InstallSearchPluginDialog> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onConfirm() {
    FocusScope.of(context).unfocus();
    final source = _controller.text.trim();
    if (source.isEmpty) {
      setState(() => _error = '请输入插件 URL 或路径');
      return;
    }
    Navigator.of(context).pop(source);
  }

  @override
  Widget build(BuildContext context) {
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
              '安装搜索插件',
              style: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              '输入插件 .py 的 URL，或 qB 服务器上的文件路径。多个来源可用换行分隔。',
              style: textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              autofocus: true,
              minLines: 2,
              maxLines: 5,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _onConfirm(),
              decoration: InputDecoration(
                labelText: '插件来源',
                hintText: 'https://…/engines/example.py',
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
                  child: const Text('取消'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _onConfirm,
                  child: const Text('安装'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
