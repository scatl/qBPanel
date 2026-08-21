import 'package:qbpanel/api/entity/response/connection_status.dart';
import 'package:qbpanel/api/entity/response/json_read.dart';

/// `server_state` from `/api/v2/sync/maindata`（含 transfer info + 同步附加字段）.
///
/// 增量同步时各字段均可缺省；[merge] 用非 null 覆盖。
class ServerStateResponse {
  const ServerStateResponse({
    this.alltimeDl,
    this.alltimeUl,
    this.averageTimeQueue,
    this.connectionStatus,
    this.dhtNodes,
    this.dlInfoData,
    this.dlInfoSpeed,
    this.dlRateLimit,
    this.freeSpaceOnDisk,
    this.globalRatio,
    this.lastExternalAddressV4,
    this.lastExternalAddressV6,
    this.queuedIoJobs,
    this.queuedTrackerAnnounces,
    this.queueing,
    this.readCacheHits,
    this.readCacheOverload,
    this.refreshInterval,
    this.requestLatency,
    this.totalBuffersSize,
    this.totalPeerConnections,
    this.totalQueuedSize,
    this.totalWastedSession,
    this.upInfoData,
    this.upInfoSpeed,
    this.upRateLimit,
    this.useAltSpeedLimits,
    this.writeCacheOverload,
  });

  final int? alltimeDl;
  final int? alltimeUl;
  final int? averageTimeQueue;
  final ConnectionStatus? connectionStatus;
  final int? dhtNodes;
  final int? dlInfoData;
  final int? dlInfoSpeed;
  final int? dlRateLimit;
  final int? freeSpaceOnDisk;

  /// 可能为数字字符串或 `"-"`。
  final String? globalRatio;
  final String? lastExternalAddressV4;
  final String? lastExternalAddressV6;
  final int? queuedIoJobs;
  final int? queuedTrackerAnnounces;
  final bool? queueing;
  final String? readCacheHits;
  final String? readCacheOverload;
  final int? refreshInterval;
  final int? requestLatency;
  final int? totalBuffersSize;
  final int? totalPeerConnections;
  final int? totalQueuedSize;
  final int? totalWastedSession;
  final int? upInfoData;
  final int? upInfoSpeed;
  final int? upRateLimit;
  final bool? useAltSpeedLimits;
  final String? writeCacheOverload;

  factory ServerStateResponse.fromJson(Map<String, dynamic> json) {
    return ServerStateResponse(
      alltimeDl: readInt(json['alltime_dl']),
      alltimeUl: readInt(json['alltime_ul']),
      averageTimeQueue: readInt(json['average_time_queue']),
      connectionStatus: ConnectionStatus.fromApi(
        readString(json['connection_status']),
      ),
      dhtNodes: readInt(json['dht_nodes']),
      dlInfoData: readInt(json['dl_info_data']),
      dlInfoSpeed: readInt(json['dl_info_speed']),
      dlRateLimit: readInt(json['dl_rate_limit']),
      freeSpaceOnDisk: readInt(json['free_space_on_disk']),
      globalRatio: readString(json['global_ratio']),
      lastExternalAddressV4: readString(json['last_external_address_v4']),
      lastExternalAddressV6: readString(json['last_external_address_v6']),
      queuedIoJobs: readInt(json['queued_io_jobs']),
      queuedTrackerAnnounces: readInt(json['queued_tracker_announces']),
      queueing: readBool(json['queueing']),
      readCacheHits: readString(json['read_cache_hits']),
      readCacheOverload: readString(json['read_cache_overload']),
      refreshInterval: readInt(json['refresh_interval']),
      requestLatency: readInt(json['request_latency']),
      totalBuffersSize: readInt(json['total_buffers_size']),
      totalPeerConnections: readInt(json['total_peer_connections']),
      totalQueuedSize: readInt(json['total_queued_size']),
      totalWastedSession: readInt(json['total_wasted_session']),
      upInfoData: readInt(json['up_info_data']),
      upInfoSpeed: readInt(json['up_info_speed']),
      upRateLimit: readInt(json['up_rate_limit']),
      useAltSpeedLimits: readBool(json['use_alt_speed_limits']),
      writeCacheOverload: readString(json['write_cache_overload']),
    );
  }

