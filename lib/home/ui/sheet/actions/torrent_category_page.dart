import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/home/home_page_view_model.dart';
import 'package:qbpanel/home/ui/dialog/category_edit_dialog.dart';
import 'package:qbpanel/home/ui/torrent_category_tree.dart';

class TorrentCategoryPage extends ConsumerStatefulWidget {
  const TorrentCategoryPage({
    super.key,
    required this.hash,
    required this.pageContext,
    required this.onBack,
  });

  final String hash;
  final BuildContext pageContext;
  final VoidCallback onBack;

  @override
  ConsumerState<TorrentCategoryPage> createState() => _TorrentCategoryPageState();
}

class _TorrentCategoryPageState extends ConsumerState<TorrentCategoryPage> {
  bool _busy = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    ref.watch(homePageProvider);
    final torrent =
        ref.read(homePageProvider.notifier).torrentByHash(widget.hash);
    final selected = torrent?.category?.trim() ?? '';
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final selectedLabel = selected.isEmpty ? '未分类' : selected;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 8, 8),
          child: Row(
            children: [
              IconButton(
                tooltip: '返回',
                visualDensity: VisualDensity.compact,
                onPressed: _busy ? null : widget.onBack,
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '分类',
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
                tooltip: '添加分类',
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
                tooltip: '删除未使用的分类',
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
                selectedCategory: selected,
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
    final current = ref
            .read(homePageProvider.notifier)
            .torrentByHash(widget.hash)
            ?.category
            ?.trim() ??
        '';
    if (category == current) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final error = await ref
        .read(homePageProvider.notifier)
        .setTorrentCategory(widget.hash, category);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = error;
    });
  }
}
