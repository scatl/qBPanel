import 'package:qbpanel/api/entity/response/json_read.dart';

/// `/api/v2/torrents/properties` 响应。
///
/// Wiki 表格不完整，字段按 qB 5.x `propertiesAction` + WebUI `prop-general.js`。
class TorrentPropertiesResponse {
  const TorrentPropertiesResponse({
    this.hash,
    this.name,
    this.savePath,
    this.downloadPath,
    this.creationDate,
    this.pieceSize,
    this.comment,
    this.totalWasted,
    this.totalUploaded,
    this.totalUploadedSession,
    this.totalDownloaded,
    this.totalDownloadedSession,
    this.upLimit,
    this.dlLimit,
    this.timeElapsed,
    this.seedingTime,
    this.nbConnections,
    this.nbConnectionsLimit,
    this.shareRatio,
    this.popularity,
    this.availability,
    this.progress,
    this.additionDate,
    this.completionDate,
    this.createdBy,
    this.dlSpeedAvg,
    this.dlSpeed,
    this.eta,
    this.lastSeen,
    this.peers,
    this.peersTotal,
    this.piecesHave,
    this.piecesNum,
    this.reannounce,
    this.seeds,
    this.seedsTotal,
    this.totalSize,
    this.upSpeedAvg,
    this.upSpeed,
    this.isPrivate,
    this.hasMetadata,
    this.infohashV1,
    this.infohashV2,
  });

  final String? hash;
  final String? name;
  final String? savePath;
  final String? downloadPath;
  final int? creationDate;
  final int? pieceSize;
  final String? comment;

  /// 浪费的数据量（bytes）：校验失败、重复块等。
  final int? totalWasted;
  final int? totalUploaded;
  final int? totalUploadedSession;
  final int? totalDownloaded;
  final int? totalDownloadedSession;
  final int? upLimit;
  final int? dlLimit;
  final int? timeElapsed;
  final int? seedingTime;
  final int? nbConnections;
  final int? nbConnectionsLimit;
  final double? shareRatio;
  final double? popularity;
  final double? availability;
  final double? progress;
  final int? additionDate;
  final int? completionDate;
  final String? createdBy;
  final int? dlSpeedAvg;
  final int? dlSpeed;
  final int? eta;
  final int? lastSeen;
  final int? peers;
  final int? peersTotal;
  final int? piecesHave;
  final int? piecesNum;
  final int? reannounce;
  final int? seeds;
  final int? seedsTotal;
  final int? totalSize;
  final int? upSpeedAvg;
  final int? upSpeed;

  /// JSON 键为 `private`；旧键 `isPrivate` / `is_private` 一并读。
  final bool? isPrivate;
  final bool? hasMetadata;
  final String? infohashV1;
  final String? infohashV2;

  factory TorrentPropertiesResponse.fromJson(Map<String, dynamic> json) {
    return TorrentPropertiesResponse(
      hash: readString(json['hash']),
      name: readString(json['name']),
      savePath: readString(json['save_path']),
      downloadPath: readString(json['download_path']),
      creationDate: readInt(json['creation_date']),
      pieceSize: readInt(json['piece_size']),
      comment: readString(json['comment']),
      totalWasted: readInt(json['total_wasted']),
      totalUploaded: readInt(json['total_uploaded']),
      totalUploadedSession: readInt(json['total_uploaded_session']),
      totalDownloaded: readInt(json['total_downloaded']),
      totalDownloadedSession: readInt(json['total_downloaded_session']),
      upLimit: readInt(json['up_limit']),
      dlLimit: readInt(json['dl_limit']),
      timeElapsed: readInt(json['time_elapsed']),
      seedingTime: readInt(json['seeding_time']),
      nbConnections: readInt(json['nb_connections']),
      nbConnectionsLimit: readInt(json['nb_connections_limit']),
      shareRatio: readDouble(json['share_ratio']),
      popularity: readDouble(json['popularity']),
      availability: readDouble(json['availability']),
      progress: readDouble(json['progress']),
      additionDate: readInt(json['addition_date']),
      completionDate: readInt(json['completion_date']),
      createdBy: readString(json['created_by']),
      dlSpeedAvg: readInt(json['dl_speed_avg']),
      dlSpeed: readInt(json['dl_speed']),
      eta: readInt(json['eta']),
      lastSeen: readInt(json['last_seen']),
      peers: readInt(json['peers']),
      peersTotal: readInt(json['peers_total']),
      piecesHave: readInt(json['pieces_have']),
      piecesNum: readInt(json['pieces_num']),
      reannounce: readInt(json['reannounce']),
      seeds: readInt(json['seeds']),
      seedsTotal: readInt(json['seeds_total']),
      totalSize: readInt(json['total_size']),
      upSpeedAvg: readInt(json['up_speed_avg']),
      upSpeed: readInt(json['up_speed']),
      isPrivate: readBool(
        json['private'] ?? json['isPrivate'] ?? json['is_private'],
      ),
      hasMetadata: readBool(json['has_metadata']),
      infohashV1: readString(json['infohash_v1']),
      infohashV2: readString(json['infohash_v2']),
    );
  }

