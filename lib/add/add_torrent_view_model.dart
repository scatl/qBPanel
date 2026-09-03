import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/util/app_log.dart';
import 'package:qbpanel/add/add_torrent_ui_state.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/entity/response/torrent_metadata_response.dart';
import 'package:qbpanel/detail/content/torrent_content_node.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/l10n/app_localizations.dart';

final addTorrentProvider =
    NotifierProvider.autoDispose<AddTorrentViewModel, AddTorrentUiState>(
  AddTorrentViewModel.new,
);

class AddTorrentViewModel extends Notifier<AddTorrentUiState> {
  static const _pollMs = 1000;

  Timer? _pollTimer;
  CancelToken? _cancelToken;
  int _generation = 0;
  Uint8List? _sourceFileBytes;

  AppLocalizations get _l10n => ref.read(appLocalizationsProvider);

  /// 当前导入的 .torrent 文件字节（添加时上传用）。
  Uint8List? get sourceFileBytes => _sourceFileBytes;

  @override
  AddTorrentUiState build() {
    ref.onDispose(() {
      _pollTimer?.cancel();
      _cancelToken?.cancel();
      _generation++;
      _sourceFileBytes = null;
    });
    Future.microtask(_loadDefaultSavePath);
    return const AddTorrentUiState();
  }

  Future<void> _loadDefaultSavePath() async {
    await ref
        .read(apiClientProvider)
        .get<String>(
          ApiPath.application.defaultSavePath,
          options: Options(responseType: ResponseType.plain),
          parser: (data) => data?.toString().trim() ?? '',
        )
        .onSuccess((path) {
          if (path.isEmpty) return;
          state = state.copyWith(defaultSavePath: path);
        });
  }

  void importMagnet(String url) {
    appLog('add', 'vm.importMagnet ${appLogPreview(url)}');
    _beginImport(
      kind: AddTorrentImportKind.magnet,
      sourceUrl: url,
    );
    _fetchMetadata(url);
  }

  void importFile(String name, Uint8List bytes) {
    appLog(
      'add',
      'vm.importFile name=$name ${appLogHeadHex(bytes)}',
    );
    _beginImport(
      kind: AddTorrentImportKind.file,
      sourceFileName: name,
    );
    _sourceFileBytes = bytes;
    _parseFileMetadata(name, bytes);
  }

  void retryMetadata() {
    _pollTimer?.cancel();
    state = state.copyWith(
      metadataStatus: AddTorrentMetadataStatus.loading,
      clearMetadataError: true,
    );
    if (state.importKind == AddTorrentImportKind.file) {
      final bytes = _sourceFileBytes;
      final name = state.sourceFileName;
      if (bytes == null || name == null || name.isEmpty) return;
      _parseFileMetadata(name, bytes);
      return;
    }
    final url = state.sourceUrl;
    if (url == null || url.isEmpty) return;
    _fetchMetadata(url);
  }

  void toggleExpand(String path) {
    final next = Set<String>.from(state.collapsedPaths);
    if (!next.add(path)) next.remove(path);
    state = state.copyWith(collapsedPaths: next);
  }

  void setFilePriority(TorrentContentNode node, int priority) {
    if (priority == mixedFilePriority) return;
    node.applyPriority(priority);
    recomputeContentFolders(state.fileRoots);
    state = state.copyWith(fileRoots: List.of(state.fileRoots));
  }

  void setManagementMode(TorrentManagementMode value) {
    state = state.copyWith(managementMode: value);
  }

  void setUseIncompletePath(bool value) {
    state = state.copyWith(useIncompletePath: value);
  }

  void setCategory(String value) {
    state = state.copyWith(category: value);
  }

  void toggleTag(String name) {
    final next = Set<String>.from(state.selectedTags);
    if (!next.add(name)) next.remove(name);
    state = state.copyWith(selectedTags: next);
  }

  void setStartTorrent(bool value) {
    state = state.copyWith(startTorrent: value);
  }

  void setAddToTopOfQueue(bool value) {
    state = state.copyWith(addToTopOfQueue: value);
  }

  void setStopCondition(TorrentStopCondition value) {
    state = state.copyWith(stopCondition: value);
  }

  void setSkipHashCheck(bool value) {
    state = state.copyWith(skipHashCheck: value);
  }

  void setContentLayout(TorrentContentLayout value) {
    state = state.copyWith(contentLayout: value);
  }

