import 'package:qbpanel/detail/content/torrent_content_node.dart';

/// 对应 WebUI「种子管理模式」。
enum TorrentManagementMode {
  manual('手动'),
  automatic('自动');

  const TorrentManagementMode(this.label);
  final String label;
}

/// 对应 WebUI「停止条件」。
enum TorrentStopCondition {
  none('无', 'None'),
  metadataReceived('已收到元数据', 'MetadataReceived'),
  filesChecked('文件已被检查', 'FilesChecked');

  const TorrentStopCondition(this.label, this.apiValue);
  final String label;
  final String apiValue;

  static TorrentStopCondition fromApi(String? value) {
    for (final item in values) {
      if (item.apiValue == value) return item;
    }
    return TorrentStopCondition.none;
  }
}

/// 对应 WebUI「内容布局」。
enum TorrentContentLayout {
  original('原始', 'Original'),
  createSubfolder('创建子文件夹', 'Subfolder'),
  noSubfolder('不创建子文件夹', 'NoSubfolder');

  const TorrentContentLayout(this.label, this.apiValue);
  final String label;
  final String apiValue;

  static TorrentContentLayout fromApi(String? value) {
    for (final item in values) {
      if (item.apiValue == value) return item;
    }
    return TorrentContentLayout.original;
  }
}

enum AddTorrentImportKind { none, magnet, file }

enum AddTorrentMetadataStatus { idle, loading, ready, unavailable, failed }

class AddTorrentUiState {
  const AddTorrentUiState({
    this.importKind = AddTorrentImportKind.none,
    this.sourceUrl,
    this.sourceFileName,
    this.managementMode = TorrentManagementMode.manual,
    this.defaultSavePath,
    this.useIncompletePath = false,
    this.category = '',
    this.selectedTags = const {},
    this.startTorrent = true,
    this.addToTopOfQueue = false,
    this.stopCondition = TorrentStopCondition.none,
    this.skipHashCheck = false,
    this.contentLayout = TorrentContentLayout.original,
    this.sequentialDownload = false,
    this.firstLastPiecePrio = false,
    this.limitDownloadRate = false,
    this.limitUploadRate = false,
    this.isSubmitting = false,
    this.submitError,
    this.metadataStatus = AddTorrentMetadataStatus.idle,
    this.metadataError,
    this.torrentName,
    this.infohashV1,
    this.infohashV2,
    this.creationDate,
    this.comment,
    this.totalSize,
    this.fileRoots = const [],
    this.collapsedPaths = const {},
  });

  final AddTorrentImportKind importKind;
  final String? sourceUrl;
  final String? sourceFileName;

  final TorrentManagementMode managementMode;

  /// 服务器默认保存路径；手动模式下预填「保存文件到」。
  final String? defaultSavePath;
  final bool useIncompletePath;

  /// 空字符串表示未分类。
  final String category;
  final Set<String> selectedTags;

  final bool startTorrent;
  final bool addToTopOfQueue;
  final TorrentStopCondition stopCondition;
  final bool skipHashCheck;
  final TorrentContentLayout contentLayout;
  final bool sequentialDownload;
  final bool firstLastPiecePrio;
  final bool limitDownloadRate;
  final bool limitUploadRate;

  final bool isSubmitting;
  final String? submitError;

  final AddTorrentMetadataStatus metadataStatus;
  final String? metadataError;
  final String? torrentName;
  final String? infohashV1;
  final String? infohashV2;
  final int? creationDate;
  final String? comment;
  final int? totalSize;
  final List<TorrentContentNode> fileRoots;
  final Set<String> collapsedPaths;

  bool get isAutoTmm => managementMode == TorrentManagementMode.automatic;

  bool get isFromMagnet => importKind == AddTorrentImportKind.magnet;

  bool get isFromFile => importKind == AddTorrentImportKind.file;

  bool get hasSource => importKind != AddTorrentImportKind.none;

  bool get isMetadataLoading =>
      metadataStatus == AddTorrentMetadataStatus.loading;

  bool get canSubmit {
    if (isSubmitting) return false;
    return switch (importKind) {
      AddTorrentImportKind.none => false,
      AddTorrentImportKind.magnet =>
        sourceUrl != null && sourceUrl!.trim().isNotEmpty,
      AddTorrentImportKind.file =>
        sourceFileName != null && sourceFileName!.isNotEmpty,
    };
  }

  AddTorrentUiState copyWith({
    AddTorrentImportKind? importKind,
    String? sourceUrl,
    bool clearSourceUrl = false,
    String? sourceFileName,
    bool clearSourceFileName = false,
    TorrentManagementMode? managementMode,
    String? defaultSavePath,
    bool? useIncompletePath,
    String? category,
    Set<String>? selectedTags,
    bool? startTorrent,
    bool? addToTopOfQueue,
    TorrentStopCondition? stopCondition,
    bool? skipHashCheck,
    TorrentContentLayout? contentLayout,
    bool? sequentialDownload,
    bool? firstLastPiecePrio,
    bool? limitDownloadRate,
    bool? limitUploadRate,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
    AddTorrentMetadataStatus? metadataStatus,
    String? metadataError,
    bool clearMetadataError = false,
    bool clearMetadata = false,
    String? torrentName,
    String? infohashV1,
    String? infohashV2,
    int? creationDate,
    String? comment,
    int? totalSize,
    List<TorrentContentNode>? fileRoots,
    Set<String>? collapsedPaths,
  }) {
    return AddTorrentUiState(
      importKind: importKind ?? this.importKind,
      sourceUrl: clearSourceUrl ? null : (sourceUrl ?? this.sourceUrl),
      sourceFileName:
          clearSourceFileName ? null : (sourceFileName ?? this.sourceFileName),
      managementMode: managementMode ?? this.managementMode,
      defaultSavePath: defaultSavePath ?? this.defaultSavePath,
      useIncompletePath: useIncompletePath ?? this.useIncompletePath,
      category: category ?? this.category,
      selectedTags: selectedTags ?? this.selectedTags,
      startTorrent: startTorrent ?? this.startTorrent,
      addToTopOfQueue: addToTopOfQueue ?? this.addToTopOfQueue,
      stopCondition: stopCondition ?? this.stopCondition,
      skipHashCheck: skipHashCheck ?? this.skipHashCheck,
      contentLayout: contentLayout ?? this.contentLayout,
      sequentialDownload: sequentialDownload ?? this.sequentialDownload,
      firstLastPiecePrio: firstLastPiecePrio ?? this.firstLastPiecePrio,
      limitDownloadRate: limitDownloadRate ?? this.limitDownloadRate,
      limitUploadRate: limitUploadRate ?? this.limitUploadRate,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError:
          clearSubmitError ? null : (submitError ?? this.submitError),
      metadataStatus: metadataStatus ?? this.metadataStatus,
      metadataError: (clearMetadata || clearMetadataError)
          ? null
          : (metadataError ?? this.metadataError),
      torrentName: clearMetadata ? null : (torrentName ?? this.torrentName),
      infohashV1: clearMetadata ? null : (infohashV1 ?? this.infohashV1),
      infohashV2: clearMetadata ? null : (infohashV2 ?? this.infohashV2),
      creationDate: clearMetadata ? null : (creationDate ?? this.creationDate),
      comment: clearMetadata ? null : (comment ?? this.comment),
      totalSize: clearMetadata ? null : (totalSize ?? this.totalSize),
      fileRoots: clearMetadata ? const [] : (fileRoots ?? this.fileRoots),
      collapsedPaths:
          clearMetadata ? const {} : (collapsedPaths ?? this.collapsedPaths),
    );
  }
}
