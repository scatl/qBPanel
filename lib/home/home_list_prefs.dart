import 'dart:convert';

import 'package:qbpanel/home/entity/torrent_category_filter.dart';
import 'package:qbpanel/home/entity/torrent_sort.dart';
import 'package:qbpanel/home/entity/torrent_status_filter.dart';
import 'package:qbpanel/home/entity/torrent_tag.dart';
import 'package:qbpanel/storage/sp_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 某台服务器上记住的首页筛选与排序。不含搜索框。
class HomeListPrefs {
  const HomeListPrefs({
    this.statusFilter = TorrentStatusFilter.all,
    this.categoryFilter = TorrentCategoryFilter.all,
    this.tagFilter = TorrentTagFilter.all,
    this.sortKey = TorrentSortKey.state,
    this.sortAscending = true,
  });

  static const defaults = HomeListPrefs();

  final TorrentStatusFilter statusFilter;
  final TorrentCategoryFilter categoryFilter;
  final TorrentTagFilter tagFilter;
  final TorrentSortKey sortKey;
  final bool sortAscending;

  static Future<HomeListPrefs> load(int serverId) async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(SpKey.list.prefsKey(serverId));
    if (raw == null || raw.isEmpty) return defaults;
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return defaults;
    return HomeListPrefs.fromJson(Map<String, dynamic>.from(decoded));
  }

  Future<void> save(int serverId) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(SpKey.list.prefsKey(serverId), jsonEncode(toJson()));
  }

  Map<String, Object?> toJson() => {
    'status': statusFilter.name,
    'category': _encodeCategory(categoryFilter),
    'tag': _encodeTag(tagFilter),
    'sortKey': sortKey.name,
    'sortAscending': sortAscending,
  };

  factory HomeListPrefs.fromJson(Map<String, dynamic> json) {
    return HomeListPrefs(
      statusFilter: _parseEnum(
        TorrentStatusFilter.values,
        json['status'],
        TorrentStatusFilter.all,
      ),
      categoryFilter: _parseCategory(json['category']),
      tagFilter: _parseTag(json['tag']),
      sortKey: _parseEnum(
        TorrentSortKey.values,
        json['sortKey'],
        TorrentSortKey.state,
      ),
      sortAscending: json['sortAscending'] as bool? ?? true,
    );
  }

  static Map<String, Object?> _encodeCategory(TorrentCategoryFilter filter) {
    if (filter.isAll) return const {'kind': 'all'};
    if (filter.isUncategorized) return const {'kind': 'uncategorized'};
    return {'kind': 'named', 'path': filter.path};
  }

  static Map<String, Object?> _encodeTag(TorrentTagFilter filter) {
    if (filter.isAll) return const {'kind': 'all'};
    if (filter.isUntagged) return const {'kind': 'untagged'};
    return {'kind': 'named', 'name': filter.name};
  }

  static TorrentCategoryFilter _parseCategory(Object? raw) {
    if (raw is! Map) return TorrentCategoryFilter.all;
    final kind = raw['kind'] as String?;
    switch (kind) {
      case 'uncategorized':
        return TorrentCategoryFilter.uncategorized;
      case 'named':
        final path = raw['path'] as String?;
        if (path == null || path.isEmpty) return TorrentCategoryFilter.all;
        return TorrentCategoryFilter.named(path);
      default:
        return TorrentCategoryFilter.all;
    }
  }

  static TorrentTagFilter _parseTag(Object? raw) {
    if (raw is! Map) return TorrentTagFilter.all;
    final kind = raw['kind'] as String?;
    switch (kind) {
      case 'untagged':
        return TorrentTagFilter.untagged;
      case 'named':
        final name = raw['name'] as String?;
        if (name == null || name.isEmpty) return TorrentTagFilter.all;
        return TorrentTagFilter.named(name);
      default:
        return TorrentTagFilter.all;
    }
  }

  static T _parseEnum<T extends Enum>(List<T> values, Object? raw, T fallback) {
    if (raw is! String) return fallback;
    for (final value in values) {
      if (value.name == raw) return value;
    }
    return fallback;
  }
}
