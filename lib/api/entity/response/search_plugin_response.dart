import 'package:qbpanel/api/entity/response/json_read.dart';

class SearchCategoryResponse {
  const SearchCategoryResponse({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory SearchCategoryResponse.fromJson(Map<String, dynamic> json) {
    return SearchCategoryResponse(
      id: readString(json['id']) ?? '',
      name: readString(json['name']) ?? '',
    );
  }
}

class SearchPluginResponse {
  const SearchPluginResponse({
    required this.name,
    required this.fullName,
    required this.version,
    required this.url,
    required this.enabled,
    required this.supportedCategories,
  });

  final String name;
  final String fullName;
  final String version;
  final String url;
  final bool enabled;
  final List<SearchCategoryResponse> supportedCategories;

  factory SearchPluginResponse.fromJson(Map<String, dynamic> json) {
    final categoriesRaw = json['supportedCategories'];
    final categories = categoriesRaw is List
        ? categoriesRaw
            .whereType<Map>()
            .map((e) => SearchCategoryResponse.fromJson(
                  Map<String, dynamic>.from(e),
                ))
            .toList(growable: false)
        : const <SearchCategoryResponse>[];

    return SearchPluginResponse(
      name: readString(json['name']) ?? '',
      fullName: readString(json['fullName']) ?? '',
      version: readString(json['version']) ?? '',
      url: readString(json['url']) ?? '',
      enabled: readBool(json['enabled']) ?? false,
      supportedCategories: categories,
    );
  }
}

List<SearchPluginResponse> parseSearchPluginList(dynamic data) {
  if (data is! List) return const [];
  return data
      .whereType<Map>()
      .map((e) => SearchPluginResponse.fromJson(Map<String, dynamic>.from(e)))
      .toList(growable: false);
}
