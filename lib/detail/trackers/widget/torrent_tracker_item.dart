import 'package:flutter/material.dart';
import 'package:qbpanel/api/entity/response/torrent_tracker_response.dart';
import 'package:qbpanel/detail/trackers/torrent_tracker_format.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/page_insets.dart';

class TorrentTrackerItem extends StatelessWidget {
  const TorrentTrackerItem({
    super.key,
    required this.tracker,
    required this.expanded,
    this.onToggleExpand,
    this.onLongPress,
  });

  final TorrentTrackerResponse tracker;
  final bool expanded;
  final VoidCallback? onToggleExpand;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final statusText = trackerStatusLabel(
      status: tracker.status,
      updating: tracker.updating,
      l10n: l10n,
    );
    final statusColor = trackerStatusColor(
      scheme,
      status: tracker.status,
      updating: tracker.updating,
    );

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
          onTap: onToggleExpand,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        tracker.displayName,
                        style: textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      child: Icon(
                        Icons.expand_more,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  statusText,
                  style: textTheme.labelLarge?.copyWith(color: statusColor),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (tracker.tier != null && tracker.tier! >= 0)
                      _InfoChip(label: l10n.tier, value: '${tracker.tier}'),
                    _InfoChip(
                      label: l10n.seeds,
                      value: formatTrackerCount(tracker.numSeeds),
                    ),
                    _InfoChip(
                      label: l10n.peers,
                      value: formatTrackerCount(tracker.numPeers),
                    ),
                    _InfoChip(
                      label: l10n.leeches,
                      value: formatTrackerCount(tracker.numLeeches),
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: expanded
                      ? _ExpandedDetails(tracker: tracker)
                      : const SizedBox(width: double.infinity),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpandedDetails extends StatelessWidget {
  const _ExpandedDetails({required this.tracker});

  final TorrentTrackerResponse tracker;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        _Kv(label: context.l10n.timesCompleted, value: formatTrackerCount(tracker.numDownloaded)),
        _Kv(label: context.l10n.message, value: _text(tracker.msg)),
        _Kv(
          label: context.l10n.sortNextAnnounce,
          value: formatAnnounceRemaining(tracker.nextAnnounce, context.l10n),
        ),
        _Kv(
          label: context.l10n.minAnnounce,
          value: formatAnnounceRemaining(tracker.minAnnounce, context.l10n),
        ),
        if (tracker.hasEndpoints) ...[
          const SizedBox(height: 8),
          for (final endpoint in tracker.endpoints)
            _EndpointCard(endpoint: endpoint),
        ],
      ],
    );
  }
}

class _EndpointCard extends StatelessWidget {
  const _EndpointCard({required this.endpoint});

  final TorrentTrackerEndpoint endpoint;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final statusText = trackerStatusLabel(
      status: endpoint.status,
      updating: endpoint.updating,
      l10n: l10n,
    );
    final statusColor = trackerStatusColor(
      scheme,
      status: endpoint.status,
      updating: endpoint.updating,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                endpoint.name.isEmpty ? '—' : endpoint.name,
                style: textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    statusText,
                    style: textTheme.labelLarge?.copyWith(color: statusColor),
                  ),
                  _InfoChip(label: l10n.btProtocol, value: endpoint.btProtocolLabel),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoChip(
                    label: l10n.seeds,
                    value: formatTrackerCount(endpoint.numSeeds),
                  ),
                  _InfoChip(
                    label: l10n.peers,
                    value: formatTrackerCount(endpoint.numPeers),
                  ),
                  _InfoChip(
                    label: l10n.leeches,
                    value: formatTrackerCount(endpoint.numLeeches),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _Kv(
                label: l10n.timesCompleted,
                value: formatTrackerCount(endpoint.numDownloaded),
              ),
              _Kv(label: l10n.message, value: _text(endpoint.msg)),
              _Kv(
                label: l10n.sortNextAnnounce,
                value: formatAnnounceRemaining(endpoint.nextAnnounce, context.l10n),
              ),
              _Kv(
                label: l10n.minAnnounce,
                value: formatAnnounceRemaining(endpoint.minAnnounce, context.l10n),
              ),
            ],
          ),
        ),
      ),
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

class _Kv extends StatelessWidget {
  const _Kv({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label  ',
              style: textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            TextSpan(
              text: value,
              style: textTheme.bodySmall?.copyWith(color: scheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}

String _text(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return '—';
  return trimmed;
}
