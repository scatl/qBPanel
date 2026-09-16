import 'package:flutter/material.dart';
import 'package:qbpanel/api/entity/response/torrent_peer_response.dart';
import 'package:qbpanel/detail/peers/dialog/peer_files_dialog.dart';
import 'package:qbpanel/detail/peers/widget/peer_country_flag.dart';
import 'package:qbpanel/home/list_layout_mode.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/util/byte_format.dart';
import 'package:qbpanel/util/platform_info.dart';
import 'package:qbpanel/widget/page_insets.dart';

class TorrentPeerItem extends StatelessWidget {
  const TorrentPeerItem({
    super.key,
    required this.peer,
    this.layout = ListLayoutMode.list,
    this.onLongPress,
  });

  final TorrentPeerResponse peer;
  final ListLayoutMode layout;
  final void Function(Offset? position)? onLongPress;

  bool get _grid => layout == ListLayoutMode.grid;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final progress = (peer.progress ?? 0).clamp(0.0, 1.0);
    final complete = progress >= 0.9995;
    final indicatorColor = complete ? scheme.tertiary : scheme.primary;
    final menu = contextMenuActivators(onLongPress);

    void openFiles() {
      PeerFilesDialog.show(context: context, peer: peer);
    }

    final card = Material(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: openFiles,
        onLongPress: menu.onLongPress,
        onSecondaryTapUp: menu.onSecondaryTapUp,
        child: Padding(
          padding: _grid
              ? const EdgeInsets.fromLTRB(12, 10, 12, 12)
              : const EdgeInsets.fromLTRB(16, 14, 16, 16),
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
                      label: l10n.download,
                      value: formatSpeed(peer.dlSpeed),
                      total: formatBytes(peer.downloaded),
                      color: scheme.primary,
                    ),
                  ),
                  Expanded(
                    child: _SpeedStat(
                      icon: Icons.north_rounded,
                      label: l10n.upload,
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
                    label: l10n.relevance,
                    value: formatPeerRatio(peer.relevance),
                  ),
                  _InfoChip(
                    label: l10n.contribution,
                    value: formatPeerRatio(peer.contribution),
                  ),
                  _InfoChip(label: l10n.flags, value: _text(peer.flags)),
                  _InfoChip(label: 'Peer ID', value: _text(peer.peerIdClient)),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (_grid) return card;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PageInsets.horizontal,
        vertical: 6,
      ),
      child: card,
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
