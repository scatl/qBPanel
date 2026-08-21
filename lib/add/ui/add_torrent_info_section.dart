import 'package:flutter/material.dart';
import 'package:qbpanel/add/add_torrent_ui_state.dart';
import 'package:qbpanel/add/ui/add_torrent_card.dart';
import 'package:qbpanel/detail/general/torrent_general_format.dart';
import 'package:qbpanel/util/byte_format.dart';

class AddTorrentInfoSection extends StatelessWidget {
  const AddTorrentInfoSection({super.key, required this.ui});

  final AddTorrentUiState ui;

  @override
  Widget build(BuildContext context) {
    return AddTorrentCard(
      title: '种子信息',
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _InfoRow(label: '名称', value: _text(ui.torrentName), selectable: true),
          _InfoRow(label: '大小', value: _size(ui.totalSize)),
          _InfoRow(
            label: '日期',
            value: formatUnixDate(ui.creationDate, unknown: '暂不可用'),
          ),
          _InfoRow(
            label: 'Info hash v1',
            value: _hash(ui.infohashV1),
            selectable: true,
          ),
          _InfoRow(
            label: 'Info hash v2',
            value: _hash(ui.infohashV2),
            selectable: true,
          ),
          _InfoRow(label: '注释', value: _text(ui.comment), selectable: true),
        ],
      ),
    );
  }

  String _text(String? value) {
    if (value == null || value.isEmpty) return '暂不可用';
    return value;
  }

  String _hash(String? value) {
    if (value == null) return '暂不可用';
    if (value.isEmpty) return 'N/A';
    return value;
  }

  String _size(int? bytes) {
    if (bytes == null || bytes < 0) return '暂不可用';
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
