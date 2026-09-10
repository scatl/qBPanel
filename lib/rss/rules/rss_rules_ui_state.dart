import 'package:qbpanel/api/entity/response/rss_rule_response.dart';
import 'package:qbpanel/widget/refresh/paged_refresh_state.dart';

class RssRulesUiState {
  RssRulesUiState({
    PagedRefreshState<RssAutoDownloadRule>? list,
    this.autoDownloadingEnabled = true,
    this.busyRuleNames = const {},
  }) : list = list ?? PagedRefreshState<RssAutoDownloadRule>();

  final PagedRefreshState<RssAutoDownloadRule> list;
  final bool autoDownloadingEnabled;
  final Set<String> busyRuleNames;

  RssRulesUiState copyWith({
    PagedRefreshState<RssAutoDownloadRule>? list,
    bool? autoDownloadingEnabled,
    Set<String>? busyRuleNames,
  }) {
    return RssRulesUiState(
      list: list ?? this.list,
      autoDownloadingEnabled:
          autoDownloadingEnabled ?? this.autoDownloadingEnabled,
      busyRuleNames: busyRuleNames ?? this.busyRuleNames,
    );
  }
}
