import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qbpanel/widget/check_row.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';

/// 修改当前生效的全局上下行限速（普通 / 备用由 [useAltSpeedLimits] 决定）。
class GlobalSpeedLimitDialog extends StatefulWidget {
  const GlobalSpeedLimitDialog({
    super.key,
    required this.animation,
    required this.useAltSpeedLimits,
    required this.initialDownloadBytesPerSec,
    required this.initialUploadBytesPerSec,
    required this.onSubmit,
  });

  final Animation<double> animation;
  final bool useAltSpeedLimits;
  final int? initialDownloadBytesPerSec;
  final int? initialUploadBytesPerSec;
  final Future<String?> Function({
    required int downloadBytesPerSec,
    required int uploadBytesPerSec,
  }) onSubmit;

  static Future<bool> show({
    required BuildContext context,
    required bool useAltSpeedLimits,
    required int? initialDownloadBytesPerSec,
    required int? initialUploadBytesPerSec,
    required Future<String?> Function({
      required int downloadBytesPerSec,
      required int uploadBytesPerSec,
    }) onSubmit,
  }) async {
    final result = await showGeneralDialog<bool>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: BlurDialogMotion.duration,
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return GlobalSpeedLimitDialog(
          animation: animation,
          useAltSpeedLimits: useAltSpeedLimits,
          initialDownloadBytesPerSec: initialDownloadBytesPerSec,
          initialUploadBytesPerSec: initialUploadBytesPerSec,
          onSubmit: onSubmit,
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
    );
    return result == true;
  }

  @override
  State<GlobalSpeedLimitDialog> createState() => _GlobalSpeedLimitDialogState();
}

class _GlobalSpeedLimitDialogState extends State<GlobalSpeedLimitDialog> {
  late final _SpeedLimitDraft _dlLimit;
  late final _SpeedLimitDraft _upLimit;
  var _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _dlLimit = _SpeedLimitDraft.fromBytes(widget.initialDownloadBytesPerSec);
    _upLimit = _SpeedLimitDraft.fromBytes(widget.initialUploadBytesPerSec);
  }

  @override
  void dispose() {
    _dlLimit.dispose();
    _upLimit.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final dl = _dlLimit.toBytes();
    final up = _upLimit.toBytes();
    if (dl == _SpeedLimitDraft.invalid || up == _SpeedLimitDraft.invalid) {
      setState(() => _error = '请输入有效的速度');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    final error = await widget.onSubmit(
      downloadBytesPerSec: dl,
      uploadBytesPerSec: up,
    );
    if (!mounted) return;
    if (error != null) {
      setState(() {
        _submitting = false;
        _error = error;
      });
      return;
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final title = widget.useAltSpeedLimits ? '备用速度限制' : '全局速度限制';

    return PopScope(
      canPop: !_submitting,
      child: BlurDialogScaffold(
        animation: widget.animation,
        onBarrierTap: _submitting ? null : () => Navigator.of(context).pop(),
        panelConstraints: const BoxConstraints(minWidth: 240, maxWidth: 300),
        panelPadding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: textTheme.titleMedium),
            if (widget.useAltSpeedLimits) ...[
              const SizedBox(height: 4),
              Text(
                '当前已开启备用限速，修改将作用于备用值',
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 12),
            _SpeedLimitRow(
              label: '下载',
              draft: _dlLimit,
              enabled: !_submitting,
              onChanged: () => setState(() => _error = null),
            ),
            const SizedBox(height: 4),
            _SpeedLimitRow(
              label: '上传',
              draft: _upLimit,
              enabled: !_submitting,
              onChanged: () => setState(() => _error = null),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: textTheme.bodySmall?.copyWith(color: scheme.error),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _submitting
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: const Text('取消'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _SpeedUnit { kb, mb }

class _SpeedLimitDraft {
  _SpeedLimitDraft({
    required this.enabled,
    required this.controller,
    required this.unit,
  });

  static const invalid = -1;
  static const _kb = 1024;
  static const _mb = 1024 * 1024;

  bool enabled;
  final TextEditingController controller;
  _SpeedUnit unit;

  factory _SpeedLimitDraft.fromBytes(int? bytesPerSec) {
    final unlimited = bytesPerSec == null || bytesPerSec <= 0;
    if (unlimited) {
      return _SpeedLimitDraft(
        enabled: false,
        controller: TextEditingController(),
        unit: _SpeedUnit.kb,
      );
    }
    final useMb = bytesPerSec >= _mb;
    final div = useMb ? _mb : _kb;
    return _SpeedLimitDraft(
      enabled: true,
      controller: TextEditingController(
        text: _formatSpeedNumber(bytesPerSec / div),
      ),
      unit: useMb ? _SpeedUnit.mb : _SpeedUnit.kb,
    );
  }

  int toBytes() {
    if (!enabled) return 0;
    final raw = controller.text.trim();
    if (raw.isEmpty) return invalid;
    final n = double.tryParse(raw);
    if (n == null || n <= 0) return invalid;
    final mul = unit == _SpeedUnit.kb ? _kb : _mb;
    return (n * mul).round().clamp(1, 0x7fffffff);
  }

  void changeUnit(_SpeedUnit next) {
    if (next == unit) return;
    final n = double.tryParse(controller.text.trim());
    if (n != null && n > 0) {
      final bytes = n * (unit == _SpeedUnit.kb ? _kb : _mb);
      controller.text = _formatSpeedNumber(
        bytes / (next == _SpeedUnit.kb ? _kb : _mb),
      );
    }
    unit = next;
  }

  void dispose() => controller.dispose();
}

String _formatSpeedNumber(double value) {
  if (value == value.roundToDouble()) return value.round().toString();
  var text = value.toStringAsFixed(2);
  if (text.contains('.')) {
    text = text
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }
  return text;
}

class _SpeedLimitRow extends StatelessWidget {
  const _SpeedLimitRow({
    required this.label,
    required this.draft,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final _SpeedLimitDraft draft;
  final bool enabled;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final rowEnabled = enabled && draft.enabled;
    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Text(label, style: textTheme.bodyLarge),
        ),
        AlignedCheckbox(
          value: draft.enabled,
          onChanged: enabled
              ? (value) {
                  draft.enabled = value;
                  onChanged();
                }
              : null,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: draft.controller,
            enabled: rowEnabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            textInputAction: TextInputAction.done,
            onChanged: (_) => onChanged(),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        DropdownButton<_SpeedUnit>(
          value: draft.unit,
          underline: const SizedBox.shrink(),
          style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
          onChanged: rowEnabled
              ? (value) {
                  if (value == null) return;
                  draft.changeUnit(value);
                  onChanged();
                }
              : null,
          items: const [
            DropdownMenuItem(value: _SpeedUnit.kb, child: Text('KB/s')),
            DropdownMenuItem(value: _SpeedUnit.mb, child: Text('MB/s')),
          ],
        ),
      ],
    );
  }
}
