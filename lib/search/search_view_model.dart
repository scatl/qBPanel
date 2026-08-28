import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/entity/response/search_plugin_response.dart';
import 'package:qbpanel/api/entity/response/search_result_response.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/http/poll_loop.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/l10n/app_localizations.dart';
import 'package:qbpanel/search/entity/search_result_filter.dart';
import 'package:qbpanel/search/search_ui_state.dart';
import 'package:qbpanel/search/util/search_filter.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

final searchProvider =
    NotifierProvider.autoDispose<SearchViewModel, SearchUiState>(
  SearchViewModel.new,
);

class SearchViewModel extends Notifier<SearchUiState> {
  late PollLoop _poll;
  Timer? _resultFilterDebounce;
  int? _activeJobId;

  AppLocalizations get _l10n => ref.read(appLocalizationsProvider);

  @override
  SearchUiState build() {
    _poll = PollLoop(
      ref: ref,
      onPoll: _onPoll,
      canPoll: () => _activeJobId != null && state.isRunning,
    )..attach(startImmediately: false);

    ref.onDispose(() {
      _resultFilterDebounce?.cancel();
      _poll.dispose();
      final id = _activeJobId;
      if (id != null) {
        unawaited(_stopAndDeleteJob(id));
      }
    });

    Future.microtask(_loadPlugins);
    final l10n = _l10n;
    return SearchUiState(
      categoryOptions: [
        SearchCategoryOption(id: 'all', name: l10n.allCategories),
      ],
      emptyState: EmptyState.empty(
        title: l10n.searchTorrents,
        subtitle: l10n.searchIdleHint,
        icon: Icons.search_outlined,
      ),
    );
  }

  void setPatternInput(String value) {
    state = state.copyWith(patternInput: value);
  }

