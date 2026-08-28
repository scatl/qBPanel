import 'package:flutter/material.dart';
import 'package:qbpanel/add/add_torrent_ui_state.dart';
import 'package:qbpanel/add/ui/add_torrent_card.dart';
import 'package:qbpanel/detail/general/torrent_general_format.dart';
import 'package:qbpanel/l10n/app_localizations.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/util/byte_format.dart';

class AddTorrentInfoSection extends StatelessWidget {
  const AddTorrentInfoSection({super.key, required this.ui});

  final AddTorrentUiState ui;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AddTorrentCard(
      title: l10n.torrentInfo,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _InfoRow(label: l10n.sortName, value: _text(ui.torrentName, l10n), selectable: true),
          _InfoRow(label: l10n.sortSize, value: _size(ui.totalSize, l10n)),
          _InfoRow(
            label: l10n.date,
            value: formatUnixDate(ui.creationDate, unknown: l10n.unavailable),
          ),
          _InfoRow(
            label: 'Info hash v1',
            value: _hash(ui.infohashV1, l10n),
            selectable: true,
          ),
          _InfoRow(
            label: 'Info hash v2',
            value: _hash(ui.infohashV2, l10n),
            selectable: true,
          ),
          _InfoRow(label: l10n.comment, value: _text(ui.comment, l10n), selectable: true),
        ],
      ),
    );
  }

  String _text(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) return l10n.unavailable;
    return value;
  }

  String _hash(String? value, AppLocalizations l10n) {
    if (value == null) return l10n.unavailable;
    if (value.isEmpty) return l10n.notAvailable;
    return value;
  }

  String _size(int? bytes, AppLocalizations l10n) {
    if (bytes == null || bytes < 0) return l10n.unavailable;
    return formatBytes(bytes);
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.selectable = false,
  });

  final String label;
  final String value;
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final valueStyle = textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 108,
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: selectable
                ? SelectableText(value, style: valueStyle)
                : Text(value, style: valueStyle),
          ),
        ],
      ),
    );
  }
}
