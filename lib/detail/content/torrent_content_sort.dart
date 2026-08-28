import 'package:qbpanel/detail/content/torrent_content_node.dart';
import 'package:qbpanel/l10n/app_localizations.dart';

enum ContentSortKey {
  priority,
  size,
  progress,
  availability,
  remaining,
  name;

  String label(AppLocalizations l10n) => switch (this) {
        ContentSortKey.priority => l10n.sortContentPriority,
        ContentSortKey.size => l10n.sortTotalSize,
        ContentSortKey.progress => l10n.sortProgress,
        ContentSortKey.availability => l10n.sortAvailability,
        ContentSortKey.remaining => l10n.sortRemaining,
        ContentSortKey.name => l10n.sortName,
      };
}

List<TorrentContentNode> sortContentTree(
  List<TorrentContentNode> roots,
  ContentSortKey key,
  bool ascending,
) {
  _sortNodes(roots, key, ascending);
  return roots;
}

void _sortNodes(
  List<TorrentContentNode> nodes,
  ContentSortKey key,
  bool ascending,
) {
  nodes.sort((a, b) {
    if (key == ContentSortKey.name && a.isFolder != b.isFolder) {
      return a.isFolder ? -1 : 1;
    }
    final result = _compare(a, b, key);
    return ascending ? result : -result;
  });
  for (final node in nodes) {
    if (node.isFolder) _sortNodes(node.children, key, ascending);
  }
}

int _compare(TorrentContentNode a, TorrentContentNode b, ContentSortKey key) {
  final result = switch (key) {
    ContentSortKey.priority => a.priority.compareTo(b.priority),
    ContentSortKey.size => a.size.compareTo(b.size),
    ContentSortKey.progress => a.progress.compareTo(b.progress),
    ContentSortKey.availability => a.availability.compareTo(b.availability),
    ContentSortKey.remaining => a.remaining.compareTo(b.remaining),
    ContentSortKey.name => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
  };
  if (result != 0) return result;
  return a.path.toLowerCase().compareTo(b.path.toLowerCase());
}
