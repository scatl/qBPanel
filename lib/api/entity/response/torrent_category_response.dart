import 'package:qbpanel/api/entity/response/json_read.dart';

/// 未完成 Torrent 路径：默认 / 是 / 否，对应 JSON `null` / 字符串 / `false`。
enum CategoryIncompletePathMode { followDefault, yes, no }

class CategoryIncompletePath {
  const CategoryIncompletePath({
    this.mode = CategoryIncompletePathMode.followDefault,
    this.path,
  });

  const CategoryIncompletePath.followDefault()
      : mode = CategoryIncompletePathMode.followDefault,
        path = null;

  const CategoryIncompletePath.no()
      : mode = CategoryIncompletePathMode.no,
        path = null;

  const CategoryIncompletePath.yes([this.path])
      : mode = CategoryIncompletePathMode.yes;

  final CategoryIncompletePathMode mode;
  final String? path;

  factory CategoryIncompletePath.fromJson(dynamic value) {
    if (value == null) return const CategoryIncompletePath.followDefault();
    if (value is bool) {
      return value
          ? const CategoryIncompletePath.yes()
          : const CategoryIncompletePath.no();
    }
    return CategoryIncompletePath.yes(value.toString());
  }

  dynamic toJsonValue() {
    return switch (mode) {
      CategoryIncompletePathMode.followDefault => null,
      CategoryIncompletePathMode.no => false,
      CategoryIncompletePathMode.yes => path ?? '',
    };
  }
}

/// Category entry from `sync/maindata` / `torrents/categories`.
///
/// Wiki 示例只有 `name` / `savePath`；较新 5.x 还会带下载路径和分享限制。
/// `savePath` 为 camelCase，其余为 snake_case。
class TorrentCategoryResponse {
  const TorrentCategoryResponse({
    this.downloadPath,
    this.inactiveSeedingTimeLimit,
    this.name,
    this.ratioLimit,
    this.savePath,
    this.seedingTimeLimit,
    this.shareLimitAction,
  });

  final CategoryIncompletePath? downloadPath;
  final int? inactiveSeedingTimeLimit;
  final String? name;
  final double? ratioLimit;
  final String? savePath;
  final int? seedingTimeLimit;
  final String? shareLimitAction;

  factory TorrentCategoryResponse.fromJson(Map<String, dynamic> json) {
    return TorrentCategoryResponse(
      downloadPath: json.containsKey('download_path')
          ? CategoryIncompletePath.fromJson(json['download_path'])
          : null,
      inactiveSeedingTimeLimit: readInt(json['inactive_seeding_time_limit']),
      name: readString(json['name']),
      ratioLimit: readDouble(json['ratio_limit']),
      savePath: readString(json['savePath']),
      seedingTimeLimit: readInt(json['seeding_time_limit']),
      shareLimitAction: readString(json['share_limit_action']),
    );
  }

  Map<String, dynamic> toJson() => {
        if (downloadPath != null) 'download_path': downloadPath!.toJsonValue(),
        if (inactiveSeedingTimeLimit != null)
          'inactive_seeding_time_limit': inactiveSeedingTimeLimit,
        if (name != null) 'name': name,
        if (ratioLimit != null) 'ratio_limit': ratioLimit,
        if (savePath != null) 'savePath': savePath,
        if (seedingTimeLimit != null) 'seeding_time_limit': seedingTimeLimit,
        if (shareLimitAction != null) 'share_limit_action': shareLimitAction,
      };

  TorrentCategoryResponse merge(TorrentCategoryResponse patch) {
    return TorrentCategoryResponse(
      downloadPath: patch.downloadPath ?? downloadPath,
      inactiveSeedingTimeLimit:
          patch.inactiveSeedingTimeLimit ?? inactiveSeedingTimeLimit,
      name: patch.name ?? name,
      ratioLimit: patch.ratioLimit ?? ratioLimit,
      savePath: patch.savePath ?? savePath,
      seedingTimeLimit: patch.seedingTimeLimit ?? seedingTimeLimit,
      shareLimitAction: patch.shareLimitAction ?? shareLimitAction,
    );
  }
}
