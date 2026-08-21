import 'package:flutter/material.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';

class AddTorrentLinkDialog extends StatefulWidget {
  const AddTorrentLinkDialog({
    super.key,
    required this.animation,
    this.initialUrl,
  });

  final Animation<double> animation;
  final String? initialUrl;

  /// 返回一条链接；取消为 `null`。
  static Future<String?> show(BuildContext context, {String? initialUrl}) {
    return showGeneralDialog<String>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: BlurDialogMotion.duration,
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return AddTorrentLinkDialog(
          animation: animation,
          initialUrl: initialUrl,
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
    );
  }

  @override
  State<AddTorrentLinkDialog> createState() => _AddTorrentLinkDialogState();
}

class _AddTorrentLinkDialogState extends State<AddTorrentLinkDialog> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialUrl ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> _parseUrls(String raw) {
    return raw
        .split(RegExp(r'\r?\n'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  void _onConfirm() {
    FocusScope.of(context).unfocus();
    final urls = _parseUrls(_controller.text);
    if (urls.isEmpty) {
      setState(() => _error = '请输入磁力链接或 HTTP(S) 地址');
      return;
    }
    if (urls.length > 1) {
      setState(() => _error = '一次只能导入一个种子');
      return;
    }
    Navigator.of(context).pop(urls.single);
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
              '从磁力链接导入',
              style: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              autofocus: true,
              minLines: 3,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              decoration: InputDecoration(
                labelText: '磁力链接或 URL',
                alignLabelWithHint: true,
                errorText: _error,
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
                  child: const Text('导入'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
