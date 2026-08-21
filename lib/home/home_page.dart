import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qbpanel/api/entity/response/torrent_info_response.dart';
import 'package:qbpanel/home/home_page_view_model.dart';
import 'package:qbpanel/home/entity/torrent_sort.dart';
import 'package:qbpanel/home/entity/torrent_status_filter.dart';
import 'package:qbpanel/home/ui/home_bottom_bar.dart';
import 'package:qbpanel/home/ui/sheet/server_state_sheet.dart';
import 'package:qbpanel/home/ui/sheet/server_switch_sheet.dart';
import 'package:qbpanel/home/ui/sheet/actions/torrent_action_sheet.dart';
import 'package:qbpanel/home/ui/sheet/torrent_filter_sheet.dart';
import 'package:qbpanel/home/ui/sheet/torrent_sort_sheet.dart';
import 'package:qbpanel/home/ui/torrent_item.dart';
import 'package:qbpanel/router/router_path.dart';
import 'package:qbpanel/widget/dialog/confirm_dialog.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';
import 'package:qbpanel/widget/refresh/paged_refresh_list.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  void _showServerStateSheet() {
    ServerStateSheet.show(context);
  }

  Future<void> _confirmStartDisplayed() {
    return _confirmBatchAction(
      title: '一键开始',
      messagePrefix: '开始',
      confirmText: '开始',
      loadingMessage: '开始中…',
      failLabel: '一键开始失败',
      successLabel: '已开始',
      action: () => ref.read(homePageProvider.notifier).startDisplayedTorrents(),
    );
  }

  Future<void> _confirmStopDisplayed() {
    return _confirmBatchAction(
      title: '一键停止',
      messagePrefix: '停止',
      confirmText: '停止',
      loadingMessage: '停止中…',
      failLabel: '一键停止失败',
      successLabel: '已停止',
      destructive: true,
      action: () => ref.read(homePageProvider.notifier).stopDisplayedTorrents(),
    );
  }

  Future<void> _confirmBatchAction({
    required String title,
    required String messagePrefix,
    required String confirmText,
    required String loadingMessage,
    required String failLabel,
    required String successLabel,
    required Future<String?> Function() action,
    bool destructive = false,
  }) async {
    final count = ref.read(homePageProvider).pageListState.items.length;
    if (count == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('当前列表没有种子')),
      );
      return;
    }
    final confirmed = await ConfirmDialog.show(
      context,
      title: title,
      message: '确定$messagePrefix当前列表中的 $count 个种子？',
      confirmText: confirmText,
      destructive: destructive,
    );
    if (confirmed != true || !mounted) return;
    LoadingDialog.show(context, message: loadingMessage);
    final error = await action();
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error == null ? '$successLabel $count 个种子' : '$failLabel：$error'),
      ),
    );
  }

  Future<void> _toggleAltSpeed() async {
    final wasOn =
        ref.read(homePageProvider).serverState?.useAltSpeedLimits == true;
    final error =
        await ref.read(homePageProvider.notifier).toggleAltSpeedLimits();
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('切换备用速度限制失败：$error')),
      );
      return;
    }
    final nowOn =
        ref.read(homePageProvider).serverState?.useAltSpeedLimits == true;
    if (wasOn == nowOn) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(nowOn ? '已开启备用速度限制' : '已关闭备用速度限制'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(homePageProvider);
    final vm = ref.read(homePageProvider.notifier);

    final filteredEmpty = ui.activeServer != null &&
        ui.hasTorrents &&
        (ui.statusFilter != TorrentStatusFilter.all ||
            !ui.categoryFilter.isAll ||
            !ui.tagFilter.isAll) &&
        ui.pageListState.isEmpty &&
        !ui.pageListState.error;

    final filtering = ui.statusFilter != TorrentStatusFilter.all ||
        !ui.categoryFilter.isAll ||
        !ui.tagFilter.isAll;
    final sorting = ui.sortKey != TorrentSortKey.state || !ui.sortAscending;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: ui.activeServer == null ? const Text('qBPanel')
            : _AppBarTitle(name: ui.activeServer!.name),
        actions: [
          if (ui.activeServer != null) ...[
            IconButton(
              tooltip: filtering ? '筛选中' : '筛选',
              icon: Icon(
                filtering ? Icons.filter_alt_outlined : Icons.filter_alt_off_outlined,
                color: filtering ? scheme.primary : null,
              ),
              onPressed: () => TorrentFilterSheet.show(context),
            ),
            IconButton(
              tooltip: sorting ? '排序中' : '排序',
              icon: Icon(
                sorting ? Icons.sort : Icons.filter_list_off_outlined,
                color: sorting ? scheme.primary : null,
              ),
              onPressed: () => TorrentSortSheet.show(context),
            ),
          ],
          PopupMenuButton<_HomeMoreAction>(
            tooltip: '更多',
            icon: const Icon(Icons.more_vert),
            onSelected: (action) {
              switch (action) {
                case _HomeMoreAction.startAll:
                  _confirmStartDisplayed();
                case _HomeMoreAction.stopAll:
                  _confirmStopDisplayed();
                case _HomeMoreAction.settings:
                  context.push(RouterPath.settings);
              }
            },
            itemBuilder: (context) => [
              if (ui.activeServer != null) ...[
                const PopupMenuItem(
                  value: _HomeMoreAction.startAll,
                  child: ListTile(
                    leading: Icon(Icons.play_arrow_rounded),
                    title: Text('一键开始'),
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const PopupMenuItem(
                  value: _HomeMoreAction.stopAll,
                  child: ListTile(
                    leading: Icon(Icons.stop_rounded),
                    title: Text('一键停止'),
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const PopupMenuDivider(),
              ],
              const PopupMenuItem(
                value: _HomeMoreAction.settings,
                child: ListTile(
                  leading: Icon(Icons.settings_outlined),
                  title: Text('设置'),
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: ui.activeServer == null
          ? null
          : FloatingActionButton(
              heroTag: 'addTorrent',
              tooltip: '添加种子',
              onPressed: () => context.push(RouterPath.addTorrent),
              child: const Icon(Icons.add),
            ),
      bottomNavigationBar: ui.activeServer == null || ui.serverState == null
          ? null
          : HomeBottomBar(
              serverState: ui.serverState!,
              onTap: _showServerStateSheet,
              onAltSpeedPressed: _toggleAltSpeed,
            ),
      body: PagedRefreshList<TorrentInfoResponse>(
        state: ui.pageListState,
        enableLoadMore: false,
        enableRefresh: ui.activeServer != null,
        padding: EdgeInsets.fromLTRB(
          0,
          8,
          0,
          ui.activeServer == null ? 8 : 88,
        ),
        onRefresh: vm.refresh,
        emptyTitle: ui.activeServer == null
            ? '还没有活跃的服务器'
            : (filteredEmpty ? '没有符合条件的种子' : '暂无种子'),
        emptySubtitle: ui.activeServer == null ? '去服务器列表添加或点选一台' : null,
        emptyIcon: ui.activeServer == null
            ? Icons.dns_outlined
            : (filteredEmpty ? Icons.filter_alt_outlined : null),
        emptyActionText: ui.activeServer == null
            ? '去选择服务器'
            : (filteredEmpty ? '清除筛选' : null),
        onEmptyAction: ui.activeServer == null
            ? () async {
                await context.push(RouterPath.serverList);
              }
            : (filteredEmpty
                ? () => vm.clearFilters()
                : null),
        itemBuilder: (context, index, torrent) {
          return TorrentItem(
            key: ValueKey(torrent.hash ?? index),
            torrent: torrent,
            queueing: ui.serverState?.queueing == true,
            onTap: () {
              final hash = torrent.hash;
              if (hash == null || hash.isEmpty) return;
              context.push(RouterPath.torrentDetailWithParams(hash));
            },
            onLongPress: () {
              TorrentActionSheet.show(context, torrent: torrent);
            },
          );
        },
      ),
    );
  }
}

enum _HomeMoreAction { startAll, stopAll, settings }

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ServerSwitchSheet.show(context),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.expand_more),
          ],
        ),
      ),
    );
  }
}
