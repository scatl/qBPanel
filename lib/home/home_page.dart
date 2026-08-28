import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qbpanel/api/entity/response/torrent_info_response.dart';
import 'package:qbpanel/home/home_page_view_model.dart';
import 'package:qbpanel/home/entity/torrent_sort.dart';
import 'package:qbpanel/home/entity/torrent_status_filter.dart';
import 'package:qbpanel/home/ui/dialog/global_speed_limit_dialog.dart';
import 'package:qbpanel/home/ui/home_bottom_bar.dart';
import 'package:qbpanel/home/ui/sheet/server_state_sheet.dart';
import 'package:qbpanel/home/ui/sheet/server_switch_sheet.dart';
import 'package:qbpanel/home/ui/sheet/actions/torrent_action_sheet.dart';
import 'package:qbpanel/home/ui/sheet/torrent_filter_sheet.dart';
import 'package:qbpanel/home/ui/sheet/torrent_sort_sheet.dart';
import 'package:qbpanel/home/ui/torrent_item.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
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

  Future<void> _showGlobalSpeedLimitDialog() async {
    final serverState = ref.read(homePageProvider).serverState;
    if (serverState == null) return;
    final saved = await GlobalSpeedLimitDialog.show(
      context: context,
      useAltSpeedLimits: serverState.useAltSpeedLimits == true,
      initialDownloadBytesPerSec: serverState.dlRateLimit,
      initialUploadBytesPerSec: serverState.upRateLimit,
      onSubmit: ({
        required int downloadBytesPerSec,
        required int uploadBytesPerSec,
      }) {
        return ref.read(homePageProvider.notifier).setGlobalSpeedLimits(
              downloadBytesPerSec: downloadBytesPerSec,
              uploadBytesPerSec: uploadBytesPerSec,
            );
      },
    );
    if (!mounted || !saved) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          serverState.useAltSpeedLimits == true
              ? context.l10n.homeSavedAltSpeed
              : context.l10n.homeSavedGlobalSpeed,
        ),
      ),
    );
  }

  Future<void> _confirmStartDisplayed() {
    final l10n = context.l10n;
    return _confirmBatchAction(
      title: l10n.homeStartAll,
      messagePrefix: l10n.homeStart,
      confirmText: l10n.homeStart,
      loadingMessage: l10n.homeStarting,
      failLabel: l10n.homeStartAllFailed,
      started: true,
      action: () => ref.read(homePageProvider.notifier).startDisplayedTorrents(),
    );
  }

  Future<void> _confirmStopDisplayed() {
    final l10n = context.l10n;
    return _confirmBatchAction(
      title: l10n.homeStopAll,
      messagePrefix: l10n.homeStop,
      confirmText: l10n.homeStop,
      loadingMessage: l10n.homeStopping,
      failLabel: l10n.homeStopAllFailed,
      started: false,
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
    required bool started,
    required Future<String?> Function() action,
    bool destructive = false,
  }) async {
    final l10n = context.l10n;
    final count = ref.read(homePageProvider).pageListState.items.length;
    if (count == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.homeNoTorrentsInList)),
      );
      return;
    }
    final confirmed = await ConfirmDialog.show(
      context,
      title: title,
      message: l10n.homeConfirmBatch(messagePrefix, count),
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
        content: Text(
          error == null
              ? (started
                  ? l10n.homeBatchStarted(count)
                  : l10n.homeBatchStopped(count))
              : l10n.homeBatchFailed(failLabel, error),
        ),
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
        SnackBar(content: Text(context.l10n.homeAltSpeedToggleFailed(error))),
      );
      return;
    }
    final nowOn =
        ref.read(homePageProvider).serverState?.useAltSpeedLimits == true;
    if (wasOn == nowOn) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(nowOn ? context.l10n.homeAltSpeedOn : context.l10n.homeAltSpeedOff),
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
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: ui.activeServer == null ? Text(l10n.appTitle)
            : _AppBarTitle(name: ui.activeServer!.name),
        actions: [
          if (ui.activeServer != null) ...[
            IconButton(
              tooltip: filtering ? l10n.homeFiltering : l10n.homeFilter,
              icon: Icon(
                filtering ? Icons.filter_alt_outlined : Icons.filter_alt_off_outlined,
                color: filtering ? scheme.primary : null,
              ),
              onPressed: () => TorrentFilterSheet.show(context),
            ),
            IconButton(
              tooltip: sorting ? l10n.homeSorting : l10n.homeSort,
              icon: Icon(
                sorting ? Icons.sort : Icons.filter_list_off_outlined,
                color: sorting ? scheme.primary : null,
              ),
              onPressed: () => TorrentSortSheet.show(context),
            ),
          ],
          PopupMenuButton<_HomeMoreAction>(
            tooltip: l10n.actionMore,
            icon: const Icon(Icons.more_vert),
            onSelected: (action) {
              switch (action) {
                case _HomeMoreAction.startAll:
                  _confirmStartDisplayed();
                case _HomeMoreAction.stopAll:
                  _confirmStopDisplayed();
                case _HomeMoreAction.logs:
                  context.push(RouterPath.log);
                case _HomeMoreAction.search:
                  context.push(RouterPath.search);
                case _HomeMoreAction.settings:
                  context.push(RouterPath.settings);
              }
            },
            itemBuilder: (context) {
              final menuL10n = context.l10n;
              return [
              if (ui.activeServer != null) ...[
                PopupMenuItem(
                  value: _HomeMoreAction.startAll,
                  child: ListTile(
                    leading: const Icon(Icons.play_arrow_rounded),
                    title: Text(menuL10n.homeStartAll),
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                PopupMenuItem(
                  value: _HomeMoreAction.stopAll,
                  child: ListTile(
                    leading: const Icon(Icons.stop_rounded),
                    title: Text(menuL10n.homeStopAll),
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: _HomeMoreAction.search,
                  child: ListTile(
                    leading: const Icon(Icons.travel_explore_outlined),
                    title: Text(menuL10n.homeSearchTorrents),
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                PopupMenuItem(
                  value: _HomeMoreAction.logs,
                  child: ListTile(
                    leading: const Icon(Icons.receipt_long_outlined),
                    title: Text(menuL10n.homeLogs),
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
              PopupMenuItem(
                value: _HomeMoreAction.settings,
                child: ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: Text(menuL10n.homeSettings),
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ];
            },
          ),
        ],
      ),
      floatingActionButton: ui.activeServer == null
          ? null
          : FloatingActionButton(
              heroTag: 'addTorrent',
              tooltip: l10n.homeAddTorrent,
              onPressed: () => context.push(RouterPath.addTorrent),
              child: const Icon(Icons.add),
            ),
      bottomNavigationBar: ui.activeServer == null || ui.serverState == null
          ? null
          : HomeBottomBar(
              serverState: ui.serverState!,
              onStatusTap: _showServerStateSheet,
              onSpeedTap: _showGlobalSpeedLimitDialog,
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
            ? l10n.homeNoActiveServer
            : (filteredEmpty ? l10n.homeNoMatchingTorrents : l10n.homeNoTorrents),
        emptySubtitle: ui.activeServer == null ? l10n.homeNoActiveServerHint : null,
        emptyIcon: ui.activeServer == null
            ? Icons.dns_outlined
            : (filteredEmpty ? Icons.filter_alt_outlined : null),
        emptyActionText: ui.activeServer == null
            ? l10n.homeChooseServer
            : (filteredEmpty ? l10n.homeClearFilters : null),
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

enum _HomeMoreAction { startAll, stopAll, search, logs, settings }

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
