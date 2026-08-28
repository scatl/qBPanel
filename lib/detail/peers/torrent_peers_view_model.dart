import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/entity/response/torrent_peer_response.dart';
import 'package:qbpanel/detail/peers/model/torrent_peer_sort.dart';
import 'package:qbpanel/detail/peers/torrent_peers_ui_state.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/http/poll_loop.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/l10n/app_localizations.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

final torrentPeersProvider = NotifierProvider.autoDispose
    .family<TorrentPeersViewModel, TorrentPeersUiState, String>(
      TorrentPeersViewModel.new,
    );

class TorrentPeersViewModel extends Notifier<TorrentPeersUiState> {
  TorrentPeersViewModel(this.hash);

  final String hash;

  late PollLoop _poll;

  AppLocalizations get _l10n => ref.read(appLocalizationsProvider);

  @override
  TorrentPeersUiState build() {
    _poll = PollLoop(
      ref: ref,
      onPoll: _onPoll,
      canPoll: () => !state.pollPaused,
    )..attach();
    return const TorrentPeersUiState();
  }

  void retry() => _poll.retry();

  void setSort(PeerSortKey key) {
    final ascending = state.sortKey == key ? !state.sortAscending : true;
    state = state.copyWith(
      sortKey: key,
      sortAscending: ascending,
      peers: sortPeers(state.peers, key, ascending),
    );
  }

  /// 成功为 `null`。
  Future<String?> addPeers(String rawLines) async {
    final peers = rawLines
        .split(RegExp(r'[\r\n]+'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .join('|');
    if (peers.isEmpty) return _l10n.enterPeers;

    String? error;
    await ref
        .read(apiClientProvider)
        .post<void>(
          ApiPath.torrentManagement.addPeers,
          data: {'hashes': hash, 'peers': peers},
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) {
          error = switch (e.statusCode) {
            400 => _l10n.noValidPeers,
            404 => _l10n.torrentNotFound,
            _ => e.message,
          };
        });
    if (error != null) return error;
    if (!ref.mounted) return null;
    await _poll.refreshNow(ignoreCanPoll: true);
    return null;
  }

  /// 成功为 `null`。
  Future<String?> banPeer(String endpoint) async {
    final peers = endpoint.trim();
    if (peers.isEmpty) return _l10n.invalidPeer;

    String? error;
    await ref
        .read(apiClientProvider)
        .post<void>(
          ApiPath.transfer.banPeers,
          data: {'hash': hash, 'peers': peers},
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) => error = e.message);
    if (error != null) return error;
    if (!ref.mounted) return null;
    await _poll.refreshNow(ignoreCanPoll: true);
    return null;
  }

  void togglePoll() {
    if (state.pollPaused) {
      state = state.copyWith(pollPaused: false);
      _poll.retry();
      return;
    }
    state = state.copyWith(pollPaused: true);
    _poll.stop();
  }

  Future<void> _onPoll(PollTicket ticket) async {
    if (hash.isEmpty) {
      state = state.copyWith(emptyState: EmptyState.error(_l10n.invalidTorrent));
      ticket.stopPolling();
      return;
    }

    TorrentPeersSyncResponse? data;
    String? error;
    await ref
        .read(apiClientProvider)
        .get(
          ApiPath.sync.torrentPeers,
          queryParameters: {'hash': hash, 'rid': 0},
          cancelToken: ticket.cancelToken,
          parser: parseTorrentPeers,
        )
        .onSuccess((value) {
          data = value;
        })
        .onFail((e) {
          if (e.isCancel) return;
          error = e.statusCode == 404 ? _l10n.torrentNotFound : e.message;
        });

    if (!ticket.isActive) return;

    if (data == null) {
      if (state.peers.isEmpty) {
        state = state.copyWith(emptyState: EmptyState.error(error ?? _l10n.loadFailed));
      }
      return;
    }

    final peers = sortPeers(data!.peers, state.sortKey, state.sortAscending);
    state = state.copyWith(
      emptyState: EmptyState.fromItems(peers),
      peers: peers,
      showFlags: data!.showFlags,
    );
  }
}

