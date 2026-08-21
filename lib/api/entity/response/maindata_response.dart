import 'package:qbpanel/api/entity/response/json_read.dart';
import 'package:qbpanel/api/entity/response/server_state_response.dart';
import 'package:qbpanel/api/entity/response/torrent_category_response.dart';
import 'package:qbpanel/api/entity/response/torrent_info_response.dart';

/// `/api/v2/sync/maindata` 响应。
///
/// - [fullUpdate] 为 true（或缺省且含完整数据）时整表替换本地缓存
/// - 否则按 hash / 名称 merge，并处理各 `*_removed`
class MainDataResponse {
  const MainDataResponse({
    required this.rid,
    this.fullUpdate = false,
    this.torrents,
    this.torrentsRemoved = const [],
    this.categories,
    this.categoriesRemoved = const [],
    this.tags = const [],
    this.tagsRemoved = const [],
    this.trackers,
    this.trackersRemoved = const [],
    this.serverState,
  });

  final int rid;
  final bool fullUpdate;

  /// key = torrent hash
  final Map<String, TorrentInfoResponse>? torrents;
  final List<String> torrentsRemoved;

  /// key = category name
  final Map<String, TorrentCategoryResponse>? categories;
  final List<String> categoriesRemoved;

  final List<String> tags;
  final List<String> tagsRemoved;

  /// key = tracker URL，value = 使用该 tracker 的 torrent hash 列表
  final Map<String, List<String>>? trackers;
  final List<String> trackersRemoved;

  final ServerStateResponse? serverState;

  factory MainDataResponse.fromJson(Map<String, dynamic> json) {
    final torrentsJson = readMap(json['torrents']);
    final categoriesJson = readMap(json['categories']);
    final trackersJson = readMap(json['trackers']);
    final serverStateJson = readMap(json['server_state']);

    return MainDataResponse(
      rid: readInt(json['rid']) ?? 0,
      fullUpdate: readBool(json['full_update']) ?? false,
      torrents: torrentsJson?.map((hash, value) {
        final map = readMap(value) ?? <String, dynamic>{};
        map.putIfAbsent('hash', () => hash);
        return MapEntry(hash, TorrentInfoResponse.fromJson(map));
      }),
      torrentsRemoved: readStringList(json['torrents_removed']),
      categories: categoriesJson?.map((name, value) {
        final map = readMap(value) ?? <String, dynamic>{};
        map.putIfAbsent('name', () => name);
        return MapEntry(name, TorrentCategoryResponse.fromJson(map));
      }),
      categoriesRemoved: readStringList(json['categories_removed']),
      tags: readStringList(json['tags']),
      tagsRemoved: readStringList(json['tags_removed']),
      trackers: trackersJson?.map(
        (url, value) => MapEntry(url, readStringList(value)),
      ),
      trackersRemoved: readStringList(json['trackers_removed']),
      serverState: serverStateJson == null
          ? null
          : ServerStateResponse.fromJson(serverStateJson),
    );
  }

  Map<String, dynamic> toJson() => {
        'rid': rid,
        'full_update': fullUpdate,
        if (torrents != null)
          'torrents': torrents!.map((k, v) => MapEntry(k, v.toJson())),
        if (torrentsRemoved.isNotEmpty) 'torrents_removed': torrentsRemoved,
        if (categories != null)
          'categories': categories!.map((k, v) => MapEntry(k, v.toJson())),
        if (categoriesRemoved.isNotEmpty)
          'categories_removed': categoriesRemoved,
        if (tags.isNotEmpty) 'tags': tags,
        if (tagsRemoved.isNotEmpty) 'tags_removed': tagsRemoved,
        if (trackers != null) 'trackers': trackers,
        if (trackersRemoved.isNotEmpty) 'trackers_removed': trackersRemoved,
        if (serverState != null) 'server_state': serverState!.toJson(),
      };
}
