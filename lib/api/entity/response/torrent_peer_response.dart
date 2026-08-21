import 'package:qbpanel/api/entity/response/json_read.dart';

/// `/api/v2/sync/torrentPeers` 里 `peers` 的一项。
class TorrentPeerResponse {
  const TorrentPeerResponse({
    required this.id,
    this.client,
    this.peerIdClient,
    this.connection,
    this.country,
    this.countryCode,
    this.dlSpeed,
    this.upSpeed,
    this.downloaded,
    this.uploaded,
    this.files,
    this.flags,
    this.flagsDesc,
    this.hostName,
    this.ip,
    this.i2pDest,
    this.port,
    this.progress,
    this.relevance,
    this.contribution,
  });

  /// 同步表的 key，一般为 `ip:port` 或 I2P 地址。
  final String id;
  final String? client;
  final String? peerIdClient;
  final String? connection;
  final String? country;
  final String? countryCode;
  final int? dlSpeed;
  final int? upSpeed;
  final int? downloaded;
  final int? uploaded;
  final String? files;
  final String? flags;
  final String? flagsDesc;
  final String? hostName;
  final String? ip;
  final String? i2pDest;
  final int? port;

  /// 0–1。
  final double? progress;
  final double? relevance;
  final double? contribution;

  /// 复制 / 封禁用的 `ip:port` 或 I2P 地址。
  String get endpoint {
    final dest = i2pDest?.trim();
    if (dest != null && dest.isNotEmpty) return dest;
    final host = ip?.trim();
    if (host != null && host.isNotEmpty) {
      if (port == null) return host;
      final needsBrackets = host.contains(':') && !host.startsWith('[');
      return needsBrackets ? '[$host]:$port' : '$host:$port';
    }
    return id;
  }

  String get displayName {
    final name = hostName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return endpoint;
  }

  factory TorrentPeerResponse.fromJson(String id, Map<String, dynamic> json) {
    return TorrentPeerResponse(
      id: id,
      client: readString(json['client']),
      peerIdClient: readString(json['peer_id_client']),
      connection: readString(json['connection']),
      country: readString(json['country']),
      countryCode: readString(json['country_code']),
      dlSpeed: readInt(json['dl_speed']),
      upSpeed: readInt(json['up_speed']),
      downloaded: readInt(json['downloaded']),
      uploaded: readInt(json['uploaded']),
      files: readString(json['files']),
      flags: readString(json['flags']),
      flagsDesc: readString(json['flags_desc']),
      hostName: readString(json['host_name']),
      ip: readString(json['ip']),
      i2pDest: readString(json['i2p_dest']),
      port: readInt(json['port']),
      progress: readDouble(json['progress']),
      relevance: readDouble(json['relevance']),
      contribution: readDouble(json['contribution']),
    );
  }
}

class TorrentPeersSyncResponse {
  const TorrentPeersSyncResponse({
    this.rid,
    this.fullUpdate = true,
    this.showFlags = false,
    this.peers = const [],
  });

  final int? rid;
  final bool fullUpdate;
  final bool showFlags;
  final List<TorrentPeerResponse> peers;
}

TorrentPeersSyncResponse parseTorrentPeers(dynamic data) {
  final map = readMap(data);
  if (map == null) return const TorrentPeersSyncResponse();

  final peersRaw = readMap(map['peers']);
  final peers = <TorrentPeerResponse>[];
  if (peersRaw != null) {
    for (final entry in peersRaw.entries) {
      final value = entry.value;
      if (value is! Map) continue;
      peers.add(
        TorrentPeerResponse.fromJson(
          entry.key,
          Map<String, dynamic>.from(value),
        ),
      );
    }
  }
  peers.sort((a, b) => a.id.toLowerCase().compareTo(b.id.toLowerCase()));

  return TorrentPeersSyncResponse(
    rid: readInt(map['rid']),
    fullUpdate: readBool(map['full_update']) ?? true,
    showFlags: readBool(map['show_flags']) ?? false,
    peers: peers,
  );
}
