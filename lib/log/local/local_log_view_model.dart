import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/http/poll_loop.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/log/local/local_log_ui_state.dart';
import 'package:qbpanel/log/model/local_log_entry.dart';
import 'package:qbpanel/log/util/log_grouping.dart';
import 'package:qbpanel/log/util/log_search.dart';
import 'package:qbpanel/util/app_log.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

final localLogProvider =
    NotifierProvider<LocalLogViewModel, LocalLogUiState>(
  LocalLogViewModel.new,
);

class LocalLogViewModel extends Notifier<LocalLogUiState> {
  List<LocalLogEntry> _entries = const [];
  int? _lastLength;
  DateTime? _lastModified;
  bool _initialLoadDone = false;
  bool _userRefreshPending = false;
  Timer? _searchDebounce;
  late PollLoop _poll;

  @override
  LocalLogUiState build() {
    _poll = PollLoop(
      ref: ref,
      onPoll: _onPoll,
      canPoll: () => state.pollingEnabled,
    )..attach();

    ref.onDispose(() {
      _searchDebounce?.cancel();
    });

    return const LocalLogUiState();
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
    _entries = const [];
    _lastLength = null;
    _lastModified = null;
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

  Future<void> _onPoll(PollTicket ticket) async {
    final l10n = ref.read(appLocalizationsProvider);

    if (!isAppLogFileSupported) {
      if (!ticket.isActive) return;
      _userRefreshPending = false;
      _initialLoadDone = true;
      state = state.copyWith(
        sections: const [],
        emptyState: EmptyState.empty(
          title: l10n.localLogsUnsupported,
          subtitle: l10n.localLogsUnsupportedHint,
          icon: Icons.web_asset_off_outlined,
        ),
        refreshing: false,
      );
      ticket.stopPolling();
      return;
    }

    AppLogFileReadResult? result;
    String? error;
    try {
      result = await loadAppLogFile();
    } catch (e) {
      error = e.toString();
    }

    if (!ticket.isActive) return;

    final refreshing = _userRefreshPending;
    _userRefreshPending = false;

    if (result == null) {
      state = state.copyWith(refreshing: false);
      if (_entries.isEmpty) {
        state = state.copyWith(
          emptyState: EmptyState.error(error ?? l10n.loadFailed),
        );
      }
      return;
    }

    final unchanged = _initialLoadDone &&
        _lastLength == result.length &&
        _lastModified == result.modified &&
        !refreshing;
    if (unchanged) {
      return;
    }

    _lastLength = result.length;
    _lastModified = result.modified;
    _entries = [
      for (var i = 0; i < result.lines.length; i++)
        LocalLogEntry.parse(i, result.lines[i]),
    ];
    _initialLoadDone = true;
    state = state.copyWith(refreshing: refreshing);
    _applyDisplayState();
  }

  void _applyDisplayState() {
    final l10n = ref.read(appLocalizationsProvider);
    final terms = parseLogSearchTerms(state.searchQuery);
    var entries = List<LocalLogEntry>.from(_entries)
      ..sort((a, b) => b.id.compareTo(a.id));

    if (terms.isNotEmpty) {
      entries = entries
          .where(
            (e) => logContainsAllTerms('${e.tag} ${e.message}', terms),
          )
          .toList();
    }

    final sections = groupLogEntriesByDay(
      entries,
      (e) => e.timestampSeconds,
      l10n,
    );
    final hasCache = _entries.isNotEmpty;

    if (!hasCache) {
      state = state.copyWith(
        sections: sections,
        emptyState: _initialLoadDone
            ? EmptyState.empty(
                title: l10n.noLocalLogs,
                subtitle: l10n.noLocalLogsHint,
                icon: Icons.phone_android_outlined,
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
          title: l10n.noMatchingLogs,
          subtitle: l10n.adjustSearchHint,
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
