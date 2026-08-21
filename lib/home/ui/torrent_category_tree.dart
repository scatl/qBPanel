import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/home/home_page_view_model.dart';
import 'package:qbpanel/home/entity/torrent_category_node.dart';
import 'package:qbpanel/home/ui/dialog/category_edit_dialog.dart';
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
            label: '全部',
            icon: Icons.apps_outlined,
            showExpandGutter: showExpandGutter,
            count: counts.all,
            selected: widget.allSelected,
            onTap: widget.enabled ? widget.onSelectAll : null,
          ),
        CategoryRow(
          label: '未分类',
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
              tooltip: '编辑分类',
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
              tooltip: '添加子分类',
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
              tooltip: '删除分类',
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
  final message = node.hasChildren
      ? '确定删除分类「${node.fullPath}」？其子分类也会一并删除。种子不会被删除。'
      : '确定删除分类「${node.fullPath}」？种子不会被删除。';
  final confirmed = await ConfirmDialog.show(
    context,
    title: '删除分类',
    message: message,
    confirmText: '删除',
  );
  if (confirmed != true || !context.mounted) return;

  LoadingDialog.show(context, message: '删除中…');
  final error =
      await ref.read(homePageProvider.notifier).removeCategory(node.fullPath);
  if (!context.mounted) return;
  LoadingDialog.dismiss(context);
  if (error == null) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('删除失败：$error')),
  );
}

Future<void> confirmRemoveUnusedCategories(
  BuildContext context,
  WidgetRef ref,
) async {
  final vm = ref.read(homePageProvider.notifier);
  final names = vm.unusedCategoryNames();
  if (names.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('没有未使用的分类')),
    );
    return;
  }

  final confirmed = await ConfirmDialog.show(
    context,
    title: '删除未使用的分类',
    message: '确定删除 ${names.length} 个未使用的分类？种子不会被删除。',
    confirmText: '删除',
  );
  if (confirmed != true || !context.mounted) return;

  LoadingDialog.show(context, message: '删除中…');
  final error = await vm.removeUnusedCategories();
  if (!context.mounted) return;
  LoadingDialog.dismiss(context);
  if (error == null) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('删除失败：$error')),
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
