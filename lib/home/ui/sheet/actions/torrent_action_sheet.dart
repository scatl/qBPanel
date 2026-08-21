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

    final availability = TorrentActionAvailability.of(torrent);
    final copyItems = torrentCopyItems(torrent);
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
                          failLabel: '置顶失败',
                        ),
                        onUp: () => _run(
                          action: () => vm.moveTorrentQueueUp(widget.hash),
                          failLabel: '上移失败',
                        ),
                        onDown: () => _run(
                          action: () => vm.moveTorrentQueueDown(widget.hash),
                          failLabel: '下移失败',
                        ),
                        onBottom: () => _run(
                          action: () => vm.moveTorrentQueueBottom(widget.hash),
                          failLabel: '置底失败',
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
                  label: '开始',
                  onTap: () => _run(
                    action: () => vm.startTorrent(widget.hash),
                    failLabel: '开始失败',
                  ),
                ),
              if (availability.showStop)
                TorrentActionTile(
                  icon: Icons.stop_rounded,
                  label: '停止',
                  onTap: () => _run(
                    action: () => vm.stopTorrent(widget.hash),
                    failLabel: '停止失败',
                  ),
                ),
              if (availability.showForceStart)
                TorrentActionTile(
                  icon: Icons.fast_forward_rounded,
                  label: '强制启动',
                  onTap: () => _run(
                    action: () => vm.forceStartTorrent(widget.hash),
                    failLabel: '强制启动失败',
                  ),
                ),
              const Divider(height: 8),
              TorrentActionTile(
                icon: Icons.delete_outline,
                label: '删除',
                foreground: scheme.error,
                onTap: () => _confirmDelete(
                  name: torrent.name ?? '',
                  vm: vm,
                ),
              ),
              const Divider(height: 8),
              TorrentActionTile(
                icon: Icons.folder_outlined,
                label: '设置保存位置',
                onTap: () => _setLocation(torrent, vm),
              ),
              TorrentActionTile(
                icon: Icons.drive_file_rename_outline,
                label: '重命名',
                onTap: () => _rename(torrent, vm),
              ),
              TorrentActionTile(
                icon: Icons.category_outlined,
                label: '分类',
                trailing: Icon(
                  Icons.chevron_right,
                  size: 22,
                  color: scheme.onSurfaceVariant,
                ),
                onTap: () => _openSub(_SubPage.category),
              ),
              TorrentActionTile(
                icon: Icons.label_outlined,
                label: '标签',
                trailing: Icon(
                  Icons.chevron_right,
                  size: 22,
                  color: scheme.onSurfaceVariant,
                ),
                onTap: () => _openSub(_SubPage.tags),
              ),
              TorrentActionTile(
                icon: Icons.auto_mode_outlined,
                label: '自动种子管理',
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
                label: availability.isCompleted ? '上传限速' : '上传/下载限速',
                trailing: Icon(
                  Icons.chevron_right,
                  size: 22,
                  color: scheme.onSurfaceVariant,
                ),
                onTap: () => _openSub(_SubPage.speedLimit),
              ),
              TorrentActionTile(
                icon: Icons.percent,
                label: '分享率限制',
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
                  label: '超级做种模式',
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
                  label: '顺序下载',
                  trailing: torrent.seqDl == true
                      ? Icon(Icons.check, size: 22, color: scheme.primary)
                      : null,
                  onTap: () => _run(
                    action: () => vm.toggleTorrentSequentialDownload(widget.hash),
                    failLabel: '设置顺序下载失败',
                  ),
                ),
                TorrentActionTile(
                  icon: Icons.vertical_align_center,
                  label: '先下首尾块',
                  trailing: torrent.fLPiecePrio == true
                      ? Icon(Icons.check, size: 22, color: scheme.primary)
                      : null,
                  onTap: () => _run(
                    action: () =>
                        vm.toggleTorrentFirstLastPiecePrio(widget.hash),
                    failLabel: '设置先下首尾块失败',
                  ),
                ),
              ],
              const Divider(height: 8),
              TorrentActionTile(
                icon: Icons.verified_outlined,
                label: '强制重新校验',
                onTap: () => _run(
                  action: () => vm.recheckTorrent(widget.hash),
                  failLabel: '重新校验失败',
                ),
              ),
              TorrentActionTile(
                icon: Icons.campaign_outlined,
                label: '强制重新汇报',
                enabled: availability.canReannounce,
                onTap: availability.canReannounce
                    ? () => _run(
                        action: () => vm.reannounceTorrent(widget.hash),
                        failLabel: '重新汇报失败',
                      )
                    : null,
              ),
              const Divider(height: 8),
              if (queueing)
                TorrentActionTile(
                  icon: Icons.low_priority,
                  label: '队列',
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
                  label: '复制',
                  trailing: Icon(
                    Icons.chevron_right,
                    size: 22,
                    color: scheme.onSurfaceVariant,
                  ),
                  onTap: () => _openSub(_SubPage.copy),
                ),
              TorrentActionTile(
                icon: Icons.share_outlined,
                label: '分享种子',
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
    String loadingMessage = '处理中…',
  }) {
    final sheetContext = context;
    Navigator.pop(sheetContext);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!widget.pageContext.mounted) return;
      if (loading) {
        LoadingDialog.show(widget.pageContext, message: loadingMessage);
      }
      final error = await action();
      if (!widget.pageContext.mounted) return;
      if (loading) LoadingDialog.dismiss(widget.pageContext);
      if (error == null) return;
      ScaffoldMessenger.of(widget.pageContext).showSnackBar(
        SnackBar(content: Text('$failLabel：$error')),
      );
    });
  }

  void _exportTorrent(TorrentInfoResponse torrent, HomePageViewModel vm) {
    Navigator.pop(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!widget.pageContext.mounted) return;
      LoadingDialog.show(widget.pageContext, message: '准备分享…');
      final result = await vm.exportTorrentFile(
        widget.hash,
        name: torrent.name,
      );
      if (!widget.pageContext.mounted) return;
      LoadingDialog.dismiss(widget.pageContext);
      if (result.error != null) {
        ScaffoldMessenger.of(widget.pageContext).showSnackBar(
          SnackBar(content: Text('分享失败：${result.error}')),
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
          SnackBar(content: Text('分享失败：$e')),
        );
      }
    });
  }

  void _rename(TorrentInfoResponse torrent, HomePageViewModel vm) {
    final currentName = torrent.name ?? '';
    Navigator.pop(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.pageContext.mounted) return;
      RenameDialog.show(
        context: widget.pageContext,
        initialName: currentName,
        labelText: '名称',
        description: '修改的是种子在列表中的显示名称，不会改动服务器上的文件或文件夹。',
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
      LoadingDialog.show(widget.pageContext, message: '设置中…');
      final error = await vm.setTorrentLocation(widget.hash, location);
      if (!widget.pageContext.mounted) return;
      LoadingDialog.dismiss(widget.pageContext);
      if (error == null) return;
      ScaffoldMessenger.of(widget.pageContext).showSnackBar(
        SnackBar(content: Text('设置保存位置失败：$error')),
      );
    });
  }

  void _toggleAutoTmm({
    required bool enabled,
    required HomePageViewModel vm,
  }) {
    Navigator.pop(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!widget.pageContext.mounted) return;
      if (!enabled) {
        final confirmed = await ConfirmDialog.show(
          widget.pageContext,
          title: '开启自动种子管理',
          message: '确定开启自动种子管理？种子可能会按分类的保存路径被移动。',
          confirmText: '开启',
        );
        if (confirmed != true || !widget.pageContext.mounted) return;
      }
      final enable = !enabled;
      LoadingDialog.show(
        widget.pageContext,
        message: enable ? '开启中…' : '关闭中…',
      );
      final error = await vm.setTorrentAutoTmm(widget.hash, enable: enable);
      if (!widget.pageContext.mounted) return;
      LoadingDialog.dismiss(widget.pageContext);
      if (error == null) return;
      ScaffoldMessenger.of(widget.pageContext).showSnackBar(
        SnackBar(content: Text('${enable ? '开启' : '关闭'}自动管理失败：$error')),
      );
    });
  }

  void _toggleSuperSeeding({
    required bool enabled,
    required HomePageViewModel vm,
  }) {
    Navigator.pop(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!widget.pageContext.mounted) return;
      final enable = !enabled;
      LoadingDialog.show(
        widget.pageContext,
        message: enable ? '开启中…' : '关闭中…',
      );
      final error = await vm.setTorrentSuperSeeding(
        widget.hash,
        enable: enable,
      );
      if (!widget.pageContext.mounted) return;
      LoadingDialog.dismiss(widget.pageContext);
      if (error == null) return;
      ScaffoldMessenger.of(widget.pageContext).showSnackBar(
        SnackBar(content: Text('${enable ? '开启' : '关闭'}超级做种失败：$error')),
      );
    });
  }

  void _confirmDelete({
    required String name,
    required HomePageViewModel vm,
  }) {
    final sheetContext = context;
    Navigator.pop(sheetContext);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!widget.pageContext.mounted) return;
      var deleteFiles = false;
      final confirmed = await ConfirmDialog.show(
        widget.pageContext,
        title: '删除种子',
        confirmText: '删除',
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
                  name.isEmpty ? '确定删除该种子？' : '确定删除「$name」？',
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                CheckRow(
                  label: '同时删除文件',
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
      LoadingDialog.show(widget.pageContext, message: '删除中…');
      final error = await vm.deleteTorrent(
        widget.hash,
        deleteFiles: deleteFiles,
      );
      if (!widget.pageContext.mounted) return;
      LoadingDialog.dismiss(widget.pageContext);
      if (error == null) return;
      ScaffoldMessenger.of(widget.pageContext).showSnackBar(
        SnackBar(content: Text('删除失败：$error')),
      );
    });
  }
}

enum _SubPage { none, copy, speedLimit, shareLimit, tags, category, queue }
