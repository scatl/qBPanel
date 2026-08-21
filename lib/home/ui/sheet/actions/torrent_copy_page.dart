import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qbpanel/home/entity/torrent_action.dart';
import 'package:qbpanel/home/ui/sheet/actions/torrent_action_tile.dart';

class TorrentCopyPage extends StatelessWidget {
  const TorrentCopyPage({
    super.key,
    required this.items,
    required this.pageContext,
    required this.onBack,
  });

  final List<TorrentCopyItem> items;
  final BuildContext pageContext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
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
                  '复制',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final item in items)
                TorrentActionTile(
                  icon: item.icon,
                  label: item.label,
                  foreground: scheme.onSurface,
                  onTap: () => _copyAndClose(context, item),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _copyAndClose(BuildContext sheetContext, TorrentCopyItem item) async {
    await Clipboard.setData(ClipboardData(text: item.value));
    if (sheetContext.mounted) Navigator.pop(sheetContext);
    if (!pageContext.mounted) return;
    ScaffoldMessenger.of(pageContext).showSnackBar(
      SnackBar(content: Text('已复制 ${item.label}')),
    );
  }
}
