import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/home/home_page_view_model.dart';
import 'package:qbpanel/home/entity/torrent_category_node.dart';
import 'package:qbpanel/home/ui/dialog/category_edit_dialog.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/dialog/confirm_dialog.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';

/// `''` 表示未分类。
typedef CategoryPathCallback = void Function(String category);

class TorrentCategoryTree extends ConsumerStatefulWidget {
  const TorrentCategoryTree({
    super.key,
    required this.selectedCategory,
    required this.onSelectCategory,
    this.showAllRow = false,
    this.allSelected = false,
    this.onSelectAll,
    this.enabled = true,
    this.snackContext,
  });

  /// 当前选中的分类完整路径；空字符串表示未分类。
  final String selectedCategory;
  final CategoryPathCallback onSelectCategory;
  final bool showAllRow;
  final bool allSelected;
  final VoidCallback? onSelectAll;
  final bool enabled;
  final BuildContext? snackContext;

  @override
  ConsumerState<TorrentCategoryTree> createState() =>
      _TorrentCategoryTreeState();
}

class _TorrentCategoryTreeState extends ConsumerState<TorrentCategoryTree> {
  final Set<String> _expandedPaths = {};

  @override
  void initState() {
    super.initState();
    _expandAncestors(widget.selectedCategory);
  }

  @override
  void didUpdateWidget(covariant TorrentCategoryTree oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory) {
      _expandAncestors(widget.selectedCategory);
    }
  }

  void _expandAncestors(String fullPath) {
    if (fullPath.isEmpty) return;
    _expandedPaths.addAll(categoryAncestorPaths(fullPath));
  }

  void _toggleExpand(String fullPath) {
    setState(() {
      if (!_expandedPaths.remove(fullPath)) {
        _expandedPaths.add(fullPath);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tree = ref.watch(homePageProvider.select((s) => s.categoryTree));
    final counts = ref.watch(homePageProvider.select((s) => s.categoryCounts));
    final showExpandGutter = tree.any((node) => node.hasChildren);
    final selectedPath = widget.allSelected || widget.selectedCategory.isEmpty
        ? null
        : widget.selectedCategory;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showAllRow)
          CategoryRow(
            label: context.l10n.filterAll,
            icon: Icons.apps_outlined,
            showExpandGutter: showExpandGutter,
            count: counts.all,
            selected: widget.allSelected,
            onTap: widget.enabled ? widget.onSelectAll : null,
          ),
        CategoryRow(
          label: context.l10n.filterUncategorized,
          icon: Icons.label_off_outlined,
          showExpandGutter: showExpandGutter,
          count: counts.uncategorized,
          selected: !widget.allSelected && widget.selectedCategory.isEmpty,
          onTap: widget.enabled ? () => widget.onSelectCategory('') : null,
        ),
        ..._treeRows(
          tree,
          showExpandGutter: showExpandGutter,
          counts: counts,
          selectedPath: selectedPath,
        ),
      ],
    );
  }

  List<Widget> _treeRows(
    List<TorrentCategoryNode> nodes, {
    int depth = 0,
    required bool showExpandGutter,
    required TorrentCategoryCounts counts,
    required String? selectedPath,
  }) {
    final rows = <Widget>[];
    for (final node in nodes) {
      final expanded = _expandedPaths.contains(node.fullPath);
      rows.add(
        CategoryRow(
          label: node.segment,
          depth: depth,
          hasChildren: node.hasChildren,
          expanded: expanded,
          showExpandGutter: showExpandGutter,
          count: counts.of(node.fullPath),
          selected: selectedPath == node.fullPath,
          onTap: widget.enabled
              ? () => widget.onSelectCategory(node.fullPath)
              : null,
          onToggleExpand: node.hasChildren
              ? () => _toggleExpand(node.fullPath)
              : null,
          actions: [
            FilterIconButton(
              tooltip: context.l10n.editCategory,
              icon: Icons.edit_note_outlined,
              onPressed: widget.enabled
                  ? () => CategoryEditDialog.show(
                      context,
                      mode: CategoryEditMode.edit,
                      categoryName: node.fullPath,
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            FilterIconButton(
              tooltip: context.l10n.addSubcategory,
              icon: Icons.create_new_folder_outlined,
              onPressed: widget.enabled
                  ? () => CategoryEditDialog.show(
                      context,
                      mode: CategoryEditMode.createSubcategory,
                      parentPath: node.fullPath,
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            FilterIconButton(
              tooltip: context.l10n.deleteCategory,
              icon: Icons.delete_outline,
              onPressed: widget.enabled
                  ? () => confirmRemoveCategory(
                      widget.snackContext ?? context,
                      ref,
                      node,
                    )
                  : null,
            ),
          ],
        ),
      );
      if (node.hasChildren && expanded) {
        rows.addAll(
          _treeRows(
            node.children,
            depth: depth + 1,
            showExpandGutter: showExpandGutter,
            counts: counts,
            selectedPath: selectedPath,
          ),
        );
      }
    }
    return rows;
  }
}

List<String> categoryAncestorPaths(String fullPath) {
  final parts = fullPath.split('/');
  if (parts.length < 2) return const [];
  final paths = <String>[];
  var prefix = parts.first;
  paths.add(prefix);
  for (var i = 1; i < parts.length - 1; i++) {
    prefix = '$prefix/${parts[i]}';
    paths.add(prefix);
  }
  return paths;
}

Future<void> confirmRemoveCategory(
  BuildContext context,
  WidgetRef ref,
  TorrentCategoryNode node,
) async {
  final l10n = context.l10n;
  final message = node.hasChildren
      ? l10n.confirmDeleteCategoryWithChildren(node.fullPath)
      : l10n.confirmDeleteCategory(node.fullPath);
  final confirmed = await ConfirmDialog.show(
    context,
    title: l10n.deleteCategory,
    message: message,
    confirmText: l10n.actionDelete,
  );
  if (confirmed != true || !context.mounted) return;

  LoadingDialog.show(context, message: l10n.deleting);
  final error =
      await ref.read(homePageProvider.notifier).removeCategory(node.fullPath);
  if (!context.mounted) return;
  LoadingDialog.dismiss(context);
  if (error == null) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(l10n.deleteFailed(error))),
  );
}

Future<void> confirmRemoveUnusedCategories(
  BuildContext context,
  WidgetRef ref,
) async {
  final l10n = context.l10n;
  final vm = ref.read(homePageProvider.notifier);
  final names = vm.unusedCategoryNames();
  if (names.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.noUnusedCategories)),
    );
    return;
  }

  final confirmed = await ConfirmDialog.show(
    context,
    title: l10n.deleteUnusedCategories,
    message: l10n.confirmDeleteUnusedCategories(names.length),
    confirmText: l10n.actionDelete,
  );
  if (confirmed != true || !context.mounted) return;

  LoadingDialog.show(context, message: l10n.deleting);
  final error = await vm.removeUnusedCategories();
  if (!context.mounted) return;
  LoadingDialog.dismiss(context);
  if (error == null) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(l10n.deleteFailed(error))),
  );
}

