import 'package:flutter/material.dart';
import 'package:qbpanel/api/entity/response/torrent_peer_response.dart';
import 'package:qbpanel/detail/peers/widget/peer_country_flag.dart';
import 'package:qbpanel/util/byte_format.dart';
import 'package:qbpanel/widget/page_insets.dart';

class TorrentPeerItem extends StatelessWidget {
  const TorrentPeerItem({super.key, required this.peer, this.onLongPress});

  final TorrentPeerResponse peer;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final progress = (peer.progress ?? 0).clamp(0.0, 1.0);
    final complete = progress >= 0.9995;
    final indicatorColor = complete ? scheme.tertiary : scheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PageInsets.horizontal,
        vertical: 6,
      ),
      child: Material(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(_displayAddress(peer), style: textTheme.titleSmall),
                if (_hasText(peer.country) ||
                    _hasText(peer.countryCode) ||
                    _hasText(peer.client) ||
                    _hasText(peer.connection)) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (_hasText(peer.country) ||
                          _hasText(peer.countryCode)) ...[
                        PeerCountryFlag(countryCode: peer.countryCode),
                        const SizedBox(width: 6),
                      ],
                      Expanded(
                        child: Text(
                          [
                            if (_hasText(peer.country)) peer.country,
                            if (_hasText(peer.client)) peer.client,
                            if (_hasText(peer.connection)) peer.connection,
                          ].join(' · '),
                          style: textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 3,
                          color: indicatorColor,
                          backgroundColor: scheme.surfaceContainerHighest,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      formatProgress(progress),
                      style: textTheme.labelLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _SpeedStat(
                        icon: Icons.south_rounded,
                        label: '下载',
                        value: formatSpeed(peer.dlSpeed),
                        total: formatBytes(peer.downloaded),
                        color: scheme.primary,
                      ),
                    ),
                    Expanded(
                      child: _SpeedStat(
                        icon: Icons.north_rounded,
                        label: '上传',
                        value: formatSpeed(peer.upSpeed),
                        total: formatBytes(peer.uploaded),
                        color: scheme.tertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoChip(
                      label: '关联度',
                      value: formatPeerRatio(peer.relevance),
                    ),
                    _InfoChip(
                      label: '贡献',
                      value: formatPeerRatio(peer.contribution),
                    ),
                    _InfoChip(label: '标志', value: _text(peer.flags)),
                    _InfoChip(
                      label: 'Peer ID',
                      value: _text(peer.peerIdClient),
                    ),
                  ],
                ),
                if (_hasText(peer.files)) ...[
                  const SizedBox(height: 12),
                  _PeerFiles(raw: peer.files!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _displayAddress(TorrentPeerResponse peer) {
  if (_hasText(peer.hostName)) return peer.hostName!;
  if (_hasText(peer.i2pDest)) return peer.i2pDest!;
  if (_hasText(peer.ip)) {
    return peer.port == null ? peer.ip! : '${peer.ip}:${peer.port}';
  }
  return peer.id;
}

String _text(String? value) => _hasText(value) ? value! : '—';

bool _hasText(String? value) => value != null && value.trim().isNotEmpty;

String formatPeerRatio(double? value) {
  if (value == null || value < 0) return '—';
  return formatProgress(value);
}

class _SpeedStat extends StatelessWidget {
  const _SpeedStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.total,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: label,
                style: textTheme.labelSmall?.copyWith(
                  color: color.withValues(alpha: 0.8),
                ),
              ),
              TextSpan(
                text: '  $total',
                style: textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                value,
                style: textTheme.titleSmall?.copyWith(color: color),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$label ',
                style: textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              TextSpan(
                text: value,
                style: textTheme.labelMedium?.copyWith(color: scheme.onSurface),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PeerFiles extends StatelessWidget {
  const _PeerFiles({required this.raw});

  final String raw;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final names = raw
        .split(RegExp(r'[\r\n]+'))
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toList();
    if (names.isEmpty) return const SizedBox.shrink();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.insert_drive_file_outlined,
              size: 16,
              color: scheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    names.length == 1 ? '正在下载' : '正在下载 ${names.length} 个文件',
                    style: textTheme.labelSmall?.copyWith(
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  for (final name in names)
                    Text(
                      name,
                      style: textTheme.bodySmall?.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
