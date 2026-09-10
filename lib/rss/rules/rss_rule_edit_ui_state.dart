import 'package:qbpanel/api/entity/response/rss_items_response.dart';
import 'package:qbpanel/api/entity/response/rss_rule_response.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

class RssRuleEditUiState {
  const RssRuleEditUiState({
    this.emptyState = const EmptyState.loading(),
    this.originalName = '',
    this.rule = const RssAutoDownloadRule(name: ''),
    this.feeds = const [],
    this.categories = const [],
    this.saving = false,
    this.matchingLoading = false,
    this.matching = const {},
  });

  final EmptyState emptyState;
  final String originalName;
  final RssAutoDownloadRule rule;
  final List<RssTreeNode> feeds;
  final List<String> categories;
  final bool saving;
  final bool matchingLoading;
  final Map<String, List<String>> matching;

  bool get ready => emptyState.ready;
  bool get isNew => originalName.isEmpty;

  RssRuleEditUiState copyWith({
    EmptyState? emptyState,
    String? originalName,
    RssAutoDownloadRule? rule,
    List<RssTreeNode>? feeds,
    List<String>? categories,
    bool? saving,
    bool? matchingLoading,
    Map<String, List<String>>? matching,
  }) {
    return RssRuleEditUiState(
      emptyState: emptyState ?? this.emptyState,
      originalName: originalName ?? this.originalName,
      rule: rule ?? this.rule,
      feeds: feeds ?? this.feeds,
      categories: categories ?? this.categories,
      saving: saving ?? this.saving,
      matchingLoading: matchingLoading ?? this.matchingLoading,
      matching: matching ?? this.matching,
    );
  }
}
