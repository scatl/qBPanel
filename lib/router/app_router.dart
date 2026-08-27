import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qbpanel/add/add_torrent_page.dart';
import 'package:qbpanel/detail/torrent_detail_page.dart';
import 'package:qbpanel/home/home_page.dart';
import 'package:qbpanel/log/log_page.dart';
import 'package:qbpanel/search/plugin/search_plugin_list_page.dart';
import 'package:qbpanel/search/search_page.dart';
import 'package:qbpanel/router/router_para.dart';
import 'package:qbpanel/router/router_path.dart';
import 'package:qbpanel/settings/server/list/server_list_page.dart';
import 'package:qbpanel/settings/server/modify/server_modify_page.dart';
import 'package:qbpanel/settings/server/setting/behavior/behavior_settings_page.dart';
import 'package:qbpanel/settings/server/setting/bittorrent/bittorrent_settings_page.dart';
import 'package:qbpanel/settings/server/setting/connection/connection_settings_page.dart';
import 'package:qbpanel/settings/server/setting/downloads/downloads_settings_page.dart';
import 'package:qbpanel/settings/server/setting/speed/speed_settings_page.dart';
import 'package:qbpanel/settings/server/setting/advanced/advanced_settings_page.dart';
import 'package:qbpanel/settings/server/setting/webui/webui_settings_page.dart';
import 'package:qbpanel/settings/server/setting/server_settings_page.dart';
import 'package:qbpanel/settings/settings_page.dart';

/// 应用路由表（go_router）
/// 使用 builder → MaterialPage，转场由 Theme.pageTransitionsTheme 决定（Zoom）
final GoRouter appRouter = GoRouter(
  initialLocation: RouterPath.home,
  // 文件 Intent 的 content:// 不应作为路由；由 InboundTorrentOpen 处理
  overridePlatformDefaultLocation: true,
  routes: [
    GoRoute(
      path: RouterPath.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: RouterPath.log,
      builder: (context, state) => const LogPage(),
    ),
    GoRoute(
      path: RouterPath.search,
      builder: (context, state) => const SearchPage(),
    ),
    GoRoute(
      path: RouterPath.searchPlugins,
      builder: (context, state) => const SearchPluginListPage(),
    ),
    GoRoute(
      path: RouterPath.settings,
      builder: (context, state) => const SettingsPage()
    ),
    GoRoute(
      path: RouterPath.serverSettings,
      builder: (context, state) {
        final raw = state.uri.queryParameters[RouterParameters.serverId];
        final id = int.tryParse(raw.toString()) ?? -1;
        return ServerSettingsPage(serverId: id);
      },
    ),
    GoRoute(
      path: RouterPath.serverSettingsBehavior,
      builder: (context, state) {
        final raw = state.uri.queryParameters[RouterParameters.serverId];
        final id = int.tryParse(raw.toString()) ?? -1;
        return BehaviorSettingsPage(serverId: id);
      },
    ),
    GoRoute(
      path: RouterPath.serverSettingsDownloads,
      builder: (context, state) {
        final raw = state.uri.queryParameters[RouterParameters.serverId];
        final id = int.tryParse(raw.toString()) ?? -1;
        return DownloadsSettingsPage(serverId: id);
      },
    ),
    GoRoute(
      path: RouterPath.serverSettingsConnection,
      builder: (context, state) {
        final raw = state.uri.queryParameters[RouterParameters.serverId];
        final id = int.tryParse(raw.toString()) ?? -1;
        return ConnectionSettingsPage(serverId: id);
      },
    ),
    GoRoute(
      path: RouterPath.serverSettingsSpeed,
      builder: (context, state) {
        final raw = state.uri.queryParameters[RouterParameters.serverId];
        final id = int.tryParse(raw.toString()) ?? -1;
        return SpeedSettingsPage(serverId: id);
      },
    ),
    GoRoute(
      path: RouterPath.serverSettingsBittorrent,
      builder: (context, state) {
        final raw = state.uri.queryParameters[RouterParameters.serverId];
        final id = int.tryParse(raw.toString()) ?? -1;
        return BittorrentSettingsPage(serverId: id);
      },
    ),
    GoRoute(
      path: RouterPath.serverSettingsWebUi,
      builder: (context, state) {
        final raw = state.uri.queryParameters[RouterParameters.serverId];
        final id = int.tryParse(raw.toString()) ?? -1;
        return WebUiSettingsPage(serverId: id);
      },
    ),
    GoRoute(
      path: RouterPath.serverSettingsAdvanced,
      builder: (context, state) {
        final raw = state.uri.queryParameters[RouterParameters.serverId];
        final id = int.tryParse(raw.toString()) ?? -1;
        return AdvancedSettingsPage(serverId: id);
      },
    ),
    GoRoute(
      path: RouterPath.serverList,
      builder: (context, state) => const ServerListPage()
    ),
    GoRoute(
      path: RouterPath.serverModify,
      builder: (context, state) {
        final raw = state.uri.queryParameters[RouterParameters.serverId];
        final id = raw == null ? null : int.tryParse(raw);
        return ServerModifyPage(serverId: id);
      },
    ),
    GoRoute(
      path: RouterPath.torrentDetail,
      builder: (context, state) {
        final hash = state.uri.queryParameters[RouterParameters.torrentHash] ?? '';
        return TorrentDetailPage(torrentHash: hash);
      },
    ),
    GoRoute(
      path: RouterPath.addTorrent,
      builder: (context, state) {
        final url = state.uri.queryParameters[RouterParameters.url];
        final torrentPath =
            state.uri.queryParameters[RouterParameters.torrentPath];
        return AddTorrentPage(
          key: ValueKey('add-${url ?? ''}-${torrentPath ?? ''}'),
          initialUrl: url,
          initialTorrentPath: torrentPath,
        );
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('页面不存在')),
    body: Center(child: Text(state.error.toString())),
  ),
);
