import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/log/peer/peer_log_view_model.dart';
import 'package:qbpanel/log/peer/widget/peer_log_item.dart';
import 'package:qbpanel/log/widget/log_sticky_grouped_list.dart';
import 'package:qbpanel/widget/adaptive_card_grid.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';

class PeerLogTab extends ConsumerWidget {
  const PeerLogTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(peerLogProvider);
    final vm = ref.read(peerLogProvider.notifier);
    final width = MediaQuery.sizeOf(context).width;
    final layout = adaptiveListLayout(width);
    final columns = useAdaptiveGrid(width) ? adaptiveGridColumnCount(width) : 1;

    return EmptyStateHost(
      state: ui.emptyState,
      onRetry: vm.retry,
      child: RefreshIndicator(
        onRefresh: vm.refresh,
        child: LogStickyGroupedList(
          sections: ui.sections,
          crossAxisCount: columns,
          itemBuilder: (context, entry) =>
              PeerLogItem(entry: entry, layout: layout),
        ),
      ),
    );
  }
}