  void setResultFilterQuery(String query) {
    if (query == state.resultFilterQuery) return;
    state = state.copyWith(resultFilterQuery: query);
    _resultFilterDebounce?.cancel();
    _resultFilterDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!ref.mounted) return;
      _applyDisplayFilters();
    });
  }

  void setResultFilter(SearchResultFilter filter) {
    state = state.copyWith(resultFilter: filter);
    _applyDisplayFilters();
  }

  void clearResultFilter() {
    state = state.copyWith(
      resultFilter: const SearchResultFilter(),
      resultFilterQuery: '',
    );
    _applyDisplayFilters();
  }

  void setCategory(String categoryId) {
    if (categoryId == state.selectedCategoryId) return;
    state = state.copyWith(selectedCategoryId: categoryId);
  }

  void setPluginMode(SearchPluginMode mode, {String? pluginName}) {
    if (mode == SearchPluginMode.single &&
        (pluginName == null || pluginName.isEmpty)) {
      return;
    }

    state = state.copyWith(
      pluginMode: mode,
      selectedPluginName: mode == SearchPluginMode.single ? pluginName : null,
      clearSelectedPluginName: mode != SearchPluginMode.single,
    );
    _refreshCategoryOptions();
  }

  Future<void> startSearch() async {
    final pattern = state.patternInput.trim();
    if (pattern.isEmpty || state.startingSearch || state.isRunning) return;

    state = state.copyWith(
      startingSearch: true,
      searchPattern: pattern,
      allResults: const [],
      displayedResults: const [],
      totalResults: 0,
      clearSearchJobId: true,
      isRunning: false,
      emptyState: const EmptyState.loading(),
    );

    final pluginsParam = _pluginsParam();
    String? error;
    int? jobId;

    await ref
        .read(apiClientProvider)
        .post(
          ApiPath.search.start,
          data: {
            'pattern': pattern,
            'category': state.selectedCategoryId,
            'plugins': pluginsParam,
          },
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: jsonParser(SearchStartResponse.fromJson),
        )
        .onSuccess((data) => jobId = data.id)
        .onFail((e) {
          error = switch (e.statusCode) {
            409 => e.message.contains('Python') || e.message.contains('python')
                ? _l10n.pythonRequired
                : _l10n.searchLimitReached,
            _ => e.message,
          };
        });

    if (!ref.mounted) return;

    if (jobId == null || jobId == 0) {
      state = state.copyWith(
        startingSearch: false,
        emptyState: EmptyState.error(error ?? _l10n.startSearchFailed),
      );
      return;
    }

    _activeJobId = jobId;
    state = state.copyWith(
      startingSearch: false,
      searchJobId: jobId,
      isRunning: true,
      emptyState: const EmptyState.loading(),
    );
    await _poll.refreshNow(ignoreCanPoll: true);
  }

  Future<void> stopSearch() async {
    final id = _activeJobId;
    if (id == null || !state.isRunning) return;

    await _stopJob(id);
    if (!ref.mounted) return;
    state = state.copyWith(isRunning: false);
    _poll.stop();
    _applyDisplayFilters();
  }

  Future<void> reloadPlugins() => _loadPlugins();

  Future<void> _loadPlugins() async {
    String? error;
    List<SearchPluginResponse>? plugins;

    await ref
        .read(apiClientProvider)
        .get(
          ApiPath.search.plugins,
          parser: parseSearchPluginList,
        )
        .onSuccess((value) => plugins = value)
        .onFail((e) => error = e.message);

    if (!ref.mounted) return;

    if (plugins == null) {
      state = state.copyWith(
        pluginsLoading: false,
        pluginsError: error ?? _l10n.loadPluginsFailed,
        emptyState: EmptyState.error(error ?? _l10n.loadPluginsFailed),
      );
      return;
    }

    if (plugins!.isEmpty) {
      state = state.copyWith(
        pluginsLoading: false,
        plugins: plugins!,
        emptyState: EmptyState.empty(
          title: _l10n.noSearchPlugins,
          subtitle: _l10n.noSearchPluginsHint,
          icon: Icons.extension_off_outlined,
        ),
      );
      return;
    }

    state = state.copyWith(
      pluginsLoading: false,
      plugins: plugins!,
      clearPluginsError: true,
    );
    _refreshCategoryOptions();
  }

  void _refreshCategoryOptions() {
    final plugins = state.plugins;
    final mode = state.pluginMode;
    final selectedName = state.selectedPluginName;

    final Map<String, SearchCategoryOption> unique = {};

    Iterable<SearchPluginResponse> source;
    switch (mode) {
      case SearchPluginMode.enabled:
        source = plugins.where((p) => p.enabled);
      case SearchPluginMode.all:
        source = plugins;
      case SearchPluginMode.single:
        source = plugins.where((p) => p.name == selectedName);
    }

    for (final plugin in source) {
      for (final category in plugin.supportedCategories) {
        if (category.id.isEmpty) continue;
        unique.putIfAbsent(
          category.id,
          () => SearchCategoryOption(id: category.id, name: category.name),
        );
      }
    }

    final options = unique.values.toList()
      ..sort((a, b) => a.id.compareTo(b.id));

    if (options.isEmpty ||
        options.firstWhere(
          (c) => c.id == 'all',
          orElse: () => const SearchCategoryOption(id: '', name: ''),
        ).id.isEmpty) {
      options.insert(
        0,
        SearchCategoryOption(id: 'all', name: _l10n.allCategories),
      );
    }

    final nextCategory = options.any((c) => c.id == state.selectedCategoryId)
        ? state.selectedCategoryId
        : 'all';

    state = state.copyWith(
      categoryOptions: options,
      selectedCategoryId: nextCategory,
    );
  }

  String _pluginsParam() {
    return switch (state.pluginMode) {
      SearchPluginMode.enabled => 'enabled',
      SearchPluginMode.all => 'all',
      SearchPluginMode.single => state.selectedPluginName ?? 'enabled',
    };
  }

  Future<void> _onPoll(PollTicket ticket) async {
    final id = _activeJobId;
    if (id == null) return;

    SearchResultsResponse? payload;
    String? error;

    await ref
        .read(apiClientProvider)
        .get(
          ApiPath.search.results,
          queryParameters: {
            'id': id,
            'limit': 0,
            'offset': 0,
          },
          cancelToken: ticket.cancelToken,
          parser: jsonParser(SearchResultsResponse.fromJson),
        )
        .onSuccess((value) => payload = value)
        .onFail((e) {
          if (e.isCancel) return;
          error = switch (e.statusCode) {
            404 => _l10n.searchJobNotFound,
            409 => _l10n.searchResultsUnavailable,
            _ => e.message,
          };
        });

    if (!ticket.isActive) return;

    if (payload == null) {
      if (error != null) {
        _activeJobId = null;
        _poll.stop();
        state = state.copyWith(
          clearSearchJobId: true,
          isRunning: false,
          emptyState: EmptyState.error(error!),
        );
      }
      return;
    }

    final running = payload!.isRunning;
    state = state.copyWith(
      isRunning: running,
      totalResults: payload!.total,
      allResults: payload!.results,
    );

    if (!running) {
      _poll.stop();
    }

    _applyDisplayFilters();
  }

  void _applyDisplayFilters() {
    final filtered = filterSearchResults(
      results: state.allResults,
      resultFilterQuery: state.resultFilterQuery,
      filter: state.resultFilter,
    );

    EmptyState emptyState;
    if (state.pluginsError != null) {
      emptyState = EmptyState.error(state.pluginsError!);
    } else if (state.plugins.isEmpty && !state.pluginsLoading) {
      emptyState = EmptyState.empty(
        title: _l10n.noSearchPlugins,
        subtitle: _l10n.noSearchPluginsHint,
        icon: Icons.extension_off_outlined,
      );
    } else if (!state.hasSearchJob) {
      emptyState = EmptyState.empty(
        title: _l10n.searchTorrents,
        subtitle: _l10n.searchIdleHint,
        icon: Icons.search_outlined,
      );
    } else if (state.isRunning && state.allResults.isEmpty) {
      emptyState = EmptyState.empty(
        title: _l10n.searching,
        subtitle: _l10n.searchingHint,
        icon: Icons.hourglass_top_outlined,
      );
    } else if (filtered.isEmpty) {
      emptyState = EmptyState.empty(
        title: state.resultFiltering ? _l10n.noMatchingResults : _l10n.noResults,
        subtitle: state.resultFiltering
            ? _l10n.adjustFiltersHint
            : _l10n.retrySearchHint,
        icon: state.resultFiltering
            ? Icons.search_off_outlined
            : Icons.inbox_outlined,
        actionText: state.resultFiltering ? _l10n.homeClearFilters : null,
      );
    } else {
      emptyState = const EmptyState.content();
    }

    state = state.copyWith(
      displayedResults: filtered,
      emptyState: emptyState,
    );
  }

  Future<void> _stopJob(int id) async {
    await ref.read(apiClientProvider).post<void>(
          ApiPath.search.stop,
          data: {'id': id},
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        );
  }

  Future<void> _deleteJob(int id) async {
    await ref.read(apiClientProvider).post<void>(
          ApiPath.search.delete,
          data: {'id': id},
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        );
  }

  Future<void> _stopAndDeleteJob(int id) async {
    await _stopJob(id);
    await _deleteJob(id);
    _activeJobId = null;
  }
}
