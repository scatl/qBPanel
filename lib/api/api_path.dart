abstract final class ApiPath {
  static const application = _Application();
  static const torrentManagement = _TorrentManagement();
  static const transfer = _Transfer();
  static const sync = _Sync();
  static const log = _Log();
  static const search = _Search();
}

class _Application {
  const _Application();
  static const _base = '/api/v2/app';

  ///Get application version
  final appVersion = '$_base/version';

  ///Get API version
  final apiVersion = '$_base/webapiVersion';

  /// Get build info
  final buildInfo = '$_base/buildInfo';

  /// Get application preferences
  final preferences = '$_base/preferences';

  /// Set application preferences（`json={...}`）
  final setPreferences = '$_base/setPreferences';

  /// Send a test email using current mail notification settings
  final sendTestEmail = '$_base/sendTestEmail';

  /// Rotate / generate WebUI API key（返回 `{ "apiKey": "..." }`）
  final rotateAPIKey = '$_base/rotateAPIKey';

  /// Delete WebUI API key
  final deleteAPIKey = '$_base/deleteAPIKey';

  /// Get default save path
  final defaultSavePath = '$_base/defaultSavePath';

  /// 网卡列表（`[{ "name", "value" }]`）
  final networkInterfaceList = '$_base/networkInterfaceList';

  /// 指定网卡上的 IP 列表（`iface` query）
  final networkInterfaceAddressList = '$_base/networkInterfaceAddressList';
}

class _TorrentManagement {
  const _TorrentManagement();
  static const _base = '/api/v2/torrents';

  final torrentList = '$_base/info';

  /// Get torrent generic properties
  final properties = '$_base/properties';

  /// Get torrent pieces' states (`0` 未下 / `1` 正在下 / `2` 已下)
  final pieceStates = '$_base/pieceStates';

  /// Get per-piece availability (peer count)
  final pieceAvailability = '$_base/pieceAvailability';

  /// Get torrent contents (file list)
  final files = '$_base/files';

  /// Get torrent trackers
  final trackers = '$_base/trackers';

  /// Get torrent web seeds (HTTP 源)
  final webseeds = '$_base/webseeds';

  /// Add web seeds
  final addWebSeeds = '$_base/addWebSeeds';

  /// Edit a web seed URL
  final editWebSeed = '$_base/editWebSeed';

  /// Remove web seeds
  final removeWebSeeds = '$_base/removeWebSeeds';

  /// Add trackers to torrent
  final addTrackers = '$_base/addTrackers';

  /// Edit a torrent tracker URL / tier
  final editTracker = '$_base/editTracker';

  /// Remove trackers from torrent
  final removeTrackers = '$_base/removeTrackers';

  /// Set file download priority
  final filePrio = '$_base/filePrio';

  /// Rename a torrent
  final rename = '$_base/rename';

  /// Rename a torrent file
  final renameFile = '$_base/renameFile';

  /// Rename a torrent folder
  final renameFolder = '$_base/renameFolder';

  /// Export .torrent file
  final export = '$_base/export';

  /// Add peers to torrents
  final addPeers = '$_base/addPeers';

  /// Stop torrents (qB 5.0；旧版为 `pause`)
  final stop = '$_base/stop';

  /// Start torrents (qB 5.0；旧版为 `resume`)
  final start = '$_base/start';

  /// Delete torrents
  final delete = '$_base/delete';

  /// Recheck torrents
  final recheck = '$_base/recheck';

  /// Reannounce torrents
  final reannounce = '$_base/reannounce';

  /// Set force start
  final setForceStart = '$_base/setForceStart';

  /// Set torrent save location
  final setLocation = '$_base/setLocation';

  /// Set automatic torrent management
  final setAutoManagement = '$_base/setAutoManagement';

  /// Set super seeding
  final setSuperSeeding = '$_base/setSuperSeeding';

  /// Toggle sequential download
  final toggleSequentialDownload = '$_base/toggleSequentialDownload';

