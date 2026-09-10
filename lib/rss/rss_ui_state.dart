import 'package:flutter/material.dart';
import 'package:qbpanel/api/entity/response/rss_items_response.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

/// RSS 阅读器状态（源树 + 文章）。
class RssUiState {
  const RssUiState({
    this.emptyState = const EmptyState.content(),
    this.roots = const [],
    this.rssProcessingEnabled = true,
    this.busy = false,
    this.expandedPaths = const {},
    this.articleFilterQuery = '',
  });

  final EmptyState emptyState;
  final List<RssTreeNode> roots;
  final bool rssProcessingEnabled;
  final bool busy;
  final Set<String> expandedPaths;
  final String articleFilterQuery;

  bool get ready => emptyState.ready;

  int get totalUnread {
    var n = 0;
    for (final root in roots) {
      n += root.unreadCount;
    }
    return n;
  }

  List<RssArticle> get allArticles {
    return [
      for (final root in roots) ...root.allArticles,
    ];
  }

  List<RssArticle> get unreadArticles {
    final list = allArticles.where((a) => !a.isRead).toList();
    list.sort((a, b) {
      final da = DateTime.tryParse(a.date);
      final db = DateTime.tryParse(b.date);
      if (da != null && db != null) return db.compareTo(da);
      return b.date.compareTo(a.date);
    });
    return list;
  }

  RssTreeNode? findNode(String path) {
    if (path == RssItemsParser.unreadPath) return null;
    RssTreeNode? walk(List<RssTreeNode> nodes) {
      for (final node in nodes) {
        if (node.path == path) return node;
        final hit = walk(node.children);
        if (hit != null) return hit;
      }
      return null;
    }

    return walk(roots);
  }

  List<RssArticle> articlesForPath(String path) {
    if (path == RssItemsParser.unreadPath) return unreadArticles;
    final node = findNode(path);
    if (node == null) return const [];
    final list = List<RssArticle>.from(node.allArticles);
    list.sort((a, b) {
      final da = DateTime.tryParse(a.date);
      final db = DateTime.tryParse(b.date);
      if (da != null && db != null) return db.compareTo(da);
      return b.date.compareTo(a.date);
    });
    return list;
  }

  List<RssArticle> filteredArticlesForPath(String path) {
    final q = articleFilterQuery.trim().toLowerCase();
    final all = articlesForPath(path);
    if (q.isEmpty) return all;
    return all
        .where((a) => a.title.toLowerCase().contains(q))
        .toList(growable: false);
  }

  RssArticle? findArticle({
    required String feedPath,
    required String articleId,
  }) {
    final node = findNode(feedPath);
    if (node == null) return null;
    for (final a in node.allArticles) {
      if (a.id == articleId) return a;
    }
    return null;
  }

  RssUiState copyWith({
    EmptyState? emptyState,
    List<RssTreeNode>? roots,
    bool? rssProcessingEnabled,
    bool? busy,
    Set<String>? expandedPaths,
    String? articleFilterQuery,
  }) {
    return RssUiState(
      emptyState: emptyState ?? this.emptyState,
      roots: roots ?? this.roots,
      rssProcessingEnabled:
          rssProcessingEnabled ?? this.rssProcessingEnabled,
      busy: busy ?? this.busy,
      expandedPaths: expandedPaths ?? this.expandedPaths,
      articleFilterQuery: articleFilterQuery ?? this.articleFilterQuery,
    );
  }
}

/// 源列表扁平行（含缩进）。
class RssFeedListRow {
  const RssFeedListRow({
    required this.node,
    required this.depth,
  });

  final RssTreeNode node;
  final int depth;
}

List<RssFeedListRow> flattenRssTree(
  List<RssTreeNode> roots,
  Set<String> expandedPaths,
) {
  final rows = <RssFeedListRow>[];
  void walk(List<RssTreeNode> nodes, int depth) {
    for (final node in nodes) {
      rows.add(RssFeedListRow(node: node, depth: depth));
      if (node.isFolder && expandedPaths.contains(node.path)) {
        walk(node.children, depth + 1);
      }
    }
  }

  walk(roots, 0);
  return rows;
}

IconData rssNodeIcon(RssTreeNode node) {
  if (node.isFolder) return Icons.folder_outlined;
  if (node.isLoading) return Icons.hourglass_top_outlined;
  if (node.hasError) return Icons.error_outline;
  return Icons.rss_feed;
}
