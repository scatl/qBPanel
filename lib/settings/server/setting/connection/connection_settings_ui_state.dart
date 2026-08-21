import 'package:qbpanel/widget/empty/empty_state.dart';

/// WebUI「连接」页状态。
class ConnectionSettingsUiState {
  const ConnectionSettingsUiState({
    this.emptyState = const EmptyState.content(),
    this.saving = false,
    this.peerProtocol = ConnectionPeerProtocol.tcpAndUtp,
    this.listenPort = 6881,
    this.upnp = true,
    this.maxConnecEnabled = true,
    this.maxConnec = 500,
    this.maxConnecPerTorrentEnabled = true,
    this.maxConnecPerTorrent = 100,
    this.maxUploadsEnabled = true,
    this.maxUploads = 8,
    this.maxUploadsPerTorrentEnabled = true,
    this.maxUploadsPerTorrent = 4,
    this.i2pEnabled = false,
    this.i2pAddress = '127.0.0.1',
    this.i2pPort = 7656,
    this.i2pMixedMode = false,
    this.proxyType = ConnectionProxyType.none,
    this.proxyIp = '',
    this.proxyPort = 8080,
    this.proxyAuthEnabled = false,
    this.proxyUsername = '',
    this.proxyPassword = '',
    this.proxyHostnameLookup = false,
    this.proxyBittorrent = true,
    this.proxyPeerConnections = false,
    this.proxyRss = true,
    this.proxyMisc = true,
    this.ipFilterEnabled = false,
    this.ipFilterPath = '',
    this.ipFilterTrackers = false,
    this.bannedIps = '',
  });

  final EmptyState emptyState;
  final bool saving;

  final ConnectionPeerProtocol peerProtocol;
  final int listenPort;
  final bool upnp;

  final bool maxConnecEnabled;
  final int maxConnec;
  final bool maxConnecPerTorrentEnabled;
  final int maxConnecPerTorrent;
  final bool maxUploadsEnabled;
  final int maxUploads;
  final bool maxUploadsPerTorrentEnabled;
  final int maxUploadsPerTorrent;

  final bool i2pEnabled;
  final String i2pAddress;
  final int i2pPort;
  final bool i2pMixedMode;

  final ConnectionProxyType proxyType;
  final String proxyIp;
  final int proxyPort;
  final bool proxyAuthEnabled;
  final String proxyUsername;
  final String proxyPassword;
  final bool proxyHostnameLookup;
  final bool proxyBittorrent;
  final bool proxyPeerConnections;
  final bool proxyRss;
  final bool proxyMisc;

  final bool ipFilterEnabled;
  final String ipFilterPath;
  final bool ipFilterTrackers;
  final String bannedIps;

  bool get ready => emptyState.ready;

  bool get proxyEnabled => proxyType != ConnectionProxyType.none;

  bool get proxySupportsAuth =>
      proxyEnabled && proxyType != ConnectionProxyType.socks4;

