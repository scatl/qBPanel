import 'package:flutter/material.dart';
import 'package:qbpanel/detail/webseeds/torrent_webseeds_view_model.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';

class AddWebSeedsDialog extends StatefulWidget {
  const AddWebSeedsDialog({
    super.key,
    required this.animation,
    required this.viewModel,
  });

  final Animation<double> animation;
  final TorrentWebSeedsViewModel viewModel;

  static Future<void> show({
    required BuildContext context,
    required TorrentWebSeedsViewModel viewModel,
  }) {
    return showGeneralDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: BlurDialogMotion.duration,
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return AddWebSeedsDialog(animation: animation, viewModel: viewModel);
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
    );
  }

  @override
  State<AddWebSeedsDialog> createState() => _AddWebSeedsDialogState();
}

class _AddWebSeedsDialogState extends State<AddWebSeedsDialog> {
  final _controller = TextEditingController();
  var _submitting = false;
  String? _error;

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
    final error = await widget.viewModel.addWebSeeds(_controller.text);
    if (!mounted) return;
    if (error != null) {
      setState(() {
        _submitting = false;
        _error = error;
      });
      return;
    }
    final l10n = context.l10n;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.addedHttpSeed)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dialogWidth = MediaQuery.sizeOf(context).width * 0.86;

    return BlurDialogScaffold(
      animation: widget.animation,
      onBarrierTap: _submitting ? null : () => Navigator.of(context).pop(),
      panelConstraints: BoxConstraints.tightFor(width: dialogWidth),
      panelPadding: const EdgeInsets.fromLTRB(24, 22, 24, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.addHttpSeed,
            style: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            enabled: !_submitting,
            autofocus: true,
            minLines: 4,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
            decoration: InputDecoration(
              labelText: l10n.httpSeedListHint,
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
                child: Text(l10n.actionCancel),
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
                    : Text(l10n.actionAdd),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
