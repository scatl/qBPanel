import 'package:qbpanel/router/router_para.dart';

abstract final class RouterPath {
  static const home = '/';
  static const settings = '/settings';
  static const serverList = '$settings/server_list';
  static const serverSettings = '/server/settings';
  static const serverSettingsBehavior = '$serverSettings/behavior';
  static const serverSettingsDownloads = '$serverSettings/downloads';
  static const serverSettingsConnection = '$serverSettings/connection';
  static const serverSettingsSpeed = '$serverSettings/speed';
  static const serverSettingsBittorrent = '$serverSettings/bittorrent';
  static const serverSettingsRss = '$serverSettings/rss';
  static const serverSettingsWebUi = '$serverSettings/webui';
  static const serverSettingsAdvanced = '$serverSettings/advanced';

  /// 路由表注册用的 path（不要带 query）
  static const serverModify = '$settings/server_modify';

  static const torrentDetail = '/torrent/detail';
  static const addTorrent = '/torrent/add';
  static const log = '/log';
  static const search = '/search';
  static const searchPlugins = '$search/plugins';
  static const rss = '/rss';
  static const rssArticles = '$rss/articles';
  static const rssArticle = '$rss/article';
  static const rssRules = '$rss/rules';
  static const rssRuleEdit = '$rssRules/edit';

  /// 跳转用：添加不传 [serverId]；编辑传入数据库 id
  static String serverModifyWithParams({int? serverId}) {
    if (serverId == null) return serverModify;
    return '$serverModify?${RouterParameters.serverId}=$serverId';
  }

  static String torrentDetailWithParams(String hash) {
    return '$torrentDetail?${RouterParameters.torrentHash}=$hash';
  }

  static String serverSettingsWithParams(int? serverId) {
    return '$serverSettings?${RouterParameters.serverId}=$serverId';
  }

  static String serverSettingsBehaviorWithParams(int serverId) {
    return '$serverSettingsBehavior?${RouterParameters.serverId}=$serverId';
  }

  static String serverSettingsDownloadsWithParams(int serverId) {
    return '$serverSettingsDownloads?${RouterParameters.serverId}=$serverId';
  }

  static String serverSettingsConnectionWithParams(int serverId) {
    return '$serverSettingsConnection?${RouterParameters.serverId}=$serverId';
  }

  static String serverSettingsSpeedWithParams(int serverId) {
    return '$serverSettingsSpeed?${RouterParameters.serverId}=$serverId';
  }

  static String serverSettingsBittorrentWithParams(int serverId) {
    return '$serverSettingsBittorrent?${RouterParameters.serverId}=$serverId';
  }

  static String serverSettingsRssWithParams(int serverId) {
    return '$serverSettingsRss?${RouterParameters.serverId}=$serverId';
  }

  static String serverSettingsWebUiWithParams(int serverId) {
    return '$serverSettingsWebUi?${RouterParameters.serverId}=$serverId';
  }

  static String serverSettingsAdvancedWithParams(int serverId) {
    return '$serverSettingsAdvanced?${RouterParameters.serverId}=$serverId';
  }

  static String rssArticlesWithParams(String path) {
    return Uri(
      path: rssArticles,
      queryParameters: {RouterParameters.rssPath: path},
    ).toString();
  }

  static String rssArticleWithParams({
    required String feedPath,
    required String articleId,
  }) {
    return Uri(
      path: rssArticle,
      queryParameters: {
        RouterParameters.rssPath: feedPath,
        RouterParameters.rssArticleId: articleId,
      },
    ).toString();
  }

  static String rssRuleEditWithParams({String? name}) {
    final trimmed = name?.trim();
    if (trimmed == null || trimmed.isEmpty) return rssRuleEdit;
    return Uri(
      path: rssRuleEdit,
      queryParameters: {RouterParameters.rssRuleName: trimmed},
    ).toString();
  }

  /// [url] 与 [torrentPath] 二选一；都会做 encode。
  static String addTorrentWithParams({String? url, String? torrentPath}) {
    final params = <String, String>{};
    final trimmedUrl = url?.trim();
    final trimmedPath = torrentPath?.trim();
    if (trimmedUrl != null && trimmedUrl.isNotEmpty) {
      params[RouterParameters.url] = trimmedUrl;
    }
    if (trimmedPath != null && trimmedPath.isNotEmpty) {
      params[RouterParameters.torrentPath] = trimmedPath;
    }
    if (params.isEmpty) return addTorrent;
    return Uri(path: addTorrent, queryParameters: params).toString();
  }
}
