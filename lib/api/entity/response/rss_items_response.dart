import 'package:qbpanel/api/entity/response/json_read.dart';

/// RSS 文章（`/rss/items?withData=true`）。
class RssArticle {
  const RssArticle({
    required this.id,
    required this.title,
    this.date = '',
    this.author = '',
    this.description = '',
    this.torrentUrl = '',
    this.link = '',
    this.isRead = false,
    required this.feedPath,
  });

  final String id;
  final String title;
  final String date;
  final String author;
  final String description;
  final String torrentUrl;
  final String link;
  final bool isRead;

  /// 所属源完整路径（`\` 分隔）。
  final String feedPath;

  factory RssArticle.fromJson(
    Map<String, dynamic> json, {
    required String feedPath,
  }) {
    return RssArticle(
      id: readString(json['id']) ?? '',
      title: readString(json['title']) ?? '',
      date: readString(json['date']) ?? '',
      author: readString(json['author']) ?? '',
      description: readString(json['description']) ?? '',
      torrentUrl: readString(json['torrentURL']) ?? '',
      link: readString(json['link']) ?? '',
      isRead: readBool(json['isRead']) ?? false,
      feedPath: feedPath,
    );
  }

  RssArticle copyWith({bool? isRead}) {
    return RssArticle(
      id: id,
      title: title,
      date: date,
      author: author,
      description: description,
      torrentUrl: torrentUrl,
      link: link,
      isRead: isRead ?? this.isRead,
      feedPath: feedPath,
    );
  }
}

/// 源树节点：文件夹或订阅源。
enum RssNodeKind { folder, feed }

class RssTreeNode {
  const RssTreeNode({
    required this.name,
    required this.path,
    required this.kind,
    this.url = '',
    this.uid = '',
    this.title = '',
    this.isLoading = false,
    this.hasError = false,
    this.articles = const [],
    this.children = const [],
  });

  final String name;
  final String path;
  final RssNodeKind kind;
  final String url;
  final String uid;
  final String title;
  final bool isLoading;
  final bool hasError;
  final List<RssArticle> articles;
  final List<RssTreeNode> children;

  bool get isFolder => kind == RssNodeKind.folder;
  bool get isFeed => kind == RssNodeKind.feed;

  String get displayName {
    if (isFeed && title.trim().isNotEmpty) return title.trim();
    return name;
  }

  int get unreadCount {
    if (isFeed) {
      return articles.where((a) => !a.isRead).length;
    }
    return children.fold<int>(0, (sum, c) => sum + c.unreadCount);
  }

  List<RssArticle> get allArticles {
    if (isFeed) return articles;
    return [
      for (final child in children) ...child.allArticles,
    ];
  }

  List<RssTreeNode> get allFeeds {
    if (isFeed) return [this];
    return [
      for (final child in children) ...child.allFeeds,
    ];
  }
}

/// 解析 `/rss/items` 响应。
abstract final class RssItemsParser {
  RssItemsParser._();

  static const pathSeparator = r'\';
  static const unreadPath = '__unread__';

  static List<RssTreeNode> parse(dynamic data) {
    if (data is! Map) return const [];
    return _parseMap(Map<String, dynamic>.from(data), parentPath: '');
  }

  static List<RssTreeNode> _parseMap(
    Map<String, dynamic> map, {
    required String parentPath,
  }) {
    final nodes = <RssTreeNode>[];
    for (final entry in map.entries) {
      final name = entry.key;
      final path = parentPath.isEmpty
          ? name
          : '$parentPath$pathSeparator$name';
      final value = entry.value;

      if (value is String) {
        nodes.add(
          RssTreeNode(
            name: name,
            path: path,
            kind: RssNodeKind.feed,
            url: value,
            title: name,
          ),
        );
        continue;
      }

      if (value is! Map) continue;
      final obj = Map<String, dynamic>.from(value);
      if (_looksLikeFeed(obj)) {
        final articlesRaw = obj['articles'];
        final articles = <RssArticle>[];
        if (articlesRaw is List) {
          for (final item in articlesRaw) {
            if (item is! Map) continue;
            articles.add(
              RssArticle.fromJson(
                Map<String, dynamic>.from(item),
                feedPath: path,
              ),
            );
          }
        }
        articles.sort(_compareArticlesByDateDesc);
        nodes.add(
          RssTreeNode(
            name: name,
            path: path,
            kind: RssNodeKind.feed,
            url: readString(obj['url']) ?? '',
            uid: readString(obj['uid']) ?? '',
            title: readString(obj['title']) ?? name,
            isLoading: readBool(obj['isLoading']) ?? false,
            hasError: readBool(obj['hasError']) ?? false,
            articles: articles,
          ),
        );
      } else {
        nodes.add(
          RssTreeNode(
            name: name,
            path: path,
            kind: RssNodeKind.folder,
            children: _parseMap(obj, parentPath: path),
          ),
        );
      }
    }
    nodes.sort((a, b) {
      if (a.isFolder != b.isFolder) return a.isFolder ? -1 : 1;
      return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
    });
    return nodes;
  }

  static bool _looksLikeFeed(Map<String, dynamic> obj) {
    if (obj.containsKey('url') || obj.containsKey('uid')) return true;
    if (obj.containsKey('articles')) return true;
    if (obj.containsKey('isLoading') || obj.containsKey('hasError')) {
      return true;
    }
    return false;
  }

  static int _compareArticlesByDateDesc(RssArticle a, RssArticle b) {
    final da = DateTime.tryParse(a.date);
    final db = DateTime.tryParse(b.date);
    if (da != null && db != null) return db.compareTo(da);
    return b.date.compareTo(a.date);
  }

  /// 父路径；根级返回空串。
  static String parentPathOf(String path) {
    final i = path.lastIndexOf(pathSeparator);
    if (i < 0) return '';
    return path.substring(0, i);
  }

  /// 路径最后一段名称。
  static String leafNameOf(String path) {
    final i = path.lastIndexOf(pathSeparator);
    if (i < 0) return path;
    return path.substring(i + 1);
  }

  static String joinPath(String parent, String name) {
    final n = name.trim();
    if (parent.isEmpty) return n;
    return '$parent$pathSeparator$n';
  }
}
