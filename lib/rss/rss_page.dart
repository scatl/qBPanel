import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qbpanel/api/entity/response/rss_items_response.dart';
import 'package:qbpanel/api/qb_api_capabilities.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/router/router_path.dart';
import 'package:qbpanel/rss/rss_ui_state.dart';
import 'package:qbpanel/rss/rss_view_model.dart';
import 'package:qbpanel/rss/ui/rss_feed_action_dialog.dart';
import 'package:qbpanel/rss/ui/rss_text_input_dialog.dart';
import 'package:qbpanel/settings/widget/settings_group_card.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';
import 'package:qbpanel/widget/page_insets.dart';

/// RSS 源列表（阅读器首页）。
class RssPage extends ConsumerWidget {
  const RssPage({super.key});

  Future<void> _snack(
    BuildContext context,
    String? error, {
    String? success,
  }) async {
    if (!context.mounted) return;
    final text = error ?? success;
    if (text == null || text.isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  Future<void> _withLoading(
    BuildContext context,
    Future<String?> Function() task, {
    String? success,
  }) async {
    LoadingDialog.show(context, message: context.l10n.saving);
    await Future<void>.delayed(Duration.zero);
    final error = await task();
    if (!context.mounted) return;
    LoadingDialog.dismiss(context);
    await _snack(context, error, success: success);
  }

  Future<void> _addFeed(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final url = await RssTextInputDialog.show(
      context,
      title: l10n.rssNewSubscription,
      label: l10n.rssFeedUrl,
      hint: 'https://…',
      minLines: 2,
      maxLines: 4,
      emptyError: l10n.rssFeedUrlRequired,
    );
    if (url == null || !context.mounted) return;
    await _withLoading(
      context,
      () => ref.read(rssProvider.notifier).addFeed(url: url),
    );
  }

  Future<void> _addFolder(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final name = await RssTextInputDialog.show(
      context,
      title: l10n.rssNewFolder,
      label: l10n.rssFolderName,
      emptyError: l10n.rssFolderNameRequired,
    );
    if (name == null || !context.mounted) return;
    await _withLoading(
      context,
      () => ref.read(rssProvider.notifier).addFolder(name),
    );
  }

  Future<void> _openRssSettings(BuildContext context, WidgetRef ref) async {
    final serverId = ref.read(activeServerProvider).value?.id;
    if (serverId == null) return;
    await context.push(RouterPath.serverSettingsRssWithParams(serverId));
    if (!context.mounted) return;
    await ref.read(rssProvider.notifier).reloadProcessingFlag();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(rssProvider);
    final vm = ref.read(rssProvider.notifier);
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;
    final rows = flattenRssTree(ui.roots, ui.expandedPaths);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.rssPageTitle),
        actions: [
          IconButton(
            tooltip: l10n.rssNewSubscription,
            icon: const Icon(Icons.add),
            onPressed: ui.busy ? null : () => _addFeed(context, ref),
          ),
          IconButton(
            tooltip: l10n.rssAutoDownloadRules,
            icon: const Icon(Icons.rule_outlined),
            onPressed: () => context.push(RouterPath.rssRules),
          ),
          PopupMenuButton<_RssToolbarAction>(
            tooltip: l10n.actionMore,
            onSelected: (action) async {
              switch (action) {
                case _RssToolbarAction.newFolder:
                  await _addFolder(context, ref);
                case _RssToolbarAction.updateAll:
                  await _withLoading(
                    context,
                    () => vm.refreshAll(),
                    success: l10n.rssUpdateStarted,
                  );
                case _RssToolbarAction.markAllRead:
                  // 标记每个顶层节点
                  LoadingDialog.show(context, message: l10n.saving);
                  await Future<void>.delayed(Duration.zero);
                  String? error;
                  for (final root in ui.roots) {
                    error ??= await vm.markAsRead(itemPath: root.path);
                  }
                  if (!context.mounted) return;
                  LoadingDialog.dismiss(context);
                  await _snack(
                    context,
                    error,
                    success: l10n.rssMarkedAsRead,
                  );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _RssToolbarAction.newFolder,
                child: Text(l10n.rssNewFolder),
              ),
              PopupMenuItem(
                value: _RssToolbarAction.updateAll,
                child: Text(l10n.rssUpdateAll),
              ),
              PopupMenuItem(
                value: _RssToolbarAction.markAllRead,
                child: Text(l10n.rssMarkAllAsRead),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (!ui.rssProcessingEnabled)
            Material(
              color: scheme.errorContainer,
              child: InkWell(
                onTap: () => _openRssSettings(context, ref),
                child: Padding(
                  padding: PageInsets.content.copyWith(top: 10, bottom: 10),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: scheme.onErrorContainer),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.rssProcessingDisabledBanner,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: scheme.onErrorContainer,
                              ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: scheme.onErrorContainer,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: EmptyStateHost(
              state: ui.emptyState,
              onRetry: () => vm.refreshNow(),
              padding: const EdgeInsets.all(24),
              builder: (context) => ListView(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 24 + bottomSafe),
                children: [
                  SettingsGroupCard(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: Icon(
                        Icons.mark_email_unread_outlined,
                        color: scheme.primary,
                      ),
                      title: Text(l10n.rssUnread),
                      trailing: ui.totalUnread > 0
                          ? Text(
                              '${ui.totalUnread}',
                              style: TextStyle(color: scheme.primary),
                            )
                          : null,
                      onTap: () => context.push(
                        RouterPath.rssArticlesWithParams(
                          RssItemsParser.unreadPath,
                        ),
                      ),
                    ),
                  ),
                  if (rows.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    SettingsGroupCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          for (var i = 0; i < rows.length; i++) ...[
                            if (i > 0) const Divider(height: 1),
                            _FeedTile(
                              row: rows[i],
                              onOpen: () {
                                final node = rows[i].node;
                                if (node.isFolder) {
                                  vm.toggleExpanded(node.path);
                                } else {
                                  context.push(
                                    RouterPath.rssArticlesWithParams(
                                      node.path,
                                    ),
                                  );
                                }
                              },
                              onMore: () => RssFeedActionDialog.show(
                                context: context,
                                node: rows[i].node,
                                vm: vm,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _RssToolbarAction { newFolder, updateAll, markAllRead }

class _FeedTile extends StatelessWidget {
  const _FeedTile({
    required this.row,
    required this.onOpen,
    required this.onMore,
  });

  final RssFeedListRow row;
  final VoidCallback onOpen;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final node = row.node;
    final scheme = Theme.of(context).colorScheme;
    final unread = node.unreadCount;

    return ListTile(
      contentPadding: EdgeInsets.only(
        left: 16.0 + row.depth * 20.0,
        right: 4,
      ),
      leading: Icon(
        rssNodeIcon(node),
        color: node.hasError ? scheme.error : scheme.onSurfaceVariant,
      ),
      title: Text(node.displayName, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: node.isFeed && node.hasError
          ? Text(
              context.l10n.rssFeedHasError,
              style: TextStyle(color: scheme.error),
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (unread > 0)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                '$unread',
                style: TextStyle(color: scheme.primary),
              ),
            ),
          if (node.isFolder)
            Icon(
              Icons.expand_more,
              color: scheme.onSurfaceVariant,
            ),
          IconButton(
            tooltip: context.l10n.actionMore,
            icon: const Icon(Icons.more_vert),
            onPressed: onMore,
          ),
        ],
      ),
      onTap: onOpen,
      onLongPress: onMore,
    );
  }
}
