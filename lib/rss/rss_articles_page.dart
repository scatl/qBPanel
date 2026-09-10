import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qbpanel/api/entity/response/rss_items_response.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/router/router_path.dart';
import 'package:qbpanel/rss/rss_view_model.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';
import 'package:qbpanel/widget/page_insets.dart';

/// 某源 / Unread 下的文章列表。
class RssArticlesPage extends ConsumerStatefulWidget {
  const RssArticlesPage({
    super.key,
    required this.path,
  });

  final String path;

  @override
  ConsumerState<RssArticlesPage> createState() => _RssArticlesPageState();
}

class _RssArticlesPageState extends ConsumerState<RssArticlesPage> {
  final _filterController = TextEditingController();

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  String _title(RssUiTitleArgs args) {
    final l10n = context.l10n;
    if (widget.path == RssItemsParser.unreadPath) return l10n.rssUnread;
    return args.nodeTitle ?? l10n.rssPageTitle;
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(rssProvider);
    final vm = ref.read(rssProvider.notifier);
    final l10n = context.l10n;
    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;
    final node = ui.findNode(widget.path);
    final articles = ui.filteredArticlesForPath(widget.path);
    final isUnread = widget.path == RssItemsParser.unreadPath;

    // 确保从深层进入时仍有轮询（父页若被 dispose 则本页 watch 保活 provider）
    final title = _title(
      RssUiTitleArgs(nodeTitle: node?.displayName),
    );

    final empty = !ui.ready
        ? ui.emptyState
        : articles.isEmpty
            ? EmptyState.empty(
                title: l10n.rssEmptyArticlesTitle,
                subtitle: l10n.rssEmptyArticlesSubtitle,
                icon: Icons.article_outlined,
              )
            : const EmptyState.content();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (!isUnread && node != null)
            IconButton(
              tooltip: l10n.rssMarkAsRead,
              icon: const Icon(Icons.done_all),
              onPressed: () async {
                LoadingDialog.show(context, message: l10n.saving);
                await Future<void>.delayed(Duration.zero);
                final error = await vm.markAsRead(itemPath: widget.path);
                if (!context.mounted) return;
                LoadingDialog.dismiss(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error ?? l10n.rssMarkedAsRead),
                  ),
                );
              },
            ),
          if (!isUnread && node != null)
            IconButton(
              tooltip: l10n.rssUpdate,
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                LoadingDialog.show(context, message: l10n.saving);
                await Future<void>.delayed(Duration.zero);
                final error = await vm.refreshItem(widget.path);
                if (!context.mounted) return;
                LoadingDialog.dismiss(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error ?? l10n.rssUpdateStarted),
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: PageInsets.content.copyWith(top: 8, bottom: 8),
            child: TextField(
              controller: _filterController,
              onChanged: vm.setArticleFilterQuery,
              decoration: InputDecoration(
                hintText: l10n.rssFilterArticles,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: ui.articleFilterQuery.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _filterController.clear();
                          vm.setArticleFilterQuery('');
                        },
                      ),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: EmptyStateHost(
              state: empty,
              onRetry: () => vm.refreshNow(),
              padding: const EdgeInsets.all(24),
              builder: (context) => ListView.builder(
                padding: EdgeInsets.fromLTRB(0, 2, 0, 24 + bottomSafe),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return _RssArticleItem(
                    article: article,
                    showFeedName: isUnread,
                    onTap: () => context.push(
                      RouterPath.rssArticleWithParams(
                        feedPath: article.feedPath,
                        articleId: article.id,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RssUiTitleArgs {
  const RssUiTitleArgs({this.nodeTitle});
  final String? nodeTitle;
}

class _RssArticleItem extends StatelessWidget {
  const _RssArticleItem({
    required this.article,
    required this.showFeedName,
    required this.onTap,
  });

  final RssArticle article;
  final bool showFeedName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final subtitle = [
      if (showFeedName) RssItemsParser.leafNameOf(article.feedPath),
      if (article.date.isNotEmpty) article.date,
    ].where((e) => e.isNotEmpty).join(' · ');

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PageInsets.horizontal,
        vertical: 6,
      ),
      child: Material(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  article.title.isEmpty
                      ? l10n.rssUntitledArticle
                      : article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight:
                        article.isRead ? FontWeight.normal : FontWeight.w600,
                    color: article.isRead ? scheme.onSurfaceVariant : null,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
