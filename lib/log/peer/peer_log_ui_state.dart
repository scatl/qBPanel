import 'package:qbpanel/log/model/log_day_section.dart';
import 'package:qbpanel/log/model/log_peer_entry.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

class PeerLogUiState {
  const PeerLogUiState({
    this.emptyState = const EmptyState.loading(),
    this.sections = const [],
    this.searchQuery = '',
    this.pollingEnabled = false,
    this.refreshing = false,
  });

  final EmptyState emptyState;
  final List<LogDaySection<LogPeerEntry>> sections;
  final String searchQuery;
  final bool pollingEnabled;
  final bool refreshing;

  PeerLogUiState copyWith({
    EmptyState? emptyState,
    List<LogDaySection<LogPeerEntry>>? sections,
    String? searchQuery,
    bool? pollingEnabled,
    bool? refreshing,
  }) {
    return PeerLogUiState(
      emptyState: emptyState ?? this.emptyState,
      sections: sections ?? this.sections,
      searchQuery: searchQuery ?? this.searchQuery,
      pollingEnabled: pollingEnabled ?? this.pollingEnabled,
      refreshing: refreshing ?? this.refreshing,
    );
  }
}
