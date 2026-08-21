import 'package:qbpanel/api/entity/response/json_read.dart';
import 'package:qbpanel/api/entity/response/torrent_state.dart';

/// 单条种子字段，形状与 `/api/v2/torrents/info` 单项相同。
///
/// 与 `sync/maindata.torrents[hash]` 同源（qB `serialize_torrent`）。
/// 官方 Wiki「Get torrent list」表格不完整，本实体按源码键补全。
/// 增量包常只含变化字段，故全部可空；用 [merge] 合并。
class TorrentInfoResponse {
  const TorrentInfoResponse({
    this.addedOn,
    this.amountLeft,
    this.autoTmm,
    this.availability,
    this.category,
    this.comment,
    this.completed,
    this.completionOn,
    this.connectionsCount,
    this.connectionsLimit,
    this.contentPath,
    this.createdBy,
    this.creationDate,
    this.dlLimit,
    this.dlspeed,
    this.downloadPath,
    this.downloaded,
    this.downloadedSession,
    this.eta,
    this.fLPiecePrio,
    this.forceStart,
    this.hasMetadata,
    this.hash,
    this.infohashV1,
    this.infohashV2,
    this.inactiveSeedingTimeLimit,
    this.isPrivate,
    this.lastActivity,
    this.magnetUri,
    this.maxInactiveSeedingTime,
    this.maxRatio,
    this.maxSeedingTime,
    this.name,
    this.numComplete,
    this.numIncomplete,
    this.numLeechs,
    this.numSeeds,
    this.pieceSize,
    this.piecesHave,
    this.piecesNum,
    this.popularity,
    this.priority,
    this.progress,
    this.ratio,
    this.ratioLimit,
    this.reannounce,
    this.rootPath,
    this.savePath,
    this.seedingTime,
    this.seedingTimeLimit,
    this.seenComplete,
    this.seqDl,
    this.shareLimitAction,
    this.shareLimitsMode,
    this.size,
    this.state,
    this.superSeeding,
    this.tags,
    this.timeActive,
    this.totalSize,
    this.totalWasted,
    this.tracker,
    this.trackersCount,
    this.upLimit,
    this.uploaded,
    this.uploadedSession,
    this.upspeed,
  });

  final int? addedOn;
  final int? amountLeft;
  final bool? autoTmm;
  final double? availability;
  final String? category;
  final String? comment;
  final int? completed;
  final int? completionOn;
  final int? connectionsCount;
  final int? connectionsLimit;
  final String? contentPath;
  final String? createdBy;
  final int? creationDate;
  final int? dlLimit;
  final int? dlspeed;
  final String? downloadPath;
  final int? downloaded;
  final int? downloadedSession;
  final int? eta;
  final bool? fLPiecePrio;
  final bool? forceStart;
  final bool? hasMetadata;
  final String? hash;
  final String? infohashV1;
  final String? infohashV2;
  final int? inactiveSeedingTimeLimit;

  /// 列表项 JSON 键为 `private`（serialize）；Wiki / properties 写 `isPrivate`。
  final bool? isPrivate;
  final int? lastActivity;
  final String? magnetUri;
  final int? maxInactiveSeedingTime;
  final double? maxRatio;
  final int? maxSeedingTime;
  final String? name;
  final int? numComplete;
  final int? numIncomplete;
  final int? numLeechs;
  final int? numSeeds;
  final int? pieceSize;
  final int? piecesHave;
  final int? piecesNum;
  final double? popularity;
  final int? priority;
  final double? progress;
  final double? ratio;
  final double? ratioLimit;
  final int? reannounce;
  final String? rootPath;
  final String? savePath;
  final int? seedingTime;
  final int? seedingTimeLimit;
  final int? seenComplete;
  final bool? seqDl;
  final String? shareLimitAction;
  final String? shareLimitsMode;
  final int? size;

  /// 如 `downloading` / `uploading` / `stoppedDL` 等。
  final TorrentState? state;
  final bool? superSeeding;

  /// 逗号分隔标签列表。
  final String? tags;
  final int? timeActive;
  final int? totalSize;

