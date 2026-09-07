import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/web_api_version.dart';
import 'package:qbpanel/storage/db/app_database.dart';
import 'package:qbpanel/storage/db/app_database_provider.dart';

/// 当前激活服务器的 WebAPI 能力。业务层用具名 getter，不要自己比版本字符串。
final qbApiCapabilitiesProvider = Provider<QbApiCapabilities>((ref) {
  final server = ref.watch(activeServerProvider).value;
  return QbApiCapabilities.parse(server?.apiVersion);
});

final activeServerProvider = StreamProvider<QbServer?>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.qbServers)..where((t) => t.isActive.equals(true)))
      .watchSingleOrNull();
});

class QbApiCapabilities {
  const QbApiCapabilities(this.version);

  final WebApiVersion? version;

  static const none = QbApiCapabilities(null);

  factory QbApiCapabilities.parse(String? apiVersion) {
    return QbApiCapabilities(WebApiVersion.tryParse(apiVersion));
  }

  bool _atLeast(int major, [int minor = 0, int patch = 0]) {
    return version != null && version!.isAtLeast(major, minor, patch);
  }

  bool get isSupported => version != null && version!.isSupported;

  /// qB 5.0+：`/torrents/stop|start`；更早为 `pause|resume`。
  bool get usesStopStart => _atLeast(2, 11, 0);

  /// qB 5.2+ Bearer API Key。
  bool get supportsApiKey => _atLeast(2, 14, 1);

  bool get hasSearch => _atLeast(2, 1, 1);

  bool get hasCategorySavePath => _atLeast(2, 1, 0);

  bool get hasTags => _atLeast(2, 3, 0);

  bool get hasBuildInfo => _atLeast(2, 3, 0);

  bool get hasNetworkInterfaces => _atLeast(2, 3, 0);

  bool get hasBanPeers => _atLeast(2, 3, 0);

  bool get hasTorrentPeers => _atLeast(2, 3, 0);

  bool get hasAddPeers => _atLeast(2, 3, 0);

  /// `renameFile` 改用 `oldPath`/`newPath`；此前为 `id`/`name`。
  bool get hasRenameFileByPath => _atLeast(2, 7, 0);

  bool get hasRenameFolder => _atLeast(2, 7, 0);

  bool get hasContentLayout => _atLeast(2, 7, 0);

  bool get hasAddTagsOnAdd => _atLeast(2, 6, 2);

  bool get hasDownloadPath => _atLeast(2, 8, 4);

  bool get hasCategoryDownloadPath => _atLeast(2, 8, 4);

  bool get hasStopCondition => _atLeast(2, 8, 15);

  bool get hasAddToTopOfQueue => _atLeast(2, 8, 19);

  bool get hasExportTorrent => _atLeast(2, 8, 14);

  bool get hasInactiveSeedingLimit => _atLeast(2, 9, 2);

  bool get hasWebSeedMutate => _atLeast(2, 11, 0);

  bool get hasSendTestEmail => _atLeast(2, 11, 0);

  bool get hasMetadataPreview => _atLeast(2, 11, 9);

  String get torrentStartPath => usesStopStart
      ? ApiPath.torrentManagement.start
      : ApiPath.torrentManagement.resume;

  String get torrentStopPath => usesStopStart
      ? ApiPath.torrentManagement.stop
      : ApiPath.torrentManagement.pause;
}
