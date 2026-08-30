import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qbpanel/api/entity/response/torrent_info_response.dart';
import 'package:qbpanel/home/home_page_view_model.dart';
import 'package:qbpanel/home/entity/torrent_sort.dart';
import 'package:qbpanel/home/entity/torrent_status_filter.dart';
import 'package:qbpanel/home/list_density.dart';
import 'package:qbpanel/home/ui/dialog/global_speed_limit_dialog.dart';
import 'package:qbpanel/home/ui/home_bottom_bar.dart';
import 'package:qbpanel/home/ui/sheet/server_state_sheet.dart';
import 'package:qbpanel/home/ui/sheet/server_switch_sheet.dart';
import 'package:qbpanel/home/ui/sheet/actions/torrent_action_sheet.dart';
import 'package:qbpanel/home/ui/sheet/torrent_filter_sheet.dart';
import 'package:qbpanel/home/ui/torrent_item.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/router/router_path.dart';
import 'package:qbpanel/widget/dialog/confirm_dialog.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';
import 'package:qbpanel/widget/page_insets.dart';
import 'package:qbpanel/widget/refresh/paged_refresh_list.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  static const _searchAnimDuration = Duration(milliseconds: 260);

  /// 与 M3 AppBar 默认 `scrolledUnderElevation` 对齐，搜索框叠同样 tint。
  static const _appBarScrolledUnderElevation = 3.0;

  late final AnimationController _searchAnim;
  late final Animation<double> _searchProgress;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  bool _searchActive = false;
  bool _appBarScrolledUnder = false;

  @override
  void initState() {
    super.initState();
    _searchAnim = AnimationController(
      vsync: this,
      duration: _searchAnimDuration,
    );
    _searchProgress = CurvedAnimation(
      parent: _searchAnim,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _searchAnim.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _openSearch() async {
    if (_searchActive) return;
    setState(() => _searchActive = true);
    await _searchAnim.forward(from: 0);
    if (!mounted) return;
    _searchFocusNode.requestFocus();
  }

  Future<void> _closeSearch() async {
    _searchFocusNode.unfocus();
    await _searchAnim.reverse();
    if (!mounted) return;
    _searchController.clear();
    ref.read(homePageProvider.notifier).clearSearchQuery();
    setState(() => _searchActive = false);
  }

  void _onSearchChanged(String value) {
    ref.read(homePageProvider.notifier).setSearchQuery(value);
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;
    final scrolled = notification.metrics.pixels > 0.5;
    if (scrolled != _appBarScrolledUnder) {
      setState(() => _appBarScrolledUnder = scrolled);
    }
    return false;
  }

  void _clearListConstraints() {
    final vm = ref.read(homePageProvider.notifier);
    final ui = ref.read(homePageProvider);
    if (ui.searchQuery.trim().isNotEmpty) {
      _searchController.clear();
      vm.clearSearchQuery();
    }
    vm.clearFilters();
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
      onSubmit:
          ({required int downloadBytesPerSec, required int uploadBytesPerSec}) {
            return ref
                .read(homePageProvider.notifier)
                .setGlobalSpeedLimits(
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
      action: () =>
          ref.read(homePageProvider.notifier).startDisplayedTorrents(),
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.homeNoTorrentsInList)));
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
    final error = await ref
        .read(homePageProvider.notifier)
        .toggleAltSpeedLimits();
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
        content: Text(
          nowOn ? context.l10n.homeAltSpeedOn : context.l10n.homeAltSpeedOff,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(homePageProvider);
    final vm = ref.read(homePageProvider.notifier);
    final compact = ref.watch(listDensityProvider) == ListDensity.compact;

    final searching = ui.searchQuery.trim().isNotEmpty;
    final filtering =
        ui.statusFilter != TorrentStatusFilter.all ||
        !ui.categoryFilter.isAll ||
        !ui.tagFilter.isAll;
    final sortActive = ui.sortKey != TorrentSortKey.state || !ui.sortAscending;
    final listConstrained = filtering || searching;
    final filteredEmpty =
        ui.activeServer != null &&
        ui.hasTorrents &&
        listConstrained &&
        ui.pageListState.isEmpty &&
        !ui.pageListState.error;
    final filterOrSortActive = filtering || sortActive;
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return AnimatedBuilder(
      animation: _searchProgress,
      builder: (context, body) {
        final t = _searchProgress.value;
        // 首页无 leading，左右边距都保持 PageInsets，避免搜索框贴左。
        final titleSpacing = PageInsets.horizontal;
        final actionsOpacity = (1 - t).clamp(0.0, 1.0);

        return Scaffold(
          appBar: AppBar(
            titleSpacing: titleSpacing,
            title: _HomeAppBarTitle(
              progress: _searchProgress,
              showSearchField: _searchActive,
              serverName: ui.activeServer?.name,
              controller: _searchController,
              focusNode: _searchFocusNode,
              onClose: _closeSearch,
              onChanged: _onSearchChanged,
              scrolledUnder: _appBarScrolledUnder,
              scrolledUnderElevation: _appBarScrolledUnderElevation,
            ),
            actions: [
              ClipRect(
                child: Align(
                  alignment: Alignment.centerRight,
                  widthFactor: actionsOpacity,
                  child: Opacity(
                    opacity: actionsOpacity,
                    child: IgnorePointer(
                      ignoring: t > 0.01,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (ui.activeServer != null) ...[
                            IconButton(
                              tooltip: l10n.actionSearch,
                              icon: const Icon(Icons.search),
                              onPressed: _openSearch,
                            ),
                            IconButton(
                              tooltip: filterOrSortActive
                                  ? l10n.homeFiltering
                                  : l10n.homeFilter,
                              icon: Icon(
                                Icons.filter_alt_outlined,
                                color: filterOrSortActive
                                    ? scheme.primary
                                    : null,
                              ),
                              onPressed: () => TorrentFilterSheet.show(context),
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
                                      leading: const Icon(
                                        Icons.play_arrow_rounded,
                                      ),
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
                                      leading: const Icon(
                                        Icons.travel_explore_outlined,
                                      ),
                                      title: Text(menuL10n.homeSearchTorrents),
                                      contentPadding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: _HomeMoreAction.logs,
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.receipt_long_outlined,
                                      ),
                                      title: Text(menuL10n.homeLogs),
                                      contentPadding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                ],
                                PopupMenuItem(
                                  value: _HomeMoreAction.settings,
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.settings_outlined,
                                    ),
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
                    ),
                  ),
                ),
              ),
              // 不要再加右侧 SizedBox：titleSpacing 已是 middle 左右各一份，
              // 再加会变成右边双倍边距。
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
          body: NotificationListener<ScrollNotification>(
            onNotification: _onScrollNotification,
            child: body!,
          ),
        );
      },
      child: PagedRefreshList<TorrentInfoResponse>(
        state: ui.pageListState,
        enableLoadMore: false,
        enableRefresh: ui.activeServer != null,
        padding: EdgeInsets.fromLTRB(0, 8, 0, ui.activeServer == null ? 8 : 88),
        onRefresh: vm.refresh,
        emptyTitle: ui.activeServer == null
            ? l10n.homeNoActiveServer
            : (filteredEmpty
                  ? l10n.homeNoMatchingTorrents
                  : l10n.homeNoTorrents),
        emptySubtitle: ui.activeServer == null
            ? l10n.homeNoActiveServerHint
            : null,
        emptyIcon: ui.activeServer == null
            ? Icons.dns_outlined
            : (filteredEmpty
                  ? (searching && !filtering
                        ? Icons.search_off_outlined
                        : Icons.filter_alt_outlined)
                  : null),
        emptyActionText: ui.activeServer == null
            ? l10n.homeChooseServer
            : (filteredEmpty
                  ? (searching && !filtering
                        ? l10n.homeClearSearch
                        : l10n.homeClearFilters)
                  : null),
        onEmptyAction: ui.activeServer == null
            ? () async {
                await context.push(RouterPath.serverList);
              }
            : (filteredEmpty
                  ? () {
                      if (searching && !filtering) {
                        _closeSearch();
                      } else {
                        _clearListConstraints();
                      }
                    }
                  : null),
        itemBuilder: (context, index, torrent) {
          return TorrentItem(
            key: ValueKey(torrent.hash ?? index),
            torrent: torrent,
            queueing: ui.serverState?.queueing == true,
            compact: compact,
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

class _HomeAppBarTitle extends StatelessWidget {
  const _HomeAppBarTitle({
    required this.progress,
    required this.showSearchField,
    required this.serverName,
    required this.controller,
    required this.focusNode,
    required this.onClose,
    required this.onChanged,
    required this.scrolledUnder,
    required this.scrolledUnderElevation,
  });

  final Animation<double> progress;
  final bool showSearchField;
  final String? serverName;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClose;
  final ValueChanged<String> onChanged;
  final bool scrolledUnder;
  final double scrolledUnderElevation;

  static const _fieldHeight = 40.0;
  static const _fieldRadius = 20.0;

  Color _searchFieldColor(ColorScheme scheme) {
    final base = scheme.surfaceContainerHighest;
    if (!scrolledUnder) return base;
    return ElevationOverlay.applySurfaceTint(
      base,
      scheme.surfaceTint,
      scrolledUnderElevation,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        final t = progress.value;
        final titleOpacity = (1 - t * 1.4).clamp(0.0, 1.0);
        final fieldOpacity = t.clamp(0.0, 1.0);
        final fieldScale = 0.94 + (0.06 * t);

        return SizedBox(
          height: _fieldHeight,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.centerLeft,
            clipBehavior: Clip.none,
            children: [
              Opacity(
                opacity: titleOpacity,
                child: serverName == null
                    ? Text(l10n.appTitle, style: textTheme.titleLarge)
                    : _ServerTitle(name: serverName!),
              ),
              if (showSearchField)
                Positioned.fill(
                  child: Opacity(
                    opacity: fieldOpacity,
                    child: Transform.scale(
                      scale: fieldScale,
                      alignment: Alignment.centerLeft,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOut,
                        decoration: BoxDecoration(
                          color: _searchFieldColor(scheme),
                          borderRadius: BorderRadius.circular(_fieldRadius),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: TextField(
                          controller: controller,
                          focusNode: focusNode,
                          style: textTheme.bodyMedium,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: false,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            hintText: l10n.searchTorrentsHint,
                            hintStyle: textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            suffixIcon: IconButton(
                              tooltip: l10n.closeSearch,
                              icon: Icon(
                                Icons.close,
                                size: 20,
                                color: scheme.onSurfaceVariant,
                              ),
                              onPressed: onClose,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          onChanged: onChanged,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ServerTitle extends StatelessWidget {
  const _ServerTitle({required this.name});

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
              child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            const Icon(Icons.expand_more),
          ],
        ),
      ),
    );
  }
}
