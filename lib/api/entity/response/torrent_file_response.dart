import 'package:qbpanel/api/entity/response/json_read.dart';

/// `/api/v2/torrents/files` 单项。
class TorrentFileResponse {
  const TorrentFileResponse({
    this.index,
    this.name,
    this.size,
    this.progress,
    this.priority,
    this.isSeed,
    this.pieceRange = const [],
    this.availability,
  });

  final int? index;

  /// 种子内完整相对路径，如 `Season 1/.unwanted/ep1.mkv`。
  final String? name;
  final int? size;

  /// 0–1。
  final double? progress;

  /// `0` 不下载 / `1` 普通 / `6` 高 / `7` 最高。
  final int? priority;
  final bool? isSeed;
  final List<int> pieceRange;
  final double? availability;

  factory TorrentFileResponse.fromJson(Map<String, dynamic> json) {
    return TorrentFileResponse(
      index: readInt(json['index']),
      name: readString(json['name']),
      size: readInt(json['size']),
      progress: readDouble(json['progress']),
      priority: readInt(json['priority']),
      isSeed: readBool(json['is_seed']),
      pieceRange: readIntList(json['piece_range']),
      availability: readDouble(json['availability']),
    );
  }
}

List<TorrentFileResponse> parseTorrentFiles(dynamic data) {
  if (data is! List) return const [];
  return [
    for (final item in data)
      if (item is Map)
        TorrentFileResponse.fromJson(Map<String, dynamic>.from(item)),
  ];
}
