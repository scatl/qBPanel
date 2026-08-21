import 'package:qbpanel/api/entity/response/torrent_peer_response.dart';
import 'package:qbpanel/detail/peers/model/torrent_peer_sort.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

class TorrentPeersUiState {
  const TorrentPeersUiState({
    this.emptyState = const EmptyState.loading(),
    this.peers = const [],
    this.showFlags = false,
    this.pollPaused = false,
    this.sortKey = PeerSortKey.ip,
    this.sortAscending = true,
  });

  final EmptyState emptyState;
  final List<TorrentPeerResponse> peers;
  final bool showFlags;
  final bool pollPaused;
  final PeerSortKey sortKey;
  final bool sortAscending;

  TorrentPeersUiState copyWith({
    EmptyState? emptyState,
    List<TorrentPeerResponse>? peers,
    bool? showFlags,
    bool? pollPaused,
    PeerSortKey? sortKey,
    bool? sortAscending,
  }) {
    return TorrentPeersUiState(
      emptyState: emptyState ?? this.emptyState,
      peers: peers ?? this.peers,
      showFlags: showFlags ?? this.showFlags,
      pollPaused: pollPaused ?? this.pollPaused,
      sortKey: sortKey ?? this.sortKey,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }
}
