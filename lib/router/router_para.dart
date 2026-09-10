abstract class RouterParameters {
  static const serverId = 'serverId';
  static const torrentHash = 'torrentHash';

  /// RSS：源路径（`\` 分隔；Unread 为 `__unread__`）
  static const rssPath = 'path';

  /// RSS：文章 id
  static const rssArticleId = 'articleId';

  /// RSS 自动下载规则名
  static const rssRuleName = 'ruleName';

  /// 添加种子：磁力 / HTTP(S) 等 URL
  static const url = 'url';

  /// 添加种子：本地 .torrent 临时文件路径
  static const torrentPath = 'torrentPath';
}
