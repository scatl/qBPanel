import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/entity/response/torrent_file_response.dart';
import 'package:qbpanel/detail/content/torrent_content_node.dart';
import 'package:qbpanel/detail/content/torrent_content_sort.dart';
import 'package:qbpanel/detail/content/torrent_content_ui_state.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/http/poll_loop.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/l10n/app_localizations.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

final torrentContentProvider = NotifierProvider.autoDispose
    .family<TorrentContentViewModel, TorrentContentUiState, String>(
      TorrentContentViewModel.new,
    );

class TorrentContentViewModel extends Notifier<TorrentContentUiState> {
  TorrentContentViewModel(this.hash);

  final String hash;

  late PollLoop _poll;
  bool _priorityBusy = false;
  bool _renameBusy = false;

  AppLocalizations get _l10n => ref.read(appLocalizationsProvider);

  @override
  TorrentContentUiState build() {
    _poll = PollLoop(ref: ref, onPoll: _onPoll)..attach();
    return const TorrentContentUiState();
  }

  void retry() => _poll.retry();

  void setSort(ContentSortKey key) {
    final ascending = state.sortKey == key ? !state.sortAscending : true;
    sortContentTree(state.roots, key, ascending);
    state = state.copyWith(
      sortKey: key,
      sortAscending: ascending,
      roots: List.of(state.roots),
    );
  }

  void toggleExpand(String path) {
    final next = Set<String>.from(state.collapsedPaths);
    if (!next.add(path)) next.remove(path);
    state = state.copyWith(collapsedPaths: next);
  }

  /// 文件改自身；文件夹改其下全部文件。成功为 `null`。
  Future<String?> setPriority(TorrentContentNode node, int priority) async {
    if (_priorityBusy) return null;
    if (priority != mixedFilePriority && node.priority == priority) {
      return null;
    }
    final ids = node.fileIndexes;
    if (ids.isEmpty) return null;

    node.applyPriority(priority);
    recomputeContentFolders(state.roots);
    _priorityBusy = true;
    state = state.copyWith(roots: List.of(state.roots));

    _poll.stop();

    String? error;
    await ref
        .read(apiClientProvider)
        .post<void>(
          ApiPath.torrentManagement.filePrio,
          data: {'hash': hash, 'id': ids.join('|'), 'priority': '$priority'},
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) {
          error = switch (e.statusCode) {
            400 => _l10n.priorityInvalid,
            404 => _l10n.torrentNotFound,
            409 => _l10n.metadataNotReady,
            _ => e.message,
          };
        });

    _priorityBusy = false;
    if (!ref.mounted) return error;
    await _poll.refreshNow();
    return error;
  }

  /// 只改当前节点名称（不含路径）。成功为 `null`。
  Future<String?> rename(TorrentContentNode node, String rawName) async {
    if (_renameBusy) return null;
    final name = rawName.trim();
    final invalid = _validateRenameName(name);
    if (invalid != null) return invalid;
    if (name == node.name) return null;

    final oldPath = node.renameOldPath;
    final newPath = contentJoinPath(contentParentPath(oldPath), name);
    if (newPath == oldPath) return null;

    _renameBusy = true;
    _poll.stop();

    String? error;
    await ref
        .read(apiClientProvider)
        .post<void>(
          node.isFolder
              ? ApiPath.torrentManagement.renameFolder
              : ApiPath.torrentManagement.renameFile,
          data: {'hash': hash, 'oldPath': oldPath, 'newPath': newPath},
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) {
          error = switch (e.statusCode) {
            400 => _l10n.enterNewName,
            404 => _l10n.torrentNotFound,
            409 => _l10n.nameTaken,
            _ => e.message,
          };
        });

    if (!ref.mounted) {
      _renameBusy = false;
      return error;
    }
    if (error == null) {
      final displayNewPath = contentJoinPath(
        contentParentPath(node.path),
        name,
      );
      state = state.copyWith(
        collapsedPaths: remapCollapsedPaths(
          state.collapsedPaths,
          node.path,
          displayNewPath,
        ),
      );
    }
    _renameBusy = false;
    await _poll.refreshNow();
    return error;
  }

  String? _validateRenameName(String name) {
    if (name.isEmpty) return _l10n.enterName;
    if (name.contains('/') || name.contains('\\')) {
      return _l10n.nameNoPathSeparator;
    }
    if (name == '.' || name == '..') return _l10n.nameInvalid;
    return null;
  }

  Future<void> _onPoll(PollTicket ticket) async {
    if (hash.isEmpty) {
      state = state.copyWith(emptyState: EmptyState.error(_l10n.invalidTorrent));
      ticket.stopPolling();
      return;
    }

    List<TorrentFileResponse>? files;
    String? error;
    await ref
        .read(apiClientProvider)
        .get(
          ApiPath.torrentManagement.files,
          queryParameters: {'hash': hash},
          cancelToken: ticket.cancelToken,
          parser: parseTorrentFiles,
        )
        .onSuccess((data) {
          files = data;
        })
        .onFail((e) {
          if (e.isCancel) return;
          error = e.statusCode == 404 ? _l10n.torrentNotFound : e.message;
        });

    if (!ticket.isActive) return;

    if (files == null) {
      if (state.roots.isEmpty) {
        state = state.copyWith(emptyState: EmptyState.error(error ?? _l10n.loadFailed));
      }
      return;
    }

    final roots = buildContentTree(files!);
    sortContentTree(roots, state.sortKey, state.sortAscending);
    state = state.copyWith(emptyState: EmptyState.fromItems(roots), roots: roots);
  }
}