  /// 浪费数据量（bytes）：校验失败、重复块等。
  final int? totalWasted;
  final String? tracker;
  final int? trackersCount;
  final int? upLimit;
  final int? uploaded;
  final int? uploadedSession;
  final int? upspeed;

  factory TorrentInfoResponse.fromJson(Map<String, dynamic> json) {
    return TorrentInfoResponse(
      addedOn: readInt(json['added_on']),
      amountLeft: readInt(json['amount_left']),
      autoTmm: readBool(json['auto_tmm']),
      availability: readDouble(json['availability']),
      category: readString(json['category']),
      comment: readString(json['comment']),
      completed: readInt(json['completed']),
      completionOn: readInt(json['completion_on']),
      connectionsCount: readInt(json['connections_count']),
      connectionsLimit: readInt(json['connections_limit']),
      contentPath: readString(json['content_path']),
      createdBy: readString(json['created_by']),
      creationDate: readInt(json['creation_date']),
      dlLimit: readInt(json['dl_limit']),
      dlspeed: readInt(json['dlspeed']),
      downloadPath: readString(json['download_path']),
      downloaded: readInt(json['downloaded']),
      downloadedSession: readInt(json['downloaded_session']),
      eta: readInt(json['eta']),
      fLPiecePrio: readBool(json['f_l_piece_prio']),
      forceStart: readBool(json['force_start']),
      hasMetadata: readBool(json['has_metadata']),
      hash: readString(json['hash']),
      infohashV1: readString(json['infohash_v1']),
      infohashV2: readString(json['infohash_v2']),
      inactiveSeedingTimeLimit: readInt(json['inactive_seeding_time_limit']),
      isPrivate: readBool(json['private'] ?? json['isPrivate']),
      lastActivity: readInt(json['last_activity']),
      magnetUri: readString(json['magnet_uri']),
      maxInactiveSeedingTime: readInt(json['max_inactive_seeding_time']),
      maxRatio: readDouble(json['max_ratio']),
      maxSeedingTime: readInt(json['max_seeding_time']),
      name: readString(json['name']),
      numComplete: readInt(json['num_complete']),
      numIncomplete: readInt(json['num_incomplete']),
      numLeechs: readInt(json['num_leechs']),
      numSeeds: readInt(json['num_seeds']),
      pieceSize: readInt(json['piece_size']),
      piecesHave: readInt(json['pieces_have']),
      piecesNum: readInt(json['pieces_num']),
      popularity: readDouble(json['popularity']),
      priority: readInt(json['priority']),
      progress: readDouble(json['progress']),
      ratio: readDouble(json['ratio']),
      ratioLimit: readDouble(json['ratio_limit']),
      reannounce: readInt(json['reannounce']),
      rootPath: readString(json['root_path']),
      savePath: readString(json['save_path']),
      seedingTime: readInt(json['seeding_time']),
      seedingTimeLimit: readInt(json['seeding_time_limit']),
      seenComplete: readInt(json['seen_complete']),
      seqDl: readBool(json['seq_dl']),
      shareLimitAction: readString(json['share_limit_action']),
      shareLimitsMode: readString(json['share_limits_mode']),
      size: readInt(json['size']),
      state: TorrentState.fromApi(readString(json['state'])),
      superSeeding: readBool(json['super_seeding']),
      tags: readString(json['tags']),
      timeActive: readInt(json['time_active']),
      totalSize: readInt(json['total_size']),
      totalWasted: readInt(json['total_wasted']),
      tracker: readString(json['tracker']),
      trackersCount: readInt(json['trackers_count']),
      upLimit: readInt(json['up_limit']),
      uploaded: readInt(json['uploaded']),
      uploadedSession: readInt(json['uploaded_session']),
      upspeed: readInt(json['upspeed']),
    );
  }