  ConnectionSettingsUiState copyWith({
    EmptyState? emptyState,
    bool? saving,
    ConnectionPeerProtocol? peerProtocol,
    int? listenPort,
    bool? upnp,
    bool? maxConnecEnabled,
    int? maxConnec,
    bool? maxConnecPerTorrentEnabled,
    int? maxConnecPerTorrent,
    bool? maxUploadsEnabled,
    int? maxUploads,
    bool? maxUploadsPerTorrentEnabled,
    int? maxUploadsPerTorrent,
    bool? i2pEnabled,
    String? i2pAddress,
    int? i2pPort,
    bool? i2pMixedMode,
    ConnectionProxyType? proxyType,
    String? proxyIp,
    int? proxyPort,
    bool? proxyAuthEnabled,
    String? proxyUsername,
    String? proxyPassword,
    bool? proxyHostnameLookup,
    bool? proxyBittorrent,
    bool? proxyPeerConnections,
    bool? proxyRss,
    bool? proxyMisc,
    bool? ipFilterEnabled,
    String? ipFilterPath,
    bool? ipFilterTrackers,
    String? bannedIps,
  }) {
    return ConnectionSettingsUiState(
      emptyState: emptyState ?? this.emptyState,
      saving: saving ?? this.saving,
      peerProtocol: peerProtocol ?? this.peerProtocol,
      listenPort: listenPort ?? this.listenPort,
      upnp: upnp ?? this.upnp,
      maxConnecEnabled: maxConnecEnabled ?? this.maxConnecEnabled,
      maxConnec: maxConnec ?? this.maxConnec,
      maxConnecPerTorrentEnabled:
          maxConnecPerTorrentEnabled ?? this.maxConnecPerTorrentEnabled,
      maxConnecPerTorrent: maxConnecPerTorrent ?? this.maxConnecPerTorrent,
      maxUploadsEnabled: maxUploadsEnabled ?? this.maxUploadsEnabled,
      maxUploads: maxUploads ?? this.maxUploads,
      maxUploadsPerTorrentEnabled:
          maxUploadsPerTorrentEnabled ?? this.maxUploadsPerTorrentEnabled,
      maxUploadsPerTorrent:
          maxUploadsPerTorrent ?? this.maxUploadsPerTorrent,
      i2pEnabled: i2pEnabled ?? this.i2pEnabled,
      i2pAddress: i2pAddress ?? this.i2pAddress,
      i2pPort: i2pPort ?? this.i2pPort,
      i2pMixedMode: i2pMixedMode ?? this.i2pMixedMode,
      proxyType: proxyType ?? this.proxyType,
      proxyIp: proxyIp ?? this.proxyIp,
      proxyPort: proxyPort ?? this.proxyPort,
      proxyAuthEnabled: proxyAuthEnabled ?? this.proxyAuthEnabled,
      proxyUsername: proxyUsername ?? this.proxyUsername,
      proxyPassword: proxyPassword ?? this.proxyPassword,
      proxyHostnameLookup: proxyHostnameLookup ?? this.proxyHostnameLookup,
      proxyBittorrent: proxyBittorrent ?? this.proxyBittorrent,
      proxyPeerConnections:
          proxyPeerConnections ?? this.proxyPeerConnections,
      proxyRss: proxyRss ?? this.proxyRss,
      proxyMisc: proxyMisc ?? this.proxyMisc,
      ipFilterEnabled: ipFilterEnabled ?? this.ipFilterEnabled,
      ipFilterPath: ipFilterPath ?? this.ipFilterPath,
      ipFilterTrackers: ipFilterTrackers ?? this.ipFilterTrackers,
      bannedIps: bannedIps ?? this.bannedIps,
    );
  }
}

/// `bittorrent_protocol`
enum ConnectionPeerProtocol {
  tcpAndUtp('TCP 和 μTP', 0),
  tcp('TCP', 1),
  utp('μTP', 2);

  const ConnectionPeerProtocol(this.label, this.apiValue);
  final String label;
  final int apiValue;

  static ConnectionPeerProtocol fromApi(int? value) {
    for (final item in values) {
      if (item.apiValue == value) return item;
    }
    return ConnectionPeerProtocol.tcpAndUtp;
  }
}

/// 5.x `proxy_type` 字符串。
enum ConnectionProxyType {
  none('(无)', 'None'),
  socks4('SOCKS4', 'SOCKS4'),
  socks5('SOCKS5', 'SOCKS5'),
  http('HTTP', 'HTTP');

  const ConnectionProxyType(this.label, this.apiValue);
  final String label;
  final String apiValue;

  static ConnectionProxyType fromApi(String? value) {
    final raw = value?.trim();
    if (raw == null || raw.isEmpty) return ConnectionProxyType.none;
    for (final item in values) {
      if (item.apiValue.toLowerCase() == raw.toLowerCase()) return item;
    }
    return ConnectionProxyType.none;
  }
}
