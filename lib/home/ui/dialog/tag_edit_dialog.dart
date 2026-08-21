import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/home/home_page_view_model.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';

class TagEditDialog extends ConsumerStatefulWidget {
  const TagEditDialog({
    super.key,
    required this.animation,
  });

  final Animation<double> animation;

  static Future<bool?> show(BuildContext context) {
    return showGeneralDialog<bool>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: BlurDialogMotion.duration,
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return TagEditDialog(animation: animation);
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
    );
  }

  @override
  ConsumerState<TagEditDialog> createState() => _TagEditDialogState();
}

class _TagEditDialogState extends ConsumerState<TagEditDialog> {
  final _nameController = TextEditingController();

  bool _saving = false;
  String? _nameError;
  String? _submitError;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String? _validateName(String name) {
    if (name.isEmpty) return '请输入标签名称';
    if (name.contains(',')) return '标签名称不能包含逗号';
    return null;
  }

  Future<void> _onConfirm() async {
    FocusScope.of(context).unfocus();
    final name = _nameController.text.trim();
    final nameError = _validateName(name);
    setState(() {
      _nameError = nameError;
      _submitError = null;
    });
    if (nameError != null) return;

    setState(() => _saving = true);
    final error =
        await ref.read(homePageProvider.notifier).createTags([name]);
    if (!mounted) return;
    if (error != null) {
      setState(() {
        _saving = false;
        _submitError = error;
      });
      return;
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dialogWidth = MediaQuery.sizeOf(context).width * 0.8;

    return BlurDialogScaffold(
      animation: widget.animation,
      onBarrierTap: _saving ? null : () => Navigator.of(context).pop(false),
      panelConstraints: BoxConstraints.tightFor(width: dialogWidth),
      panelPadding: const EdgeInsets.fromLTRB(24, 22, 24, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '添加标签',
            style: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            enabled: !_saving,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _onConfirm(),
            onChanged: (_) {
              if (_nameError != null) {
                setState(() => _nameError = null);
              }
            },
            decoration: InputDecoration(
              labelText: '标签名称',
              errorText: _nameError,
            ),
          ),
          if (_submitError != null) ...[
            const SizedBox(height: 12),
            Text(
              _submitError!,
              style: textTheme.bodySmall?.copyWith(color: scheme.error),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed:
                    _saving ? null : () => Navigator.of(context).pop(false),
                child: const Text('取消'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _saving ? null : _onConfirm,
                child: _saving
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
    );
  }
}
