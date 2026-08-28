import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:qbpanel/api/entity/response/torrent_info_response.dart';
import 'package:qbpanel/home/home_page_view_model.dart';
import 'package:qbpanel/home/entity/torrent_action.dart';
import 'package:qbpanel/home/ui/dialog/torrent_location_dialog.dart';
import 'package:qbpanel/widget/dialog/rename_dialog.dart';
import 'package:qbpanel/home/ui/sheet/actions/torrent_action_tile.dart';
import 'package:qbpanel/home/ui/sheet/actions/torrent_category_page.dart';
import 'package:qbpanel/home/ui/sheet/actions/torrent_copy_page.dart';
import 'package:qbpanel/home/ui/sheet/actions/torrent_queue_page.dart';
import 'package:qbpanel/home/ui/sheet/actions/torrent_share_limit_page.dart';
import 'package:qbpanel/home/ui/sheet/actions/torrent_speed_limit_page.dart';
import 'package:qbpanel/home/ui/sheet/actions/torrent_tags_page.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/dialog/confirm_dialog.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';
import 'package:qbpanel/widget/check_row.dart';
import 'package:qbpanel/widget/sheet/blur_modal_bottom_sheet.dart';

class TorrentActionSheet extends ConsumerStatefulWidget {
  const TorrentActionSheet({
    super.key,
    required this.hash,
    required this.pageContext,
  });

  final String hash;
  final BuildContext pageContext;

  static Future<void> show(
    BuildContext context, {
    required TorrentInfoResponse torrent,
  }) {
    final hash = torrent.hash?.trim() ?? '';
    if (hash.isEmpty) return Future.value();
    HapticFeedback.mediumImpact();
    return showBlurModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => TorrentActionSheet(
        hash: hash,
        pageContext: context,
      ),
    );
  }

  @override
  ConsumerState<TorrentActionSheet> createState() => _TorrentActionSheetState();
}

