import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/http/poll_loop.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/log/model/log_peer_entry.dart';
import 'package:qbpanel/log/peer/peer_log_ui_state.dart';
import 'package:qbpanel/log/util/log_grouping.dart';
import 'package:qbpanel/log/util/log_search.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

final peerLogProvider =
    NotifierProvider<PeerLogViewModel, PeerLogUiState>(
  PeerLogViewModel.new,
);

class PeerLogViewModel extends Notifier<PeerLogUiState> {
  final Map<int, LogPeerEntry> _entriesById = {};
  int _lastKnownId = -1;
  bool _initialLoadDone = false;
  bool _userRefreshPending = false;
  Timer? _searchDebounce;
  late PollLoop _poll;

  @override
  PeerLogUiState build() {
    _poll = PollLoop(
      ref: ref,
      onPoll: _onPoll,
      canPoll: () => state.pollingEnabled,
    )..attach();

    ref.onDispose(() {
      _searchDebounce?.cancel();
    });

    return const PeerLogUiState();
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

  Future<void> _onPoll(PollTicket ticket) async {
    List<LogPeerEntry>? rows;
    String? error;

    await ref
        .read(apiClientProvider)
        .get(
          ApiPath.log.peers,
          queryParameters: {'last_known_id': _lastKnownId},
          cancelToken: ticket.cancelToken,
          parser: parseLogPeerList,
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
          emptyState: EmptyState.error(
            error ?? ref.read(appLocalizationsProvider).loadFailed,
          ),
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
          .where((e) => logContainsAllTerms('${e.ip} ${e.reason}', terms))
          .toList();
    }

    final l10n = ref.read(appLocalizationsProvider);
    final sections = groupLogEntriesByDay(
      entries,
      (e) => e.timestamp,
      l10n,
    );
    final hasCache = _entriesById.isNotEmpty;

    if (!hasCache) {
      state = state.copyWith(
        sections: sections,
        emptyState: _initialLoadDone
            ? EmptyState.empty(
                title: l10n.noBanRecords,
                subtitle: l10n.noBanRecordsHint,
                icon: Icons.shield_outlined,
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
          title: l10n.noMatchingRecords,
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