  Map<String, dynamic> toJson() => {
        if (addedOn != null) 'added_on': addedOn,
        if (amountLeft != null) 'amount_left': amountLeft,
        if (autoTmm != null) 'auto_tmm': autoTmm,
        if (availability != null) 'availability': availability,
        if (category != null) 'category': category,
        if (comment != null) 'comment': comment,
        if (completed != null) 'completed': completed,
        if (completionOn != null) 'completion_on': completionOn,
        if (connectionsCount != null) 'connections_count': connectionsCount,
        if (connectionsLimit != null) 'connections_limit': connectionsLimit,
        if (contentPath != null) 'content_path': contentPath,
        if (createdBy != null) 'created_by': createdBy,
        if (creationDate != null) 'creation_date': creationDate,
        if (dlLimit != null) 'dl_limit': dlLimit,
        if (dlspeed != null) 'dlspeed': dlspeed,
        if (downloadPath != null) 'download_path': downloadPath,
        if (downloaded != null) 'downloaded': downloaded,
        if (downloadedSession != null) 'downloaded_session': downloadedSession,
        if (eta != null) 'eta': eta,
        if (fLPiecePrio != null) 'f_l_piece_prio': fLPiecePrio,
        if (forceStart != null) 'force_start': forceStart,
        if (hasMetadata != null) 'has_metadata': hasMetadata,
        if (hash != null) 'hash': hash,
        if (infohashV1 != null) 'infohash_v1': infohashV1,
        if (infohashV2 != null) 'infohash_v2': infohashV2,
        if (inactiveSeedingTimeLimit != null)
          'inactive_seeding_time_limit': inactiveSeedingTimeLimit,
        if (isPrivate != null) 'private': isPrivate,
        if (lastActivity != null) 'last_activity': lastActivity,
        if (magnetUri != null) 'magnet_uri': magnetUri,
        if (maxInactiveSeedingTime != null)
          'max_inactive_seeding_time': maxInactiveSeedingTime,
        if (maxRatio != null) 'max_ratio': maxRatio,
        if (maxSeedingTime != null) 'max_seeding_time': maxSeedingTime,
        if (name != null) 'name': name,
        if (numComplete != null) 'num_complete': numComplete,
        if (numIncomplete != null) 'num_incomplete': numIncomplete,
        if (numLeechs != null) 'num_leechs': numLeechs,
        if (numSeeds != null) 'num_seeds': numSeeds,
        if (pieceSize != null) 'piece_size': pieceSize,
        if (piecesHave != null) 'pieces_have': piecesHave,
        if (piecesNum != null) 'pieces_num': piecesNum,
        if (popularity != null) 'popularity': popularity,
        if (priority != null) 'priority': priority,
        if (progress != null) 'progress': progress,
        if (ratio != null) 'ratio': ratio,
        if (ratioLimit != null) 'ratio_limit': ratioLimit,
        if (reannounce != null) 'reannounce': reannounce,
        if (rootPath != null) 'root_path': rootPath,
        if (savePath != null) 'save_path': savePath,
        if (seedingTime != null) 'seeding_time': seedingTime,
        if (seedingTimeLimit != null) 'seeding_time_limit': seedingTimeLimit,
        if (seenComplete != null) 'seen_complete': seenComplete,
        if (seqDl != null) 'seq_dl': seqDl,
        if (shareLimitAction != null) 'share_limit_action': shareLimitAction,
        if (shareLimitsMode != null) 'share_limits_mode': shareLimitsMode,
        if (size != null) 'size': size,
        if (state != null) 'state': state!.apiValue,
        if (superSeeding != null) 'super_seeding': superSeeding,
        if (tags != null) 'tags': tags,
        if (timeActive != null) 'time_active': timeActive,
        if (totalSize != null) 'total_size': totalSize,
        if (totalWasted != null) 'total_wasted': totalWasted,
        if (tracker != null) 'tracker': tracker,
        if (trackersCount != null) 'trackers_count': trackersCount,
        if (upLimit != null) 'up_limit': upLimit,
        if (uploaded != null) 'uploaded': uploaded,
        if (uploadedSession != null) 'uploaded_session': uploadedSession,
        if (upspeed != null) 'upspeed': upspeed,
      };

