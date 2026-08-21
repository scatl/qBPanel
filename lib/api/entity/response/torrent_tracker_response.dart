import 'package:qbpanel/api/entity/response/json_read.dart';

/// `/api/v2/torrents/trackers` 单项。
class TorrentTrackerResponse {
  const TorrentTrackerResponse({
    required this.url,
    this.tier,
    this.updating = false,
    this.status,
    this.msg,
    this.numPeers,
    this.numSeeds,
    this.numLeeches,
    this.numDownloaded,
    this.nextAnnounce,
    this.minAnnounce,
    this.endpoints = const [],
  });

  /// Tracker URL；DHT / PeX / LSD 为 `** [DHT] **` 这类占位。
  final String url;
  final int? tier;
  final bool updating;

  /// `0` 禁用 / `1` 尚未联系 / `2` 工作 / `3` 正在更新（旧版）/
  /// `4` 未工作 / `5` Tracker 错误 / `6` 无法访问。
  final int? status;
  final String? msg;
  final int? numPeers;
  final int? numSeeds;
  final int? numLeeches;
  final int? numDownloaded;

  /// Unix 秒；剩余时间 = 该值 − 当前时间。
  final int? nextAnnounce;
  final int? minAnnounce;
  final List<TorrentTrackerEndpoint> endpoints;

  bool get hasEndpoints => endpoints.isNotEmpty;

  bool get isSpecial {
    return url.startsWith('** [') && url.endsWith('] **');
  }

  /// 卡片标题：特殊项显示 `DHT` / `PeX` / `LSD`，其余为原始 URL。
  String get displayName {
    if (!isSpecial) return url;
    return url.substring(4, url.length - 4);
  }

  TorrentTrackerResponse copyWith({List<TorrentTrackerEndpoint>? endpoints}) {
    return TorrentTrackerResponse(
      url: url,
      tier: tier,
      updating: updating,
      status: status,
      msg: msg,
      numPeers: numPeers,
      numSeeds: numSeeds,
      numLeeches: numLeeches,
      numDownloaded: numDownloaded,
      nextAnnounce: nextAnnounce,
      minAnnounce: minAnnounce,
      endpoints: endpoints ?? this.endpoints,
    );
  }

  factory TorrentTrackerResponse.fromJson(Map<String, dynamic> json) {
    return TorrentTrackerResponse(
      url: readString(json['url']) ?? '',
      tier: readInt(json['tier']),
      updating: readBool(json['updating']) ?? false,
      status: readInt(json['status']),
      msg: readString(json['msg']),
      numPeers: readInt(json['num_peers']),
      numSeeds: readInt(json['num_seeds']),
      numLeeches: readInt(json['num_leeches']),
      numDownloaded: readInt(json['num_downloaded']),
      nextAnnounce: readInt(json['next_announce']),
      minAnnounce: readInt(json['min_announce']),
      endpoints: parseTrackerEndpoints(json['endpoints']),
    );
  }
}

/// Tracker 下的宣告端点（IPv4/IPv6 × BT v1/v2）。
class TorrentTrackerEndpoint {
  const TorrentTrackerEndpoint({
    required this.name,
    this.updating = false,
    this.status,
    this.msg,
    this.btVersion,
    this.numPeers,
    this.numSeeds,
    this.numLeeches,
    this.numDownloaded,
    this.nextAnnounce,
    this.minAnnounce,
  });

  /// 端点地址，一般为 `ip:port`。
  final String name;
  final bool updating;
  final int? status;
  final String? msg;
  final int? btVersion;
  final int? numPeers;
  final int? numSeeds;
  final int? numLeeches;
  final int? numDownloaded;
  final int? nextAnnounce;
  final int? minAnnounce;

  String get btProtocolLabel {
    if (btVersion == null) return '—';
    return 'v$btVersion';
  }

  factory TorrentTrackerEndpoint.fromJson(Map<String, dynamic> json) {
    return TorrentTrackerEndpoint(
      name: readString(json['name']) ?? '',
      updating: readBool(json['updating']) ?? false,
      status: readInt(json['status']),
      msg: readString(json['msg']),
      btVersion: readInt(json['bt_version']),
      numPeers: readInt(json['num_peers']),
      numSeeds: readInt(json['num_seeds']),
      numLeeches: readInt(json['num_leeches']),
      numDownloaded: readInt(json['num_downloaded']),
      nextAnnounce: readInt(json['next_announce']),
      minAnnounce: readInt(json['min_announce']),
    );
  }
}

List<TorrentTrackerEndpoint> parseTrackerEndpoints(dynamic data) {
  if (data is! List) return const [];
  return [
    for (final item in data)
      if (item is Map)
        TorrentTrackerEndpoint.fromJson(Map<String, dynamic>.from(item)),
  ];
}

List<TorrentTrackerResponse> parseTorrentTrackers(dynamic data) {
  if (data is! List) return const [];
  return [
    for (final item in data)
      if (item is Map)
        TorrentTrackerResponse.fromJson(Map<String, dynamic>.from(item)),
  ];
}
