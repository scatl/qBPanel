/// 分类树节点。`fullPath` 为 qB 分类名（`/` 分层）。
class TorrentCategoryNode {
  TorrentCategoryNode({
    required this.segment,
    required this.fullPath,
    List<TorrentCategoryNode>? children,
  }) : children = children ?? [];

  /// 路径最后一段，用于展示。
  final String segment;

  final String fullPath;
  final List<TorrentCategoryNode> children;

  bool get hasChildren => children.isNotEmpty;
}

/// 各分类在全量缓存中的数量；父分类含子孙，与当前状态筛选无关。
class TorrentCategoryCounts {
  const TorrentCategoryCounts({
    this.all = 0,
    this.uncategorized = 0,
    this.byPath = const {},
  });

  final int all;
  final int uncategorized;

  /// key = 分类 `fullPath`
  final Map<String, int> byPath;

  int of(String fullPath) => byPath[fullPath] ?? 0;
}

/// 由扁平分类名（如 `1/1/111`）建成森林；缺省的中间层会补虚拟节点。
List<TorrentCategoryNode> buildCategoryTree(Iterable<String> names) {
  final root = TorrentCategoryNode(segment: '', fullPath: '');
  final sorted = names.where((name) => name.isNotEmpty).toList()..sort();
  for (final name in sorted) {
    _insert(root, name.split('/'));
  }
  _sortRecursively(root);
  return root.children;
}

void _insert(TorrentCategoryNode parent, List<String> segments) {
  if (segments.isEmpty) return;
  final head = segments.first;
  final path = parent.fullPath.isEmpty ? head : '${parent.fullPath}/$head';
  TorrentCategoryNode? child;
  for (final existing in parent.children) {
    if (existing.segment == head) {
      child = existing;
      break;
    }
  }
  if (child == null) {
    child = TorrentCategoryNode(segment: head, fullPath: path);
    parent.children.add(child);
  }
  if (segments.length > 1) {
    _insert(child, segments.sublist(1));
  }
}

void _sortRecursively(TorrentCategoryNode node) {
  node.children.sort((a, b) => a.segment.compareTo(b.segment));
  for (final child in node.children) {
    _sortRecursively(child);
  }
}