  /// Toggle first/last piece first
  final toggleFirstLastPiecePrio = '$_base/toggleFirstLastPiecePrio';

  /// Move torrent to the top of the queue
  final topPrio = '$_base/topPrio';

  /// Move torrent up in the queue
  final increasePrio = '$_base/increasePrio';

  /// Move torrent down in the queue
  final decreasePrio = '$_base/decreasePrio';

  /// Move torrent to the bottom of the queue
  final bottomPrio = '$_base/bottomPrio';

  /// Set torrent download limit (bytes/s，`0` 为不限)
  final setDownloadLimit = '$_base/setDownloadLimit';

  /// Set torrent upload limit (bytes/s，`0` 为不限)
  final setUploadLimit = '$_base/setUploadLimit';

  /// Set torrent share limits（分享率 / 做种时间 / 不活跃做种时间）
  final setShareLimits = '$_base/setShareLimits';

  /// Set torrent category（空字符串表示未分类）
  final setCategory = '$_base/setCategory';

  /// Add tags to torrents
  final addTags = '$_base/addTags';

  /// Remove tags from torrents（`tags` 为空则去掉全部）
  final removeTags = '$_base/removeTags';

  /// Remove categories
  final removeCategories = '$_base/removeCategories';

  /// Add new category
  final createCategory = '$_base/createCategory';

  /// Edit category
  final editCategory = '$_base/editCategory';

  /// Create tags
  final createTags = '$_base/createTags';

  /// Delete tags
  final deleteTags = '$_base/deleteTags';

  /// Add new torrent(s)
  final add = '$_base/add';

  /// Fetch torrent metadata from a magnet / hash / HTTP(S) URL
  final fetchMetadata = '$_base/fetchMetadata';

  /// Parse torrent metadata from uploaded .torrent file(s)
  final parseMetadata = '$_base/parseMetadata';
}

class _Transfer {
  const _Transfer();
  static const _base = '/api/v2/transfer';

  /// Permanently ban peers
  final banPeers = '$_base/banPeers';

  /// Toggle alternative speed limits
  final toggleSpeedLimitsMode = '$_base/toggleSpeedLimitsMode';

  /// Set global download limit（bytes/s；开启备用限速时改备用值）
  final setDownloadLimit = '$_base/setDownloadLimit';

  /// Set global upload limit（bytes/s；开启备用限速时改备用值）
  final setUploadLimit = '$_base/setUploadLimit';
}

class _Sync {
  const _Sync();
  static const _base = '/api/v2/sync';

  final mainData = '$_base/maindata';

  /// Get peers of a torrent (`rid=0` 为全量)
  final torrentPeers = '$_base/torrentPeers';
}

class _Log {
  const _Log();
  static const _base = '/api/v2/log';

  /// Application log (`normal` / `info` / `warning` / `critical` / `last_known_id`)
  final main = '$_base/main';

  /// Peer / banned IP log (`last_known_id`)
  final peers = '$_base/peers';
}

class _Search {
  const _Search();
  static const _base = '/api/v2/search';

  /// Start search job (`pattern`, `category`, `plugins`)
  final start = '$_base/start';

  /// Stop search job (`id`)
  final stop = '$_base/stop';

  /// Search job status (`id` optional)
  final status = '$_base/status';

  /// Search results (`id`, optional `limit` / `offset`)
  final results = '$_base/results';

  /// Delete search job (`id`)
  final delete = '$_base/delete';

  /// Installed search plugins
  final plugins = '$_base/plugins';

  /// Install search plugin (`sources`, `\|` separated)
  final installPlugin = '$_base/installPlugin';

  /// Uninstall search plugin (`names`, `\|` separated)
  final uninstallPlugin = '$_base/uninstallPlugin';

  /// Enable / disable plugins (`names`, `enable`)
  final enablePlugin = '$_base/enablePlugin';

  /// Check and apply plugin updates
  final updatePlugins = '$_base/updatePlugins';
}
