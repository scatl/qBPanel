import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/entity/response/maindata_response.dart';
import 'package:qbpanel/api/entity/response/server_state_response.dart';
import 'package:qbpanel/api/entity/response/torrent_category_response.dart';
import 'package:qbpanel/api/entity/response/torrent_info_response.dart';
import 'package:qbpanel/home/home_page_ui_state.dart';
import 'package:qbpanel/home/entity/torrent_category_filter.dart';
import 'package:qbpanel/home/entity/torrent_category_node.dart';
import 'package:qbpanel/home/entity/torrent_sort.dart';
import 'package:qbpanel/home/entity/torrent_status_filter.dart';
import 'package:qbpanel/home/entity/torrent_tag.dart';
import 'package:qbpanel/detail/general/speed/torrent_speed_history_view_model.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/http/poll_loop.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/l10n/app_localizations.dart';
import 'package:qbpanel/log/util/log_search.dart';
import 'package:qbpanel/storage/db/app_database.dart';
import 'package:qbpanel/storage/db/app_database_provider.dart';
import 'package:qbpanel/widget/refresh/paged_refresh_state.dart';

final homePageProvider = NotifierProvider<HomePageViewModel, HomePageUiState>(
  HomePageViewModel.new,
);

class HomePageViewModel extends Notifier<HomePageUiState> {
  int _rid = 0;
  final Map<String, TorrentInfoResponse> _torrentsByHash = {};
  final Map<String, TorrentCategoryResponse> _categoriesByName = {};
  final Set<String> _tags = {};

  /// 当前绑定的活跃服务器 id；`null` 表示还没绑过。
  int? _activeServerId;

  /// 下一次 [PollLoop] 拍是否为用户下拉（全量 + 刷新态）。
  bool _userRefreshPending = false;

  /// 备用限速切换进行中，避免连点打成两次 toggle。
  bool _altSpeedBusy = false;

  Timer? _searchDebounce;

  late PollLoop _poll;

  AppLocalizations get _l10n => ref.read(appLocalizationsProvider);

  @override
  HomePageUiState build() {
    final ui = HomePageUiState();
    ui.pageListState.beginInit();

    _poll = PollLoop(
      ref: ref,
      onPoll: _onPoll,
      canPoll: () => _activeServerId != null,
    )..attach(startImmediately: false);

    final db = ref.read(appDatabaseProvider);
    final sub = (db.select(db.qbServers)..where((t) => t.isActive.equals(true)))
        .watchSingleOrNull()
        .listen(_onActiveServerChanged);
    ref.onDispose(() {
      sub.cancel();
      _searchDebounce?.cancel();
    });

    return ui;
  }

  /// 用户下拉刷新：显示刷新态，失败可进错误页；强制全量。
  Future<void> refresh() async {
    _userRefreshPending = true;
    await _poll.refreshNow(ignoreCanPoll: true);
  }

  /// 内部同步（操作后 / 定时）：不打刷新动画。
  Future<void> sync() => _poll.refreshNow();

  void setStatusFilter(TorrentStatusFilter filter) {
    if (state.statusFilter == filter) return;
    state = state.copyWith(statusFilter: filter);
    _reapplyListFilter();
  }

  void setCategoryFilter(TorrentCategoryFilter filter) {
    if (state.categoryFilter == filter) return;
    state = state.copyWith(categoryFilter: filter);
    _reapplyListFilter();
  }

  void setTagFilter(TorrentTagFilter filter) {
    if (state.tagFilter == filter) return;
    state = state.copyWith(tagFilter: filter);
    _reapplyListFilter();
  }

  /// 点同一项切换升降序；换项则按该属性升序。
  void setSort(TorrentSortKey key) {
    if (state.sortKey == key) {
      state = state.copyWith(sortAscending: !state.sortAscending);
    } else {
      state = state.copyWith(sortKey: key, sortAscending: true);
    }
    _reapplyListFilter();
  }

