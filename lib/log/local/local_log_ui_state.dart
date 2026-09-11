import 'package:qbpanel/log/model/local_log_entry.dart';
import 'package:qbpanel/log/model/log_day_section.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

class LocalLogUiState {
  const LocalLogUiState({
    this.emptyState = const EmptyState.loading(),
    this.sections = const [],
    this.searchQuery = '',
    this.pollingEnabled = false,
    this.refreshing = false,
  });

  final EmptyState emptyState;
  final List<LogDaySection<LocalLogEntry>> sections;
  final String searchQuery;
  final bool pollingEnabled;
  final bool refreshing;

  LocalLogUiState copyWith({
    EmptyState? emptyState,
    List<LogDaySection<LocalLogEntry>>? sections,
    String? searchQuery,
    bool? pollingEnabled,
    bool? refreshing,
  }) {
    return LocalLogUiState(
      emptyState: emptyState ?? this.emptyState,
      sections: sections ?? this.sections,
      searchQuery: searchQuery ?? this.searchQuery,
      pollingEnabled: pollingEnabled ?? this.pollingEnabled,
      refreshing: refreshing ?? this.refreshing,
    );
  }
}
