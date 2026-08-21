import 'package:qbpanel/api/entity/response/json_read.dart';

/// `/api/v2/torrents/webseeds` 单项。
class TorrentWebSeedResponse {
  const TorrentWebSeedResponse({required this.url});

  final String url;

  factory TorrentWebSeedResponse.fromJson(Map<String, dynamic> json) {
    return TorrentWebSeedResponse(url: readString(json['url']) ?? '');
  }
}

List<TorrentWebSeedResponse> parseTorrentWebSeeds(dynamic data) {
  if (data is! List) return const [];
  return [
    for (final item in data)
      if (item is Map)
        TorrentWebSeedResponse.fromJson(Map<String, dynamic>.from(item)),
  ];
}
