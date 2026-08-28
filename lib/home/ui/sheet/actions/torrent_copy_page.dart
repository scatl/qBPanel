import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qbpanel/home/entity/torrent_action.dart';
import 'package:qbpanel/home/ui/sheet/actions/torrent_action_tile.dart';
import 'package:qbpanel/l10n/context_l10n.dart';

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
    final l10n = context.l10n;
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
                tooltip: l10n.actionBack,
                visualDensity: VisualDensity.compact,
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Text(
                  l10n.copy,
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
      SnackBar(content: Text(pageContext.l10n.copiedWithLabel(item.label))),
    );
  }
}
