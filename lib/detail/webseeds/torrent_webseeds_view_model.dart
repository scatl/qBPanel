import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/entity/response/torrent_webseed_response.dart';
import 'package:qbpanel/detail/webseeds/torrent_webseeds_ui_state.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/http/poll_loop.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/l10n/app_localizations.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

final torrentWebSeedsProvider = NotifierProvider.autoDispose
    .family<TorrentWebSeedsViewModel, TorrentWebSeedsUiState, String>(
      TorrentWebSeedsViewModel.new,
    );

class TorrentWebSeedsViewModel extends Notifier<TorrentWebSeedsUiState> {
  TorrentWebSeedsViewModel(this.hash);

  final String hash;

  late PollLoop _poll;

  AppLocalizations get _l10n => ref.read(appLocalizationsProvider);

  @override
  TorrentWebSeedsUiState build() {
    _poll = PollLoop(ref: ref, onPoll: _onPoll)..attach();
    return const TorrentWebSeedsUiState();
  }

  void retry() => _poll.retry();

  /// 成功为 `null`。每行一个 URL，提交时用 `|` 拼接。
  Future<String?> addWebSeeds(String rawLines) async {
    final urls = rawLines
        .split(RegExp(r'[\r\n]+'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .join('|');
    if (urls.isEmpty) return _l10n.enterHttpSeeds;
    return _mutate(
      ApiPath.torrentManagement.addWebSeeds,
      {'hash': hash, 'urls': urls},
      errorOf: (code, message) => switch (code) {
        400 => 'URL 无效',
        404 => _l10n.torrentNotFound,
        _ => message,
      },
    );
  }

  Future<String?> editWebSeed({
    required String origUrl,
    required String newUrl,
  }) async {
    final nextUrl = newUrl.trim();
    if (nextUrl.isEmpty) return _l10n.enterHttpSeedUrl;
    if (nextUrl == origUrl) return null;
    return _mutate(
      ApiPath.torrentManagement.editWebSeed,
      {'hash': hash, 'origUrl': origUrl, 'newUrl': nextUrl},
      errorOf: (code, message) => switch (code) {
        400 => 'URL 无效',
        404 => _l10n.torrentNotFound,
        409 => _l10n.httpSeedNotFound,
        _ => message,
      },
    );
  }

  Future<String?> removeWebSeed(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return Future.value(_l10n.invalidHttpSeed);
    return _mutate(
      ApiPath.torrentManagement.removeWebSeeds,
      {'hash': hash, 'urls': trimmed},
      errorOf: (code, message) => switch (code) {
        400 => 'URL 无效',
        404 => _l10n.torrentNotFound,
        _ => message,
      },
    );
  }

  Future<String?> _mutate(
    String path,
    Map<String, String> data, {
    required String Function(int? code, String message) errorOf,
  }) async {
    String? error;
    await ref
        .read(apiClientProvider)
        .post<void>(
          path,
          data: data,
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) => error = errorOf(e.statusCode, e.message));
    if (error != null) return error;
    if (!ref.mounted) return null;
    await _poll.refreshNow();
    return null;
  }

  Future<void> _onPoll(PollTicket ticket) async {
    if (hash.isEmpty) {
      state = state.copyWith(emptyState: EmptyState.error(_l10n.invalidTorrent));
      ticket.stopPolling();
      return;
    }

    List<TorrentWebSeedResponse>? webSeeds;
    String? error;
    await ref
        .read(apiClientProvider)
        .get(
          ApiPath.torrentManagement.webseeds,
          queryParameters: {'hash': hash},
          cancelToken: ticket.cancelToken,
          parser: parseTorrentWebSeeds,
        )
        .onSuccess((data) {
          webSeeds = data;
        })
        .onFail((e) {
          if (e.isCancel) return;
          error = e.statusCode == 404 ? _l10n.torrentNotFound : e.message;
        });

    if (!ticket.isActive) return;

    if (webSeeds == null) {
      if (state.webSeeds.isEmpty) {
        state = state.copyWith(emptyState: EmptyState.error(error ?? _l10n.loadFailed));
      }
      return;
    }

    state = state.copyWith(
      emptyState: EmptyState.fromItems(webSeeds!),
      webSeeds: webSeeds!,
    );
  }
}

