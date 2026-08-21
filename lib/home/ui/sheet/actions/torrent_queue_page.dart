import 'package:flutter/material.dart';
import 'package:qbpanel/home/ui/sheet/actions/torrent_action_tile.dart';

class TorrentQueuePage extends StatelessWidget {
  const TorrentQueuePage({
    super.key,
    required this.position,
    required this.onBack,
    required this.onTop,
    required this.onUp,
    required this.onDown,
    required this.onBottom,
  });

  final int? position;
  final VoidCallback onBack;
  final VoidCallback onTop;
  final VoidCallback onUp;
  final VoidCallback onDown;
  final VoidCallback onBottom;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final inQueue = position != null && position! > 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 16, 8),
          child: Row(
            children: [
              IconButton(
                tooltip: '返回',
                visualDensity: VisualDensity.compact,
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Text(
                  '队列',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium,
                ),
              ),
              Text(
                inQueue ? '第 $position 位' : '不在队列中',
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            children: [
              TorrentActionTile(
                icon: Icons.vertical_align_top,
                label: '置顶',
                onTap: onTop,
              ),
              TorrentActionTile(
                icon: Icons.keyboard_arrow_up,
                label: '上移',
                onTap: onUp,
              ),
              TorrentActionTile(
                icon: Icons.keyboard_arrow_down,
                label: '下移',
                onTap: onDown,
              ),
              TorrentActionTile(
                icon: Icons.vertical_align_bottom,
                label: '置底',
                onTap: onBottom,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
