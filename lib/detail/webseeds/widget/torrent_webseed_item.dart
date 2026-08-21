import 'package:flutter/material.dart';
import 'package:qbpanel/api/entity/response/torrent_webseed_response.dart';
import 'package:qbpanel/widget/page_insets.dart';

class TorrentWebSeedItem extends StatelessWidget {
  const TorrentWebSeedItem({
    super.key,
    required this.webSeed,
    this.onLongPress,
  });

  final TorrentWebSeedResponse webSeed;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.http, size: 20, color: scheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Expanded(child: Text(webSeed.url, style: textTheme.titleSmall)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
