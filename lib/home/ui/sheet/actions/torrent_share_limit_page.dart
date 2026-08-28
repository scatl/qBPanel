import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/entity/response/torrent_info_response.dart';
import 'package:qbpanel/home/home_page_view_model.dart';
import 'package:qbpanel/home/entity/torrent_share_limit.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/check_row.dart';

class TorrentShareLimitPage extends ConsumerStatefulWidget {
  const TorrentShareLimitPage({
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
  ConsumerState<TorrentShareLimitPage> createState() =>
      _TorrentShareLimitPageState();
}

class _TorrentShareLimitPageState extends ConsumerState<TorrentShareLimitPage> {
  late TorrentShareLimitMode _mode;
  late final _ShareLimitField _ratio;
  late final _ShareLimitField _seeding;
  late final _ShareLimitField _inactive;
  late TorrentShareLimitAction _action;
  late final bool _supportsAction;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final torrent = widget.torrent;
    _mode = TorrentShareLimit.modeOf(torrent);
    _supportsAction = TorrentShareLimit.supportsAction(torrent);
    _action = TorrentShareLimitAction.parse(torrent.shareLimitAction);
    _ratio = _ShareLimitField.ratio(torrent.ratioLimit);
    _seeding = _ShareLimitField.minutes(
      TorrentShareLimit.minutesOf(torrent.seedingTimeLimit),
    );
    _inactive = _ShareLimitField.minutes(
      TorrentShareLimit.minutesOf(torrent.inactiveSeedingTimeLimit),
    );
  }

  @override
  void dispose() {
    _ratio.dispose();
    _seeding.dispose();
    _inactive.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
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
                  tooltip: l10n.actionBack,
                  visualDensity: VisualDensity.compact,
                  onPressed: _saving ? null : widget.onBack,
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Text(
                    l10n.shareLimit,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                _ModeTile(
                  label: l10n.shareLimitUseDefault,
                  selected: _mode == TorrentShareLimitMode.global,
                  enabled: !_saving,
                  onTap: () => setState(() {
                    _mode = TorrentShareLimitMode.global;
                    _error = null;
                  }),
                ),
                _ModeTile(
                  label: l10n.unlimited,
                  selected: _mode == TorrentShareLimitMode.unlimited,
                  enabled: !_saving,
                  onTap: () => setState(() {
                    _mode = TorrentShareLimitMode.unlimited;
                    _error = null;
                  }),
                ),
                _ModeTile(
                  label: l10n.custom,
                  selected: _mode == TorrentShareLimitMode.custom,
                  enabled: !_saving,
                  onTap: () => setState(() {
                    _mode = TorrentShareLimitMode.custom;
                    _error = null;
                  }),
                ),
                if (_mode == TorrentShareLimitMode.custom) ...[
                  const SizedBox(height: 4),
                  _ShareLimitRow(
                    label: l10n.sortRatio,
                    field: _ratio,
                    enabled: !_saving,
                    onChanged: () => setState(() => _error = null),
                  ),
                  _ShareLimitRow(
                    label: l10n.seedingTime,
                    field: _seeding,
                    suffix: l10n.minutes,
                    enabled: !_saving,
                    onChanged: () => setState(() => _error = null),
                  ),
                  _ShareLimitRow(
                    label: l10n.inactive,
                    field: _inactive,
                    suffix: l10n.minutes,
                    enabled: !_saving,
                    onChanged: () => setState(() => _error = null),
                  ),
                ],
                if (_supportsAction)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: DropdownButtonFormField<TorrentShareLimitAction>(
                      initialValue: _action,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: l10n.afterLimitReached,
                        isDense: true,
                      ),
                      onChanged: _saving
                          ? null
                          : (value) {
                              if (value == null) return;
                              setState(() {
                                _action = value;
                                _error = null;
                              });
                            },
                      items: [
                        for (final action in TorrentShareLimitAction.values)
                          DropdownMenuItem(
                            value: action,
                            child: Text(action.label(context.l10n)),
                          ),
                      ],
                    ),
                  ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Text(
                      _error!,
                      style: textTheme.bodySmall?.copyWith(color: scheme.error),
                    ),
                  ),
              ],
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
                  : Text(l10n.actionOk),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    late final double ratioLimit;
    late final int seedingTimeLimit;
    late final int inactiveSeedingTimeLimit;
    switch (_mode) {
      case TorrentShareLimitMode.global:
        ratioLimit = TorrentShareLimit.global.toDouble();
        seedingTimeLimit = TorrentShareLimit.global;
        inactiveSeedingTimeLimit = TorrentShareLimit.global;
      case TorrentShareLimitMode.unlimited:
        ratioLimit = TorrentShareLimit.unlimited.toDouble();
        seedingTimeLimit = TorrentShareLimit.unlimited;
        inactiveSeedingTimeLimit = TorrentShareLimit.unlimited;
      case TorrentShareLimitMode.custom:
        final ratio = _ratio.toValue();
        final seeding = _seeding.toValue();
        final inactive = _inactive.toValue();
        if (ratio == _ShareLimitField.invalid ||
            seeding == _ShareLimitField.invalid ||
            inactive == _ShareLimitField.invalid) {
          setState(() => _error = context.l10n.enterValidLimit);
          return;
        }
        ratioLimit = ratio;
        seedingTimeLimit = seeding.round();
        inactiveSeedingTimeLimit = inactive.round();
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final error = await ref.read(homePageProvider.notifier).setTorrentShareLimits(
      widget.hash,
      ratioLimit: ratioLimit,
      seedingTimeLimit: seedingTimeLimit,
      inactiveSeedingTimeLimit: inactiveSeedingTimeLimit,
      shareLimitAction: _supportsAction ? _action.apiValue : null,
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
      SnackBar(content: Text(widget.pageContext.l10n.shareLimitSaved)),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = enabled
        ? scheme.onSurface
        : scheme.onSurface.withValues(alpha: 0.38);
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              size: 22,
              color: selected && enabled ? scheme.primary : color,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareLimitField {
  _ShareLimitField({
    required this.enabled,
    required this.controller,
    required this.allowDecimal,
  });

  static const invalid = -3.0;
  static const _defaultRatio = '1';
  static const _defaultMinutes = '1440';

  bool enabled;
  final TextEditingController controller;
  final bool allowDecimal;

  factory _ShareLimitField.ratio(double? value) {
    final custom = value != null && value >= 0;
    return _ShareLimitField(
      enabled: custom,
      controller: TextEditingController(
        text: custom ? _formatNumber(value) : _defaultRatio,
      ),
      allowDecimal: true,
    );
  }

  factory _ShareLimitField.minutes(int? minutes) {
    final custom = minutes != null && minutes > 0;
    return _ShareLimitField(
      enabled: custom,
      controller: TextEditingController(
        text: custom ? '$minutes' : _defaultMinutes,
      ),
      allowDecimal: false,
    );
  }

  double toValue() {
    if (!enabled) return TorrentShareLimit.unlimited.toDouble();
    final raw = controller.text.trim();
    if (raw.isEmpty) return invalid;
    final n = double.tryParse(raw);
    if (n == null || n <= 0) return invalid;
    return n;
  }

  void dispose() => controller.dispose();
}

String _formatNumber(double value) {
  if (value == value.roundToDouble()) return value.round().toString();
  var text = value.toStringAsFixed(2);
  if (text.contains('.')) {
    text = text
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }
  return text;
}

class _ShareLimitRow extends StatelessWidget {
  const _ShareLimitRow({
    required this.label,
    required this.field,
    required this.enabled,
    required this.onChanged,
    this.suffix,
  });

  final String label;
  final _ShareLimitField field;
  final String? suffix;
  final bool enabled;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final rowEnabled = enabled && field.enabled;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        children: [
          AlignedCheckbox(
            value: field.enabled,
            onChanged: enabled
                ? (value) {
                    field.enabled = value;
                    onChanged();
                  }
                : null,
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 72,
            child: Text(label, style: textTheme.bodyLarge),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: field.controller,
              enabled: rowEnabled,
              keyboardType: TextInputType.numberWithOptions(
                decimal: field.allowDecimal,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  field.allowDecimal ? RegExp(r'[0-9.]') : RegExp(r'[0-9]'),
                ),
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
          if (suffix != null) ...[
            const SizedBox(width: 8),
            Text(suffix!, style: textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