  Map<String, dynamic> toJson() => {
        if (hash != null) 'hash': hash,
        if (name != null) 'name': name,
        if (savePath != null) 'save_path': savePath,
        if (downloadPath != null) 'download_path': downloadPath,
        if (creationDate != null) 'creation_date': creationDate,
        if (pieceSize != null) 'piece_size': pieceSize,
        if (comment != null) 'comment': comment,
        if (totalWasted != null) 'total_wasted': totalWasted,
        if (totalUploaded != null) 'total_uploaded': totalUploaded,
        if (totalUploadedSession != null)
          'total_uploaded_session': totalUploadedSession,
        if (totalDownloaded != null) 'total_downloaded': totalDownloaded,
        if (totalDownloadedSession != null)
          'total_downloaded_session': totalDownloadedSession,
        if (upLimit != null) 'up_limit': upLimit,
        if (dlLimit != null) 'dl_limit': dlLimit,
        if (timeElapsed != null) 'time_elapsed': timeElapsed,
        if (seedingTime != null) 'seeding_time': seedingTime,
        if (nbConnections != null) 'nb_connections': nbConnections,
        if (nbConnectionsLimit != null)
          'nb_connections_limit': nbConnectionsLimit,
        if (shareRatio != null) 'share_ratio': shareRatio,
        if (popularity != null) 'popularity': popularity,
        if (availability != null) 'availability': availability,
        if (progress != null) 'progress': progress,
        if (additionDate != null) 'addition_date': additionDate,
        if (completionDate != null) 'completion_date': completionDate,
        if (createdBy != null) 'created_by': createdBy,
        if (dlSpeedAvg != null) 'dl_speed_avg': dlSpeedAvg,
        if (dlSpeed != null) 'dl_speed': dlSpeed,
        if (eta != null) 'eta': eta,
        if (lastSeen != null) 'last_seen': lastSeen,
        if (peers != null) 'peers': peers,
        if (peersTotal != null) 'peers_total': peersTotal,
        if (piecesHave != null) 'pieces_have': piecesHave,
        if (piecesNum != null) 'pieces_num': piecesNum,
        if (reannounce != null) 'reannounce': reannounce,
        if (seeds != null) 'seeds': seeds,
        if (seedsTotal != null) 'seeds_total': seedsTotal,
        if (totalSize != null) 'total_size': totalSize,
        if (upSpeedAvg != null) 'up_speed_avg': upSpeedAvg,
        if (upSpeed != null) 'up_speed': upSpeed,
        if (isPrivate != null) 'private': isPrivate,
        if (hasMetadata != null) 'has_metadata': hasMetadata,
        if (infohashV1 != null) 'infohash_v1': infohashV1,
        if (infohashV2 != null) 'infohash_v2': infohashV2,
      };
}
