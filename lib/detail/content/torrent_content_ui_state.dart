import 'package:qbpanel/detail/content/torrent_content_node.dart';
import 'package:qbpanel/detail/content/torrent_content_sort.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

class TorrentContentUiState {
  const TorrentContentUiState({
    this.emptyState = const EmptyState.loading(),
    this.roots = const [],
    this.collapsedPaths = const {},
    this.sortKey = ContentSortKey.name,
    this.sortAscending = true,
  });

  final EmptyState emptyState;
  final List<TorrentContentNode> roots;
  final Set<String> collapsedPaths;
  final ContentSortKey sortKey;
  final bool sortAscending;

  List<TorrentContentRow> get visibleRows =>
      flattenContentTree(roots, collapsedPaths);

  TorrentContentUiState copyWith({
    EmptyState? emptyState,
    List<TorrentContentNode>? roots,
    Set<String>? collapsedPaths,
    ContentSortKey? sortKey,
    bool? sortAscending,
  }) {
    return TorrentContentUiState(
      emptyState: emptyState ?? this.emptyState,
      roots: roots ?? this.roots,
      collapsedPaths: collapsedPaths ?? this.collapsedPaths,
      sortKey: sortKey ?? this.sortKey,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }
}