  TorrentInfoResponse merge(TorrentInfoResponse patch) {
    return TorrentInfoResponse(
      addedOn: patch.addedOn ?? addedOn,
      amountLeft: patch.amountLeft ?? amountLeft,
      autoTmm: patch.autoTmm ?? autoTmm,
      availability: patch.availability ?? availability,
      category: patch.category ?? category,
      comment: patch.comment ?? comment,
      completed: patch.completed ?? completed,
      completionOn: patch.completionOn ?? completionOn,
      connectionsCount: patch.connectionsCount ?? connectionsCount,
      connectionsLimit: patch.connectionsLimit ?? connectionsLimit,
      contentPath: patch.contentPath ?? contentPath,
      createdBy: patch.createdBy ?? createdBy,
      creationDate: patch.creationDate ?? creationDate,
      dlLimit: patch.dlLimit ?? dlLimit,
      dlspeed: patch.dlspeed ?? dlspeed,
      downloadPath: patch.downloadPath ?? downloadPath,
      downloaded: patch.downloaded ?? downloaded,
      downloadedSession: patch.downloadedSession ?? downloadedSession,
      eta: patch.eta ?? eta,
      fLPiecePrio: patch.fLPiecePrio ?? fLPiecePrio,
      forceStart: patch.forceStart ?? forceStart,
      hasMetadata: patch.hasMetadata ?? hasMetadata,
      hash: patch.hash ?? hash,
      infohashV1: patch.infohashV1 ?? infohashV1,
      infohashV2: patch.infohashV2 ?? infohashV2,
      inactiveSeedingTimeLimit:
          patch.inactiveSeedingTimeLimit ?? inactiveSeedingTimeLimit,
      isPrivate: patch.isPrivate ?? isPrivate,
      lastActivity: patch.lastActivity ?? lastActivity,
      magnetUri: patch.magnetUri ?? magnetUri,
      maxInactiveSeedingTime:
          patch.maxInactiveSeedingTime ?? maxInactiveSeedingTime,
      maxRatio: patch.maxRatio ?? maxRatio,
      maxSeedingTime: patch.maxSeedingTime ?? maxSeedingTime,
      name: patch.name ?? name,
      numComplete: patch.numComplete ?? numComplete,
      numIncomplete: patch.numIncomplete ?? numIncomplete,
      numLeechs: patch.numLeechs ?? numLeechs,
      numSeeds: patch.numSeeds ?? numSeeds,
      pieceSize: patch.pieceSize ?? pieceSize,
      piecesHave: patch.piecesHave ?? piecesHave,
      piecesNum: patch.piecesNum ?? piecesNum,
      popularity: patch.popularity ?? popularity,
      priority: patch.priority ?? priority,
      progress: patch.progress ?? progress,
      ratio: patch.ratio ?? ratio,
      ratioLimit: patch.ratioLimit ?? ratioLimit,
      reannounce: patch.reannounce ?? reannounce,
      rootPath: patch.rootPath ?? rootPath,
      savePath: patch.savePath ?? savePath,
      seedingTime: patch.seedingTime ?? seedingTime,
      seedingTimeLimit: patch.seedingTimeLimit ?? seedingTimeLimit,
      seenComplete: patch.seenComplete ?? seenComplete,
      seqDl: patch.seqDl ?? seqDl,
      shareLimitAction: patch.shareLimitAction ?? shareLimitAction,
      shareLimitsMode: patch.shareLimitsMode ?? shareLimitsMode,
      size: patch.size ?? size,
      state: patch.state ?? state,
      superSeeding: patch.superSeeding ?? superSeeding,
      tags: patch.tags ?? tags,
      timeActive: patch.timeActive ?? timeActive,
      totalSize: patch.totalSize ?? totalSize,
      totalWasted: patch.totalWasted ?? totalWasted,
      tracker: patch.tracker ?? tracker,
      trackersCount: patch.trackersCount ?? trackersCount,
      upLimit: patch.upLimit ?? upLimit,
      uploaded: patch.uploaded ?? uploaded,
      uploadedSession: patch.uploadedSession ?? uploadedSession,
      upspeed: patch.upspeed ?? upspeed,
    );
  }
}
