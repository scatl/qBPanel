import 'package:flutter/material.dart';
import 'package:qbpanel/api/entity/response/torrent_info_response.dart';
import 'package:qbpanel/api/entity/response/torrent_state.dart';
import 'package:qbpanel/home/entity/torrent_tag.dart';
import 'package:qbpanel/widget/page_insets.dart';
import 'package:qbpanel/util/byte_format.dart';

class TorrentItem extends StatelessWidget {
  const TorrentItem({
    super.key,
    required this.torrent,
    this.queueing = false,
    this.onTap,
    this.onLongPress,
  });

  final TorrentInfoResponse torrent;
  final bool queueing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final progress = (torrent.progress ?? 0).clamp(0.0, 1.0);
    final indicatorColor = _progressColor(scheme, torrent.state);
    final queuePosition = queueing ? torrent.priority : null;
    final showQueuePosition =
        queuePosition != null && queuePosition > 0;
    final tags = splitTorrentTags(torrent.tags);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PageInsets.horizontal,
        vertical: 6,
      ),
      child: Material(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    if (showQueuePosition)
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: _TitleChip(
                          text: '#$queuePosition',
                          background: scheme.secondaryContainer,
                          foreground: scheme.onSecondaryContainer,
                          tabular: true,
                        ),
                      ),
                    if (showQueuePosition) const TextSpan(text: ' '),
                    TextSpan(text: _softWrapName(torrent.name)),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleSmall,
              ),
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
                    formatProgress(torrent.progress),
                    style: textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StateLabel(state: torrent.state),
                  ),
                  SpeedChip(
                    icon: Icons.south_rounded,
                    text: formatSpeed(torrent.dlspeed),
                    color: scheme.primary,
                  ),
                  const SizedBox(width: 16),
                  SpeedChip(
                    icon: Icons.north_rounded,
                    text: formatSpeed(torrent.upspeed),
                    color: scheme.tertiary,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 6,
                children: [
                  _StatText(
                    label: '已下载',
                    value: formatBytes(torrent.downloaded, fractionDigits: 2),
                  ),
                  _StatText(
                    label: '大小',
                    value: formatBytes(
                      torrent.size ?? torrent.totalSize,
                      fractionDigits: 2,
                    ),
                  ),
                  _StatText(
                    label: '已上传',
                    value: formatBytes(torrent.uploaded, fractionDigits: 2),
                  ),
                  if (_isCompleted(torrent.state))
                    _StatText(
                      label: '分享率',
                      value: formatRatio(torrent.ratio),
                    )
                  else
                    _StatText(
                      label: '剩余',
                      value: formatEta(torrent.eta),
                    ),
                ],
              ),
              if (tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.label_outlined,
                      size: 16,
                      color: scheme.onSurfaceVariant,
                    ),
                    Text(
                      ' : ',
                      style: textTheme.labelMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final tag in tags)
                            _TitleChip(
                              text: tag,
                              background: scheme.surfaceContainerHighest,
                              foreground: scheme.onSurfaceVariant,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
            ),
          ),
        ),
      ),
    );
  }

  Color _progressColor(ColorScheme scheme, TorrentState? state) {
    switch (state) {
      case TorrentState.error:
      case TorrentState.missingFiles:
        return scheme.error;
      case TorrentState.uploading:
      case TorrentState.forcedUP:
      case TorrentState.stalledUP:
      case TorrentState.stoppedUP:
        return scheme.tertiary;
      default:
        return scheme.primary;
    }
  }
}

bool _isCompleted(TorrentState? state) {
  switch (state) {
    case TorrentState.uploading:
    case TorrentState.stalledUP:
    case TorrentState.checkingUP:
    case TorrentState.stoppedUP:
    case TorrentState.queuedUP:
    case TorrentState.forcedUP:
      return true;
    default:
      return false;
  }
}

/// 种子名常无空格；跟在 WidgetSpan 后若整段不可断，会被挤到下一行。
/// 插入零宽空格后可在第一行继续排字，换行仍从左侧顶格开始。
String _softWrapName(String? name) {
  final text = name ?? '';
  if (text.isEmpty) return text;
  final buffer = StringBuffer();
  for (final unit in text.runes) {
    buffer.writeCharCode(unit);
    buffer.write('\u200B');
  }
  return buffer.toString();
}

class _StateLabel extends StatelessWidget {
  const _StateLabel({required this.state});

  final TorrentState? state;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final resolved = state ?? TorrentState.unknown;
    final color = _color(scheme, resolved);

    return Row(
      children: [
        Icon(_stateIcon(resolved), size: 16, color: color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            resolved.displayText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelMedium?.copyWith(color: color),
          ),
        ),
      ],
    );
  }

  IconData _stateIcon(TorrentState state) {
    switch (state) {
      case TorrentState.stoppedUP:
        return Icons.check_circle_outline;
      case TorrentState.uploading:
        return Icons.arrow_circle_up_outlined;
      case TorrentState.downloading:
        return Icons.arrow_circle_down_outlined;
      case TorrentState.forcedDL:
        return Icons.fast_forward_rounded;
      case TorrentState.error:
      case TorrentState.missingFiles:
        return Icons.cancel_outlined;
      case TorrentState.stoppedDL:
        return Icons.stop_circle_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Color _color(ColorScheme scheme, TorrentState state) {
    switch (state) {
      case TorrentState.stoppedUP:
      case TorrentState.uploading:
        return scheme.tertiary;
      case TorrentState.downloading:
        return scheme.primary;
      case TorrentState.error:
      case TorrentState.missingFiles:
        return scheme.error;
      default:
        return scheme.onSurfaceVariant;
    }
  }
}

class _TitleChip extends StatelessWidget {
  const _TitleChip({
    required this.text,
    required this.background,
    required this.foreground,
    this.tabular = false,
  });

  final String text;
  final Color background;
  final Color foreground;
  final bool tabular;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: textTheme.labelSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
          fontFeatures: tabular
              ? const [FontFeature.tabularFigures()]
              : null,
          height: 1.2,
        ),
      ),
    );
  }
}

class SpeedChip extends StatelessWidget {
  const SpeedChip({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: textTheme.bodyMedium?.copyWith(
            color: color,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _StatText extends StatelessWidget {
  const _StatText({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label ',
            style: textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          TextSpan(
            text: value,
            style: textTheme.bodySmall?.copyWith(
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
