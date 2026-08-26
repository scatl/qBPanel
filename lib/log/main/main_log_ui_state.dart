import 'package:qbpanel/log/model/log_day_section.dart';
import 'package:qbpanel/log/model/log_level.dart';
import 'package:qbpanel/log/model/log_main_entry.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

class MainLogUiState {
  const MainLogUiState({
    this.emptyState = const EmptyState.loading(),
    this.sections = const [],
    this.enabledLevels = LogLevel.all,
    this.searchQuery = '',
    this.pollingEnabled = false,
    this.refreshing = false,
  });

  final EmptyState emptyState;
  final List<LogDaySection<LogMainEntry>> sections;
  final Set<LogLevel> enabledLevels;
  final String searchQuery;
  final bool pollingEnabled;
  final bool refreshing;

  MainLogUiState copyWith({
    EmptyState? emptyState,
    List<LogDaySection<LogMainEntry>>? sections,
    Set<LogLevel>? enabledLevels,
    String? searchQuery,
    bool? pollingEnabled,
    bool? refreshing,
  }) {
    return MainLogUiState(
      emptyState: emptyState ?? this.emptyState,
      sections: sections ?? this.sections,
      enabledLevels: enabledLevels ?? this.enabledLevels,
      searchQuery: searchQuery ?? this.searchQuery,
      pollingEnabled: pollingEnabled ?? this.pollingEnabled,
      refreshing: refreshing ?? this.refreshing,
    );
  }
}
