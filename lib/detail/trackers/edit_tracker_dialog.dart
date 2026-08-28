import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qbpanel/api/entity/response/torrent_tracker_response.dart';
import 'package:qbpanel/detail/trackers/torrent_trackers_view_model.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';

class EditTrackerDialog extends StatefulWidget {
  const EditTrackerDialog({
    super.key,
    required this.animation,
    required this.viewModel,
    required this.tracker,
  });

  final Animation<double> animation;
  final TorrentTrackersViewModel viewModel;
  final TorrentTrackerResponse tracker;

  static Future<void> show({
    required BuildContext context,
    required TorrentTrackersViewModel viewModel,
    required TorrentTrackerResponse tracker,
  }) {
    return showGeneralDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: BlurDialogMotion.duration,
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return EditTrackerDialog(
          animation: animation,
          viewModel: viewModel,
          tracker: tracker,
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
    );
  }

  @override
  State<EditTrackerDialog> createState() => _EditTrackerDialogState();
}

class _EditTrackerDialogState extends State<EditTrackerDialog> {
  late final TextEditingController _urlController;
  late final TextEditingController _tierController;
  var _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.tracker.url);
    final tier = widget.tracker.tier;
    _tierController = TextEditingController(
      text: (tier != null && tier >= 0) ? '$tier' : '0',
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _tierController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _submitting = true;
      _error = null;
    });
    final tier = int.tryParse(_tierController.text.trim());
    if (tier == null) {
      setState(() {
        _submitting = false;
        _error = context.l10n.enterTier;
      });
      return;
    }
    final error = await widget.viewModel.editTracker(
      url: widget.tracker.url,
      newUrl: _urlController.text,
      tier: tier,
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
    final l10n = context.l10n;
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
              l10n.editTracker,
              style: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              enabled: !_submitting,
              autofocus: true,
              minLines: 1,
              maxLines: null,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.next,
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              decoration: InputDecoration(labelText: l10n.trackerUrl),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tierController,
              enabled: !_submitting,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onSubmitted: (_) => _submit(),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              decoration: InputDecoration(labelText: l10n.tier, errorText: _error),
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
                      : Text(l10n.actionOk),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
