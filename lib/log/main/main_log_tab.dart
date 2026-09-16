import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/log/main/main_log_view_model.dart';
import 'package:qbpanel/log/main/widget/main_log_item.dart';
import 'package:qbpanel/log/widget/log_level_filter_bar.dart';
import 'package:qbpanel/log/widget/log_sticky_grouped_list.dart';
import 'package:qbpanel/widget/adaptive_card_grid.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';

class MainLogTab extends ConsumerWidget {
  const MainLogTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(mainLogProvider);
    final vm = ref.read(mainLogProvider.notifier);
    final width = MediaQuery.sizeOf(context).width;
    final layout = adaptiveListLayout(width);
    final columns = useAdaptiveGrid(width) ? adaptiveGridColumnCount(width) : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LogLevelFilterBar(
          enabledLevels: ui.enabledLevels,
          onToggle: vm.toggleLevel,
        ),
        Expanded(
          child: EmptyStateHost(
            state: ui.emptyState,
            onRetry: vm.retry,
            child: RefreshIndicator(
              onRefresh: vm.refresh,
              child: LogStickyGroupedList(
                sections: ui.sections,
                crossAxisCount: columns,
                itemBuilder: (context, entry) =>
                    MainLogItem(entry: entry, layout: layout),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
