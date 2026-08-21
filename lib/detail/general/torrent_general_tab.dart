import 'package:flutter/material.dart';
import 'package:qbpanel/detail/general/pieces_bar.dart';
import 'package:qbpanel/detail/general/torrent_general_format.dart';
import 'package:qbpanel/detail/torrent_detail_ui_state.dart';
import 'package:qbpanel/util/byte_format.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';
import 'package:qbpanel/widget/page_insets.dart';

class TorrentGeneralTab extends StatelessWidget {
  const TorrentGeneralTab({
    super.key,
    required this.ui,
    required this.onRetry,
  });

  final TorrentDetailUiState ui;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return EmptyStateHost(
      state: ui.emptyState,
      onRetry: onRetry,
      builder: (context) {
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
                  '进度',
                  PiecesProgressBar(pieces: ui.pieceStates),
                  formatDetailProgress(props.progress),
                ),
                if (ui.showAvailability)
                  (
                    '可用性',
                    PiecesAvailabilityBar(availability: ui.pieceAvailability),
                    formatAvailability(props.availability),
                  ),
              ],
            ),
            const SizedBox(height: 28),
            const _SectionTitle('传输'),
            const SizedBox(height: 16),
            _KvList(
              items: [
                _KvItem('活动时间', formatTimeActive(props.timeElapsed, props.seedingTime)),
                _KvItem('剩余时间', formatDurationSeconds(props.eta)),
                _KvItem('连接', formatConnections(props.nbConnections, props.nbConnectionsLimit)),
                _KvItem('已下载', formatWithSession(props.totalDownloaded, props.totalDownloadedSession)),
                _KvItem('已上传', formatWithSession(props.totalUploaded, props.totalUploadedSession)),
                _KvItem('种子', formatCountTotal(props.seeds, props.seedsTotal)),
                _KvItem('下载速度', formatSpeedAvg(props.dlSpeed, props.dlSpeedAvg)),
                _KvItem('上传速度', formatSpeedAvg(props.upSpeed, props.upSpeedAvg)),
                _KvItem('用户', formatCountTotal(props.peers, props.peersTotal)),
                _KvItem('下载限制', formatSpeedLimit(props.dlLimit)),
                _KvItem('上传限制', formatSpeedLimit(props.upLimit)),
                _KvItem('已丢弃', formatBytes(props.totalWasted)),
                _KvItem('分享率', formatShareNumber(props.shareRatio)),
                _KvItem('下次汇报', formatDurationSeconds(props.reannounce)),
                _KvItem('最后完整可见', formatUnixDate(props.lastSeen, unknown: '从未')),
                _KvItem('流行度', formatShareNumber(props.popularity)),
              ],
            ),
            const SizedBox(height: 28),
            const _SectionTitle('信息'),
            const SizedBox(height: 16),
            _KvList(
              items: [
                _KvItem('名称', props.name ?? '', true),
                _KvItem('总大小', formatBytes(props.totalSize)),
                _KvItem(
                  '区块',
                  formatPieces(props.piecesNum, props.pieceSize, props.piecesHave),
                ),
                _KvItem('创建', props.createdBy ?? ''),
                _KvItem('添加于', formatUnixDate(props.additionDate, unknown: '未知')),
                _KvItem('完成于', formatUnixDate(props.completionDate, unknown: '')),
                _KvItem('创建于', formatUnixDate(props.creationDate, unknown: '')),
                _KvItem('私有', formatPrivate(props.hasMetadata, props.isPrivate)),
                _KvItem('信息哈希值 v1', formatInfoHash(props.infohashV1), true),
                _KvItem('信息哈希值 v2', formatInfoHash(props.infohashV2), true),
                _KvItem('保存路径', props.savePath ?? '', true),
                _KvItem('注释', props.comment ?? '', true),
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
                padding: EdgeInsets.only(right: 8, bottom: i == rows.length - 1 ? 0 : 10),
                child: Text('${rows[i].$1}:', style: labelStyle),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: i == rows.length - 1 ? 0 : 10),
                child: rows[i].$2,
              ),
              Padding(
                padding: EdgeInsets.only(left: 4, bottom: i == rows.length - 1 ? 0 : 10),
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
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
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
        child: Column(
          children: [
            for (final item in items) _KvRow(item: item),
          ],
        ),
      )
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

