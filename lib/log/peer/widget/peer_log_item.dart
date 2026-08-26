import 'package:flutter/material.dart';
import 'package:qbpanel/log/model/log_peer_entry.dart';
import 'package:qbpanel/log/widget/log_item_meta_row.dart';
import 'package:qbpanel/widget/page_insets.dart';

class PeerLogItem extends StatelessWidget {
  const PeerLogItem({super.key, required this.entry});

  final LogPeerEntry entry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final statusColor = entry.blocked ? scheme.error : scheme.onSurfaceVariant;
    final statusLabel = entry.blocked ? '已屏蔽' : '已封禁';

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PageInsets.horizontal,
        0,
        PageInsets.horizontal,
        8,
      ),
      child: Material(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
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
                Text(
                  entry.reason,
                  style: textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