  void setSequentialDownload(bool value) {
    state = state.copyWith(sequentialDownload: value);
  }

  void setFirstLastPiecePrio(bool value) {
    state = state.copyWith(firstLastPiecePrio: value);
  }

  void setLimitDownloadRate(bool value) {
    state = state.copyWith(limitDownloadRate: value);
  }

  void setLimitUploadRate(bool value) {
    state = state.copyWith(limitUploadRate: value);
  }

  /// 提交添加。成功返回 `null`，失败返回可读错误信息。
  Future<String?> submit({
    required String savePath,
    required String incompletePath,
    required String rename,
    required String dlLimitKib,
    required String upLimitKib,
  }) async {
    if (!state.canSubmit) {
      if (!state.hasSource) return _l10n.importTorrentFirst;
      if (state.isMetadataLoading) return _l10n.fetchingMetadataWait;
      return _l10n.cannotAdd;
    }
    if (state.isFromFile) {
      final bytes = _sourceFileBytes;
      if (bytes == null || bytes.isEmpty) {
        return _l10n.cannotReadTorrentFile;
      }
    }

    state = state.copyWith(isSubmitting: true, clearSubmitError: true);

    final formData = _buildAddFormData(
      savePath: savePath.trim(),
      incompletePath: incompletePath.trim(),
      rename: rename.trim(),
      dlLimitKib: dlLimitKib.trim(),
      upLimitKib: upLimitKib.trim(),
    );
    appLog(
      'add',
      'vm.submit kind=${state.importKind} metadata=${state.metadataStatus} '
      'bytes=${appLogHeadHex(_sourceFileBytes)}',
    );
    appLogFormData('add', formData);

    String? error;
    await ref
        .read(apiClientProvider)
        .post(
          ApiPath.torrentManagement.add,
          data: formData,
          parser: (_) {},
        )
        .onSuccess((_) async {
          appLog('add', 'vm.submit success');
          await _applyFilePrioritiesAfterAdd();
        })
        .onFail((e) {
          if (e.isCancel) return;
          appLog('add', 'vm.submit fail ${appLogApiFailure(e)}');
          error = e.message;
        });

    if (error != null) {
      state = state.copyWith(isSubmitting: false, submitError: error);
      return error;
    }
    state = state.copyWith(isSubmitting: false, clearSubmitError: true);
    return null;
  }

  FormData _buildAddFormData({
    required String savePath,
    required String incompletePath,
    required String rename,
    required String dlLimitKib,
    required String upLimitKib,
  }) {
    final ui = state;
    final autoTmm = ui.isAutoTmm;
    final stopped = !ui.startTorrent;
    final map = <String, dynamic>{
      'autoTMM': autoTmm.toString(),
      'skip_checking': ui.skipHashCheck.toString(),
      'stopped': stopped.toString(),
      'paused': stopped.toString(),
      'sequentialDownload': ui.sequentialDownload.toString(),
      'firstLastPiecePrio': ui.firstLastPiecePrio.toString(),
      'addToTopOfQueue': ui.addToTopOfQueue.toString(),
      'contentLayout': ui.contentLayout.apiValue,
      'stopCondition': ui.stopCondition.apiValue,
    };

    if (!autoTmm) {
      if (savePath.isNotEmpty) map['savepath'] = savePath;
      map['useDownloadPath'] = ui.useIncompletePath.toString();
      if (ui.useIncompletePath && incompletePath.isNotEmpty) {
        map['downloadPath'] = incompletePath;
      }
    }

    if (ui.category.isNotEmpty) map['category'] = ui.category;
    if (ui.selectedTags.isNotEmpty) {
      map['tags'] = ui.selectedTags.join(',');
    }
    if (rename.isNotEmpty) map['rename'] = rename;

    if (ui.limitDownloadRate) {
      final kib = int.tryParse(dlLimitKib);
      if (kib != null && kib > 0) map['dlLimit'] = kib * 1024;
    }
    if (ui.limitUploadRate) {
      final kib = int.tryParse(upLimitKib);
      if (kib != null && kib > 0) map['upLimit'] = kib * 1024;
    }

    if (ui.isFromMagnet) {
      map['urls'] = ui.sourceUrl!.trim();
      // filePriorities 只能跟 urls 一起发（磁力，且元数据已在 qB 缓存里）。
      final useMetadataCache =
          ui.metadataStatus == AddTorrentMetadataStatus.ready;
      final priorities = useMetadataCache
          ? _filePrioritiesFromTree(ui.fileRoots)
          : const <int>[];
      if (priorities.isNotEmpty) {
        map['filePriorities'] = priorities.join(',');
      }
    } else {
      // 本地 .torrent：上传文件字节。不要用 urls=file:文件名——
      // parseMetadata 缓存在 infohash 上，不在文件名上；那条 URL 会变成在 qB 本机找文件。
      map['torrents'] = MultipartFile.fromBytes(
        _sourceFileBytes!,
        filename: _uploadTorrentFileName(ui.sourceFileName),
      );
    }

    return FormData.fromMap(map);
  }

