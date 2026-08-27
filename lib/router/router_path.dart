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
  static const serverSettingsWebUi = '$serverSettings/webui';
  static const serverSettingsAdvanced = '$serverSettings/advanced';

  /// 路由表注册用的 path（不要带 query）
  static const serverModify = '$settings/server_modify';

  static const torrentDetail = '/torrent/detail';
  static const addTorrent = '/torrent/add';
  static const log = '/log';
  static const search = '/search';
  static const searchPlugins = '$search/plugins';

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

  static String serverSettingsWebUiWithParams(int serverId) {
    return '$serverSettingsWebUi?${RouterParameters.serverId}=$serverId';
  }

  static String serverSettingsAdvancedWithParams(int serverId) {
    return '$serverSettingsAdvanced?${RouterParameters.serverId}=$serverId';
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
