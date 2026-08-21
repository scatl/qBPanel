import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/home/home_page_view_model.dart';
import 'package:qbpanel/home/entity/torrent_category_filter.dart';
import 'package:qbpanel/home/entity/torrent_status_filter.dart';
import 'package:qbpanel/home/entity/torrent_tag.dart';
import 'package:qbpanel/home/ui/dialog/category_edit_dialog.dart';
import 'package:qbpanel/home/ui/dialog/tag_edit_dialog.dart';
import 'package:qbpanel/home/ui/torrent_category_tree.dart';
import 'package:qbpanel/widget/dialog/confirm_dialog.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';
import 'package:qbpanel/widget/page_insets.dart';
import 'package:qbpanel/widget/sheet/blur_modal_bottom_sheet.dart';

class TorrentFilterSheet extends ConsumerStatefulWidget {
  const TorrentFilterSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showBlurModalBottomSheet<void>(
      context: context,
      builder: (context) {
        final height = MediaQuery.sizeOf(context).height * 0.7;
        return SizedBox(
          height: height,
          child: const ScaffoldMessenger(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: TorrentFilterSheet(),
            ),
          ),
        );
      },
    );
  }

  @override
  ConsumerState<TorrentFilterSheet> createState() => _TorrentFilterSheetState();
}

class _TorrentFilterSheetState extends ConsumerState<TorrentFilterSheet> {
  bool _statusExpanded = true;
  bool _categoryExpanded = true;
  bool _tagExpanded = true;

