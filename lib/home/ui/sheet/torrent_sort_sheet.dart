import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/home/home_page_view_model.dart';
import 'package:qbpanel/home/entity/torrent_sort.dart';
import 'package:qbpanel/widget/page_insets.dart';
import 'package:qbpanel/widget/sheet/blur_modal_bottom_sheet.dart';

class TorrentSortSheet extends ConsumerWidget {
  const TorrentSortSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showBlurModalBottomSheet<void>(
      context: context,
      builder: (_) => const TorrentSortSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortKey = ref.watch(homePageProvider.select((s) => s.sortKey));
    final sortAscending = ref.watch(
      homePageProvider.select((s) => s.sortAscending),
    );
    final textTheme = Theme.of(context).textTheme;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.7;
    final keys = TorrentSortKey.values;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text('排序', style: textTheme.titleMedium),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 16),
              children: [
                Padding(
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
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 48,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 4,
                      ),
                      itemCount: keys.length,
                      itemBuilder: (context, index) {
                        final key = keys[index];
                        final selected = key == sortKey;
                        return _SortCell(
                          label: key.displayText,
                          selected: selected,
                          ascending: sortAscending,
                          onTap: () => ref
                              .read(homePageProvider.notifier)
                              .setSort(key),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SortCell extends StatelessWidget {
  const _SortCell({
    required this.label,
    required this.selected,
    required this.ascending,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool ascending;
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
              if (selected) ...[
                Icon(
                  ascending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 18,
                  color: scheme.primary,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(color: labelColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
