import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qbpanel/api/entity/response/rss_items_response.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/router/router_path.dart';
import 'package:qbpanel/rss/rss_view_model.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';
import 'package:qbpanel/widget/page_insets.dart';
import 'package:url_launcher/url_launcher.dart';

/// 文章详情。
class RssArticleDetailPage extends ConsumerStatefulWidget {
  const RssArticleDetailPage({
    super.key,
    required this.feedPath,
    required this.articleId,
  });

  final String feedPath;
  final String articleId;

  @override
  ConsumerState<RssArticleDetailPage> createState() =>
      _RssArticleDetailPageState();
}

class _RssArticleDetailPageState extends ConsumerState<RssArticleDetailPage> {
  var _marked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _markReadOnce());
  }

  Future<void> _markReadOnce() async {
    if (_marked) return;
    final article = ref.read(rssProvider).findArticle(
          feedPath: widget.feedPath,
          articleId: widget.articleId,
        );
    if (article == null || article.isRead) {
      _marked = true;
      return;
    }
    _marked = true;
    await ref.read(rssProvider.notifier).markAsRead(
          itemPath: widget.feedPath,
          articleId: widget.articleId,
        );
  }

  Future<void> _openUrl(String raw) async {
    final uri = Uri.tryParse(raw.trim());
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static String stripHtml(String html) {
    var text = html
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]+>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");
    text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(rssProvider);
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;
    final article = ui.findArticle(
      feedPath: widget.feedPath,
      articleId: widget.articleId,
    );

    if (article == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.rssArticleDetail)),
        body: EmptyStateHost(
          state: EmptyState.empty(
            title: l10n.rssArticleNotFound,
            icon: Icons.article_outlined,
          ),
          padding: const EdgeInsets.all(24),
          builder: (_) => const SizedBox.shrink(),
        ),
      );
    }

    final bodyText = stripHtml(article.description);
    final canDownload = article.torrentUrl.trim().isNotEmpty;
    final canOpenLink = article.link.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.rssArticleDetail),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          PageInsets.content.left,
          16,
          PageInsets.content.right,
          24 + bottomSafe,
        ),
        children: [
          Text(
            article.title.isEmpty ? l10n.rssUntitledArticle : article.title,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            [
              if (article.date.isNotEmpty) article.date,
              if (article.author.isNotEmpty) article.author,
              RssItemsParser.leafNameOf(article.feedPath),
            ].where((e) => e.isNotEmpty).join(' · '),
            style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (canDownload)
                FilledButton.icon(
                  onPressed: () => context.push(
                    RouterPath.addTorrentWithParams(url: article.torrentUrl),
                  ),
                  icon: const Icon(Icons.download),
                  label: Text(l10n.rssDownloadTorrent),
                ),
              if (canOpenLink)
                OutlinedButton.icon(
                  onPressed: () => _openUrl(article.link),
                  icon: const Icon(Icons.open_in_new),
                  label: Text(l10n.rssOpenLink),
                ),
            ],
          ),
          const SizedBox(height: 20),
          if (bodyText.isNotEmpty)
            SelectableText(
              bodyText,
              style: textTheme.bodyMedium,
            )
          else
            Text(
              l10n.rssNoDescription,
              style: textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}
