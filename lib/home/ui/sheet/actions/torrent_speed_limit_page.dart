import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/entity/response/torrent_info_response.dart';
import 'package:qbpanel/home/home_page_view_model.dart';
import 'package:qbpanel/widget/check_row.dart';

class TorrentSpeedLimitPage extends ConsumerStatefulWidget {
  const TorrentSpeedLimitPage({
    super.key,
    required this.hash,
    required this.torrent,
    required this.pageContext,
    required this.onBack,
  });

  final String hash;
  final TorrentInfoResponse torrent;
  final BuildContext pageContext;
  final VoidCallback onBack;

  @override
  ConsumerState<TorrentSpeedLimitPage> createState() =>
      _TorrentSpeedLimitPageState();
}

class _TorrentSpeedLimitPageState extends ConsumerState<TorrentSpeedLimitPage> {
  late final bool _completed;
  late final _SpeedLimitDraft? _dlLimit;
  late final _SpeedLimitDraft _upLimit;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _completed = (widget.torrent.progress ?? 0) >= 1;
    _dlLimit = _completed
        ? null
        : _SpeedLimitDraft.fromBytes(widget.torrent.dlLimit);
    _upLimit = _SpeedLimitDraft.fromBytes(widget.torrent.upLimit);
  }

  @override
  void dispose() {
    _dlLimit?.dispose();
    _upLimit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final title = _completed ? '上传限速' : '上传/下载限速';
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 16, 8),
            child: Row(
              children: [
                IconButton(
                  tooltip: '返回',
                  visualDensity: VisualDensity.compact,
                  onPressed: _saving ? null : widget.onBack,
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
          if (_dlLimit != null)
            _SpeedLimitRow(
              label: '下载',
              draft: _dlLimit,
              enabled: !_saving,
              onChanged: () => setState(() => _error = null),
            ),
          _SpeedLimitRow(
            label: '上传',
            draft: _upLimit,
            enabled: !_saving,
            onChanged: () => setState(() => _error = null),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Text(
                _error!,
                style: textTheme.bodySmall?.copyWith(color: scheme.error),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: FilledButton(
              onPressed: _saving ? null : _save,
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
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final dl = _dlLimit?.toBytes();
    final up = _upLimit.toBytes();
    if (dl == _SpeedLimitDraft.invalid || up == _SpeedLimitDraft.invalid) {
      setState(() => _error = '请输入有效的速度');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final vm = ref.read(homePageProvider.notifier);
    final error = await vm.setTorrentSpeedLimits(
      widget.hash,
      downloadBytesPerSec: dl,
      uploadBytesPerSec: up,
    );
    if (!mounted) return;
    if (error != null) {
      setState(() {
        _saving = false;
        _error = error;
      });
      return;
    }
    _saving = false;
    widget.onBack();
    if (!widget.pageContext.mounted) return;
    ScaffoldMessenger.of(widget.pageContext).showSnackBar(
      const SnackBar(content: Text('已保存限速')),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
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
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
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
              DropdownMenuItem(
                value: _SpeedUnit.kb,
                child: Text('KB/s'),
              ),
              DropdownMenuItem(
                value: _SpeedUnit.mb,
                child: Text('MB/s'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
