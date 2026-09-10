import 'package:qbpanel/api/entity/response/json_read.dart';

/// `/rss/rules` 单条自动下载规则。
class RssAutoDownloadRule {
  const RssAutoDownloadRule({
    required this.name,
    this.enabled = true,
    this.mustContain = '',
    this.mustNotContain = '',
    this.useRegex = false,
    this.episodeFilter = '',
    this.smartFilter = false,
    this.previouslyMatchedEpisodes = const [],
    this.affectedFeeds = const [],
    this.ignoreDays = 0,
    this.lastMatch = '',
    this.addPaused,
    this.assignedCategory = '',
    this.savePath = '',
    this.torrentContentLayout,
  });

  final String name;
  final bool enabled;
  final String mustContain;
  final String mustNotContain;
  final bool useRegex;
  final String episodeFilter;
  final bool smartFilter;
  final List<String> previouslyMatchedEpisodes;
  final List<String> affectedFeeds;
  final int ignoreDays;
  final String lastMatch;

  /// `null` 表示跟随全局默认。
  final bool? addPaused;
  final String assignedCategory;
  final String savePath;

  /// WebUI：`Original` / `Subfolder` / `NoSubfolder`；`null` 跟随默认。
  final String? torrentContentLayout;

  factory RssAutoDownloadRule.fromJson(
    String name,
    Map<String, dynamic> json,
  ) {
    return RssAutoDownloadRule(
      name: name,
      enabled: readBool(json['enabled']) ?? true,
      mustContain: readString(json['mustContain']) ?? '',
      mustNotContain: readString(json['mustNotContain']) ?? '',
      useRegex: readBool(json['useRegex']) ?? false,
      episodeFilter: readString(json['episodeFilter']) ?? '',
      smartFilter: readBool(json['smartFilter']) ?? false,
      previouslyMatchedEpisodes: readStringList(json['previouslyMatchedEpisodes']),
      affectedFeeds: readStringList(json['affectedFeeds']),
      ignoreDays: readInt(json['ignoreDays']) ?? 0,
      lastMatch: readString(json['lastMatch']) ?? '',
      addPaused: readBool(json['addPaused']),
      assignedCategory: readString(json['assignedCategory']) ?? '',
      savePath: readString(json['savePath']) ?? '',
      torrentContentLayout: readString(json['torrentContentLayout']),
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'mustContain': mustContain,
        'mustNotContain': mustNotContain,
        'useRegex': useRegex,
        'episodeFilter': episodeFilter,
        'smartFilter': smartFilter,
        'previouslyMatchedEpisodes': previouslyMatchedEpisodes,
        'affectedFeeds': affectedFeeds,
        'ignoreDays': ignoreDays,
        'lastMatch': lastMatch,
        'addPaused': addPaused,
        'assignedCategory': assignedCategory,
        'savePath': savePath,
        'torrentContentLayout': torrentContentLayout,
      };

  RssAutoDownloadRule copyWith({
    String? name,
    bool? enabled,
    String? mustContain,
    String? mustNotContain,
    bool? useRegex,
    String? episodeFilter,
    bool? smartFilter,
    List<String>? previouslyMatchedEpisodes,
    List<String>? affectedFeeds,
    int? ignoreDays,
    String? lastMatch,
    bool? addPaused,
    bool clearAddPaused = false,
    String? assignedCategory,
    String? savePath,
    String? torrentContentLayout,
    bool clearTorrentContentLayout = false,
  }) {
    return RssAutoDownloadRule(
      name: name ?? this.name,
      enabled: enabled ?? this.enabled,
      mustContain: mustContain ?? this.mustContain,
      mustNotContain: mustNotContain ?? this.mustNotContain,
      useRegex: useRegex ?? this.useRegex,
      episodeFilter: episodeFilter ?? this.episodeFilter,
      smartFilter: smartFilter ?? this.smartFilter,
      previouslyMatchedEpisodes:
          previouslyMatchedEpisodes ?? this.previouslyMatchedEpisodes,
      affectedFeeds: affectedFeeds ?? this.affectedFeeds,
      ignoreDays: ignoreDays ?? this.ignoreDays,
      lastMatch: lastMatch ?? this.lastMatch,
      addPaused: clearAddPaused ? null : (addPaused ?? this.addPaused),
      assignedCategory: assignedCategory ?? this.assignedCategory,
      savePath: savePath ?? this.savePath,
      torrentContentLayout: clearTorrentContentLayout
          ? null
          : (torrentContentLayout ?? this.torrentContentLayout),
    );
  }
}

List<RssAutoDownloadRule> parseRssRules(dynamic data) {
  if (data is! Map) return const [];
  final out = <RssAutoDownloadRule>[];
  for (final entry in data.entries) {
    final value = entry.value;
    if (value is! Map) continue;
    out.add(
      RssAutoDownloadRule.fromJson(
        entry.key.toString(),
        Map<String, dynamic>.from(value),
      ),
    );
  }
  out.sort(
    (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
  );
  return out;
}

/// `/rss/matchingArticles`：源显示名 → 文章标题。
Map<String, List<String>> parseRssMatchingArticles(dynamic data) {
  if (data is! Map) return const {};
  final out = <String, List<String>>{};
  for (final entry in data.entries) {
    out[entry.key.toString()] = readStringList(entry.value);
  }
  return out;
}