class _TorrentActionSheetState extends ConsumerState<TorrentActionSheet>
    with SingleTickerProviderStateMixin {
  static const _slideDuration = Duration(milliseconds: 280);

  late final AnimationController _slideController;
  late final Animation<Offset> _mainSlide;
  late final Animation<Offset> _subSlide;
  late final ScrollController _scrollController;
  _SubPage _subPage = _SubPage.none;

  bool get _subOpen => _subPage != _SubPage.none;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _slideController = AnimationController(
      vsync: this,
      duration: _slideDuration,
    );
    final curved = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _mainSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1, 0),
    ).animate(curved);
    _subSlide = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(curved);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _openSub(_SubPage page) {
    setState(() => _subPage = page);
    _slideController.forward();
  }

  void _closeSub() {
    _slideController.reverse().whenComplete(() {
      if (!mounted) return;
      setState(() => _subPage = _SubPage.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(homePageProvider);
    final torrent =
        ref.read(homePageProvider.notifier).torrentByHash(widget.hash);
    if (torrent == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) Navigator.pop(context);
      });
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;
    final availability = TorrentActionAvailability.of(torrent);
    final copyItems = torrentCopyItems(torrent, l10n);
    final queueing = ref.read(homePageProvider).serverState?.queueing == true;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.7;
    final vm = ref.read(homePageProvider.notifier);

    return PopScope(
      canPop: !_subOpen,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _closeSub();
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ClipRect(
            child: Stack(
              children: [
                SlideTransition(
                  position: _mainSlide,
                  child: IgnorePointer(
                    ignoring: _subOpen,
                    child: _buildMainPage(
                      context,
                      torrent: torrent,
                      availability: availability,
                      showCopy: copyItems.isNotEmpty,
                      queueing: queueing,
                      vm: vm,
                    ),
                  ),
                ),
                SlideTransition(
                  position: _subSlide,
                  child: IgnorePointer(
                    ignoring: !_subOpen,
                    child: switch (_subPage) {
                      _SubPage.copy => TorrentCopyPage(
                        items: copyItems,
                        pageContext: widget.pageContext,
                        onBack: _closeSub,
                      ),
                      _SubPage.speedLimit => TorrentSpeedLimitPage(
                        hash: widget.hash,
                        torrent: torrent,
                        pageContext: widget.pageContext,
                        onBack: _closeSub,
                      ),
                      _SubPage.shareLimit => TorrentShareLimitPage(
                        hash: widget.hash,
                        torrent: torrent,
                        pageContext: widget.pageContext,
                        onBack: _closeSub,
                      ),
                      _SubPage.tags => TorrentTagsPage(
                        hash: widget.hash,
                        pageContext: widget.pageContext,
                        onBack: _closeSub,
                      ),
                      _SubPage.category => TorrentCategoryPage(
                        hash: widget.hash,
                        pageContext: widget.pageContext,
                        onBack: _closeSub,
                      ),
                      _SubPage.queue => TorrentQueuePage(
                        position: torrent.priority,
                        onBack: _closeSub,
                        onTop: () => _run(
                          action: () => vm.moveTorrentQueueTop(widget.hash),
                          failLabel: l10n.queueTopFailed,
                        ),
                        onUp: () => _run(
                          action: () => vm.moveTorrentQueueUp(widget.hash),
                          failLabel: l10n.queueUpFailed,
                        ),
                        onDown: () => _run(
                          action: () => vm.moveTorrentQueueDown(widget.hash),
                          failLabel: l10n.queueDownFailed,
                        ),
                        onBottom: () => _run(
                          action: () => vm.moveTorrentQueueBottom(widget.hash),
                          failLabel: l10n.queueBottomFailed,
                        ),
                      ),
                      _SubPage.none => const SizedBox.shrink(),
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainPage(
    BuildContext context, {
    required TorrentInfoResponse torrent,
    required TorrentActionAvailability availability,
    required bool showCopy,
    required bool queueing,
    required HomePageViewModel vm,
  }) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            torrent.name ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium,
          ),
        ),
        Flexible(
          child: Scrollbar(
            controller: _scrollController,
            child: ListView(
              controller: _scrollController,
              shrinkWrap: true,
              children: [
              if (availability.showStart)
                TorrentActionTile(
                  icon: Icons.play_arrow_rounded,
                  label: l10n.homeStart,
                  onTap: () => _run(
                    action: () => vm.startTorrent(widget.hash),
                    failLabel: l10n.actionStartFailed,
                  ),
                ),
              if (availability.showStop)
                TorrentActionTile(
                  icon: Icons.stop_rounded,
                  label: l10n.homeStop,
                  onTap: () => _run(
                    action: () => vm.stopTorrent(widget.hash),
                    failLabel: l10n.actionStopFailed,
                  ),
                ),
              if (availability.showForceStart)
                TorrentActionTile(
                  icon: Icons.fast_forward_rounded,
                  label: l10n.actionForceStart,
                  onTap: () => _run(
                    action: () => vm.forceStartTorrent(widget.hash),
                    failLabel: l10n.actionForceStartFailed,
                  ),
                ),
              const Divider(height: 8),
              TorrentActionTile(
                icon: Icons.delete_outline,
                label: l10n.actionDelete,
                foreground: scheme.error,
                onTap: () => _confirmDelete(
                  name: torrent.name ?? '',
                  vm: vm,
                ),
              ),
              const Divider(height: 8),
              TorrentActionTile(
                icon: Icons.folder_outlined,
                label: l10n.setSaveLocation,
                onTap: () => _setLocation(torrent, vm),
              ),
              TorrentActionTile(
                icon: Icons.drive_file_rename_outline,
                label: l10n.renameTitle,
                onTap: () => _rename(torrent, vm),
              ),
              TorrentActionTile(
                icon: Icons.category_outlined,
                label: l10n.category,
                trailing: Icon(
                  Icons.chevron_right,
                  size: 22,
                  color: scheme.onSurfaceVariant,
                ),
                onTap: () => _openSub(_SubPage.category),
              ),
              TorrentActionTile(
                icon: Icons.label_outlined,
                label: l10n.tags,
                trailing: Icon(
                  Icons.chevron_right,
                  size: 22,
                  color: scheme.onSurfaceVariant,
                ),
                onTap: () => _openSub(_SubPage.tags),
              ),
              TorrentActionTile(
                icon: Icons.auto_mode_outlined,
                label: l10n.autoTmm,
                trailing: torrent.autoTmm == true
                    ? Icon(Icons.check, size: 22, color: scheme.primary)
                    : null,
                onTap: () => _toggleAutoTmm(
                  enabled: torrent.autoTmm == true,
                  vm: vm,
                ),
              ),
              const Divider(height: 8),
              TorrentActionTile(
                icon: Icons.speed,
                label: availability.isCompleted
                    ? l10n.uploadLimit
                    : l10n.uploadDownloadLimit,
                trailing: Icon(
                  Icons.chevron_right,
                  size: 22,
                  color: scheme.onSurfaceVariant,
                ),
                onTap: () => _openSub(_SubPage.speedLimit),
              ),
              TorrentActionTile(
                icon: Icons.percent,
                label: l10n.shareLimit,
                trailing: Icon(
                  Icons.chevron_right,
                  size: 22,
                  color: scheme.onSurfaceVariant,
                ),
                onTap: () => _openSub(_SubPage.shareLimit),
              ),
              if (availability.showSuperSeeding)
                TorrentActionTile(
                  icon: Icons.hub_outlined,
                  label: l10n.superSeeding,
                  trailing: torrent.superSeeding == true
                      ? Icon(Icons.check, size: 22, color: scheme.primary)
                      : null,
                  onTap: () => _toggleSuperSeeding(
                    enabled: torrent.superSeeding == true,
                    vm: vm,
                  ),
                ),
              if (!availability.isCompleted) ...[
                TorrentActionTile(
                  icon: Icons.format_list_numbered,
                  label: l10n.sequentialDownload,
                  trailing: torrent.seqDl == true
                      ? Icon(Icons.check, size: 22, color: scheme.primary)
                      : null,
                  onTap: () => _run(
                    action: () => vm.toggleTorrentSequentialDownload(widget.hash),
                    failLabel: l10n.sequentialFailed,
                  ),
                ),
                TorrentActionTile(
                  icon: Icons.vertical_align_center,
                  label: l10n.firstLastPiece,
                  trailing: torrent.fLPiecePrio == true
                      ? Icon(Icons.check, size: 22, color: scheme.primary)
                      : null,
                  onTap: () => _run(
                    action: () =>
                        vm.toggleTorrentFirstLastPiecePrio(widget.hash),
                    failLabel: l10n.firstLastFailed,
                  ),
                ),
              ],
              const Divider(height: 8),
              TorrentActionTile(
                icon: Icons.verified_outlined,
                label: l10n.forceRecheck,
                onTap: () => _run(
                  action: () => vm.recheckTorrent(widget.hash),
                  failLabel: l10n.recheckFailed,
                ),
              ),
              TorrentActionTile(
                icon: Icons.campaign_outlined,
                label: l10n.forceReannounce,
                enabled: availability.canReannounce,
                onTap: availability.canReannounce
                    ? () => _run(
                        action: () => vm.reannounceTorrent(widget.hash),
                        failLabel: l10n.reannounceFailed,
                      )
                    : null,
              ),
              const Divider(height: 8),
              if (queueing)
                TorrentActionTile(
                  icon: Icons.low_priority,
                  label: l10n.queue,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (torrent.priority != null && torrent.priority! > 0)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            '#${torrent.priority}',
                            style: textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      Icon(
                        Icons.chevron_right,
                        size: 22,
                        color: scheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                  onTap: () => _openSub(_SubPage.queue),
                ),
              if (showCopy)
                TorrentActionTile(
                  icon: Icons.copy_outlined,
                  label: l10n.copy,
                  trailing: Icon(
                    Icons.chevron_right,
                    size: 22,
                    color: scheme.onSurfaceVariant,
                  ),
                  onTap: () => _openSub(_SubPage.copy),
                ),
              TorrentActionTile(
                icon: Icons.share_outlined,
                label: l10n.shareTorrent,
                enabled: torrent.hasMetadata != false,
                onTap: torrent.hasMetadata != false
                    ? () => _exportTorrent(torrent, vm)
                    : null,
              ),
            ],
            ),
          ),
        ),
      ],
    );
  }

  void _run({
    required Future<String?> Function() action,
    required String failLabel,
    bool loading = false,
    String? loadingMessage,
  }) {
    final l10n = widget.pageContext.l10n;
    final sheetContext = context;
    Navigator.pop(sheetContext);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!widget.pageContext.mounted) return;
      if (loading) {
        LoadingDialog.show(
          widget.pageContext,
          message: loadingMessage ?? l10n.processing,
        );
      }
      final error = await action();
      if (!widget.pageContext.mounted) return;
      if (loading) LoadingDialog.dismiss(widget.pageContext);
      if (error == null) return;
      ScaffoldMessenger.of(widget.pageContext).showSnackBar(
        SnackBar(content: Text(l10n.errorWithDetail(failLabel, error))),
      );
    });
  }

  void _exportTorrent(TorrentInfoResponse torrent, HomePageViewModel vm) {
    final l10n = widget.pageContext.l10n;
    Navigator.pop(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!widget.pageContext.mounted) return;
      LoadingDialog.show(widget.pageContext, message: l10n.preparingShare);
      final result = await vm.exportTorrentFile(
        widget.hash,
        name: torrent.name,
      );
      if (!widget.pageContext.mounted) return;
      LoadingDialog.dismiss(widget.pageContext);
      if (result.error != null) {
        ScaffoldMessenger.of(widget.pageContext).showSnackBar(
          SnackBar(content: Text(l10n.shareFailed(result.error!))),
        );
        return;
      }
      final filePath = result.filePath;
      final fileName = result.fileName;
      if (filePath == null || fileName == null) return;
      try {
        await SharePlus.instance.share(
          ShareParams(
            files: [
              XFile(
                filePath,
                mimeType: 'application/x-bittorrent',
                name: fileName,
              ),
            ],
            fileNameOverrides: [fileName],
          ),
        );
      } catch (e) {
        if (!widget.pageContext.mounted) return;
        ScaffoldMessenger.of(widget.pageContext).showSnackBar(
          SnackBar(content: Text(l10n.shareFailed('$e'))),
        );
      }
    });
  }

  void _rename(TorrentInfoResponse torrent, HomePageViewModel vm) {
    final l10n = widget.pageContext.l10n;
    final currentName = torrent.name ?? '';
    Navigator.pop(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.pageContext.mounted) return;
      RenameDialog.show(
        context: widget.pageContext,
        initialName: currentName,
        labelText: l10n.sortName,
        description: l10n.renameTorrentHint,
        onSubmit: (name) => vm.renameTorrent(widget.hash, name),
      );
    });
  }

  void _setLocation(TorrentInfoResponse torrent, HomePageViewModel vm) {
    final autoTmm = torrent.autoTmm == true;
    final currentPath = torrent.savePath ?? '';
    Navigator.pop(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!widget.pageContext.mounted) return;
      final location = await TorrentLocationDialog.show(
        widget.pageContext,
        initialPath: currentPath,
        autoTmm: autoTmm,
      );
      if (location == null || !widget.pageContext.mounted) return;
      if (location == currentPath.trim() && !autoTmm) return;
      final l10n = widget.pageContext.l10n;
      LoadingDialog.show(widget.pageContext, message: l10n.settingInProgress);
      final error = await vm.setTorrentLocation(widget.hash, location);
      if (!widget.pageContext.mounted) return;
      LoadingDialog.dismiss(widget.pageContext);
      if (error == null) return;
      ScaffoldMessenger.of(widget.pageContext).showSnackBar(
        SnackBar(content: Text(l10n.setLocationFailed(error))),
      );
    });
  }

  void _toggleAutoTmm({
    required bool enabled,
    required HomePageViewModel vm,
  }) {
    final l10n = widget.pageContext.l10n;
    Navigator.pop(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!widget.pageContext.mounted) return;
      if (!enabled) {
        final confirmed = await ConfirmDialog.show(
          widget.pageContext,
          title: l10n.enableAutoTmmTitle,
          message: l10n.enableAutoTmmMessage,
          confirmText: l10n.actionEnable,
        );
        if (confirmed != true || !widget.pageContext.mounted) return;
      }
      final enable = !enabled;
      LoadingDialog.show(
        widget.pageContext,
        message: enable ? l10n.enabling : l10n.disabling,
      );
      final error = await vm.setTorrentAutoTmm(widget.hash, enable: enable);
      if (!widget.pageContext.mounted) return;
      LoadingDialog.dismiss(widget.pageContext);
      if (error == null) return;
      ScaffoldMessenger.of(widget.pageContext).showSnackBar(
        SnackBar(
          content: Text(
            l10n.autoTmmFailed(
              enable ? l10n.actionEnable : l10n.actionDisable,
              error,
            ),
          ),
        ),
      );
    });
  }

  void _toggleSuperSeeding({
    required bool enabled,
    required HomePageViewModel vm,
  }) {
    final l10n = widget.pageContext.l10n;
    Navigator.pop(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!widget.pageContext.mounted) return;
      final enable = !enabled;
      LoadingDialog.show(
        widget.pageContext,
        message: enable ? l10n.enabling : l10n.disabling,
      );
      final error = await vm.setTorrentSuperSeeding(
        widget.hash,
        enable: enable,
      );
      if (!widget.pageContext.mounted) return;
      LoadingDialog.dismiss(widget.pageContext);
      if (error == null) return;
      ScaffoldMessenger.of(widget.pageContext).showSnackBar(
        SnackBar(
          content: Text(
            l10n.superSeedingFailed(
              enable ? l10n.actionEnable : l10n.actionDisable,
              error,
            ),
          ),
        ),
      );
    });
  }

  void _confirmDelete({
    required String name,
    required HomePageViewModel vm,
  }) {
    final l10n = widget.pageContext.l10n;
    final sheetContext = context;
    Navigator.pop(sheetContext);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!widget.pageContext.mounted) return;
      var deleteFiles = false;
      final confirmed = await ConfirmDialog.show(
        widget.pageContext,
        title: l10n.deleteTorrentTitle,
        confirmText: l10n.actionDelete,
        destructive: true,
        content: StatefulBuilder(
          builder: (context, setState) {
            final scheme = Theme.of(context).colorScheme;
            final textTheme = Theme.of(context).textTheme;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  name.isEmpty
                      ? l10n.confirmDeleteTorrent
                      : l10n.confirmDeleteTorrentNamed(name),
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                CheckRow(
                  label: l10n.deleteFilesToo,
                  value: deleteFiles,
                  onChanged: (value) {
                    setState(() => deleteFiles = value);
                  },
                ),
              ],
            );
          },
        ),
      );
      if (confirmed != true || !widget.pageContext.mounted) return;
      LoadingDialog.show(widget.pageContext, message: l10n.deleting);
      final error = await vm.deleteTorrent(
        widget.hash,
        deleteFiles: deleteFiles,
      );
      if (!widget.pageContext.mounted) return;
      LoadingDialog.dismiss(widget.pageContext);
      if (error == null) return;
      ScaffoldMessenger.of(widget.pageContext).showSnackBar(
        SnackBar(content: Text(l10n.deleteFailed(error))),
      );
    });
  }
}

enum _SubPage { none, copy, speedLimit, shareLimit, tags, category, queue }
