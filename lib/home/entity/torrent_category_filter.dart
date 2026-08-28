import 'package:qbpanel/l10n/app_localizations.dart';

/// 分类筛选。父路径包含子孙（`1` 能匹配 `1/1`）。
class TorrentCategoryFilter {
  const TorrentCategoryFilter._({this.isUncategorized = false}) : path = null;

  static const all = TorrentCategoryFilter._();
  static const uncategorized = TorrentCategoryFilter._(isUncategorized: true);

  const TorrentCategoryFilter.named(String this.path)
      : isUncategorized = false;

  /// 选中的完整分类名；`all` / `uncategorized` 为 `null`。
  final String? path;

  final bool isUncategorized;

  bool get isAll => path == null && !isUncategorized;

  String displayText(AppLocalizations l10n) {
    if (isAll) return l10n.filterAll;
    if (isUncategorized) return l10n.filterUncategorized;
    return path!;
  }

  bool matches(String? category) {
    final value = category ?? '';
    if (isAll) return true;
    if (isUncategorized) return value.isEmpty;
    final selected = path!;
    return value == selected || value.startsWith('$selected/');
  }

  @override
  bool operator ==(Object other) =>
      other is TorrentCategoryFilter &&
      other.path == path &&
      other.isUncategorized == isUncategorized;

  @override
  int get hashCode => Object.hash(path, isUncategorized);
}
