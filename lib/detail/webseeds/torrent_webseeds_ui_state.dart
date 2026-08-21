import 'package:qbpanel/api/entity/response/torrent_webseed_response.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

class TorrentWebSeedsUiState {
  const TorrentWebSeedsUiState({
    this.emptyState = const EmptyState.loading(),
    this.webSeeds = const [],
  });

  final EmptyState emptyState;
  final List<TorrentWebSeedResponse> webSeeds;

  TorrentWebSeedsUiState copyWith({
    EmptyState? emptyState,
    List<TorrentWebSeedResponse>? webSeeds,
  }) {
    return TorrentWebSeedsUiState(
      emptyState: emptyState ?? this.emptyState,
      webSeeds: webSeeds ?? this.webSeeds,
    );
  }
}
