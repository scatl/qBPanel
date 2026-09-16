import 'package:flutter/material.dart';
import 'package:qbpanel/home/list_layout_mode.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/log/model/log_peer_entry.dart';
import 'package:qbpanel/log/widget/log_item_meta_row.dart';
import 'package:qbpanel/widget/page_insets.dart';

class PeerLogItem extends StatelessWidget {
  const PeerLogItem({
    super.key,
    required this.entry,
    this.layout = ListLayoutMode.list,
  });

  final LogPeerEntry entry;
  final ListLayoutMode layout;

  bool get _grid => layout == ListLayoutMode.grid;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final statusColor = entry.blocked ? scheme.error : scheme.onSurfaceVariant;
    final l10n = context.l10n;
    final statusLabel = entry.blocked ? l10n.logPeerBlocked : l10n.logPeerBanned;

    final card = Material(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: _grid
          ? Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: _body(textTheme, statusColor, statusLabel),
              ),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: _body(textTheme, statusColor, statusLabel),
            ),
    );

    if (_grid) return card;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PageInsets.horizontal,
        0,
        PageInsets.horizontal,
        8,
      ),
      child: card,
    );
  }

  Widget _body(
    TextTheme textTheme,
    Color statusColor,
    String statusLabel,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LogItemMetaRow(
          id: entry.id,
          timestamp: entry.timestamp,
          trailing: Text(
            statusLabel,
            style: textTheme.labelSmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          entry.ip,
          style: textTheme.titleSmall?.copyWith(color: statusColor),
        ),
        if (entry.reason.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(entry.reason, style: textTheme.bodyMedium),
        ],
      ],
    );
  }
}