  /// 上传 .torrent 时不能在 add 里带 filePriorities，添加成功后再按文件设置。
  Future<void> _applyFilePrioritiesAfterAdd() async {
    if (!state.isFromFile) return;
    final hash = _torrentHashForApi();
    if (hash == null) {
      appLog('add', 'vm.filePrio skip no hash');
      return;
    }

    final byPrio = <int, List<int>>{};
    void walk(TorrentContentNode node) {
      if (!node.isFolder &&
          node.fileIndex != null &&
          node.priority != 1) {
        byPrio.putIfAbsent(node.priority, () => []).add(node.fileIndex!);
      }
      for (final child in node.children) {
        walk(child);
      }
    }

    for (final root in state.fileRoots) {
      walk(root);
    }
    if (byPrio.isEmpty) return;

    for (final entry in byPrio.entries) {
      appLog(
        'add',
        'vm.filePrio hash=$hash prio=${entry.key} ids=${entry.value}',
      );
      await ref
          .read(apiClientProvider)
          .post<void>(
            ApiPath.torrentManagement.filePrio,
            data: {
              'hash': hash,
              'id': entry.value.join('|'),
              'priority': '${entry.key}',
            },
            options: Options(contentType: Headers.formUrlEncodedContentType),
            parser: (_) {},
          )
          .onFail((e) {
            if (e.isCancel) return;
            appLog('add', 'vm.filePrio fail ${appLogApiFailure(e)}');
          });
    }
  }

  String? _torrentHashForApi() {
    final v1 = state.infohashV1?.trim();
    if (v1 != null && v1.isNotEmpty) return v1;
    final v2 = state.infohashV2?.trim();
    if (v2 != null && v2.isNotEmpty) return v2;
    return null;
  }

  void _beginImport({
    required AddTorrentImportKind kind,
    String? sourceUrl,
    String? sourceFileName,
  }) {
    _pollTimer?.cancel();
    _cancelToken?.cancel();
    _generation++;
    _sourceFileBytes = null;
    state = state.copyWith(
      importKind: kind,
      sourceUrl: sourceUrl,
      clearSourceUrl: sourceUrl == null,
      sourceFileName: sourceFileName,
      clearSourceFileName: sourceFileName == null,
      metadataStatus: AddTorrentMetadataStatus.loading,
      clearMetadata: true,
    );
  }

  Future<void> _fetchMetadata(String source) async {
    final gen = ++_generation;
    _cancelToken?.cancel();
    final token = CancelToken();
    _cancelToken = token;

    await ref
        .read(apiClientProvider)
        .post(
          ApiPath.torrentManagement.fetchMetadata,
          data: {'source': source},
          options: Options(contentType: Headers.formUrlEncodedContentType),
          cancelToken: token,
          parser: jsonParser(TorrentMetadataResponse.fromJson),
        )
        .onSuccess((data) {
          if (gen != _generation) return;
          _applyMetadata(data);
          if (data.hasFullInfo) {
            state = state.copyWith(
              metadataStatus: AddTorrentMetadataStatus.ready,
              clearMetadataError: true,
            );
            return;
          }
          _pollTimer?.cancel();
          _pollTimer = Timer(
            const Duration(milliseconds: _pollMs),
            () {
              if (gen != _generation) return;
              _fetchMetadata(source);
            },
          );
        })
        .onFail((e) {
          if (gen != _generation || e.isCancel) return;
          if (e.statusCode == 404) {
            state = state.copyWith(
              metadataStatus: AddTorrentMetadataStatus.unavailable,
              clearMetadataError: true,
            );
            return;
          }
          state = state.copyWith(
            metadataStatus: AddTorrentMetadataStatus.failed,
            metadataError: e.message,
          );
        });
  }

