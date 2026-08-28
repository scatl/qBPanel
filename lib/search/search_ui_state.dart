import 'package:qbpanel/api/entity/response/search_plugin_response.dart';
import 'package:qbpanel/api/entity/response/search_result_response.dart';
import 'package:qbpanel/l10n/app_localizations.dart';
import 'package:qbpanel/search/entity/search_result_filter.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

class SearchCategoryOption {
  const SearchCategoryOption({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  /// 官方 nova 分类按 id 本地化；插件自定义分类沿用接口返回的名称。
  String label(AppLocalizations l10n) => switch (id.toLowerCase()) {
        'all' => l10n.allCategories,
        'anime' => l10n.searchCategoryAnime,
        'books' => l10n.searchCategoryBooks,
        'games' => l10n.searchCategoryGames,
        'movies' => l10n.searchCategoryMovies,
        'music' => l10n.searchCategoryMusic,
        'pictures' => l10n.searchCategoryPictures,
        'software' => l10n.searchCategorySoftware,
        'tv' => l10n.searchCategoryTv,
        _ => name.isNotEmpty ? name : id,
      };
}

class SearchUiState {
  const SearchUiState({
    this.pluginsLoading = true,
    this.plugins = const [],
    this.pluginsError,
    this.patternInput = '',
    this.searchPattern = '',
    this.selectedCategoryId = 'all',
    this.categoryOptions = const [
      SearchCategoryOption(id: 'all', name: ''),
    ],
    this.pluginMode = SearchPluginMode.enabled,
    this.selectedPluginName,
    this.searchJobId,
    this.isRunning = false,
    this.totalResults = 0,
    this.allResults = const [],
    this.displayedResults = const [],
    this.resultFilterQuery = '',
    this.resultFilter = const SearchResultFilter(),
    this.startingSearch = false,
    this.emptyState = const EmptyState(isEmpty: true),
  });

  final bool pluginsLoading;
  final List<SearchPluginResponse> plugins;
  final String? pluginsError;

  /// 搜索框当前输入。
  final String patternInput;

  /// 当前任务使用的关键词。
  final String searchPattern;

  final String selectedCategoryId;
  final List<SearchCategoryOption> categoryOptions;

  final SearchPluginMode pluginMode;
  final String? selectedPluginName;

  final int? searchJobId;
  final bool isRunning;
  final int totalResults;
  final List<SearchResultResponse> allResults;
  final List<SearchResultResponse> displayedResults;

  /// 本地筛选结果名称（不触发 API）。
  final String resultFilterQuery;
  final SearchResultFilter resultFilter;

  final bool startingSearch;
  final EmptyState emptyState;

  bool get hasSearchJob => searchJobId != null;

  bool get resultFiltering =>
      resultFilterQuery.trim().isNotEmpty || resultFilter.isActive;

  bool get canSearch =>
      !pluginsLoading &&
      pluginsError == null &&
      patternInput.trim().isNotEmpty &&
      !startingSearch &&
      !isRunning;

  SearchUiState copyWith({
    bool? pluginsLoading,
    List<SearchPluginResponse>? plugins,
    String? pluginsError,
    bool clearPluginsError = false,
    String? patternInput,
    String? searchPattern,
    String? selectedCategoryId,
    List<SearchCategoryOption>? categoryOptions,
    SearchPluginMode? pluginMode,
    String? selectedPluginName,
    bool clearSelectedPluginName = false,
    int? searchJobId,
    bool clearSearchJobId = false,
    bool? isRunning,
    int? totalResults,
    List<SearchResultResponse>? allResults,
    List<SearchResultResponse>? displayedResults,
    String? resultFilterQuery,
    SearchResultFilter? resultFilter,
    bool? startingSearch,
    EmptyState? emptyState,
  }) {
    return SearchUiState(
      pluginsLoading: pluginsLoading ?? this.pluginsLoading,
      plugins: plugins ?? this.plugins,
      pluginsError:
          clearPluginsError ? null : (pluginsError ?? this.pluginsError),
      patternInput: patternInput ?? this.patternInput,
      searchPattern: searchPattern ?? this.searchPattern,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      categoryOptions: categoryOptions ?? this.categoryOptions,
      pluginMode: pluginMode ?? this.pluginMode,
      selectedPluginName: clearSelectedPluginName
          ? null
          : (selectedPluginName ?? this.selectedPluginName),
      searchJobId: clearSearchJobId ? null : (searchJobId ?? this.searchJobId),
      isRunning: isRunning ?? this.isRunning,
      totalResults: totalResults ?? this.totalResults,
      allResults: allResults ?? this.allResults,
      displayedResults: displayedResults ?? this.displayedResults,
      resultFilterQuery: resultFilterQuery ?? this.resultFilterQuery,
      resultFilter: resultFilter ?? this.resultFilter,
      startingSearch: startingSearch ?? this.startingSearch,
      emptyState: emptyState ?? this.emptyState,
    );
  }
}