  @override
  Widget build(BuildContext context) {
    final statusFilter = ref.watch(homePageProvider.select((s) => s.statusFilter));
    final statusCounts = ref.watch(homePageProvider.select((s) => s.statusCounts));
    final categoryFilter = ref.watch(homePageProvider.select((s) => s.categoryFilter));
    final tags = ref.watch(homePageProvider.select((s) => s.tags));
    final tagCounts = ref.watch(homePageProvider.select((s) => s.tagCounts));
    final tagFilter = ref.watch(homePageProvider.select((s) => s.tagFilter));
    final filtering = statusFilter != TorrentStatusFilter.all
        || !categoryFilter.isAll || !tagFilter.isAll;

    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: Text('筛选', style: textTheme.titleMedium),
              ),
              TextButton(
                onPressed: filtering
                    ? () =>
                        ref.read(homePageProvider.notifier).clearFilters()
                    : null,
                child: const Text('清除筛选'),
              ),
            ],
          ),
        ),
        _FilterSection(
            title: '状态',
            selectedLabel: statusFilter.displayText,
            expanded: _statusExpanded,
            onToggle: () {
              setState(() => _statusExpanded = !_statusExpanded);
            },
            child: _FilterCard(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 48,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 4,
                ),
                itemCount: TorrentStatusFilter.values.length,
                itemBuilder: (context, index) {
                  final filter = TorrentStatusFilter.values[index];
                  return _StatusCell(
                    filter: filter,
                    selected: filter == statusFilter,
                    count: statusCounts[filter] ?? 0,
                    onTap: () {
                      ref
                          .read(homePageProvider.notifier)
                          .setStatusFilter(filter);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ),
          _FilterSection(
            title: '分类',
            selectedLabel: categoryFilter.displayText,
            expanded: _categoryExpanded,
            onToggle: () {
              setState(() => _categoryExpanded = !_categoryExpanded);
            },
            actions: [
              FilterIconButton(
                tooltip: '添加分类',
                iconSize: 22,
                icon: Icons.create_new_folder_outlined,
                onPressed: () => CategoryEditDialog.show(
                  context,
                  mode: CategoryEditMode.create,
                ),
              ),
              const SizedBox(width: 16),
              FilterIconButton(
                tooltip: '删除未使用的分类',
                iconSize: 22,
                icon: Icons.folder_delete_outlined,
                onPressed: () => confirmRemoveUnusedCategories(context, ref),
              ),
              const SizedBox(width: 8),
            ],
            child: _FilterCard(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                child: TorrentCategoryTree(
                  showAllRow: true,
                  allSelected: categoryFilter.isAll,
                  selectedCategory: categoryFilter.isUncategorized
                      ? ''
                      : (categoryFilter.path ?? ''),
                  onSelectAll: () =>
                      _onSelectCategory(TorrentCategoryFilter.all),
                  onSelectCategory: (path) {
                    _onSelectCategory(
                      path.isEmpty
                          ? TorrentCategoryFilter.uncategorized
                          : TorrentCategoryFilter.named(path),
                    );
                  },
                ),
              ),
            ),
          ),
          _FilterSection(
            title: '标签',
            selectedLabel: tagFilter.displayText,
            expanded: _tagExpanded,
            onToggle: () {
              setState(() => _tagExpanded = !_tagExpanded);
            },
            actions: [
              FilterIconButton(
                tooltip: '添加标签',
                iconSize: 22,
                icon: Icons.new_label_outlined,
                onPressed: () => TagEditDialog.show(context),
              ),
              const SizedBox(width: 16),
              FilterIconButton(
                tooltip: '删除未使用的标签',
                iconSize: 22,
                icon: Icons.label_off_outlined,
                onPressed: _onRemoveUnusedTags,
              ),
              const SizedBox(width: 8),
            ],
            child: _FilterCard(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                child: Column(
                  children: [
                    CategoryRow(
                      label: '全部',
                      icon: Icons.apps_outlined,
                      count: tagCounts.all,
                      selected: tagFilter.isAll,
                      onTap: () => _onSelectTag(TorrentTagFilter.all),
                    ),
                    CategoryRow(
                      label: '无标签',
                      icon: Icons.label_off_outlined,
                      count: tagCounts.untagged,
                      selected: tagFilter.isUntagged,
                      onTap: () => _onSelectTag(TorrentTagFilter.untagged),
                    ),
                    for (final tag in tags)
                      CategoryRow(
                        label: tag,
                        icon: Icons.label_outlined,
                        count: tagCounts.of(tag),
                        selected: tagFilter.name == tag,
                        onTap: () => _onSelectTag(TorrentTagFilter.named(tag)),
                        actions: [
                          FilterIconButton(
                            tooltip: '删除标签',
                            icon: Icons.delete_outline,
                            onPressed: () => _onRemoveTag(tag),
                          )
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
    );
  }

  void _onSelectCategory(TorrentCategoryFilter filter) {
    ref.read(homePageProvider.notifier).setCategoryFilter(filter);
    Navigator.pop(context);
  }

  void _onSelectTag(TorrentTagFilter filter) {
    ref.read(homePageProvider.notifier).setTagFilter(filter);
    Navigator.pop(context);
  }

  Future<void> _onRemoveTag(String tag) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: '删除标签',
      message: '确定删除标签「$tag」？种子不会被删除。',
      confirmText: '删除',
    );
    if (confirmed != true || !mounted) return;

    LoadingDialog.show(context, message: '删除中…');
    final error = await ref.read(homePageProvider.notifier).deleteTag(tag);
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    if (error == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('删除失败：$error')),
    );
  }

  Future<void> _onRemoveUnusedTags() async {
    final vm = ref.read(homePageProvider.notifier);
    final names = vm.unusedTagNames();
    if (names.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('没有未使用的标签')),
      );
      return;
    }

    final confirmed = await ConfirmDialog.show(
      context,
      title: '删除未使用的标签',
      message: '确定删除 ${names.length} 个未使用的标签？种子不会被删除。',
      confirmText: '删除',
    );
    if (confirmed != true || !mounted) return;

    LoadingDialog.show(context, message: '删除中…');
    final error = await vm.deleteUnusedTags();
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    if (error == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('删除失败：$error')),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.title,
    required this.selectedLabel,
    required this.expanded,
    required this.onToggle,
    required this.child,
    this.actions = const [],
  });

  final String title;
  final String selectedLabel;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 4, 0),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onToggle,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            color: scheme.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            selectedLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ...actions,
              InkWell(
                onTap: onToggle,
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.expand_more),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: expanded
              ? child
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

class _FilterCard extends StatelessWidget {
  const _FilterCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PageInsets.horizontal,
        0,
        PageInsets.horizontal,
        8,
      ),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}

class _StatusCell extends StatelessWidget {
  const _StatusCell({
    required this.filter,
    required this.selected,
    required this.count,
    required this.onTap,
  });

  final TorrentStatusFilter filter;
  final bool selected;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final labelColor =
        selected ? scheme.onPrimaryContainer : scheme.onSurface;

    return Material(
      color: selected ? scheme.secondaryContainer : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(filter.icon, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  filter.displayText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(color: labelColor),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '($count)',
                style: textTheme.bodyMedium?.copyWith(color: labelColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
