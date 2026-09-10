import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/entity/response/app_preferences_response.dart';
import 'package:qbpanel/api/entity/response/rss_items_response.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/http/poll_loop.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/rss/rss_ui_state.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

final rssProvider = NotifierProvider.autoDispose<RssViewModel, RssUiState>(
  RssViewModel.new,
);

class RssViewModel extends Notifier<RssUiState> {
  late PollLoop _poll;
  bool _prefsLoaded = false;

  @override
  RssUiState build() {
    _poll = PollLoop(
      ref: ref,
      onPoll: _onPoll,
      canPoll: () => true,
    )..attach(startImmediately: true);

    return const RssUiState(
      emptyState: EmptyState.loading(),
    );
  }

  Future<void> _onPoll(PollTicket ticket) async {
    if (!_prefsLoaded) {
      await _loadProcessingFlag(ticket.cancelToken);
      if (!ticket.isActive) return;
      _prefsLoaded = true;
    }

    List<RssTreeNode>? roots;
    String? error;
    await ref
        .read(apiClientProvider)
        .get(
          ApiPath.rss.items,
          queryParameters: {'withData': true},
          cancelToken: ticket.cancelToken,
          parser: (data) => RssItemsParser.parse(data),
        )
        .onSuccess((data) => roots = data)
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });

    if (!ticket.isActive) return;

    if (roots == null) {
      if (state.roots.isEmpty) {
        state = state.copyWith(
          emptyState: EmptyState.error(
            error ?? ref.read(appLocalizationsProvider).loadFailed,
          ),
        );
      }
      return;
    }

    final list = roots!;
    final l10n = ref.read(appLocalizationsProvider);
    state = state.copyWith(
      roots: list,
      emptyState: list.isEmpty
          ? EmptyState.empty(
              title: l10n.rssEmptyFeedsTitle,
              subtitle: l10n.rssEmptyFeedsSubtitle,
              icon: Icons.rss_feed_outlined,
            )
          : const EmptyState.content(),
    );
  }

  Future<void> reloadProcessingFlag() {
    return _loadProcessingFlag(CancelToken());
  }

  Future<void> _loadProcessingFlag(CancelToken cancelToken) async {
    await ref
        .read(apiClientProvider)
        .get(
          ApiPath.application.preferences,
          cancelToken: cancelToken,
          parser: jsonParser(AppPreferencesResponse.fromJson),
        )
        .onSuccess((prefs) {
          state = state.copyWith(
            rssProcessingEnabled: prefs.rssProcessingEnabled ?? true,
          );
        });
  }

  void toggleExpanded(String path) {
    final next = Set<String>.from(state.expandedPaths);
    if (next.contains(path)) {
      next.remove(path);
    } else {
      next.add(path);
    }
    state = state.copyWith(expandedPaths: next);
  }

  void setArticleFilterQuery(String query) {
    state = state.copyWith(articleFilterQuery: query);
  }

  Future<void> refreshNow() => _poll.refreshNow(ignoreCanPoll: true);

  /// 刷新全部源（逐个 feed 调 refreshItem；根级用各顶层 path）。
  Future<String?> refreshAll() async {
    final feeds = [
      for (final root in state.roots) ...root.allFeeds,
    ];
    if (feeds.isEmpty) {
      // 无源时仍尝试刷新根（WebUI 对空树也可点 Update all）
      return null;
    }
    String? error;
    for (final feed in feeds) {
      final e = await refreshItem(feed.path);
      error ??= e;
    }
    await refreshNow();
    return error;
  }

  Future<String?> refreshItem(String itemPath) async {
    String? error;
    await ref
        .read(apiClientProvider)
        .post(
          ApiPath.rss.refreshItem,
          data: {'itemPath': itemPath},
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });
    return error;
  }

  Future<String?> markAsRead({
    required String itemPath,
    String? articleId,
  }) async {
    String? error;
    final data = <String, dynamic>{'itemPath': itemPath};
    if (articleId != null && articleId.isNotEmpty) {
      data['articleId'] = articleId;
    }
    await ref
        .read(apiClientProvider)
        .post(
          ApiPath.rss.markAsRead,
          data: data,
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });
    if (error == null) {
      await refreshNow();
    }
    return error;
  }

  Future<String?> addFeed({
    required String url,
    String path = '',
  }) async {
    final trimmed = url.trim();
    if (trimmed.isEmpty) {
      return ref.read(appLocalizationsProvider).rssFeedUrlRequired;
    }
    state = state.copyWith(busy: true);
    String? error;
    // 新版 qB 用 requireParams 强制要 path；空字符串表示用 url 当路径。
    await ref
        .read(apiClientProvider)
        .post(
          ApiPath.rss.addFeed,
          data: {'url': trimmed, 'path': path.trim()},
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });
    state = state.copyWith(busy: false);
    if (error == null) await refreshNow();
    return error;
  }

  Future<String?> addFolder(String path) async {
    final trimmed = path.trim();
    if (trimmed.isEmpty) {
      return ref.read(appLocalizationsProvider).rssFolderNameRequired;
    }
    state = state.copyWith(busy: true);
    String? error;
    await ref
        .read(apiClientProvider)
        .post(
          ApiPath.rss.addFolder,
          data: {'path': trimmed},
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });
    state = state.copyWith(busy: false);
    if (error == null) await refreshNow();
    return error;
  }

  Future<String?> removeItem(String path) async {
    state = state.copyWith(busy: true);
    String? error;
    await ref
        .read(apiClientProvider)
        .post(
          ApiPath.rss.removeItem,
          data: {'path': path},
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });
    state = state.copyWith(busy: false);
    if (error == null) await refreshNow();
    return error;
  }

  Future<String?> renameItem({
    required String itemPath,
    required String newName,
  }) async {
    final name = newName.trim();
    if (name.isEmpty) {
      return ref.read(appLocalizationsProvider).rssNameRequired;
    }
    final parent = RssItemsParser.parentPathOf(itemPath);
    final dest = RssItemsParser.joinPath(parent, name);
    if (dest == itemPath) return null;
    return moveItem(itemPath: itemPath, destPath: dest);
  }

  Future<String?> moveItem({
    required String itemPath,
    required String destPath,
  }) async {
    state = state.copyWith(busy: true);
    String? error;
    await ref
        .read(apiClientProvider)
        .post(
          ApiPath.rss.moveItem,
          data: {
            'itemPath': itemPath,
            'destPath': destPath,
          },
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });
    state = state.copyWith(busy: false);
    if (error == null) await refreshNow();
    return error;
  }

  Future<String?> setFeedUrl({
    required String path,
    required String url,
  }) async {
    final trimmed = url.trim();
    if (trimmed.isEmpty) {
      return ref.read(appLocalizationsProvider).rssFeedUrlRequired;
    }
    state = state.copyWith(busy: true);
    String? error;
    await ref
        .read(apiClientProvider)
        .post(
          ApiPath.rss.setFeedURL,
          data: {
            'path': path,
            'url': trimmed,
          },
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });
    state = state.copyWith(busy: false);
    if (error == null) await refreshNow();
    return error;
  }
}