  Future<void> _parseFileMetadata(String name, Uint8List bytes) async {
    final gen = ++_generation;
    _cancelToken?.cancel();
    final token = CancelToken();
    _cancelToken = token;

    final formData = FormData.fromMap({
      'torrents': MultipartFile.fromBytes(bytes, filename: name),
    });

    await ref
        .read(apiClientProvider)
        .post(
          ApiPath.torrentManagement.parseMetadata,
          data: formData,
          cancelToken: token,
          parser: _parseMetadataPayload,
        )
        .onSuccess((data) {
          if (gen != _generation) return;
          appLog(
            'add',
            'vm.parseMetadata ok hasFullInfo=${data.hasFullInfo}',
          );
          _applyMetadata(data);
          state = state.copyWith(
            metadataStatus: data.hasFullInfo
                ? AddTorrentMetadataStatus.ready
                : AddTorrentMetadataStatus.unavailable,
            clearMetadataError: true,
          );
        })
        .onFail((e) {
          if (gen != _generation || e.isCancel) return;
          appLog(
            'add',
            'vm.parseMetadata fail ${appLogApiFailure(e)}',
          );
          if (e.statusCode == 404) {
            state = state.copyWith(
              metadataStatus: AddTorrentMetadataStatus.unavailable,
              clearMetadataError: true,
            );
            return;
          }
          state = state.copyWith(
            metadataStatus: AddTorrentMetadataStatus.failed,
            metadataError: e.message,
          );
        });
  }

  void _applyMetadata(TorrentMetadataResponse data) {
    final files = metadataToTorrentFiles(data);
    final roots = files.isEmpty ? state.fileRoots : buildContentTree(files);
    state = state.copyWith(
      torrentName: data.info?.name ?? state.torrentName,
      infohashV1: data.infohashV1 ?? data.hash ?? state.infohashV1,
      infohashV2: data.infohashV2 ?? state.infohashV2,
      creationDate: (data.creationDate != null && data.creationDate! > 1)
          ? data.creationDate
          : state.creationDate,
      comment: data.comment ?? state.comment,
      totalSize: data.info?.totalSize ?? state.totalSize,
      fileRoots: roots,
    );
  }
}

/// `parseMetadata`：新版返回数组，旧版可能按文件名 keyed 的对象。
TorrentMetadataResponse _parseMetadataPayload(dynamic data) {
  if (data is List) {
    if (data.isEmpty) return const TorrentMetadataResponse();
    final first = data.first;
    if (first is! Map) return const TorrentMetadataResponse();
    return TorrentMetadataResponse.fromJson(Map<String, dynamic>.from(first));
  }
  if (data is Map) {
    final map = Map<String, dynamic>.from(data);
    if (map.containsKey('info') ||
        map.containsKey('hash') ||
        map.containsKey('infohash_v1') ||
        map.containsKey('infohash_v2')) {
      return TorrentMetadataResponse.fromJson(map);
    }
    for (final value in map.values) {
      if (value is Map) {
        return TorrentMetadataResponse.fromJson(
          Map<String, dynamic>.from(value),
        );
      }
    }
  }
  return const TorrentMetadataResponse();
}

/// multipart 文件名只用 ASCII，避免 Content-Disposition 在部分 qB 上 400。
String _uploadTorrentFileName(String? name) {
  final raw = (name ?? 'torrent.torrent').trim();
  final base = raw.replaceAll(RegExp(r'[^\w.\-]+'), '_');
  if (base.toLowerCase().endsWith('.torrent') &&
      base.length > '.torrent'.length) {
    return base;
  }
  return 'import.torrent';
}

/// 按文件 index 收集优先级；缺号则不发送（避免与服务端 filesCount 不一致）。
List<int> _filePrioritiesFromTree(List<TorrentContentNode> roots) {
  final byIndex = <int, int>{};
  void walk(TorrentContentNode node) {
    if (!node.isFolder && node.fileIndex != null) {
      byIndex[node.fileIndex!] = node.priority;
    }
    for (final child in node.children) {
      walk(child);
    }
  }

  for (final root in roots) {
    walk(root);
  }
  if (byIndex.isEmpty) return const [];

  final maxIndex = byIndex.keys.reduce((a, b) => a > b ? a : b);
  if (maxIndex < 0) return const [];
  for (var i = 0; i <= maxIndex; i++) {
    if (!byIndex.containsKey(i)) return const [];
  }
  return [for (var i = 0; i <= maxIndex; i++) byIndex[i]!];
}