  Map<String, dynamic> toJson() => {
        if (alltimeDl != null) 'alltime_dl': alltimeDl,
        if (alltimeUl != null) 'alltime_ul': alltimeUl,
        if (averageTimeQueue != null) 'average_time_queue': averageTimeQueue,
        if (connectionStatus != null)
          'connection_status': connectionStatus!.apiValue,
        if (dhtNodes != null) 'dht_nodes': dhtNodes,
        if (dlInfoData != null) 'dl_info_data': dlInfoData,
        if (dlInfoSpeed != null) 'dl_info_speed': dlInfoSpeed,
        if (dlRateLimit != null) 'dl_rate_limit': dlRateLimit,
        if (freeSpaceOnDisk != null) 'free_space_on_disk': freeSpaceOnDisk,
        if (globalRatio != null) 'global_ratio': globalRatio,
        if (lastExternalAddressV4 != null)
          'last_external_address_v4': lastExternalAddressV4,
        if (lastExternalAddressV6 != null)
          'last_external_address_v6': lastExternalAddressV6,
        if (queuedIoJobs != null) 'queued_io_jobs': queuedIoJobs,
        if (queuedTrackerAnnounces != null)
          'queued_tracker_announces': queuedTrackerAnnounces,
        if (queueing != null) 'queueing': queueing,
        if (readCacheHits != null) 'read_cache_hits': readCacheHits,
        if (readCacheOverload != null) 'read_cache_overload': readCacheOverload,
        if (refreshInterval != null) 'refresh_interval': refreshInterval,
        if (requestLatency != null) 'request_latency': requestLatency,
        if (totalBuffersSize != null) 'total_buffers_size': totalBuffersSize,
        if (totalPeerConnections != null)
          'total_peer_connections': totalPeerConnections,
        if (totalQueuedSize != null) 'total_queued_size': totalQueuedSize,
        if (totalWastedSession != null)
          'total_wasted_session': totalWastedSession,
        if (upInfoData != null) 'up_info_data': upInfoData,
        if (upInfoSpeed != null) 'up_info_speed': upInfoSpeed,
        if (upRateLimit != null) 'up_rate_limit': upRateLimit,
        if (useAltSpeedLimits != null) 'use_alt_speed_limits': useAltSpeedLimits,
        if (writeCacheOverload != null)
          'write_cache_overload': writeCacheOverload,
      };

  ServerStateResponse merge(ServerStateResponse patch) {
    return ServerStateResponse(
      alltimeDl: patch.alltimeDl ?? alltimeDl,
      alltimeUl: patch.alltimeUl ?? alltimeUl,
      averageTimeQueue: patch.averageTimeQueue ?? averageTimeQueue,
      connectionStatus: patch.connectionStatus ?? connectionStatus,
      dhtNodes: patch.dhtNodes ?? dhtNodes,
      dlInfoData: patch.dlInfoData ?? dlInfoData,
      dlInfoSpeed: patch.dlInfoSpeed ?? dlInfoSpeed,
      dlRateLimit: patch.dlRateLimit ?? dlRateLimit,
      freeSpaceOnDisk: patch.freeSpaceOnDisk ?? freeSpaceOnDisk,
      globalRatio: patch.globalRatio ?? globalRatio,
      lastExternalAddressV4:
          patch.lastExternalAddressV4 ?? lastExternalAddressV4,
      lastExternalAddressV6:
          patch.lastExternalAddressV6 ?? lastExternalAddressV6,
      queuedIoJobs: patch.queuedIoJobs ?? queuedIoJobs,
      queuedTrackerAnnounces:
          patch.queuedTrackerAnnounces ?? queuedTrackerAnnounces,
      queueing: patch.queueing ?? queueing,
      readCacheHits: patch.readCacheHits ?? readCacheHits,
      readCacheOverload: patch.readCacheOverload ?? readCacheOverload,
      refreshInterval: patch.refreshInterval ?? refreshInterval,
      requestLatency: patch.requestLatency ?? requestLatency,
      totalBuffersSize: patch.totalBuffersSize ?? totalBuffersSize,
      totalPeerConnections: patch.totalPeerConnections ?? totalPeerConnections,
      totalQueuedSize: patch.totalQueuedSize ?? totalQueuedSize,
      totalWastedSession: patch.totalWastedSession ?? totalWastedSession,
      upInfoData: patch.upInfoData ?? upInfoData,
      upInfoSpeed: patch.upInfoSpeed ?? upInfoSpeed,
      upRateLimit: patch.upRateLimit ?? upRateLimit,
      useAltSpeedLimits: patch.useAltSpeedLimits ?? useAltSpeedLimits,
      writeCacheOverload: patch.writeCacheOverload ?? writeCacheOverload,
    );
  }
}
