import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/entity/response/app_preferences_response.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/settings/server/setting/connection/connection_settings_ui_state.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

final connectionSettingsProvider =
    NotifierProvider<ConnectionSettingsViewModel, ConnectionSettingsUiState>(
  ConnectionSettingsViewModel.new,
);

class ConnectionSettingsViewModel extends Notifier<ConnectionSettingsUiState> {
  @override
  ConnectionSettingsUiState build() => const ConnectionSettingsUiState();

  Future<bool> load() async {
    state = state.copyWith(emptyState: const EmptyState.loading());
    String? error;
    AppPreferencesResponse? prefs;
    await ref
        .read(apiClientProvider)
        .get(
          ApiPath.application.preferences,
          parser: jsonParser(AppPreferencesResponse.fromJson),
        )
        .onSuccess((data) => prefs = data)
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });

    if (prefs == null) {
      state = state.copyWith(
        emptyState: EmptyState.error(error ?? ref.read(appLocalizationsProvider).loadSettingsFailed),
      );
      return false;
    }

    final data = prefs!;
    final maxConnec = _limitFromApi(data.maxConnec, 500);
    final maxConnecPerTorrent = _limitFromApi(data.maxConnecPerTorrent, 100);
    final maxUploads = _limitFromApi(data.maxUploads, 8);
    final maxUploadsPerTorrent = _limitFromApi(data.maxUploadsPerTorrent, 4);

    state = state.copyWith(
      emptyState: const EmptyState.content(),
      peerProtocol: ConnectionPeerProtocol.fromApi(data.bittorrentProtocol),
      listenPort: data.listenPort ?? state.listenPort,
      upnp: data.upnp ?? true,
      maxConnecEnabled: maxConnec.enabled,
      maxConnec: maxConnec.value,
      maxConnecPerTorrentEnabled: maxConnecPerTorrent.enabled,
      maxConnecPerTorrent: maxConnecPerTorrent.value,
      maxUploadsEnabled: maxUploads.enabled,
      maxUploads: maxUploads.value,
      maxUploadsPerTorrentEnabled: maxUploadsPerTorrent.enabled,
      maxUploadsPerTorrent: maxUploadsPerTorrent.value,
      i2pEnabled: data.i2pEnabled ?? false,
      i2pAddress: data.i2pAddress ?? '127.0.0.1',
      i2pPort: data.i2pPort ?? 7656,
      i2pMixedMode: data.i2pMixedMode ?? false,
      proxyType: ConnectionProxyType.fromApi(data.proxyType),
      proxyIp: data.proxyIp ?? '',
      proxyPort: data.proxyPort ?? 8080,
      proxyAuthEnabled: data.proxyAuthEnabled ?? false,
      proxyUsername: data.proxyUsername ?? '',
      proxyPassword: data.proxyPassword ?? '',
      proxyHostnameLookup: data.proxyHostnameLookup ?? false,
      proxyBittorrent: data.proxyBittorrent ?? true,
      proxyPeerConnections: data.proxyPeerConnections ?? false,
      proxyRss: data.proxyRss ?? true,
      proxyMisc: data.proxyMisc ?? true,
      ipFilterEnabled: data.ipFilterEnabled ?? false,
      ipFilterPath: data.ipFilterPath ?? '',
      ipFilterTrackers: data.ipFilterTrackers ?? false,
      bannedIps: data.bannedIps ?? '',
    );
    return true;
  }

  void setPeerProtocol(ConnectionPeerProtocol value) {
    state = state.copyWith(peerProtocol: value);
  }

  void setListenPort(int value) {
    state = state.copyWith(listenPort: value);
  }

  void randomizeListenPort() {
    final random = Random.secure();
    var port = random.nextInt(65536);
    while (port < 1024) {
      port = random.nextInt(65536);
    }
    state = state.copyWith(listenPort: port);
  }

  void setUpnp(bool value) {
    state = state.copyWith(upnp: value);
  }

  void setMaxConnecEnabled(bool value) {
    state = state.copyWith(maxConnecEnabled: value);
  }

  void setMaxConnec(int value) {
    state = state.copyWith(maxConnec: value);
  }

  void setMaxConnecPerTorrentEnabled(bool value) {
    state = state.copyWith(maxConnecPerTorrentEnabled: value);
  }

  void setMaxConnecPerTorrent(int value) {
    state = state.copyWith(maxConnecPerTorrent: value);
  }

  void setMaxUploadsEnabled(bool value) {
    state = state.copyWith(maxUploadsEnabled: value);
  }

  void setMaxUploads(int value) {
    state = state.copyWith(maxUploads: value);
  }

  void setMaxUploadsPerTorrentEnabled(bool value) {
    state = state.copyWith(maxUploadsPerTorrentEnabled: value);
  }

  void setMaxUploadsPerTorrent(int value) {
    state = state.copyWith(maxUploadsPerTorrent: value);
  }

  void setI2pEnabled(bool value) {
    state = state.copyWith(i2pEnabled: value);
  }

  void setI2pAddress(String value) {
    state = state.copyWith(i2pAddress: value);
  }

  void setI2pPort(int value) {
    state = state.copyWith(i2pPort: value);
  }

  void setI2pMixedMode(bool value) {
    state = state.copyWith(i2pMixedMode: value);
  }

  void setProxyType(ConnectionProxyType value) {
    state = state.copyWith(proxyType: value);
  }

  void setProxyIp(String value) {
    state = state.copyWith(proxyIp: value);
  }

  void setProxyPort(int value) {
    state = state.copyWith(proxyPort: value);
  }

  void setProxyAuthEnabled(bool value) {
    state = state.copyWith(proxyAuthEnabled: value);
  }

  void setProxyUsername(String value) {
    state = state.copyWith(proxyUsername: value);
  }

  void setProxyPassword(String value) {
    state = state.copyWith(proxyPassword: value);
  }

  void setProxyHostnameLookup(bool value) {
    state = state.copyWith(proxyHostnameLookup: value);
  }

  void setProxyBittorrent(bool value) {
    state = state.copyWith(proxyBittorrent: value);
  }

  void setProxyPeerConnections(bool value) {
    state = state.copyWith(proxyPeerConnections: value);
  }

  void setProxyRss(bool value) {
    state = state.copyWith(proxyRss: value);
  }

  void setProxyMisc(bool value) {
    state = state.copyWith(proxyMisc: value);
  }

  void setIpFilterEnabled(bool value) {
    state = state.copyWith(ipFilterEnabled: value);
  }

  void setIpFilterPath(String value) {
    state = state.copyWith(ipFilterPath: value);
  }

  void setIpFilterTrackers(bool value) {
    state = state.copyWith(ipFilterTrackers: value);
  }

  void setBannedIps(String value) {
    state = state.copyWith(bannedIps: value);
  }

  /// 成功返回 `null`。
  Future<String?> save() async {
    if (state.saving) return null;

    final listenPort = state.listenPort;
    if (listenPort < 0 || listenPort > 65535) {
      return ref.read(appLocalizationsProvider).invalidListenPort;
    }
    if (state.maxConnecEnabled && state.maxConnec <= 0) {
      return ref.read(appLocalizationsProvider).invalidMaxConnections;
    }
    if (state.maxConnecPerTorrentEnabled && state.maxConnecPerTorrent <= 0) {
      return ref.read(appLocalizationsProvider).invalidMaxConnectionsPerTorrent;
    }
    if (state.maxUploadsEnabled && state.maxUploads <= 0) {
      return ref.read(appLocalizationsProvider).invalidMaxUploads;
    }
    if (state.maxUploadsPerTorrentEnabled &&
        state.maxUploadsPerTorrent <= 0) {
      return ref.read(appLocalizationsProvider).invalidMaxUploadsPerTorrent;
    }
    if (state.proxyPort < 0 || state.proxyPort > 65535) {
      return ref.read(appLocalizationsProvider).invalidProxyPort;
    }
    if (state.i2pPort < 0 || state.i2pPort > 65535) {
      return ref.read(appLocalizationsProvider).invalidI2pPort;
    }

    state = state.copyWith(saving: true);
    final payload = <String, dynamic>{
      'bittorrent_protocol': state.peerProtocol.apiValue,
      'listen_port': listenPort,
      'upnp': state.upnp,
      'max_connec': state.maxConnecEnabled ? state.maxConnec : -1,
      'max_connec_per_torrent':
          state.maxConnecPerTorrentEnabled ? state.maxConnecPerTorrent : -1,
      'max_uploads': state.maxUploadsEnabled ? state.maxUploads : -1,
      'max_uploads_per_torrent':
          state.maxUploadsPerTorrentEnabled ? state.maxUploadsPerTorrent : -1,
      'i2p_enabled': state.i2pEnabled,
      'i2p_address': state.i2pAddress.trim(),
      'i2p_port': state.i2pPort,
      'i2p_mixed_mode': state.i2pMixedMode,
      'proxy_type': state.proxyType.apiValue,
      'proxy_ip': state.proxyIp.trim(),
      'proxy_port': state.proxyPort,
      'proxy_auth_enabled': state.proxyAuthEnabled,
      'proxy_username': state.proxyUsername.trim(),
      'proxy_password': state.proxyPassword,
      'proxy_hostname_lookup': state.proxyHostnameLookup,
      'proxy_bittorrent': state.proxyBittorrent,
      'proxy_peer_connections': state.proxyPeerConnections,
      'proxy_rss': state.proxyRss,
      'proxy_misc': state.proxyMisc,
      'ip_filter_enabled': state.ipFilterEnabled,
      'ip_filter_path': state.ipFilterPath.trim(),
      'ip_filter_trackers': state.ipFilterTrackers,
      'banned_IPs': state.bannedIps,
    };

    String? error;
    await ref
        .read(apiClientProvider)
        .post(
          ApiPath.application.setPreferences,
          data: {'json': jsonEncode(payload)},
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });

    state = state.copyWith(saving: false);
    return error;
  }

  static ({bool enabled, int value}) _limitFromApi(int? raw, int fallback) {
    final n = raw ?? -1;
    if (n <= 0) return (enabled: false, value: fallback);
    return (enabled: true, value: n);
  }
}
