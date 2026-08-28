import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/entity/response/json_read.dart';
import 'package:qbpanel/api/entity/response/torrent_properties_response.dart';
import 'package:qbpanel/detail/torrent_detail_ui_state.dart';
import 'package:qbpanel/home/home_page_view_model.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/http/poll_loop.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/l10n/app_localizations.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

final torrentDetailProvider = NotifierProvider.autoDispose
    .family<TorrentDetailViewModel, TorrentDetailUiState, String>(
      TorrentDetailViewModel.new,
    );

class TorrentDetailViewModel extends Notifier<TorrentDetailUiState> {
  TorrentDetailViewModel(this.hash);

  final String hash;

  late PollLoop _poll;

  AppLocalizations get _l10n => ref.read(appLocalizationsProvider);

  @override
  TorrentDetailUiState build() {
    _poll = PollLoop(ref: ref, onPoll: _onPoll)..attach();
    return const TorrentDetailUiState();
  }

  void retry() => _poll.retry();

  Future<void> _onPoll(PollTicket ticket) async {
    if (hash.isEmpty) {
      state = state.copyWith(emptyState: EmptyState.error(_l10n.invalidTorrent));
      ticket.stopPolling();
      return;
    }

    final api = ref.read(apiClientProvider);
    String? propsError;

    await Future.wait([
      api
          .get(
            ApiPath.torrentManagement.properties,
            queryParameters: {'hash': hash},
            cancelToken: ticket.cancelToken,
            parser: jsonParser(TorrentPropertiesResponse.fromJson),
          )
          .onSuccess((data) {
            if (!ticket.isActive) return;
            final listState = ref
                .read(homePageProvider.notifier)
                .torrentByHash(hash)
                ?.state;
            state = state.copyWith(
              emptyState: const EmptyState.content(),
              properties: data,
              listState: listState,
            );
          })
          .onFail((e) {
            if (e.isCancel) return;
            propsError = e.statusCode == 404 ? _l10n.torrentNotFound : e.message;
          }),
      api
          .get(
            ApiPath.torrentManagement.pieceStates,
            queryParameters: {'hash': hash},
            cancelToken: ticket.cancelToken,
            options: Options(responseType: ResponseType.plain),
            parser: _pieceJsonRaw,
          )
          .onSuccess((raw) async {
            final data = await _parsePieceJson(raw);
            if (!ticket.isActive) return;
            if (listEquals(data, state.pieceStates)) return;
            state = state.copyWith(pieceStates: data);
          }),
      api
          .get(
            ApiPath.torrentManagement.pieceAvailability,
            queryParameters: {'hash': hash},
            cancelToken: ticket.cancelToken,
            options: Options(responseType: ResponseType.plain),
            parser: _pieceJsonRaw,
          )
          .onSuccess((raw) async {
            final data = await _parsePieceJson(raw);
            if (!ticket.isActive) return;
            if (listEquals(data, state.pieceAvailability)) return;
            state = state.copyWith(pieceAvailability: data);
          }),
    ]);

    if (!ticket.isActive) return;

    if (state.properties == null) {
      state = state.copyWith(emptyState: EmptyState.error(propsError ?? _l10n.loadFailed));
    }
  }

  static const _pieceJsonIsolateBytes = 8192;

  static String _pieceJsonRaw(dynamic data) {
    if (data is String) return data;
    return data?.toString() ?? '[]';
  }

  static Future<List<int>> _parsePieceJson(String raw) {
    if (raw.length < _pieceJsonIsolateBytes) {
      return Future<List<int>>.value(decodeIntListJson(raw));
    }
    return compute(decodeIntListJson, raw);
  }
}

