import 'package:qbpanel/l10n/app_localizations.dart';

/// 标签筛选。
class TorrentTagFilter {
  const TorrentTagFilter._({this.isUntagged = false}) : name = null;

  static const all = TorrentTagFilter._();
  static const untagged = TorrentTagFilter._(isUntagged: true);

  const TorrentTagFilter.named(String this.name) : isUntagged = false;

  final String? name;
  final bool isUntagged;

  bool get isAll => name == null && !isUntagged;

  String displayText(AppLocalizations l10n) {
    if (isAll) return l10n.filterAll;
    if (isUntagged) return l10n.filterUntagged;
    return name!;
  }

  /// 精确包含：选中 `a` 只匹配带 `a` 的种子，不匹配仅有 `a/b` 的。
  bool matches(String? tags) {
    final names = splitTorrentTags(tags);
    if (isAll) return true;
    if (isUntagged) return names.isEmpty;
    return names.contains(name);
  }

  @override
  bool operator ==(Object other) =>
      other is TorrentTagFilter &&
      other.name == name &&
      other.isUntagged == isUntagged;

  @override
  int get hashCode => Object.hash(name, isUntagged);
}

/// 各标签在全量缓存中的数量；一枚种子可有多标签，与当前筛选无关。
class TorrentTagCounts {
  const TorrentTagCounts({
    this.all = 0,
    this.untagged = 0,
    this.byName = const {},
  });

  final int all;
  final int untagged;

  /// key = 标签名
  final Map<String, int> byName;

  int of(String name) => byName[name] ?? 0;
}

List<String> splitTorrentTags(String? tags) {
  if (tags == null || tags.isEmpty) return const [];
  return [
    for (final part in tags.split(','))
      if (part.trim().isNotEmpty) part.trim(),
  ];
}