class FilterIconButton extends StatelessWidget {
  const FilterIconButton({
    super.key,
    required this.tooltip,
    required this.icon,
    this.iconSize,
    this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final double? iconSize;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
        minimumSize: const Size(32, 32),
      ),
      icon: Icon(icon, size: iconSize ?? 20),
    );
  }
}

class CategoryRow extends StatelessWidget {
  const CategoryRow({
    super.key,
    required this.label,
    this.icon = Icons.folder_outlined,
    this.depth = 0,
    this.hasChildren = false,
    this.expanded = true,
    this.showExpandGutter = false,
    this.count = 0,
    this.selected = false,
    this.onTap,
    this.onToggleExpand,
    this.actions = const [],
  });

  final String label;
  final IconData icon;
  final int depth;
  final bool hasChildren;
  final bool expanded;
  final bool showExpandGutter;
  final int count;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onToggleExpand;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final labelColor =
        selected ? scheme.onPrimaryContainer : scheme.onSurface;

    return Padding(
      padding: EdgeInsets.only(left: 8.0 + depth * 16),
      child: Material(
        color: selected ? scheme.secondaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 48,
            child: Row(
              children: [
                if (showExpandGutter)
                  SizedBox(
                    width: 32,
                    child: hasChildren
                        ? InkWell(
                            onTap: onToggleExpand,
                            customBorder: const CircleBorder(),
                            child: Center(
                              child: AnimatedRotation(
                                turns: expanded ? 0.5 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  Icons.expand_more,
                                  size: 20,
                                  color: labelColor,
                                ),
                              ),
                            ),
                          )
                        : null,
                  )
                else
                  const SizedBox(width: 12),
                Icon(
                  hasChildren && expanded
                      ? Icons.folder_open_outlined
                      : icon,
                  size: 22,
                  color: labelColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium?.copyWith(
                            color: labelColor,
                          ),
                        ),
                      ),
                      Text(
                        ' ($count)',
                        style: textTheme.bodyMedium?.copyWith(
                          color: labelColor,
                        ),
                      ),
                    ],
                  ),
                ),
                ...actions,
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
