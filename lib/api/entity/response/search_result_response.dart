import 'package:qbpanel/api/entity/response/json_read.dart';

class SearchResultResponse {
  const SearchResultResponse({
    required this.fileName,
    required this.fileUrl,
    required this.fileSize,
    required this.nbSeeders,
    required this.nbLeechers,
    this.engineName,
    this.siteUrl,
    this.descrLink,
    this.pubDate,
  });

  final String fileName;
  final String fileUrl;
  final int fileSize;
  final int nbSeeders;
  final int nbLeechers;
  final String? engineName;
  final String? siteUrl;
  final String? descrLink;

  /// Unix epoch seconds; may be 0 or missing.
  final int? pubDate;

  factory SearchResultResponse.fromJson(Map<String, dynamic> json) {
    return SearchResultResponse(
      fileName: readString(json['fileName']) ?? '',
      fileUrl: readString(json['fileUrl']) ?? '',
      fileSize: readInt(json['fileSize']) ?? -1,
      nbSeeders: readInt(json['nbSeeders']) ?? -1,
      nbLeechers: readInt(json['nbLeechers']) ?? -1,
      engineName: readString(json['engineName']),
      siteUrl: readString(json['siteUrl']),
      descrLink: readString(json['descrLink']),
      pubDate: readInt(json['pubDate']),
    );
  }
}

class SearchResultsResponse {
  const SearchResultsResponse({
    required this.results,
    required this.status,
    required this.total,
  });

  final List<SearchResultResponse> results;
  final String status;
  final int total;

  bool get isRunning => status == 'Running';

  factory SearchResultsResponse.fromJson(Map<String, dynamic> json) {
    final resultsRaw = json['results'];
    final results = resultsRaw is List
        ? resultsRaw
            .whereType<Map>()
            .map((e) => SearchResultResponse.fromJson(
                  Map<String, dynamic>.from(e),
                ))
            .toList(growable: false)
        : const <SearchResultResponse>[];

    return SearchResultsResponse(
      results: results,
      status: readString(json['status']) ?? 'Stopped',
      total: readInt(json['total']) ?? results.length,
    );
  }
}

class SearchStartResponse {
  const SearchStartResponse({required this.id});

  final int id;

  factory SearchStartResponse.fromJson(Map<String, dynamic> json) {
    return SearchStartResponse(id: readInt(json['id']) ?? 0);
  }
}
