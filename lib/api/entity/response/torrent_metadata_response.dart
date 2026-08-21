import 'package:qbpanel/api/entity/response/json_read.dart';
import 'package:qbpanel/api/entity/response/torrent_file_response.dart';

/// `/api/v2/torrents/fetchMetadata` 响应。
///
/// `202` 时可能只有 infohash；`200` 时带完整 `info`。
class TorrentMetadataResponse {
  const TorrentMetadataResponse({
    this.hash,
    this.infohashV1,
    this.infohashV2,
    this.comment,
    this.createdBy,
    this.creationDate,
    this.info,
  });

  final String? hash;
  final String? infohashV1;
  final String? infohashV2;
  final String? comment;
  final String? createdBy;
  final int? creationDate;
  final TorrentMetadataInfo? info;

  bool get hasFullInfo => info != null;

  factory TorrentMetadataResponse.fromJson(Map<String, dynamic> json) {
    return TorrentMetadataResponse(
      hash: readString(json['hash']),
      infohashV1: readString(json['infohash_v1']),
      infohashV2: readString(json['infohash_v2']),
      comment: readString(json['comment']),
      createdBy: readString(json['created_by']),
      creationDate: readInt(json['creation_date']),
      info: () {
        final map = readMap(json['info']);
        if (map == null) return null;
        return TorrentMetadataInfo.fromJson(map);
      }(),
    );
  }
}

class TorrentMetadataInfo {
  const TorrentMetadataInfo({
    this.name,
    this.length,
    this.pieceLength,
    this.piecesNum,
    this.isPrivate,
    this.files = const [],
  });

  final String? name;
  final int? length;
  final int? pieceLength;
  final int? piecesNum;
  final bool? isPrivate;
  final List<TorrentMetadataFile> files;

  int? get totalSize {
    if (files.isNotEmpty) {
      var sum = 0;
      for (final file in files) {
        sum += file.length ?? 0;
      }
      return sum;
    }
    return length;
  }

  factory TorrentMetadataInfo.fromJson(Map<String, dynamic> json) {
    return TorrentMetadataInfo(
      name: readString(json['name']),
      length: readInt(json['length']),
      pieceLength: readInt(json['piece_length']),
      piecesNum: readInt(json['pieces_num']),
      isPrivate: readBool(json['private']),
      files: _readFiles(json['files']),
    );
  }
}

class TorrentMetadataFile {
  const TorrentMetadataFile({
    this.path,
    this.length,
    this.priority,
  });

  final String? path;
  final int? length;
  final int? priority;

  factory TorrentMetadataFile.fromJson(Map<String, dynamic> json) {
    return TorrentMetadataFile(
      path: _readPath(json['path'] ?? json['name']),
      length: readInt(json['length'] ?? json['size']),
      priority: readInt(json['priority']),
    );
  }
}

List<TorrentFileResponse> metadataToTorrentFiles(TorrentMetadataResponse meta) {
  final info = meta.info;
  if (info == null) return const [];
  if (info.files.isNotEmpty) {
    return [
      for (var i = 0; i < info.files.length; i++)
        TorrentFileResponse(
          index: i,
          name: info.files[i].path,
          size: info.files[i].length,
          priority: info.files[i].priority ?? 1,
        ),
    ];
  }
  if (info.length != null && info.length! > 0) {
    return [
      TorrentFileResponse(
        index: 0,
        name: info.name,
        size: info.length,
        priority: 1,
      ),
    ];
  }
  return const [];
}

List<TorrentMetadataFile> _readFiles(dynamic value) {
  if (value is! List) return const [];
  return [
    for (final item in value)
      if (item is Map)
        TorrentMetadataFile.fromJson(Map<String, dynamic>.from(item)),
  ];
}

String? _readPath(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is List) {
    return value
        .map((e) => e.toString())
        .where((part) => part.isNotEmpty)
        .join('/');
  }
  return value.toString();
}
