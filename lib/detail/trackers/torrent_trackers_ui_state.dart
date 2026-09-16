import 'package:qbpanel/api/entity/response/torrent_tracker_response.dart';
import 'package:qbpanel/detail/trackers/torrent_tracker_sort.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

class TorrentTrackersUiState {
  const TorrentTrackersUiState({
    this.emptyState = const EmptyState.loading(),
    this.trackers = const [],
    this.sortKey = TrackerSortKey.url,
    this.sortAscending = true,
  });

  final EmptyState emptyState;
  final List<TorrentTrackerResponse> trackers;
  final TrackerSortKey sortKey;
  final bool sortAscending;

  TorrentTrackersUiState copyWith({
    EmptyState? emptyState,
    List<TorrentTrackerResponse>? trackers,
    TrackerSortKey? sortKey,
    bool? sortAscending,
  }) {
    return TorrentTrackersUiState(
      emptyState: emptyState ?? this.emptyState,
      trackers: trackers ?? this.trackers,
      sortKey: sortKey ?? this.sortKey,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }
}
