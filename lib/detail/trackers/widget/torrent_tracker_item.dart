import 'package:flutter/material.dart';
import 'package:qbpanel/api/entity/response/torrent_tracker_response.dart';
import 'package:qbpanel/detail/trackers/torrent_tracker_format.dart';
import 'package:qbpanel/detail/trackers/tracker_details_dialog.dart';
import 'package:qbpanel/home/list_layout_mode.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/util/platform_info.dart';
import 'package:qbpanel/widget/page_insets.dart';

class TorrentTrackerItem extends StatelessWidget {
  const TorrentTrackerItem({
    super.key,
    required this.tracker,
    this.layout = ListLayoutMode.list,
    this.onLongPress,
  });

  final TorrentTrackerResponse tracker;
  final ListLayoutMode layout;
  final void Function(Offset? position)? onLongPress;

  bool get _grid => layout == ListLayoutMode.grid;

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
    final menu = contextMenuActivators(onLongPress);

    void openDetails() {
      TrackerDetailsDialog.show(context: context, tracker: tracker);
    }

    final body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(tracker.displayName, style: textTheme.titleSmall),
            ),
            const SizedBox(width: 4),
            IconButton(
              tooltip: l10n.actionMore,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              icon: const Icon(Icons.more_horiz),
              onPressed: openDetails,
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
      ],
    );

    final card = Material(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: openDetails,
        onLongPress: menu.onLongPress,
        onSecondaryTapUp: menu.onSecondaryTapUp,
        child: _grid
            ? Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 8, 12),
                  child: body,
                ),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 8, 16),
                child: body,
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
