import 'package:flutter/material.dart';
import 'package:qbpanel/detail/general/pieces_bar.dart';
import 'package:qbpanel/detail/general/speed/torrent_speed_chart.dart';
import 'package:qbpanel/detail/general/torrent_general_format.dart';
import 'package:qbpanel/detail/torrent_detail_ui_state.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/util/byte_format.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';
import 'package:qbpanel/widget/page_insets.dart';

class TorrentGeneralTab extends StatelessWidget {
  const TorrentGeneralTab({
    super.key,
    required this.torrentHash,
    required this.ui,
    required this.onRetry,
  });

  final String torrentHash;
  final TorrentDetailUiState ui;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return EmptyStateHost(
      state: ui.emptyState,
      onRetry: onRetry,
      builder: (context) {
        final l10n = context.l10n;
        final props = ui.properties!;
        final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;

        return ListView(
          padding: EdgeInsets.fromLTRB(
            PageInsets.horizontal,
            16,
            PageInsets.horizontal,
            24 + bottomSafe,
          ),
          children: [
            _BarTable(
              rows: [
                (
                  l10n.progress,
                  PiecesProgressBar(pieces: ui.pieceStates),
                  formatDetailProgress(props.progress),
                ),
                if (ui.showAvailability)
                  (
                    l10n.availability,
                    PiecesAvailabilityBar(availability: ui.pieceAvailability),
                    formatAvailability(props.availability),
                  ),
              ],
            ),
            const SizedBox(height: 28),
            TorrentSpeedChart(torrentHash: torrentHash),
            const SizedBox(height: 28),
            _SectionTitle(l10n.transfer),
            const SizedBox(height: 16),
            _KvList(
              items: [
                _KvItem(
                  l10n.timeActive,
                  formatTimeActive(props.timeElapsed, props.seedingTime, l10n),
                ),
                _KvItem(l10n.eta, formatDurationSeconds(props.eta, l10n)),
                _KvItem(
                  l10n.connections,
                  formatConnections(
                    props.nbConnections,
                    props.nbConnectionsLimit,
                    l10n,
                  ),
                ),
                _KvItem(
                  l10n.sortDownloaded,
                  formatWithSession(
                    props.totalDownloaded,
                    props.totalDownloadedSession,
                    l10n,
                  ),
                ),
                _KvItem(
                  l10n.sortUploaded,
                  formatWithSession(
                    props.totalUploaded,
                    props.totalUploadedSession,
                    l10n,
                  ),
                ),
                _KvItem(l10n.seeds, formatCountTotal(props.seeds, props.seedsTotal, l10n)),
                _KvItem(
                  l10n.sortDownloadSpeed,
                  formatSpeedAvg(props.dlSpeed, props.dlSpeedAvg, l10n),
                ),
                _KvItem(
                  l10n.sortUploadSpeed,
                  formatSpeedAvg(props.upSpeed, props.upSpeedAvg, l10n),
                ),
                _KvItem(l10n.peers, formatCountTotal(props.peers, props.peersTotal, l10n)),
                _KvItem(l10n.dlLimit, formatSpeedLimit(props.dlLimit)),
                _KvItem(l10n.upLimit, formatSpeedLimit(props.upLimit)),
                _KvItem(l10n.wasted, formatBytes(props.totalWasted)),
                _KvItem(l10n.sortRatio, formatShareNumber(props.shareRatio)),
                _KvItem(l10n.nextAnnounce, formatDurationSeconds(props.reannounce, l10n)),
                _KvItem(
                  l10n.lastSeen,
                  formatUnixDate(props.lastSeen, unknown: l10n.never),
                ),
                _KvItem(l10n.popularity, formatShareNumber(props.popularity)),
              ],
            ),
            const SizedBox(height: 28),
            _SectionTitle(l10n.info),
            const SizedBox(height: 16),
            _KvList(
              items: [
                _KvItem(l10n.sortName, props.name ?? '', true),
                _KvItem(l10n.totalSize, formatBytes(props.totalSize)),
                _KvItem(
                  l10n.pieces,
                  formatPieces(
                    props.piecesNum,
                    props.pieceSize,
                    props.piecesHave,
                    l10n,
                  ),
                ),
                _KvItem(l10n.createdBy, props.createdBy ?? ''),
                _KvItem(
                  l10n.addedOn,
                  formatUnixDate(props.additionDate, unknown: l10n.unknown),
                ),
                _KvItem(
                  l10n.completedOn,
                  formatUnixDate(props.completionDate, unknown: ''),
                ),
                _KvItem(l10n.createdOn, formatUnixDate(props.creationDate, unknown: '')),
                _KvItem(
                  l10n.privateTorrent,
                  formatPrivate(props.hasMetadata, props.isPrivate, l10n),
                ),
                _KvItem(l10n.infohashV1, formatInfoHash(props.infohashV1, l10n), true),
                _KvItem(l10n.infohashV2, formatInfoHash(props.infohashV2, l10n), true),
                _KvItem(l10n.savePath, props.savePath ?? '', true),
                _KvItem(l10n.comment, props.comment ?? '', true),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _BarTable extends StatelessWidget {
  const _BarTable({required this.rows});

  final List<(String, Widget, String)> rows;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final labelStyle = textTheme.bodySmall?.copyWith(
      color: scheme.onSurfaceVariant,
    );
    final trailingStyle = textTheme.labelMedium?.copyWith(
      color: scheme.onSurfaceVariant,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
        2: IntrinsicColumnWidth(),
      },
      children: [
        for (var i = 0; i < rows.length; i++)
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: 8,
                  bottom: i == rows.length - 1 ? 0 : 10,
                ),
                child: Text('${rows[i].$1}:', style: labelStyle),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: i == rows.length - 1 ? 0 : 10),
                child: rows[i].$2,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 4,
                  bottom: i == rows.length - 1 ? 0 : 10,
                ),
                child: Text(rows[i].$3, style: trailingStyle),
              ),
            ],
          ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

/// 传输 / 信息共用左列宽度，保证两段标签、数值各自对齐。
const _kvLabelWidth = 132.0;

class _KvItem {
  const _KvItem(this.label, this.value, [this.selectable = false]);

  final String label;
  final String value;
  final bool selectable;
}

class _KvList extends StatelessWidget {
  const _KvList({required this.items});

  final List<_KvItem> items;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(children: [for (final item in items) _KvRow(item: item)]),
      ),
    );
  }
}

class _KvRow extends StatelessWidget {
  const _KvRow({required this.item});

  final _KvItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final value = item.value.isEmpty ? '—' : item.value;
    final valueStyle = textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _kvLabelWidth,
            child: Text(
              item.label,
              style: textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: item.selectable
                ? SelectableText(value, style: valueStyle)
                : Text(value, style: valueStyle),
          ),
        ],
      ),
    );
  }
}
