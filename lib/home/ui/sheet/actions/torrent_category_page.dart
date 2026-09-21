import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/home/home_page_view_model.dart';
import 'package:qbpanel/home/ui/dialog/category_edit_dialog.dart';
import 'package:qbpanel/home/ui/torrent_category_tree.dart';
import 'package:qbpanel/l10n/context_l10n.dart';

class TorrentCategoryPage extends ConsumerStatefulWidget {
  const TorrentCategoryPage({
    super.key,
    required this.hashes,
    required this.pageContext,
    required this.onBack,
  });

  final String hashes;
  final BuildContext pageContext;
  final VoidCallback onBack;

  @override
  ConsumerState<TorrentCategoryPage> createState() =>
      _TorrentCategoryPageState();
}

class _TorrentCategoryPageState extends ConsumerState<TorrentCategoryPage> {
  bool _busy = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    ref.watch(homePageProvider);
    final vm = ref.read(homePageProvider.notifier);
    final torrents = vm.torrentsByHashes(widget.hashes.split('|'));
    final categories = {
      for (final torrent in torrents) torrent.category?.trim() ?? '',
    };
    final selected = categories.length == 1 ? categories.first : null;
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final selectedLabel = torrents.length > 1
        ? l10n.applyToSelected(torrents.length)
        : (selected == null || selected.isEmpty
              ? l10n.filterUncategorized
              : selected);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 8, 8),
          child: Row(
            children: [
              IconButton(
                tooltip: l10n.actionBack,
                visualDensity: VisualDensity.compact,
                onPressed: _busy ? null : widget.onBack,
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium,
                    ),
                    Text(
                      selectedLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              FilterIconButton(
                tooltip: l10n.addCategory,
                iconSize: 22,
                icon: Icons.create_new_folder_outlined,
                onPressed: _busy
                    ? null
                    : () => CategoryEditDialog.show(
                        context,
                        mode: CategoryEditMode.create,
                      ),
              ),
              const SizedBox(width: 16),
              FilterIconButton(
                tooltip: l10n.deleteUnusedCategories,
                iconSize: 22,
                icon: Icons.folder_delete_outlined,
                onPressed: _busy
                    ? null
                    : () => confirmRemoveUnusedCategories(
                        widget.pageContext,
                        ref,
                      ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 8, right: 8),
            children: [
              TorrentCategoryTree(
                selectedCategory: selected ?? '\u0001',
                enabled: !_busy,
                snackContext: widget.pageContext,
                onSelectCategory: _setCategory,
              ),
            ],
          ),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Text(
              _error!,
              style: textTheme.bodySmall?.copyWith(color: scheme.error),
            ),
          ),
      ],
    );
  }

  Future<void> _setCategory(String category) async {
    final torrents = ref
        .read(homePageProvider.notifier)
        .torrentsByHashes(widget.hashes.split('|'));
    if (torrents.isEmpty) return;
    final current = {
      for (final torrent in torrents) torrent.category?.trim() ?? '',
    };
    if (current.length == 1 && current.first == category) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final error = await ref
        .read(homePageProvider.notifier)
        .setTorrentCategory(widget.hashes, category);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = error;
    });
  }
}
