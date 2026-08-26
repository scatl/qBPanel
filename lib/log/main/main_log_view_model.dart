import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/http/poll_loop.dart';
import 'package:qbpanel/log/main/main_log_ui_state.dart';
import 'package:qbpanel/log/model/log_level.dart';
import 'package:qbpanel/log/model/log_main_entry.dart';
import 'package:qbpanel/log/util/log_grouping.dart';
import 'package:qbpanel/log/util/log_search.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

final mainLogProvider =
    NotifierProvider<MainLogViewModel, MainLogUiState>(
  MainLogViewModel.new,
);

class MainLogViewModel extends Notifier<MainLogUiState> {
  final Map<int, LogMainEntry> _entriesById = {};
  int _lastKnownId = -1;
  bool _initialLoadDone = false;
  bool _userRefreshPending = false;
  Timer? _searchDebounce;
  late PollLoop _poll;

  @override
  MainLogUiState build() {
    _poll = PollLoop(
      ref: ref,
      onPoll: _onPoll,
      canPoll: () => state.pollingEnabled,
    )..attach();

    ref.onDispose(() {
      _searchDebounce?.cancel();
    });

    return const MainLogUiState();
  }

  void setPollingEnabled(bool enabled) {
    if (state.pollingEnabled == enabled) return;
    state = state.copyWith(pollingEnabled: enabled);
    if (enabled) {
      _poll.retry();
    } else {
      _poll.stop();
    }
  }

  void retry() => _poll.retry();

  Future<void> refresh() async {
    _userRefreshPending = true;
    _lastKnownId = -1;
    _entriesById.clear();
    _initialLoadDone = false;
    state = state.copyWith(
      sections: const [],
      emptyState: const EmptyState.loading(),
      refreshing: true,
    );
    await _poll.refreshNow(ignoreCanPoll: true);
  }

  void setSearchQuery(String query) {
    if (query == state.searchQuery) return;
    state = state.copyWith(searchQuery: query);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!ref.mounted) return;
      _applyDisplayState();
    });
  }

  void toggleLevel(LogLevel level) {
    final next = Set<LogLevel>.from(state.enabledLevels);
    if (next.contains(level)) {
      if (next.length == 1) return;
      next.remove(level);
    } else {
      next.add(level);
    }
    _resetAndReloadLevels(next);
  }

  void _resetAndReloadLevels(Set<LogLevel> levels) {
    if (setEquals(levels, state.enabledLevels)) return;
    _lastKnownId = -1;
    _entriesById.clear();
    _initialLoadDone = false;
    state = state.copyWith(
      enabledLevels: levels,
      sections: const [],
      emptyState: const EmptyState.loading(),
    );
    _poll.refreshNow(ignoreCanPoll: true);
  }

  Future<void> _onPoll(PollTicket ticket) async {
    final levels = state.enabledLevels;
    List<LogMainEntry>? rows;
    String? error;

    await ref
        .read(apiClientProvider)
        .get(
          ApiPath.log.main,
          queryParameters: {
            'normal': levels.contains(LogLevel.normal),
            'info': levels.contains(LogLevel.info),
            'warning': levels.contains(LogLevel.warning),
            'critical': levels.contains(LogLevel.critical),
            'last_known_id': _lastKnownId,
          },
          cancelToken: ticket.cancelToken,
          parser: parseLogMainList,
        )
        .onSuccess((value) => rows = value)
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });

    if (!ticket.isActive) return;

    final refreshing = _userRefreshPending;
    _userRefreshPending = false;

    if (rows == null) {
      state = state.copyWith(refreshing: false);
      if (_entriesById.isEmpty) {
        state = state.copyWith(
          emptyState: EmptyState.error(error ?? '加载失败'),
        );
      }
      return;
    }

    for (final entry in rows!) {
      _entriesById[entry.id] = entry;
      if (entry.id > _lastKnownId) {
        _lastKnownId = entry.id;
      }
    }

    _initialLoadDone = true;
    state = state.copyWith(refreshing: refreshing);
    _applyDisplayState();
  }

  void _applyDisplayState() {
    final terms = parseLogSearchTerms(state.searchQuery);
    var entries = _entriesById.values.toList()
      ..sort((a, b) => b.id.compareTo(a.id));

    if (terms.isNotEmpty) {
      entries = entries
          .where((e) => logContainsAllTerms(e.message, terms))
          .toList();
    }

    final sections = groupLogEntriesByDay(entries, (e) => e.timestamp);
    final hasCache = _entriesById.isNotEmpty;

    if (!hasCache) {
      state = state.copyWith(
        sections: sections,
        emptyState: _initialLoadDone
            ? EmptyState.empty(
                title: '暂无日志',
                subtitle: '服务器尚未产生日志记录',
                icon: Icons.receipt_long_outlined,
              )
            : state.emptyState,
        refreshing: false,
      );
      return;
    }

    if (sections.isEmpty) {
      state = state.copyWith(
        sections: sections,
        emptyState: EmptyState.empty(
          title: '无匹配日志',
          subtitle: '试试调整筛选或搜索关键词',
          icon: Icons.search_off_outlined,
        ),
        refreshing: false,
      );
      return;
    }

    state = state.copyWith(
      sections: sections,
      emptyState: const EmptyState.content(),
      refreshing: false,
    );
  }
}
