import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/entity/response/torrent_tracker_response.dart';
import 'package:qbpanel/detail/trackers/torrent_tracker_sort.dart';
import 'package:qbpanel/detail/trackers/torrent_trackers_ui_state.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/http/poll_loop.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

final torrentTrackersProvider = NotifierProvider.autoDispose
    .family<TorrentTrackersViewModel, TorrentTrackersUiState, String>(
      TorrentTrackersViewModel.new,
    );

class TorrentTrackersViewModel extends Notifier<TorrentTrackersUiState> {
  TorrentTrackersViewModel(this.hash);

  final String hash;

  late PollLoop _poll;

  @override
  TorrentTrackersUiState build() {
    _poll = PollLoop(ref: ref, onPoll: _onPoll)..attach();
    return const TorrentTrackersUiState();
  }

  void retry() => _poll.retry();

  void setSort(TrackerSortKey key) {
    final ascending = state.sortKey == key ? !state.sortAscending : true;
    state = state.copyWith(
      sortKey: key,
      sortAscending: ascending,
      trackers: sortTrackers(state.trackers, key, ascending),
    );
  }

  void toggleExpand(String url) {
    final next = Set<String>.from(state.expandedUrls);
    if (!next.add(url)) next.remove(url);
    state = state.copyWith(expandedUrls: next);
  }

  /// 成功为 `null`。`urls` 每行一个。
  Future<String?> addTrackers(String rawLines) async {
    final urls = rawLines
        .split(RegExp(r'[\r\n]+'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .join('\n');
    if (urls.isEmpty) return '请输入至少一个 Tracker';
    return _mutate(
      ApiPath.torrentManagement.addTrackers,
      {'hash': hash, 'urls': urls},
      errorOf: (code, message) => switch (code) {
        404 => '种子不存在',
        _ => message,
      },
    );
  }

  /// 成功为 `null`。
  Future<String?> editTracker({
    required String url,
    required String newUrl,
    required int? tier,
  }) async {
    final nextUrl = newUrl.trim();
    if (nextUrl.isEmpty) return '请输入 Tracker URL';
    if (tier != null && (tier < 0 || tier > 255)) {
      return '层级必须是 0–255';
    }
    return _mutate(
      ApiPath.torrentManagement.editTracker,
      {
        'hash': hash,
        'url': url,
        'newUrl': nextUrl,
        if (tier != null) 'tier': '$tier',
      },
      errorOf: (code, message) => switch (code) {
        400 => 'URL 无效',
        404 => '种子不存在',
        409 => 'Tracker 不存在或新 URL 已被占用',
        _ => message,
      },
      onSuccess: () {
        if (url == nextUrl || !state.expandedUrls.contains(url)) return;
        final next = Set<String>.from(state.expandedUrls)
          ..remove(url)
          ..add(nextUrl);
        state = state.copyWith(expandedUrls: next);
      },
    );
  }

  /// 成功为 `null`。
  Future<String?> removeTracker(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return Future.value('无效的 Tracker');
    return _mutate(
      ApiPath.torrentManagement.removeTrackers,
      {'hash': hash, 'urls': trimmed},
      errorOf: (code, message) => switch (code) {
        404 => '种子不存在',
        409 => 'Tracker 不存在',
        _ => message,
      },
      onSuccess: () {
        if (!state.expandedUrls.contains(trimmed)) return;
        final next = Set<String>.from(state.expandedUrls)..remove(trimmed);
        state = state.copyWith(expandedUrls: next);
      },
    );
  }

  /// [url] 为空则重新宣告全部（含 DHT）。
  Future<String?> reannounce({String? url}) {
    return _mutate(ApiPath.torrentManagement.reannounce, {
      'hashes': hash,
      if (url != null && url.trim().isNotEmpty) 'urls': url.trim(),
    }, errorOf: (_, message) => message);
  }

  Future<String?> _mutate(
    String path,
    Map<String, String> data, {
    required String Function(int? code, String message) errorOf,
    void Function()? onSuccess,
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
    onSuccess?.call();
    await _poll.refreshNow();
    return null;
  }

  Future<void> _onPoll(PollTicket ticket) async {
    if (hash.isEmpty) {
      state = state.copyWith(emptyState: EmptyState.error('无效的种子'));
      ticket.stopPolling();
      return;
    }

    List<TorrentTrackerResponse>? trackers;
    String? error;
    await ref
        .read(apiClientProvider)
        .get(
          ApiPath.torrentManagement.trackers,
          queryParameters: {'hash': hash},
          cancelToken: ticket.cancelToken,
          parser: parseTorrentTrackers,
        )
        .onSuccess((data) {
          trackers = data;
        })
        .onFail((e) {
          if (e.isCancel) return;
          error = e.statusCode == 404 ? '种子不存在' : e.message;
        });

    if (!ticket.isActive) return;

    if (trackers == null) {
      if (state.trackers.isEmpty) {
        state = state.copyWith(emptyState: EmptyState.error(error ?? '加载失败'));
      }
      return;
    }

    final sorted = sortTrackers(trackers!, state.sortKey, state.sortAscending);
    state = state.copyWith(
      emptyState: EmptyState.fromItems(sorted),
      trackers: sorted,
    );
  }
}