  void setSearchQuery(String query) {
    if (query == state.searchQuery) return;
    state = state.copyWith(searchQuery: query);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!ref.mounted) return;
      _reapplyListFilter();
    });
  }

  void clearSearchQuery() {
    _searchDebounce?.cancel();
    if (state.searchQuery.isEmpty) return;
    state = state.copyWith(searchQuery: '');
    _reapplyListFilter();
  }

  void clearFilters() {
    if (state.statusFilter == TorrentStatusFilter.all &&
        state.categoryFilter.isAll &&
        state.tagFilter.isAll) {
      return;
    }
    state = state.copyWith(
      statusFilter: TorrentStatusFilter.all,
      categoryFilter: TorrentCategoryFilter.all,
      tagFilter: TorrentTagFilter.all,
    );
    _reapplyListFilter();
  }

  void _reapplyListFilter() {
    final pageListState = state.pageListState;
    if (pageListState.initLoading && _torrentsByHash.isEmpty) return;
    _applyFilteredList(pageListState);
    state = state.copyWith(pageListState: pageListState);
  }

  /// 当前选中的分类/标签已不在缓存里时，打回「全部」。
  /// 须在 `_applyFilteredList` 之前调用。
  void _dropMissingFilters() {
    var categoryFilter = state.categoryFilter;
    var tagFilter = state.tagFilter;
    final path = categoryFilter.path;
    if (path != null && !_categoriesByName.containsKey(path)) {
      categoryFilter = TorrentCategoryFilter.all;
    }
    final name = tagFilter.name;
    if (name != null && !_tags.contains(name)) {
      tagFilter = TorrentTagFilter.all;
    }
    if (categoryFilter == state.categoryFilter &&
        tagFilter == state.tagFilter) {
      return;
    }
    state = state.copyWith(
      categoryFilter: categoryFilter,
      tagFilter: tagFilter,
    );
  }

  TorrentCategoryResponse? categoryOf(String name) => _categoriesByName[name];

  TorrentInfoResponse? torrentByHash(String hash) => _torrentsByHash[hash];

  /// 切换全局备用速度限制。失败返回错误文案。
  Future<String?> toggleAltSpeedLimits() async {
    if (_altSpeedBusy) return null;
    final current = state.serverState;
    if (current == null) return null;
    final enabled = current.useAltSpeedLimits == true;
    _altSpeedBusy = true;
    _patchAltSpeedLimits(!enabled);
    String? error;
    try {
      final api = ref.read(apiClientProvider);
      await api
          .post<void>(
            ApiPath.transfer.toggleSpeedLimitsMode,
            options: Options(contentType: Headers.formUrlEncodedContentType),
            parser: (_) {},
          )
          .onFail((e) {
            error = e.message;
          });
      if (error != null) {
        _patchAltSpeedLimits(enabled);
        return error;
      }
      unawaited(sync());
      return null;
    } finally {
      _altSpeedBusy = false;
    }
  }

  void _patchAltSpeedLimits(bool enabled) {
    final current = state.serverState;
    if (current == null) return;
    state = state.copyWith(
      serverState: current.merge(
        ServerStateResponse(useAltSpeedLimits: enabled),
      ),
    );
  }

  /// 设置当前生效的全局上下行限速（bytes/s；`0` 为不限）。
  /// 开启备用速度限制时，qB 会改备用限速；否则改普通全局限速。
  Future<String?> setGlobalSpeedLimits({
    required int downloadBytesPerSec,
    required int uploadBytesPerSec,
  }) async {
    final api = ref.read(apiClientProvider);
    Future<String?> postLimit(String path, int limit) async {
      String? error;
      await api
          .post<void>(
            path,
            data: {'limit': '$limit'},
            options: Options(contentType: Headers.formUrlEncodedContentType),
            parser: (_) {},
          )
          .onFail((e) {
            error = e.message;
          });
      return error;
    }

    final dlError = await postLimit(
      ApiPath.transfer.setDownloadLimit,
      downloadBytesPerSec,
    );
    if (dlError != null) return dlError;
    final upError = await postLimit(
      ApiPath.transfer.setUploadLimit,
      uploadBytesPerSec,
    );
    if (upError != null) return upError;

    final current = state.serverState;
    if (current != null) {
      state = state.copyWith(
        serverState: current.merge(
          ServerStateResponse(
            dlRateLimit: downloadBytesPerSec,
            upRateLimit: uploadBytesPerSec,
          ),
        ),
      );
    }
    unawaited(sync());
    return null;
  }

  Future<String?> fetchDefaultSavePath() async {
    String? path;
    final api = ref.read(apiClientProvider);
    await api
        .get<String>(
          ApiPath.application.defaultSavePath,
          options: Options(responseType: ResponseType.plain),
          parser: (data) => data?.toString().trim() ?? '',
        )
        .onSuccess((data) {
          path = data;
        });
    return path;
  }

  Future<String?> createCategory({
    required String name,
    required String savePath,
    CategoryIncompletePathMode incompletePathMode =
        CategoryIncompletePathMode.followDefault,
    String downloadPath = '',
  }) {
    return _postCategory(
      ApiPath.torrentManagement.createCategory,
      name: name,
      savePath: savePath,
      incompletePathMode: incompletePathMode,
      downloadPath: downloadPath,
    );
  }

  Future<String?> editCategory({
    required String name,
    required String savePath,
    CategoryIncompletePathMode incompletePathMode =
        CategoryIncompletePathMode.followDefault,
    String downloadPath = '',
  }) {
    return _postCategory(
      ApiPath.torrentManagement.editCategory,
      name: name,
      savePath: savePath,
      incompletePathMode: incompletePathMode,
      downloadPath: downloadPath,
    );
  }

  Future<String?> _postCategory(
    String path, {
    required String name,
    required String savePath,
    required CategoryIncompletePathMode incompletePathMode,
    required String downloadPath,
  }) async {
    final data = <String, String>{'category': name, 'savePath': savePath};
    switch (incompletePathMode) {
      case CategoryIncompletePathMode.followDefault:
        break;
      case CategoryIncompletePathMode.yes:
        data['downloadPathEnabled'] = 'true';
        data['downloadPath'] = downloadPath.trim();
      case CategoryIncompletePathMode.no:
        data['downloadPathEnabled'] = 'false';
    }
    String? error;
    final api = ref.read(apiClientProvider);
    await api
        .post<void>(
          path,
          data: data,
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) {
          error = e.message;
        });
    if (error != null) return error;
    await sync();
    return null;
  }

  /// 删除分类（只传父路径，服务端会去掉子孙）。成功后立刻同步 maindata。
  /// 返回错误文案；成功为 `null`。
  Future<String?> removeCategory(String name) => removeCategories([name]);

  /// 没有种子（含子孙）的真实分类名。
  List<String> unusedCategoryNames() {
    final counts = _countByCategory();
    return [
      for (final name in _categoriesByName.keys)
        if (counts.of(name) == 0) name,
    ];
  }

  Future<String?> removeUnusedCategories() =>
      removeCategories(unusedCategoryNames());

  Future<String?> removeCategories(Iterable<String> names) async {
    final list = [
      for (final name in names)
        if (name.isNotEmpty) name,
    ];
    if (list.isEmpty) return null;
    String? error;
    final api = ref.read(apiClientProvider);
    await api
        .post<void>(
          ApiPath.torrentManagement.removeCategories,
          data: {'categories': list.join('\n')},
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) {
          error = e.message;
        });
    if (error != null) return error;
    await sync();
    return null;
  }

  Future<String?> createTags(Iterable<String> names) {
    return _postTags(ApiPath.torrentManagement.createTags, names);
  }

  Future<String?> deleteTag(String name) => deleteTags([name]);

  List<String> unusedTagNames() {
    final counts = _countByTag();
    return [
      for (final name in _tags)
        if (counts.of(name) == 0) name,
    ];
  }

  Future<String?> deleteUnusedTags() => deleteTags(unusedTagNames());

  Future<String?> deleteTags(Iterable<String> names) {
    return _postTags(ApiPath.torrentManagement.deleteTags, names);
  }

  Future<String?> addTorrentTags(String hash, Iterable<String> names) async {
    final list = [
      for (final name in names)
        if (name.isNotEmpty) name,
    ];
    if (list.isEmpty) return null;
    final error = await _postTorrentHashes(
      ApiPath.torrentManagement.addTags,
      hash,
      extra: {'tags': list.join(',')},
    );
    if (error != null) return error;
    _patchTorrentTags(hash, add: list);
    return null;
  }

  Future<String?> removeTorrentTags(String hash, Iterable<String> names) async {
    final list = [
      for (final name in names)
        if (name.isNotEmpty) name,
    ];
    if (list.isEmpty) return null;
    final error = await _postTorrentHashes(
      ApiPath.torrentManagement.removeTags,
      hash,
      extra: {'tags': list.join(',')},
    );
    if (error != null) return error;
    _patchTorrentTags(hash, remove: list);
    return null;
  }

  /// `tags` 传空，去掉该种子上的全部标签。
  Future<String?> clearTorrentTags(String hash) async {
    final error = await _postTorrentHashes(
      ApiPath.torrentManagement.removeTags,
      hash,
      extra: const {'tags': ''},
    );
    if (error != null) return error;
    _patchTorrentTags(hash, clear: true);
    return null;
  }

  Future<String?> setTorrentCategory(String hash, String category) async {
    final error = await _postTorrentHashes(
      ApiPath.torrentManagement.setCategory,
      hash,
      extra: {'category': category},
      errorOf: (e) => switch (e.statusCode) {
        409 => _l10n.categoryNotFound,
        _ => e.message,
      },
    );
    if (error != null) return error;
    _patchTorrent(hash, TorrentInfoResponse(category: category));
    return null;
  }

  Future<String?> startTorrent(String hash) {
    return _postTorrentHashes(ApiPath.torrentManagement.start, hash);
  }

  Future<String?> stopTorrent(String hash) {
    return _postTorrentHashes(ApiPath.torrentManagement.stop, hash);
  }

  Future<String?> startDisplayedTorrents() {
    return _postDisplayedTorrents(ApiPath.torrentManagement.start);
  }

  Future<String?> stopDisplayedTorrents() {
    return _postDisplayedTorrents(ApiPath.torrentManagement.stop);
  }

  Future<String?> _postDisplayedTorrents(String path) {
    final hashes = [
      for (final torrent in state.pageListState.items)
        if (torrent.hash != null && torrent.hash!.isNotEmpty) torrent.hash!,
    ];
    if (hashes.isEmpty) return Future.value(_l10n.noTorrentsToOperate);
    return _postTorrentHashes(path, hashes.join('|'));
  }

  Future<String?> forceStartTorrent(String hash) {
    return _postTorrentHashes(
      ApiPath.torrentManagement.setForceStart,
      hash,
      extra: const {'value': 'true'},
    );
  }

  Future<String?> deleteTorrent(String hash, {required bool deleteFiles}) {
    return _postTorrentHashes(
      ApiPath.torrentManagement.delete,
      hash,
      extra: {'deleteFiles': deleteFiles ? 'true' : 'false'},
    );
  }

  Future<String?> recheckTorrent(String hash) {
    return _postTorrentHashes(ApiPath.torrentManagement.recheck, hash);
  }

  Future<String?> reannounceTorrent(String hash) {
    return _postTorrentHashes(ApiPath.torrentManagement.reannounce, hash);
  }

  Future<String?> renameTorrent(String hash, String rawName) async {
    final name = rawName.trim();
    if (name.isEmpty) return _l10n.enterName;
    final current = _torrentsByHash[hash]?.name?.trim() ?? '';
    if (name == current) return null;
    final error = await _postTorrentHashes(
      ApiPath.torrentManagement.rename,
      hash,
      extra: {'name': name},
      hashKey: 'hash',
      errorOf: (e) => switch (e.statusCode) {
        400 => _l10n.enterName,
        409 => _l10n.nameInvalid,
        _ => e.message,
      },
    );
    if (error != null) return error;
    _patchTorrent(hash, TorrentInfoResponse(name: name));
    return null;
  }

  /// 把 `.torrent` 写到缓存目录，供系统分享。成功时 [error] 为空。
  Future<({String? filePath, String? fileName, String? error})>
  exportTorrentFile(String hash, {String? name}) async {
    final trimmed = hash.trim();
    if (trimmed.isEmpty) {
      return (filePath: null, fileName: null, error: _l10n.invalidTorrent);
    }
    Uint8List? bytes;
    String? error;
    await ref
        .read(apiClientProvider)
        .get<Uint8List>(
          ApiPath.torrentManagement.export,
          queryParameters: {'hash': trimmed},
          options: Options(responseType: ResponseType.bytes),
          parser: (data) {
            if (data is Uint8List) return data;
            if (data is List<int>) return Uint8List.fromList(data);
            throw StateError(_l10n.invalidTorrentFile);
          },
        )
        .onSuccess((data) => bytes = data)
        .onFail((e) {
          error = switch (e.statusCode) {
            404 => _l10n.torrentNotFound,
            409 => _l10n.torrentFileNotReady,
            _ => e.message,
          };
        });
    if (error != null) {
      return (filePath: null, fileName: null, error: error);
    }
    if (bytes == null || bytes!.isEmpty) {
      return (filePath: null, fileName: null, error: _l10n.shareContentEmpty);
    }
    try {
      final fileName = _torrentExportFileName(name, trimmed);
      final dir = await getTemporaryDirectory();
      final file = File(p.join(dir.path, fileName));
      await file.writeAsBytes(bytes!, flush: true);
      return (filePath: file.path, fileName: fileName, error: null);
    } catch (_) {
      return (filePath: null, fileName: null, error: _l10n.prepareShareFailed);
    }
  }

  Future<String?> setTorrentLocation(String hash, String location) {
    final path = location.trim();
    if (path.isEmpty) return Future.value(_l10n.savePathRequired);
    return _postTorrentHashes(
      ApiPath.torrentManagement.setLocation,
      hash,
      extra: {'location': path},
      errorOf: (e) => switch (e.statusCode) {
        400 => _l10n.savePathRequired,
        403 => _l10n.savePathNoPermission,
        409 => _l10n.savePathCreateFailed,
        _ => e.message,
      },
    );
  }

  Future<String?> setTorrentAutoTmm(String hash, {required bool enable}) {
    return _postTorrentHashes(
      ApiPath.torrentManagement.setAutoManagement,
      hash,
      extra: {'enable': enable ? 'true' : 'false'},
    );
  }

  Future<String?> setTorrentSuperSeeding(String hash, {required bool enable}) {
    return _postTorrentHashes(
      ApiPath.torrentManagement.setSuperSeeding,
      hash,
      extra: {'value': enable ? 'true' : 'false'},
    );
  }

  Future<String?> toggleTorrentSequentialDownload(String hash) async {
    final enabled = _torrentsByHash[hash]?.seqDl == true;
    final error = await _postTorrentHashes(
      ApiPath.torrentManagement.toggleSequentialDownload,
      hash,
    );
    if (error != null) return error;
    _patchTorrent(hash, TorrentInfoResponse(seqDl: !enabled));
    return null;
  }

  Future<String?> toggleTorrentFirstLastPiecePrio(String hash) async {
    final enabled = _torrentsByHash[hash]?.fLPiecePrio == true;
    final error = await _postTorrentHashes(
      ApiPath.torrentManagement.toggleFirstLastPiecePrio,
      hash,
    );
    if (error != null) return error;
    _patchTorrent(hash, TorrentInfoResponse(fLPiecePrio: !enabled));
    return null;
  }

  Future<String?> moveTorrentQueueTop(String hash) {
    return _postTorrentQueue(ApiPath.torrentManagement.topPrio, hash);
  }

  Future<String?> moveTorrentQueueUp(String hash) {
    return _postTorrentQueue(ApiPath.torrentManagement.increasePrio, hash);
  }

  Future<String?> moveTorrentQueueDown(String hash) {
    return _postTorrentQueue(ApiPath.torrentManagement.decreasePrio, hash);
  }

  Future<String?> moveTorrentQueueBottom(String hash) {
    return _postTorrentQueue(ApiPath.torrentManagement.bottomPrio, hash);
  }

  Future<String?> _postTorrentQueue(String path, String hash) {
    return _postTorrentHashes(
      path,
      hash,
      errorOf: (e) => switch (e.statusCode) {
        409 => _l10n.queueingDisabled,
        _ => e.message,
      },
    );
  }

  Future<String?> setTorrentDownloadLimit(String hash, int bytesPerSec) {
    return _postTorrentHashes(
      ApiPath.torrentManagement.setDownloadLimit,
      hash,
      extra: {'limit': '$bytesPerSec'},
    );
  }

  Future<String?> setTorrentUploadLimit(String hash, int bytesPerSec) {
    return _postTorrentHashes(
      ApiPath.torrentManagement.setUploadLimit,
      hash,
      extra: {'limit': '$bytesPerSec'},
    );
  }

  /// 先写接口再 sync；sync 增量经常不含新限速，成功后把提交值写回缓存。
  Future<String?> setTorrentSpeedLimits(
    String hash, {
    int? downloadBytesPerSec,
    required int uploadBytesPerSec,
  }) async {
    if (downloadBytesPerSec != null) {
      final error = await _postTorrentHashes(
        ApiPath.torrentManagement.setDownloadLimit,
        hash,
        extra: {'limit': '$downloadBytesPerSec'},
        syncAfter: false,
      );
      if (error != null) return error;
    }
    final error = await _postTorrentHashes(
      ApiPath.torrentManagement.setUploadLimit,
      hash,
      extra: {'limit': '$uploadBytesPerSec'},
    );
    if (error != null) return error;
    _patchTorrent(
      hash,
      TorrentInfoResponse(
        dlLimit: downloadBytesPerSec,
        upLimit: uploadBytesPerSec,
      ),
    );
    return null;
  }

  /// [ratioLimit]：`-2` 全局、`-1` 不限，否则为分享率。
  /// [seedingTimeLimit] / [inactiveSeedingTimeLimit]：分钟；同样 `-2` / `-1`。
  /// [shareLimitAction] 仅 qB 5.2+ 需要。
  Future<String?> setTorrentShareLimits(
    String hash, {
    required double ratioLimit,
    required int seedingTimeLimit,
    required int inactiveSeedingTimeLimit,
    String? shareLimitAction,
  }) async {
    final error = await _postTorrentHashes(
      ApiPath.torrentManagement.setShareLimits,
      hash,
      extra: {
        'ratioLimit': _shareLimitNumber(ratioLimit),
        'seedingTimeLimit': '$seedingTimeLimit',
        'inactiveSeedingTimeLimit': '$inactiveSeedingTimeLimit',
        'shareLimitAction': ?shareLimitAction,
      },
      errorOf: (e) => switch (e.statusCode) {
        400 => _l10n.invalidParam,
        _ => e.message,
      },
    );
    if (error != null) return error;
    _patchTorrent(
      hash,
      TorrentInfoResponse(
        ratioLimit: ratioLimit,
        seedingTimeLimit: _shareLimitSecondsForCache(seedingTimeLimit),
        inactiveSeedingTimeLimit: _shareLimitSecondsForCache(
          inactiveSeedingTimeLimit,
        ),
        shareLimitAction: shareLimitAction,
      ),
    );
    return null;
  }

  String _shareLimitNumber(double value) {
    if (value == value.roundToDouble()) return value.round().toString();
    return value.toString();
  }

  int _shareLimitSecondsForCache(int minutes) {
    if (minutes < 0) return minutes;
    return minutes * 60;
  }

  void _patchTorrent(String hash, TorrentInfoResponse patch) {
    final existing = _torrentsByHash[hash];
    if (existing == null) return;
    _torrentsByHash[hash] = existing.merge(patch);
    state = state.copyWith(pageListState: state.pageListState);
  }

  void _patchTorrentTags(
    String hash, {
    Iterable<String>? add,
    Iterable<String>? remove,
    bool clear = false,
  }) {
    final existing = _torrentsByHash[hash];
    if (existing == null) return;
    if (clear) {
      _patchTorrent(hash, const TorrentInfoResponse(tags: ''));
      return;
    }
    final current = [...splitTorrentTags(existing.tags)];
    if (add != null) {
      for (final name in add) {
        if (!current.contains(name)) current.add(name);
      }
    }
    if (remove != null) {
      current.removeWhere(remove.contains);
    }
    _patchTorrent(hash, TorrentInfoResponse(tags: current.join(',')));
  }

  Future<String?> _postTorrentHashes(
    String path,
    String hash, {
    Map<String, String> extra = const {},
    String Function(ApiFailure e)? errorOf,
    bool syncAfter = true,
    String hashKey = 'hashes',
  }) async {
    final trimmed = hash.trim();
    if (trimmed.isEmpty) return _l10n.invalidTorrent;
    String? error;
    final api = ref.read(apiClientProvider);
    await api
        .post<void>(
          path,
          data: {hashKey: trimmed, ...extra},
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) {
          error = errorOf?.call(e) ?? e.message;
        });
    if (error != null) return error;
    if (!syncAfter) return null;
    await sync();
    return null;
  }

  Future<String?> _postTags(String path, Iterable<String> names) async {
    final list = [
      for (final name in names)
        if (name.isNotEmpty) name,
    ];
    if (list.isEmpty) return null;
    String? error;
    final api = ref.read(apiClientProvider);
    await api
        .post<void>(
          path,
          data: {'tags': list.join(',')},
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) {
          error = e.message;
        });
    if (error != null) return error;
    await sync();
    return null;
  }

  /// 活跃服务器变化：无服务器则清空；同 id 只更新标题；换 id 则丢弃旧会话并全量同步。
  void _onActiveServerChanged(QbServer? server) {
    log('active server changed');
    if (server == null) {
      _poll.stop();
      _activeServerId = null;
      _userRefreshPending = false;
      _clearTorrentCache();
      ref.read(torrentSpeedHistoryProvider.notifier).clear();
      final pageListState = state.pageListState;
      pageListState.setEmpty();
      state = HomePageUiState(pageListState: pageListState);
      return;
    }

    // 同一台（例如改了名称）：只刷新 UiState，不重置 rid。
    if (server.id == _activeServerId) {
      state = state.copyWith(activeServer: server);
      return;
    }

    // id 变了（含第一次绑到服务器）：丢掉旧会话，列表重新转圈后全量拉。
    _activeServerId = server.id;
    _poll.stop();
    _userRefreshPending = false;
    _clearTorrentCache();
    ref.read(torrentSpeedHistoryProvider.notifier).clear();

    final pageListState = state.pageListState;
    pageListState.setEmpty();
    pageListState.beginInit();
    state = HomePageUiState(activeServer: server, pageListState: pageListState);
    unawaited(sync());
  }

  void _recordSpeedSamples() {
    final serverId = _activeServerId;
    if (serverId == null || _torrentsByHash.isEmpty) return;
    ref
        .read(torrentSpeedHistoryProvider.notifier)
        .recordAll(serverId: serverId, torrents: _torrentsByHash);
  }

  Future<void> _onPoll(PollTicket ticket) async {
    final userRefresh = _userRefreshPending;
    _userRefreshPending = false;

    final pageListState = state.pageListState;
    if (userRefresh && !pageListState.initLoading) {
      pageListState.beginRefresh();
      state = state.copyWith(pageListState: pageListState);
    }
    if (userRefresh) {
      _rid = 0;
    }

    final activeServer = await _activeServer();
    if (!ticket.isActive) return;
    if (activeServer == null) {
      _clearTorrentCache();
      ref.read(torrentSpeedHistoryProvider.notifier).clear();
      pageListState.setEmpty();
      state = HomePageUiState(pageListState: pageListState);
      ticket.stopPolling();
      return;
    }

    state = state.copyWith(
      activeServer: activeServer,
      pageListState: pageListState,
    );

    final api = ref.read(apiClientProvider);
    await api
        .get(
          ApiPath.sync.mainData,
          queryParameters: {'rid': _rid},
          cancelToken: ticket.cancelToken,
          parser: jsonParser(MainDataResponse.fromJson),
        )
        .onSuccess((data) {
          if (!ticket.isActive) return;
          if (activeServer.id != _activeServerId) return;
          _applyMainData(data);
          _recordSpeedSamples();
          _dropMissingFilters();
          _applyFilteredList(pageListState);
          state = state.copyWith(
            serverState: _mergeServerState(data),
            pageListState: pageListState,
            activeServer: activeServer,
            hasTorrents: _torrentsByHash.isNotEmpty,
            statusCounts: _countByStatus(),
            categoryTree: buildCategoryTree(_categoriesByName.keys),
            categoryCounts: _countByCategory(),
            tags: _sortedTags(),
            tagCounts: _countByTag(),
          );
        })
        .onFail((e) {
          if (!ticket.isActive) return;
          if (e.isCancel) return;
          final hasItems =
              pageListState.items.isNotEmpty || _torrentsByHash.isNotEmpty;
          if (userRefresh || !hasItems) {
            pageListState.setError(e.message, keepItems: hasItems);
            state = state.copyWith(pageListState: pageListState);
          }
        });
  }

  Map<TorrentStatusFilter, int> _countByStatus() {
    final counts = {for (final filter in TorrentStatusFilter.values) filter: 0};
    for (final torrent in _torrentsByHash.values) {
      for (final filter in TorrentStatusFilter.values) {
        if (filter.matches(torrent)) {
          counts[filter] = counts[filter]! + 1;
        }
      }
    }
    return counts;
  }

  TorrentCategoryCounts _countByCategory() {
    final byPath = <String, int>{};
    for (final name in _categoriesByName.keys) {
      var path = name;
      while (path.isNotEmpty) {
        byPath.putIfAbsent(path, () => 0);
        final slash = path.lastIndexOf('/');
        if (slash < 0) break;
        path = path.substring(0, slash);
      }
    }
    var uncategorized = 0;
    for (final torrent in _torrentsByHash.values) {
      final category = torrent.category ?? '';
      if (category.isEmpty) {
        uncategorized++;
        continue;
      }
      var path = category;
      while (true) {
        final current = byPath[path];
        if (current != null) {
          byPath[path] = current + 1;
        }
        final slash = path.lastIndexOf('/');
        if (slash < 0) break;
        path = path.substring(0, slash);
      }
    }
    return TorrentCategoryCounts(
      all: _torrentsByHash.length,
      uncategorized: uncategorized,
      byPath: byPath,
    );
  }

  List<String> _sortedTags() {
    final names = _tags.toList()..sort();
    return names;
  }

  TorrentTagCounts _countByTag() {
    final byName = {for (final name in _tags) name: 0};
    var untagged = 0;
    for (final torrent in _torrentsByHash.values) {
      final names = splitTorrentTags(torrent.tags);
      if (names.isEmpty) {
        untagged++;
        continue;
      }
      for (final name in names) {
        final current = byName[name];
        if (current != null) {
          byName[name] = current + 1;
        }
      }
    }
    return TorrentTagCounts(
      all: _torrentsByHash.length,
      untagged: untagged,
      byName: byName,
    );
  }

  void _applyFilteredList(
    PagedRefreshState<TorrentInfoResponse> pageListState,
  ) {
    final status = state.statusFilter;
    final category = state.categoryFilter;
    final tag = state.tagFilter;
    final sortKey = state.sortKey;
    final sortAscending = state.sortAscending;
    final searchTerms = parseLogSearchTerms(state.searchQuery);
    final items =
        [
          for (final torrent in _torrentsByHash.values)
            if (status.matches(torrent) &&
                category.matches(torrent.category) &&
                tag.matches(torrent.tags) &&
                logContainsAllTerms(torrent.name ?? '', searchTerms))
              torrent,
        ]..sort((a, b) {
          final order = sortKey.compare(a, b, ascending: sortAscending);
          if (order != 0) return order;
          return (a.hash ?? '').compareTo(b.hash ?? '');
        });
    pageListState.setSuccess(data: items, append: false, hasMore: false);
  }

  void _applyMainData(MainDataResponse data) {
    if (data.fullUpdate) {
      _replaceTorrents(data.torrents);
      _replaceCategories(data.categories);
      _replaceTags(data.tags);
    } else {
      _mergeTorrents(data.torrents, data.torrentsRemoved);
      _mergeCategories(data.categories, data.categoriesRemoved);
      _mergeTags(data.tags, data.tagsRemoved);
    }
    _rid = data.rid;
  }

  void _replaceCategories(Map<String, TorrentCategoryResponse>? incoming) {
    _categoriesByName
      ..clear()
      ..addAll(incoming ?? const {});
  }

  void _mergeCategories(
    Map<String, TorrentCategoryResponse>? incoming,
    List<String> removed,
  ) {
    if (incoming != null) {
      for (final entry in incoming.entries) {
        final existing = _categoriesByName[entry.key];
        _categoriesByName[entry.key] = existing == null
            ? entry.value
            : existing.merge(entry.value);
      }
    }
    for (final name in removed) {
      _categoriesByName.remove(name);
    }
  }

  void _replaceTags(List<String> incoming) {
    _tags
      ..clear()
      ..addAll(incoming);
  }

  void _mergeTags(List<String> incoming, List<String> removed) {
    _tags.addAll(incoming);
    for (final name in removed) {
      _tags.remove(name);
    }
  }

  void _replaceTorrents(Map<String, TorrentInfoResponse>? incoming) {
    _torrentsByHash
      ..clear()
      ..addAll(incoming ?? const {});
  }

  void _mergeTorrents(
    Map<String, TorrentInfoResponse>? incoming,
    List<String> removed,
  ) {
    if (incoming != null) {
      for (final entry in incoming.entries) {
        final existing = _torrentsByHash[entry.key];
        _torrentsByHash[entry.key] = existing == null
            ? entry.value
            : existing.merge(entry.value);
      }
    }
    for (final hash in removed) {
      _torrentsByHash.remove(hash);
    }
  }

  ServerStateResponse? _mergeServerState(MainDataResponse data) {
    final patch = data.serverState;
    if (patch == null) return state.serverState;
    if (data.fullUpdate || state.serverState == null) return patch;
    return state.serverState!.merge(patch);
  }

  /// 丢掉 rid 与种子缓存，下次请求走全量。
  void _clearTorrentCache() {
    _rid = 0;
    _torrentsByHash.clear();
    _categoriesByName.clear();
    _tags.clear();
  }

  Future<QbServer?> _activeServer() async {
    final db = ref.read(appDatabaseProvider);
    final active = await (db.select(
      db.qbServers,
    )..where((t) => t.isActive.equals(true))).getSingleOrNull();
    return active;
  }

  String _torrentExportFileName(String? name, String hash) {
    var base = (name ?? '').trim();
    if (base.isEmpty) {
      base = hash.length > 16 ? hash.substring(0, 16) : hash;
    }
    base = base.replaceAll(RegExp(r'[\\/:*?"<>|\n\r]'), '_');
    base = base.replaceAll(RegExp(r'\s+'), ' ').trim();
    while (base.endsWith('.')) {
      base = base.substring(0, base.length - 1);
    }
    if (base.length > 120) base = base.substring(0, 120);
    if (base.isEmpty) base = 'torrent';
    const ext = '.torrent';
    if (base.toLowerCase().endsWith(ext)) return base;
    return '$base$ext';
  }
}
