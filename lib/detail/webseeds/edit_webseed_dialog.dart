import 'package:flutter/material.dart';
import 'package:qbpanel/api/entity/response/torrent_webseed_response.dart';
import 'package:qbpanel/detail/webseeds/torrent_webseeds_view_model.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';

class EditWebSeedDialog extends StatefulWidget {
  const EditWebSeedDialog({
    super.key,
    required this.animation,
    required this.viewModel,
    required this.webSeed,
  });

  final Animation<double> animation;
  final TorrentWebSeedsViewModel viewModel;
  final TorrentWebSeedResponse webSeed;

  static Future<void> show({
    required BuildContext context,
    required TorrentWebSeedsViewModel viewModel,
    required TorrentWebSeedResponse webSeed,
  }) {
    return showGeneralDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: BlurDialogMotion.duration,
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return EditWebSeedDialog(
          animation: animation,
          viewModel: viewModel,
          webSeed: webSeed,
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
    );
  }

  @override
  State<EditWebSeedDialog> createState() => _EditWebSeedDialogState();
}

class _EditWebSeedDialogState extends State<EditWebSeedDialog> {
  late final TextEditingController _controller;
  var _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.webSeed.url);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _submitting = true;
      _error = null;
    });
    final error = await widget.viewModel.editWebSeed(
      origUrl: widget.webSeed.url,
      newUrl: _controller.text,
    );
    if (!mounted) return;
    if (error != null) {
      setState(() {
        _submitting = false;
        _error = error;
      });
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dialogWidth = MediaQuery.sizeOf(context).width * 0.86;

    return BlurDialogScaffold(
      animation: widget.animation,
      onBarrierTap: _submitting ? null : () => Navigator.of(context).pop(),
      panelConstraints: BoxConstraints.tightFor(width: dialogWidth),
      panelPadding: const EdgeInsets.fromLTRB(24, 22, 24, 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '编辑 HTTP 源 URL',
              style: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              enabled: !_submitting,
              autofocus: true,
              minLines: 1,
              maxLines: null,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              decoration: InputDecoration(
                labelText: 'HTTP 源 URL',
                errorText: _error,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _submitting
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: const Text('取消'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: scheme.onPrimary,
                          ),
                        )
                      : const Text('确定'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
