// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'qBPanel';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionOk => 'OK';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionApply => 'Apply';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionSave => 'Save';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionClose => 'Close';

  @override
  String get actionRename => 'Rename';

  @override
  String get actionMore => 'More';

  @override
  String get loading => 'Loading…';

  @override
  String get processing => 'Working…';

  @override
  String get emptyNoData => 'No data';

  @override
  String get loadFailed => 'Failed to load';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get notAvailable => 'N/A';

  @override
  String get emDash => '—';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get localeFollowSystem => 'System';

  @override
  String get localeChinese => '简体中文';

  @override
  String get localeChineseTraditional => '繁體中文';

  @override
  String get localeEnglish => 'English';

  @override
  String get settingsServer => 'Servers';

  @override
  String get settingsServerSettings => 'Server settings';

  @override
  String get settingsServerSettingsSubtitle => 'Edit or add servers';

  @override
  String get settingsAppearance => 'Display';

  @override
  String get settingsDisplayMode => 'Display mode';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeHint =>
      'When set to System, the app follows the device light or dark theme.';

  @override
  String get settingsThemeColor => 'Theme color';

  @override
  String get settingsUseDynamicColor => 'Use system accent color';

  @override
  String get settingsUseDynamicColorHint =>
      'Use Material You colors on Android 12+.';

  @override
  String get settingsCustomThemeColor => 'Custom theme color';

  @override
  String get settingsCustomThemeColorHintDynamic =>
      'Takes effect after the switch above is off; also used if system colors are unavailable';

  @override
  String get settingsCustomThemeColorHint =>
      'Pick any color as the Material 3 seed';

  @override
  String get settingsPickThemeColor => 'Choose theme color';

  @override
  String get settingsPickColor => 'Color';

  @override
  String get settingsPickColorHint => 'Tap Apply to save';

  @override
  String get apiNoActiveServer =>
      'No active server. Add one in Settings and select it first.';

  @override
  String get apiTimeout => 'Connection timed out. Check the address and port.';

  @override
  String get apiConnectionError =>
      'Could not reach the server. Check the network and configuration.';

  @override
  String get apiUnauthorized => 'Invalid API key or insufficient permission';

  @override
  String apiHttpStatus(int code) {
    return 'Server returned $code';
  }

  @override
  String get apiBadCertificate => 'The HTTPS certificate is not trusted';

  @override
  String get apiCancelled => 'Request cancelled';

  @override
  String durationSeconds(int count) {
    return '${count}s';
  }

  @override
  String durationMinutes(int count) {
    return '${count}m';
  }

  @override
  String durationHours(int count) {
    return '${count}h';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String durationDays(int count) {
    return '${count}d';
  }

  @override
  String durationDaysHours(int days, int hours) {
    return '${days}d ${hours}h';
  }

  @override
  String durationMinutesSeconds(int minutes, int seconds) {
    return '${minutes}m ${seconds}s';
  }

  @override
  String formatSeedingSuffix(String base, String seeding) {
    return '$base (seeding $seeding)';
  }

  @override
  String formatConnectionsUnlimited(int count) {
    return '$count (max ∞)';
  }

  @override
  String formatConnectionsLimited(int count, int limit) {
    return '$count (max $limit)';
  }

  @override
  String formatSession(String total, String session) {
    return '$total (session $session)';
  }

  @override
  String formatSpeedAvg(String current, String average) {
    return '$current (avg $average)';
  }

  @override
  String formatCountTotal(int current, int total) {
    return '$current (of $total)';
  }

  @override
  String formatPieces(int count, String size, int have) {
    return '$count × $size (have $have)';
  }

  @override
  String get logToday => 'Today';

  @override
  String get logYesterday => 'Yesterday';

  @override
  String get connectionStatusConnected => 'Connected';

  @override
  String get connectionStatusFirewalled => 'Firewalled';

  @override
  String get connectionStatusDisconnected => 'Disconnected';

  @override
  String get connectionStatusUnknown => 'Unknown';

  @override
  String get torrentStateError => 'Error';

  @override
  String get torrentStateMissingFiles => 'Missing files';

  @override
  String get torrentStateUploading => 'Seeding';

  @override
  String get torrentStateStoppedUp => 'Completed';

  @override
  String get torrentStateQueuedUp => 'Queued seeding';

  @override
  String get torrentStateStalledUp => 'Stalled seeding';

  @override
  String get torrentStateCheckingUp => 'Checking';

  @override
  String get torrentStateForcedUp => 'Forced seeding';

  @override
  String get torrentStateAllocating => 'Allocating';

  @override
  String get torrentStateDownloading => 'Downloading';

  @override
  String get torrentStateMetaDl => 'Fetching metadata';

  @override
  String get torrentStateForcedMetaDl => 'Forced metadata';

  @override
  String get torrentStateStoppedDl => 'Stopped';

  @override
  String get torrentStateQueuedDl => 'Queued download';

  @override
  String get torrentStateStalledDl => 'Stalled download';

  @override
  String get torrentStateCheckingDl => 'Checking';

  @override
  String get torrentStateForcedDl => 'Forced download';

  @override
  String get torrentStateCheckingResumeData => 'Checking resume data';

  @override
  String get torrentStateMoving => 'Moving';

  @override
  String get torrentStateUnknown => 'Unknown';

  @override
  String get filterAll => 'All';

  @override
  String get filterDownloading => 'Downloading';

  @override
  String get filterSeeding => 'Seeding';

  @override
  String get filterCompleted => 'Completed';

  @override
  String get filterRunning => 'Running';

  @override
  String get filterStopped => 'Stopped';

  @override
  String get filterActive => 'Active';

  @override
  String get filterInactive => 'Inactive';

  @override
  String get filterStalled => 'Stalled';

  @override
  String get filterStalledUploading => 'Stalled uploading';

  @override
  String get filterStalledDownloading => 'Stalled downloading';

  @override
  String get filterChecking => 'Checking';

  @override
  String get filterMoving => 'Moving';

  @override
  String get filterErrored => 'Errored';

  @override
  String get filterUncategorized => 'Uncategorized';

  @override
  String get filterUntagged => 'Untagged';

  @override
  String get sortState => 'Status';

  @override
  String get sortName => 'Name';

  @override
  String get sortProgress => 'Progress';

  @override
  String get sortSize => 'Size';

  @override
  String get sortDownloadSpeed => 'Download speed';

  @override
  String get sortUploadSpeed => 'Upload speed';

  @override
  String get sortDownloaded => 'Downloaded';

  @override
  String get sortUploaded => 'Uploaded';

  @override
  String get sortEta => 'ETA';

  @override
  String get sortAmountLeft => 'Remaining';

  @override
  String get sortRatio => 'Ratio';

  @override
  String get sortAddedOn => 'Added on';

  @override
  String get sortCompletionOn => 'Completed on';

  @override
  String get sortLastActivity => 'Last activity';

  @override
  String get sortNumSeeds => 'Seeds';

  @override
  String get sortNumLeechs => 'Leeches';

  @override
  String get sortAvailability => 'Availability';

  @override
  String get sortPriority => 'Priority';

  @override
  String get sortTimeActive => 'Active time';

  @override
  String get sortSeedingTime => 'Seeding time';

  @override
  String get sortCountry => 'Country/region';

  @override
  String get sortIp => 'IP/address';

  @override
  String get sortPort => 'Port';

  @override
  String get sortConnection => 'Connection';

  @override
  String get sortFlags => 'Flags';

  @override
  String get sortClient => 'Client';

  @override
  String get sortPeerIdClient => 'Peer ID client';

  @override
  String get sortRelevance => 'Relevance';

  @override
  String get sortFiles => 'Files';

  @override
  String get sortUrl => 'URL';

  @override
  String get sortTier => 'Tier';

  @override
  String get sortStatus => 'Status';

  @override
  String get sortSeeds => 'Seeds';

  @override
  String get sortPeers => 'Peers';

  @override
  String get sortLeeches => 'Leeches';

  @override
  String get sortDownloadCount => 'Times completed';

  @override
  String get sortMessage => 'Message';

  @override
  String get sortNextAnnounce => 'Next announce';

  @override
  String get sortMinAnnounce => 'Min announce interval';

  @override
  String get sortContentPriority => 'Download priority';

  @override
  String get sortTotalSize => 'Total size';

  @override
  String get sortRemaining => 'Remaining';

  @override
  String get shareLimitUseDefault => 'Use global settings';

  @override
  String get shareLimitStop => 'Stop torrent';

  @override
  String get shareLimitRemove => 'Remove torrent';

  @override
  String get shareLimitRemoveWithContent => 'Remove torrent and files';

  @override
  String get shareLimitSuperSeeding => 'Enable super seeding';

  @override
  String get logLevelNormal => 'Normal';

  @override
  String get logLevelInfo => 'Info';

  @override
  String get logLevelWarning => 'Warning';

  @override
  String get logLevelCritical => 'Critical';

  @override
  String get searchPluginEnabled => 'Enabled';

  @override
  String get searchPluginAll => 'All';

  @override
  String get searchPluginSingle => 'Selected plugin';

  @override
  String get addModeManual => 'Manual';

  @override
  String get addModeAutomatic => 'Automatic';

  @override
  String get addStopNone => 'None';

  @override
  String get addStopMetadataReceived => 'Metadata received';

  @override
  String get addStopFilesChecked => 'Files checked';

  @override
  String get addLayoutOriginal => 'Original';

  @override
  String get addLayoutSubfolder => 'Create subfolder';

  @override
  String get addLayoutNoSubfolder => 'No subfolder';

  @override
  String get speedPeriod30s => '30s';

  @override
  String get speedPeriod1m => '1m';

  @override
  String get speedPeriod5m => '5m';

  @override
  String get speedPeriod10m => '10m';

  @override
  String get speedPeriod30m => '30m';

  @override
  String get homeFilter => 'Filter';

  @override
  String get homeFiltering => 'Filtering';

  @override
  String get homeClearSearch => 'Clear search';

  @override
  String get searchTorrentsHint => 'Filter torrents';

  @override
  String get homeSort => 'Sort';

  @override
  String get homeSorting => 'Sorting';

  @override
  String get homeStartAll => 'Start all';

  @override
  String get homeStopAll => 'Stop all';

  @override
  String get homeSearchTorrents => 'Search torrents';

  @override
  String get homeLogs => 'Logs';

  @override
  String get homeSettings => 'Settings';

  @override
  String get homeAddTorrent => 'Add torrent';

  @override
  String get homeNoActiveServer => 'No active server';

  @override
  String get homeNoActiveServerHint =>
      'Add a server or select one from the list';

  @override
  String get homeChooseServer => 'Choose a server';

  @override
  String get homeNoMatchingTorrents => 'No torrents match the filters';

  @override
  String get homeClearFilters => 'Clear filters';

  @override
  String get homeNoTorrents => 'No torrents';

  @override
  String get homeNoTorrentsInList => 'No torrents in the current list';

  @override
  String homeConfirmBatch(String action, int count) {
    return '$action $count torrents in the current list?';
  }

  @override
  String homeBatchStarted(int count) {
    return 'Started $count torrents';
  }

  @override
  String homeBatchStopped(int count) {
    return 'Stopped $count torrents';
  }

  @override
  String homeBatchFailed(String label, String error) {
    return '$label: $error';
  }

  @override
  String get homeStartAllFailed => 'Failed to start all';

  @override
  String get homeStopAllFailed => 'Failed to stop all';

  @override
  String get homeStarting => 'Starting…';

  @override
  String get homeStopping => 'Stopping…';

  @override
  String get homeStart => 'Start';

  @override
  String get homeStop => 'Stop';

  @override
  String get homeSavedAltSpeed => 'Alternative speed limits saved';

  @override
  String get homeSavedGlobalSpeed => 'Global speed limits saved';

  @override
  String homeAltSpeedToggleFailed(String error) {
    return 'Failed to toggle alternative speed limits: $error';
  }

  @override
  String get homeAltSpeedOn => 'Alternative speed limits on';

  @override
  String get homeAltSpeedOff => 'Alternative speed limits off';

  @override
  String get homeServerStatus => 'Server status';

  @override
  String get renameTitle => 'Rename';

  @override
  String copiedWithLabel(String label) {
    return 'Copied $label';
  }

  @override
  String get actionBack => 'Back';

  @override
  String get actionAdd => 'Add';

  @override
  String get actionEnable => 'Enable';

  @override
  String get actionDisable => 'Disable';

  @override
  String get actionGotIt => 'Got it';

  @override
  String get enabling => 'Enabling…';

  @override
  String get disabling => 'Disabling…';

  @override
  String get deleting => 'Deleting…';

  @override
  String get settingInProgress => 'Saving…';

  @override
  String deleteFailed(String error) {
    return 'Delete failed: $error';
  }

  @override
  String errorWithDetail(String label, String error) {
    return '$label: $error';
  }

  @override
  String get onLabel => 'On';

  @override
  String get offLabel => 'Off';

  @override
  String get unlimited => 'Unlimited';

  @override
  String get unlimitedSpeed => 'Unlimited';

  @override
  String get custom => 'Custom';

  @override
  String get minutes => 'min';

  @override
  String get download => 'Download';

  @override
  String get upload => 'Upload';

  @override
  String get status => 'Status';

  @override
  String get category => 'Category';

  @override
  String get tags => 'Tags';

  @override
  String get queue => 'Queue';

  @override
  String get copy => 'Copy';

  @override
  String get connection => 'Connection';

  @override
  String get transfer => 'Transfer';

  @override
  String get info => 'Information';

  @override
  String get application => 'Application';

  @override
  String get never => 'Never';

  @override
  String get unknown => 'Unknown';

  @override
  String get enterName => 'Enter a name';

  @override
  String get nameInvalid => 'Invalid name';

  @override
  String get invalidTorrent => 'Invalid torrent';

  @override
  String get invalidParam => 'Invalid parameter';

  @override
  String get torrentNotFound => 'Torrent not found';

  @override
  String get actionForceStart => 'Force start';

  @override
  String get actionStartFailed => 'Failed to start';

  @override
  String get actionStopFailed => 'Failed to stop';

  @override
  String get actionForceStartFailed => 'Failed to force start';

  @override
  String get setSaveLocation => 'Set location';

  @override
  String get autoTmm => 'Automatic torrent management';

  @override
  String get uploadLimit => 'Upload limit';

  @override
  String get uploadDownloadLimit => 'Upload/download limit';

  @override
  String get shareLimit => 'Share limit';

  @override
  String get superSeeding => 'Super seeding';

  @override
  String get sequentialDownload => 'Sequential download';

  @override
  String get firstLastPiece => 'Download first and last pieces first';

  @override
  String get forceRecheck => 'Force recheck';

  @override
  String get forceReannounce => 'Force reannounce';

  @override
  String get shareTorrent => 'Share torrent';

  @override
  String get queueTop => 'Move to top';

  @override
  String get queueUp => 'Move up';

  @override
  String get queueDown => 'Move down';

  @override
  String get queueBottom => 'Move to bottom';

  @override
  String get queueTopFailed => 'Failed to move to top';

  @override
  String get queueUpFailed => 'Failed to move up';

  @override
  String get queueDownFailed => 'Failed to move down';

  @override
  String get queueBottomFailed => 'Failed to move to bottom';

  @override
  String get sequentialFailed => 'Failed to set sequential download';

  @override
  String get firstLastFailed => 'Failed to set first/last piece priority';

  @override
  String get recheckFailed => 'Recheck failed';

  @override
  String get reannounceFailed => 'Reannounce failed';

  @override
  String get preparingShare => 'Preparing to share…';

  @override
  String shareFailed(String error) {
    return 'Share failed: $error';
  }

  @override
  String get renameTorrentHint =>
      'This changes the display name in the list, not files or folders on the server.';

  @override
  String setLocationFailed(String error) {
    return 'Failed to set location: $error';
  }

  @override
  String get enableAutoTmmTitle => 'Enable automatic torrent management';

  @override
  String get enableAutoTmmMessage =>
      'Enable automatic torrent management? The torrent may be moved to the category save path.';

  @override
  String autoTmmFailed(String action, String error) {
    return 'Failed to $action automatic management: $error';
  }

  @override
  String superSeedingFailed(String action, String error) {
    return 'Failed to $action super seeding: $error';
  }

  @override
  String get deleteTorrentTitle => 'Delete torrent';

  @override
  String get confirmDeleteTorrent => 'Delete this torrent?';

  @override
  String confirmDeleteTorrentNamed(String name) {
    return 'Delete “$name”?';
  }

  @override
  String get deleteFilesToo => 'Also delete files';

  @override
  String get noTorrentsToOperate => 'No torrents to operate on';

  @override
  String get invalidTorrentFile => 'Invalid torrent file';

  @override
  String get torrentFileNotReady => 'Torrent file is not ready yet';

  @override
  String get shareContentEmpty => 'Nothing to share';

  @override
  String get prepareShareFailed => 'Failed to prepare the file for sharing';

  @override
  String get savePathRequired => 'Save path cannot be empty';

  @override
  String get savePathNoPermission => 'No write permission for that directory';

  @override
  String get savePathCreateFailed => 'Could not create the save path';

  @override
  String get queueingDisabled => 'Torrent queueing is not enabled';

  @override
  String get categoryNotFound => 'Category does not exist';

  @override
  String get magnetLink => 'Magnet link';

  @override
  String get contentPath => 'Content path';

  @override
  String get remaining => 'Remaining';

  @override
  String get addCategory => 'Add category';

  @override
  String get addSubcategory => 'Add subcategory';

  @override
  String get editCategory => 'Edit category';

  @override
  String get deleteCategory => 'Delete category';

  @override
  String get deleteUnusedCategories => 'Delete unused categories';

  @override
  String get addTag => 'Add tag';

  @override
  String get deleteTag => 'Delete tag';

  @override
  String get deleteUnusedTags => 'Delete unused tags';

  @override
  String confirmDeleteTag(String tag) {
    return 'Delete tag “$tag”? Torrents will not be deleted.';
  }

  @override
  String confirmDeleteUnusedTags(int count) {
    return 'Delete $count unused tags? Torrents will not be deleted.';
  }

  @override
  String confirmDeleteCategory(String name) {
    return 'Delete category “$name”? Torrents will not be deleted.';
  }

  @override
  String confirmDeleteCategoryWithChildren(String name) {
    return 'Delete category “$name”? Subcategories will also be deleted. Torrents will not be deleted.';
  }

  @override
  String confirmDeleteUnusedCategories(int count) {
    return 'Delete $count unused categories? Torrents will not be deleted.';
  }

  @override
  String get noUnusedTags => 'No unused tags';

  @override
  String get noUnusedCategories => 'No unused categories';

  @override
  String get noTagsHint =>
      'No tags yet. Use the button in the top right to create one.';

  @override
  String get removeTags => 'Remove tags';

  @override
  String get tagsRemoved => 'Tags removed';

  @override
  String get switchServer => 'Switch server';

  @override
  String get noServers => 'No servers';

  @override
  String get enterSavePath => 'Enter a save path';

  @override
  String get savePath => 'Save path';

  @override
  String get autoTmmLocationHint =>
      'Automatic torrent management is on. Confirming will turn it off and use the path above.';

  @override
  String get enterTagName => 'Enter a tag name';

  @override
  String get tagNameNoComma => 'Tag names cannot contain commas';

  @override
  String get tagName => 'Tag name';

  @override
  String get enterCategoryName => 'Enter a category name';

  @override
  String get categoryNameInvalid => 'Invalid category name';

  @override
  String get parentCategory => 'Parent category';

  @override
  String get categoryName => 'Category name';

  @override
  String get incompleteUseAnotherPath =>
      'Use another path for incomplete torrents';

  @override
  String get defaultOption => 'Default';

  @override
  String get path => 'Path';

  @override
  String queuePosition(int position) {
    return '#$position';
  }

  @override
  String get notInQueue => 'Not in queue';

  @override
  String get seedingTime => 'Seeding time';

  @override
  String get inactive => 'Inactive';

  @override
  String get afterLimitReached => 'When the limit is reached';

  @override
  String get enterValidLimit => 'Enter a valid limit';

  @override
  String get shareLimitSaved => 'Share limits saved';

  @override
  String get enterValidSpeed => 'Enter a valid speed';

  @override
  String get altSpeedLimit => 'Alternative speed limits';

  @override
  String get globalSpeedLimit => 'Global speed limits';

  @override
  String get altSpeedLimitHint =>
      'Alternative limits are on. Changes apply to the alternative values.';

  @override
  String get speedLimitSaved => 'Speed limits saved';

  @override
  String get altSpeedOffTooltip => 'Turn off alternative speed limits';

  @override
  String get altSpeedOnTooltip => 'Turn on alternative speed limits';

  @override
  String get ssConnectionStatus => 'Connection status';

  @override
  String get ssDhtNodes => 'DHT nodes';

  @override
  String get ssPeerConnections => 'Peer connections';

  @override
  String get ssExternalIpv4 => 'External IPv4';

  @override
  String get ssExternalIpv6 => 'External IPv6';

  @override
  String get ssSessionDownload => 'Session downloaded';

  @override
  String get ssSessionUpload => 'Session uploaded';

  @override
  String get ssAllTimeDownload => 'All-time downloaded';

  @override
  String get ssAllTimeUpload => 'All-time uploaded';

  @override
  String get ssSessionWasted => 'Session wasted';

  @override
  String get ssDlRateLimit => 'Download limit';

  @override
  String get ssUpRateLimit => 'Upload limit';

  @override
  String get ssAltSpeed => 'Alternative limits';

  @override
  String get ssDiskAndQueue => 'Disk and queue';

  @override
  String get ssFreeSpace => 'Free disk space';

  @override
  String get ssTorrentQueueing => 'Torrent queueing';

  @override
  String get ssDiskQueue => 'Disk queue';

  @override
  String get ssTrackerQueue => 'Tracker queue';

  @override
  String get ssWritePending => 'Queued for writing';

  @override
  String get ssQueued => 'Queued';

  @override
  String get ssCache => 'Cache';

  @override
  String get ssCacheUsed => 'Cache used';

  @override
  String get ssReadCacheHits => 'Read cache hits';

  @override
  String get ssReadCacheOverload => 'Read cache overload';

  @override
  String get ssWriteCacheOverload => 'Write cache overload';

  @override
  String get ssAppVersion => 'App version';

  @override
  String get ssApiVersion => 'API version';

  @override
  String get ssBitness => 'Bitness';

  @override
  String get ssPlatform => 'Platform';

  @override
  String milliseconds(int count) {
    return '$count ms';
  }

  @override
  String bitnessValue(int bitness) {
    return '$bitness-bit';
  }

  @override
  String get torrentDetail => 'Torrent details';

  @override
  String get tabGeneral => 'General';

  @override
  String get tabPeers => 'Peers';

  @override
  String get tabContent => 'Content';

  @override
  String get tabTrackers => 'Trackers';

  @override
  String get tabHttpSeeds => 'HTTP seeds';

  @override
  String get sortPeersTitle => 'Sort peers';

  @override
  String get sortContent => 'Sort content';

  @override
  String get sortTrackers => 'Sort trackers';

  @override
  String get progress => 'Progress';

  @override
  String get availability => 'Availability';

  @override
  String get timeActive => 'Time active';

  @override
  String get eta => 'ETA';

  @override
  String get connections => 'Connections';

  @override
  String get seeds => 'Seeds';

  @override
  String get peers => 'Peers';

  @override
  String get dlLimit => 'Download limit';

  @override
  String get upLimit => 'Upload limit';

  @override
  String get wasted => 'Wasted';

  @override
  String get nextAnnounce => 'Next announce';

  @override
  String get lastSeen => 'Last seen complete';

  @override
  String get popularity => 'Popularity';

  @override
  String get totalSize => 'Total size';

  @override
  String get pieces => 'Pieces';

  @override
  String get createdBy => 'Created by';

  @override
  String get addedOn => 'Added on';

  @override
  String get completedOn => 'Completed on';

  @override
  String get createdOn => 'Created on';

  @override
  String get privateTorrent => 'Private';

  @override
  String get infohashV1 => 'Infohash v1';

  @override
  String get infohashV2 => 'Infohash v2';

  @override
  String get comment => 'Comment';

  @override
  String get speed => 'Speed';

  @override
  String get downloadAvg => 'Download average';

  @override
  String get uploadAvg => 'Upload average';

  @override
  String get sampling => 'Sampling…';

  @override
  String get tier => 'Tier';

  @override
  String get leeches => 'Leeches';

  @override
  String get timesCompleted => 'Times completed';

  @override
  String get message => 'Message';

  @override
  String get minAnnounce => 'Min announce interval';

  @override
  String get btProtocol => 'BT protocol';

  @override
  String get relevance => 'Relevance';

  @override
  String get contribution => 'Contribution';

  @override
  String get flags => 'Flags';

  @override
  String get downloadingFile => 'Downloading';

  @override
  String downloadingFiles(int count) {
    return 'Downloading $count files';
  }

  @override
  String get noHttpSeeds => 'No HTTP seeds';

  @override
  String get noHttpSeedsHint => 'This torrent has no HTTP seeds yet';

  @override
  String get addHttpSeed => 'Add HTTP seeds';

  @override
  String get editHttpSeed => 'Edit HTTP seed URL';

  @override
  String get deleteHttpSeed => 'Delete HTTP seed';

  @override
  String get copyHttpSeed => 'Copy HTTP seed URL';

  @override
  String get copiedHttpSeed => 'HTTP seed URL copied';

  @override
  String confirmDeleteHttpSeed(String url) {
    return 'Delete $url?';
  }

  @override
  String get addedHttpSeed => 'HTTP seeds added';

  @override
  String get enterHttpSeeds => 'Enter at least one HTTP seed';

  @override
  String get enterHttpSeedUrl => 'Enter an HTTP seed URL';

  @override
  String get invalidUrl => 'Invalid URL';

  @override
  String get httpSeedNotFound => 'HTTP seed not found';

  @override
  String get invalidHttpSeed => 'Invalid HTTP seed';

  @override
  String get httpSeedUrl => 'HTTP seed URL';

  @override
  String get httpSeedListHint => 'HTTP seeds to add (one per line)';

  @override
  String get noTrackers => 'No trackers';

  @override
  String get noTrackersHint => 'This torrent has no trackers yet';

  @override
  String get addTracker => 'Add trackers';

  @override
  String get editTracker => 'Edit tracker URL';

  @override
  String get deleteTracker => 'Delete tracker';

  @override
  String get copyTracker => 'Copy tracker URL';

  @override
  String get copiedTracker => 'Tracker URL copied';

  @override
  String confirmDeleteTracker(String name) {
    return 'Delete $name?';
  }

  @override
  String get reannounceSelected => 'Force reannounce selected tracker';

  @override
  String get reannounceAll => 'Force reannounce all trackers';

  @override
  String get reannouncedAll => 'Reannounced all trackers';

  @override
  String get reannouncedOne => 'Reannounced this tracker';

  @override
  String reannounceFailedOne(String error) {
    return 'Reannounce failed: $error';
  }

  @override
  String get addedTracker => 'Trackers added';

  @override
  String get enterTrackers => 'Enter at least one tracker';

  @override
  String get enterTrackerUrl => 'Enter a tracker URL';

  @override
  String get trackerUrl => 'Tracker URL';

  @override
  String get tierRange => 'Tier must be 0–255';

  @override
  String get enterTier => 'Enter a tier';

  @override
  String get trackerNotFound => 'Tracker not found';

  @override
  String get trackerUrlTaken =>
      'Tracker not found or the new URL is already used';

  @override
  String get invalidTracker => 'Invalid tracker';

  @override
  String get trackerListHint => 'Trackers to add (one per line)';

  @override
  String get noPeers => 'No peers';

  @override
  String get noPeersHint => 'No peers are connected';

  @override
  String get startRefresh => 'Resume refresh';

  @override
  String get pauseRefresh => 'Pause refresh';

  @override
  String get flagsHelp => 'Flag legend';

  @override
  String get copiedEndpoint => 'IP and port copied';

  @override
  String get banPeerTitle => 'Ban peer permanently';

  @override
  String banPeerMessage(String endpoint) {
    return 'Permanently ban $endpoint? This peer will not be able to connect again.';
  }

  @override
  String get ban => 'Ban';

  @override
  String get peerBanned => 'Peer banned';

  @override
  String banFailed(String error) {
    return 'Ban failed: $error';
  }

  @override
  String get addPeers => 'Add peers';

  @override
  String get copyEndpoint => 'Copy IP:port';

  @override
  String get banPeer => 'Ban peer permanently';

  @override
  String get addedPeers => 'Peers added';

  @override
  String get peerListHint => 'Peers to add (one IP per line)';

  @override
  String get peerFormatHint => 'Format: IPv4:port / IPv6:port';

  @override
  String get enterPeers => 'Enter at least one peer';

  @override
  String get noValidPeers => 'No valid peers';

  @override
  String get invalidPeer => 'Invalid peer';

  @override
  String get noFiles => 'No files';

  @override
  String get noFilesHint =>
      'Metadata is not ready, or the torrent has no files';

  @override
  String priorityFailed(String error) {
    return 'Failed to set priority: $error';
  }

  @override
  String get priorityInvalid => 'Invalid priority';

  @override
  String get metadataNotReady =>
      'Metadata is not ready, or the file does not exist';

  @override
  String get enterNewName => 'Enter a new name';

  @override
  String get nameTaken => 'Invalid name or already in use';

  @override
  String get nameNoPathSeparator => 'Name cannot contain path separators';

  @override
  String get folderName => 'Folder name';

  @override
  String get fileName => 'File name';

  @override
  String get renameFolderHint =>
      'This renames the folder on the server. Paths of files inside it will change too.';

  @override
  String get renameFileHint =>
      'This renames the file on the server. The disk path will change too.';

  @override
  String get priorityDoNotDownload => 'Do not download';

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityMaximum => 'Maximum';

  @override
  String get priorityMixed => 'Mixed';

  @override
  String get priorityNormal => 'Normal';

  @override
  String get trackerUpdating => 'Updating…';

  @override
  String get trackerDisabled => 'Disabled';

  @override
  String get trackerNotContacted => 'Not contacted yet';

  @override
  String get trackerWorking => 'Working';

  @override
  String get trackerNotWorking => 'Not working';

  @override
  String get trackerError => 'Tracker error';

  @override
  String get trackerUnreachable => 'Unreachable';

  @override
  String get peerFlagD =>
      'Interested in downloading from this peer, and not choked';

  @override
  String get peerFlagd => 'Interested in downloading, but peer is choking us';

  @override
  String get peerFlagU =>
      'Peer is interested in downloading, and we are not choking them';

  @override
  String get peerFlagu => 'Peer is interested, but we are choking them';

  @override
  String get peerFlagK => 'Not interested, and peer is not choking us';

  @override
  String get peerFlagQuestion =>
      'Peer is not interested, and we are not choking them';

  @override
  String get peerFlagO => 'Optimistic unchoke';

  @override
  String get peerFlagS => 'Peer is snubbed';

  @override
  String get peerFlagI => 'Incoming connection';

  @override
  String get peerFlagH => 'From DHT';

  @override
  String get peerFlagX => 'From PEX';

  @override
  String get peerFlagL => 'From LSD';

  @override
  String get peerFlagE => 'Encrypted traffic';

  @override
  String get peerFlage => 'Encrypted handshake';

  @override
  String get peerFlagP => 'μTP';

  @override
  String get peerFlagh => 'NAT hole punching';

  @override
  String get optional => 'Optional';

  @override
  String get unavailable => 'Not available';

  @override
  String get notEnabled => 'Disabled';

  @override
  String get adding => 'Adding…';

  @override
  String get saved => 'Saved';

  @override
  String get saving => 'Saving…';

  @override
  String saveFailed(String error) {
    return 'Save failed: $error';
  }

  @override
  String addFailed(String error) {
    return 'Add failed: $error';
  }

  @override
  String get loadSettingsFailed => 'Failed to load settings';

  @override
  String get actionClear => 'Clear';

  @override
  String get actionImport => 'Import';

  @override
  String get actionInstall => 'Install';

  @override
  String get actionSearch => 'Search';

  @override
  String get addTorrentSettings => 'Torrent settings';

  @override
  String get noTags => 'No tags';

  @override
  String get contentLayout => 'Content layout';

  @override
  String get stopCondition => 'Stop condition';

  @override
  String get startTorrent => 'Start torrent';

  @override
  String get addToTopOfQueue => 'Add to top of queue';

  @override
  String get skipHashCheck => 'Skip hash check';

  @override
  String get limitDownloadRate => 'Limit download rate';

  @override
  String get limitUploadRate => 'Limit upload rate';

  @override
  String get saveTo => 'Save to';

  @override
  String get torrentManagementMode => 'Torrent management mode';

  @override
  String get saveFilesTo => 'Save files to';

  @override
  String get autoTmmDecides => 'Decided by automatic management';

  @override
  String get incompleteTorrentPath =>
      'Use another path for incomplete torrents';

  @override
  String get incompleteSavePath => 'Incomplete torrent save path';

  @override
  String get importMagnet => 'Import from magnet link';

  @override
  String get importFile => 'Import from file';

  @override
  String get tapToChangeLink => 'Tap to change the link';

  @override
  String get enterMagnetOrHttp => 'Enter a magnet link or HTTP(S) URL';

  @override
  String get tapToChangeFile => 'Tap to change the file';

  @override
  String get selectTorrentFile => 'Choose a .torrent file';

  @override
  String get magnetOrUrl => 'Magnet link or URL';

  @override
  String get enterMagnetOrUrl => 'Enter a magnet link or HTTP(S) URL';

  @override
  String get importOneTorrentOnly =>
      'You can import only one torrent at a time';

  @override
  String get torrentInfo => 'Torrent information';

  @override
  String get date => 'Date';

  @override
  String get fetchingMetadata => 'Fetching metadata…';

  @override
  String get metadataFailed => 'Failed to fetch metadata';

  @override
  String metadataFailedWithError(String error) {
    return 'Failed to fetch metadata: $error';
  }

  @override
  String get filesAfterImport => 'File list appears after you import a torrent';

  @override
  String get cannotReadTorrentFile => 'Could not read the torrent file';

  @override
  String get cannotReadSelectedFile => 'Could not read the selected file';

  @override
  String get importTorrentFirst => 'Import a torrent first';

  @override
  String get fetchingMetadataWait => 'Fetching metadata, please wait';

  @override
  String get cannotAdd => 'Could not add';

  @override
  String get searchTorrents => 'Search torrents';

  @override
  String get searchPlugins => 'Search plugins';

  @override
  String get filterResults => 'Filter results';

  @override
  String get stopSearch => 'Stop search';

  @override
  String get searchKeyword => 'Search keywords';

  @override
  String get searchStarting => 'Starting…';

  @override
  String get collapse => 'Collapse';

  @override
  String get expandSearchForm => 'Expand search options';

  @override
  String get searchCriteria => 'Search options';

  @override
  String get filterResultName => 'Filter by name…';

  @override
  String get enabledPlugins => 'Enabled plugins';

  @override
  String get allPlugins => 'All plugins';

  @override
  String get plugin => 'Plugin';

  @override
  String searchingFound(int total) {
    return 'Searching · $total found';
  }

  @override
  String searchingFoundVisible(int total, int visible) {
    return 'Searching · $total found (showing $visible)';
  }

  @override
  String get pythonRequired =>
      'Python is not installed on the server, so search is unavailable';

  @override
  String get searchLimitReached => 'Too many searches in progress (maximum 5)';

  @override
  String get startSearchFailed => 'Failed to start search';

  @override
  String get loadPluginsFailed => 'Failed to load search plugins';

  @override
  String get noSearchPlugins => 'No search plugins installed';

  @override
  String get noSearchPluginsHint =>
      'Install and enable search plugins in the qBittorrent Web UI';

  @override
  String get searchIdleHint =>
      'Enter keywords and choose a category / plugin to start';

  @override
  String get searching => 'Searching';

  @override
  String get searchingHint => 'Fetching results from plugins…';

  @override
  String get noMatchingResults => 'No matching results';

  @override
  String get noResults => 'No results';

  @override
  String get adjustFiltersHint => 'Try adjusting the filters';

  @override
  String get retrySearchHint => 'Try different keywords or plugins';

  @override
  String get allCategories => 'All categories';

  @override
  String get searchCategoryAnime => 'Anime';

  @override
  String get searchCategoryBooks => 'Books';

  @override
  String get searchCategoryGames => 'Games';

  @override
  String get searchCategoryMovies => 'Movies';

  @override
  String get searchCategoryMusic => 'Music';

  @override
  String get searchCategoryPictures => 'Pictures';

  @override
  String get searchCategorySoftware => 'Software';

  @override
  String get searchCategoryTv => 'TV shows';

  @override
  String get searchJobNotFound => 'Search job not found';

  @override
  String get searchResultsUnavailable =>
      'Search results are no longer available';

  @override
  String seedingCount(String count) {
    return 'Seeds $count';
  }

  @override
  String leechingCount(String count) {
    return 'Leeches $count';
  }

  @override
  String get unknownSize => 'Unknown size';

  @override
  String get cannotOpenDescription => 'Could not open the description page';

  @override
  String get copiedName => 'Name copied';

  @override
  String get copiedDownloadLink => 'Download link copied';

  @override
  String get copiedDescriptionUrl => 'Description URL copied';

  @override
  String get openDescription => 'Open description page';

  @override
  String get copyName => 'Copy name';

  @override
  String get copyDownloadLink => 'Copy download link';

  @override
  String get copyDescriptionUrl => 'Copy description URL';

  @override
  String get resultFilter => 'Filter results';

  @override
  String get resultFilterHint =>
      'Same as the Web UI: 0 means no limit. Size uses 1024-based units.';

  @override
  String get seeders => 'Seeders';

  @override
  String get minValue => 'Min';

  @override
  String get maxValue => 'Max';

  @override
  String get rangeTo => 'to';

  @override
  String pluginVersion(String version) {
    return 'Version $version';
  }

  @override
  String get deletePlugin => 'Delete plugin';

  @override
  String get installPlugin => 'Install plugin';

  @override
  String get checkingUpdates => 'Checking…';

  @override
  String get checkUpdates => 'Check for updates';

  @override
  String get searchPluginCopyrightWarning =>
      'Warning: when downloading torrents from these search engines, make sure it complies with the copyright laws of your country.';

  @override
  String get searchPluginGetMore =>
      'You can get new search engine plugins here:';

  @override
  String get noSearchPluginsList => 'No search plugins';

  @override
  String get noSearchPluginsListHint =>
      'Tap “Install plugin” or “Check for updates” to get official plugins';

  @override
  String get cannotOpenLink => 'Could not open the link';

  @override
  String get installing => 'Installing…';

  @override
  String get pluginInstalled => 'Plugin installed';

  @override
  String installFailed(String error) {
    return 'Install failed: $error';
  }

  @override
  String get pluginsUpdated => 'Plugin list updated';

  @override
  String checkUpdatesFailed(String error) {
    return 'Update check failed: $error';
  }

  @override
  String operationFailed(String error) {
    return 'Operation failed: $error';
  }

  @override
  String confirmUninstallPlugin(String name) {
    return 'Uninstall $name?';
  }

  @override
  String get pluginDeleted => 'Plugin deleted';

  @override
  String get enterPluginSource => 'Enter a plugin URL or path';

  @override
  String get installSearchPlugin => 'Install search plugin';

  @override
  String get installPluginHint =>
      'Enter the URL of a plugin .py file, or a path on the qB server. Separate multiple sources with new lines.';

  @override
  String get pluginSource => 'Plugin source';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionReset => 'Reset';

  @override
  String get actionGenerate => 'Generate';

  @override
  String get actionSend => 'Send';

  @override
  String get validating => 'Verifying…';

  @override
  String get listSeparator => ', ';

  @override
  String pleaseFillFields(String fields) {
    return 'Please fill in: $fields';
  }

  @override
  String get serverNotFound => 'Server not found or already deleted';

  @override
  String get cannotGetApiVersion => 'Could not get API version';

  @override
  String probeFailed(String error) {
    return 'Verification failed: $error';
  }

  @override
  String get saveFailedServerGone =>
      'Save failed: server not found or already deleted';

  @override
  String get unitSeconds => 's';

  @override
  String get unitMilliseconds => 'ms';

  @override
  String get unlimitedHint => '0 means unlimited';

  @override
  String get qbSetBehavior => 'Behavior';

  @override
  String get qbSetDownloads => 'Downloads';

  @override
  String get qbSetConnection => 'Connection';

  @override
  String get qbSetSpeed => 'Speed';

  @override
  String get qbSetAdvanced => 'Advanced';

  @override
  String get qbSetDisclaimer =>
      'These options apply to the current qBittorrent server. Some settings only affect the server or WebUI, not this app.';

  @override
  String get currentServerSettings => 'Current server settings';

  @override
  String get addServer => 'Add server';

  @override
  String get editServer => 'Edit server';

  @override
  String get serverListHint =>
      'Tap to switch servers. Use the top-right button to edit server settings.';

  @override
  String get noServersHint =>
      'Tap the button at the bottom right to add a qBittorrent server';

  @override
  String get deleteServer => 'Delete server';

  @override
  String confirmDeleteServer(String name) {
    return 'Delete “$name”? This cannot be undone.';
  }

  @override
  String get serverName => 'Server name';

  @override
  String get serverNameHint => 'Server name, e.g. My NAS';

  @override
  String get host => 'Host or IP';

  @override
  String get hostHint => 'Host or IP, e.g. my.nas.com, 192.168.1.1';

  @override
  String get port => 'Port';

  @override
  String get portHint => 'Port, e.g. 8888';

  @override
  String get pathHint => 'Path without leading “/”, e.g. nas/qb';

  @override
  String get apiKey => 'API key';

  @override
  String get apiKeyHint => 'API key — generate it in the WebUI';

  @override
  String get useHttps => 'Use HTTPS';

  @override
  String get schedulerEveryDay => 'Every day';

  @override
  String get schedulerWeekdays => 'Weekdays';

  @override
  String get schedulerWeekends => 'Weekends';

  @override
  String get schedulerMonday => 'Monday';

  @override
  String get schedulerTuesday => 'Tuesday';

  @override
  String get schedulerWednesday => 'Wednesday';

  @override
  String get schedulerThursday => 'Thursday';

  @override
  String get schedulerFriday => 'Friday';

  @override
  String get schedulerSaturday => 'Saturday';

  @override
  String get schedulerSunday => 'Sunday';

  @override
  String get peerProtocolTcpAndUtp => 'TCP and μTP';

  @override
  String get proxyTypeNone => '(None)';

  @override
  String get btEncryptAllow => 'Allow encryption';

  @override
  String get btEncryptRequire => 'Require encryption';

  @override
  String get btEncryptDisable => 'Disable encryption';

  @override
  String get btRatioStop => 'Stop torrent';

  @override
  String get btRatioRemove => 'Remove torrent';

  @override
  String get btRatioRemoveAndFiles => 'Remove torrent and its files';

  @override
  String get btRatioSuperSeeding => 'Enable super seeding for torrent';

  @override
  String get logAgeDays => 'days';

  @override
  String get logAgeMonths => 'months';

  @override
  String get logAgeYears => 'years';

  @override
  String get tmmRelocateTorrent => 'Relocate torrent';

  @override
  String get tmmRelocateAffected => 'Relocate affected torrents';

  @override
  String get tmmSwitchTorrentManual => 'Switch torrent to Manual Mode';

  @override
  String get tmmSwitchAffectedManual =>
      'Switch affected torrents to Manual Mode';

  @override
  String get resumeFastresume => 'Fastresume files';

  @override
  String get resumeSqlite => 'SQLite database (experimental)';

  @override
  String get removeDeleteFiles => 'Delete files permanently';

  @override
  String get removeMoveToTrash => 'Move to Recycle Bin (if possible)';

  @override
  String get diskIoMemoryMapped => 'Memory mapped files';

  @override
  String get diskIoPosix => 'POSIX-compliant';

  @override
  String get diskIoSimplePread => 'Simple pread/pwrite';

  @override
  String get osCacheDisable => 'Disable OS cache';

  @override
  String get osCacheEnable => 'Enable OS cache';

  @override
  String get osCacheWriteThrough => 'Write-through';

  @override
  String get utpPreferTcp => 'Prefer TCP';

  @override
  String get utpPeerProportional => 'Peer proportional (throttles TCP)';

  @override
  String get uploadSlotsFixed => 'Fixed slots';

  @override
  String get uploadSlotsRateBased => 'Upload rate based';

  @override
  String get chokeRoundRobin => 'Round-robin';

  @override
  String get chokeFastestUpload => 'Fastest upload';

  @override
  String get chokeAntiLeech => 'Anti-leech';

  @override
  String get bindAllAddresses => 'All addresses';

  @override
  String get bindAllIpv4 => 'All IPv4 addresses';

  @override
  String get bindAllIpv6 => 'All IPv6 addresses';

  @override
  String get anyInterface => 'Any interface';

  @override
  String get qbWebUiLanguage => 'User interface language';

  @override
  String get transferList => 'Transfer List';

  @override
  String get confirmTorrentDeletion => 'Confirm when deleting torrents';

  @override
  String get showExternalIp => 'Show external IP in status bar';

  @override
  String get logFile => 'Log file';

  @override
  String get enableLogFile => 'Enable log file';

  @override
  String get backupLogWhenLarger => 'Backup log file when larger than';

  @override
  String get deleteOldBackupLogs => 'Delete backup logs older than';

  @override
  String get logAge => 'Duration';

  @override
  String get logPerformanceWarning => 'Log performance warnings';

  @override
  String get invalidLogBackupSize => 'Enter a valid log backup size';

  @override
  String get invalidLogRetention => 'Enter a valid log retention period';

  @override
  String get scheduleAltSpeed => 'Schedule the use of alternative rate limits';

  @override
  String get scheduleFrom => 'From';

  @override
  String get scheduleTo => 'To';

  @override
  String get scheduleWhen => 'When';

  @override
  String get rateLimitOptions => 'Rate Limits Settings';

  @override
  String get limitUtpRate => 'Apply rate limit to µTP protocol';

  @override
  String get limitOverhead => 'Apply rate limit to transport overhead';

  @override
  String get limitLanPeers => 'Apply rate limit to peers on LAN';

  @override
  String get invalidSpeedLimit =>
      'Speed limits must be 0 or greater (0 is unlimited)';

  @override
  String get peerConnectionProtocol => 'Peer connection protocol';

  @override
  String get listeningPort => 'Listening Port';

  @override
  String get incomingConnectionsPort => 'Port used for incoming connections';

  @override
  String get actionRandom => 'Random';

  @override
  String get upnpPortForward =>
      'Use UPnP / NAT-PMP port forwarding from my router';

  @override
  String get connectionLimits => 'Connections Limits';

  @override
  String get maxConnectionsGlobal => 'Global maximum number of connections';

  @override
  String get maxConnectionsPerTorrent =>
      'Maximum number of connections per torrent';

  @override
  String get maxUploadsGlobal => 'Global maximum number of upload slots';

  @override
  String get maxUploadsPerTorrent =>
      'Maximum number of upload slots per torrent';

  @override
  String get i2pExperimental => 'I2P (experimental)';

  @override
  String get mixedMode => 'Mixed mode';

  @override
  String get proxyServer => 'Proxy Server';

  @override
  String get proxyType => 'Type';

  @override
  String get proxyHostnameLookup => 'Use proxy to do DNS lookups';

  @override
  String get authentication => 'Authentication';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get passwordStoredUnencrypted =>
      'Note: the password is stored unencrypted';

  @override
  String get proxyForBittorrent => 'Use proxy for BitTorrent purposes';

  @override
  String get proxyForPeerConnections => 'Use proxy for peer connections';

  @override
  String get proxyForRss => 'Use proxy for RSS purposes';

  @override
  String get proxyForGeneral => 'Use proxy for general purposes';

  @override
  String get ipFiltering => 'IP Filtering';

  @override
  String get ipFilterPath => 'Filter path (.dat, .p2p, .p2b)';

  @override
  String get filterTrackers => 'Apply to trackers';

  @override
  String get manuallyBannedIps => 'Manually banned IP addresses';

  @override
  String get oneIpPerLine => 'One IP per line';

  @override
  String get invalidListenPort =>
      'Incoming connection port must be between 0 and 65535';

  @override
  String get invalidMaxConnections =>
      'Global maximum connections must be greater than 0 or disabled';

  @override
  String get invalidMaxConnectionsPerTorrent =>
      'Maximum connections per torrent must be greater than 0 or disabled';

  @override
  String get invalidMaxUploads =>
      'Global maximum upload slots must be greater than 0 or disabled';

  @override
  String get invalidMaxUploadsPerTorrent =>
      'Maximum upload slots per torrent must be greater than 0 or disabled';

  @override
  String get invalidProxyPort => 'Proxy port must be between 0 and 65535';

  @override
  String get invalidI2pPort => 'I2P port must be between 0 and 65535';

  @override
  String get privacy => 'Privacy';

  @override
  String get enableDht =>
      'Enable DHT (decentralized network) to find more peers';

  @override
  String get enablePex => 'Enable Peer Exchange (PeX) to find more peers';

  @override
  String get enableLsd => 'Enable Local Peer Discovery to find more peers';

  @override
  String get encryptionMode => 'Encryption mode';

  @override
  String get anonymousMode => 'Enable anonymous mode';

  @override
  String get maxActiveCheckingTorrents => 'Maximum active checking torrents';

  @override
  String get maxActiveDownloads => 'Maximum active downloads';

  @override
  String get maxActiveUploads => 'Maximum active uploads';

  @override
  String get maxActiveTorrents => 'Maximum active torrents';

  @override
  String get ignoreSlowTorrents => 'Do not count slow torrents in these limits';

  @override
  String get downloadRateThreshold => 'Download rate threshold';

  @override
  String get uploadRateThreshold => 'Upload rate threshold';

  @override
  String get torrentInactivityTimer => 'Torrent inactivity timer';

  @override
  String get seedingLimits => 'Seeding Limits';

  @override
  String get whenRatioReaches => 'When ratio reaches';

  @override
  String get whenSeedingTimeReaches => 'When seeding time reaches';

  @override
  String get whenInactiveSeedingTimeReaches =>
      'When inactive seeding time reaches';

  @override
  String get then => 'then';

  @override
  String get autoAddTrackers =>
      'Automatically add these trackers to new downloads';

  @override
  String get oneTrackerPerLine => 'One tracker per line';

  @override
  String get autoAddTrackersFromUrl =>
      'Automatically add trackers from URL to new downloads';

  @override
  String get url => 'URL';

  @override
  String get fetchedTrackers => 'Fetched trackers';

  @override
  String get invalidMaxActiveChecking =>
      'Maximum active checking torrents must be greater than -1';

  @override
  String get invalidMaxActiveDownloads =>
      'Maximum active downloads must be greater than -1';

  @override
  String get invalidMaxActiveUploads =>
      'Maximum active uploads must be greater than -1';

  @override
  String get invalidMaxActiveTorrents =>
      'Maximum active torrents must be greater than -1';

  @override
  String get invalidDownloadRateThreshold =>
      'Download rate threshold must be greater than 0';

  @override
  String get invalidUploadRateThreshold =>
      'Upload rate threshold must be greater than 0';

  @override
  String get invalidTorrentInactivityTimer =>
      'Torrent inactivity timer must be greater than 0';

  @override
  String get invalidShareRatio => 'Share ratio limit cannot be negative';

  @override
  String get invalidSeedingTime => 'Seeding time limit cannot be negative';

  @override
  String get invalidInactiveSeedingTime =>
      'Inactive seeding time limit cannot be negative';

  @override
  String get whenAddingTorrent => 'When adding a torrent';

  @override
  String get doNotStartDownload => 'Do not start the download automatically';

  @override
  String get whenDuplicateTorrent => 'When adding a duplicate torrent';

  @override
  String get mergeTrackers => 'Merge trackers to existing torrent';

  @override
  String get deleteTorrentFileWhenDone => 'Delete .torrent files afterwards';

  @override
  String get preallocateAll => 'Pre-allocate disk space for all files';

  @override
  String get appendIncompleteExt => 'Append .!qB extension to incomplete files';

  @override
  String get keepUnwantedInFolder =>
      'Keep unselected files in \".unwanted\" folder';

  @override
  String get saveManagement => 'Saving Management';

  @override
  String get defaultTmmMode => 'Default Torrent Management Mode';

  @override
  String get whenTorrentCategoryChanged => 'When Torrent Category changed';

  @override
  String get whenDefaultSavePathChanged => 'When Default Save Path changed';

  @override
  String get whenCategorySavePathChanged => 'When Category Save Path changed';

  @override
  String get useCategoryPathsInManualMode =>
      'Use category paths in Manual Mode';

  @override
  String get defaultSavePath => 'Default Save Path';

  @override
  String get saveIncompleteTorrentsTo => 'Keep incomplete torrents in';

  @override
  String get copyTorrentFilesTo => 'Copy .torrent files to';

  @override
  String get copyFinishedTorrentFilesTo =>
      'Copy .torrent files of finished downloads to';

  @override
  String get excludedFileNames => 'Excluded file names';

  @override
  String get oneRulePerLine => 'One rule per line';

  @override
  String get emailOnTorrentCompletion => 'Send e-mail on finished download';

  @override
  String get mailSender => 'From';

  @override
  String get mailRecipient => 'To';

  @override
  String get smtpServer => 'SMTP server';

  @override
  String get smtpRequiresSsl =>
      'This server requires a secure connection (SSL)';

  @override
  String get sendTestEmail => 'Send test email';

  @override
  String get sending => 'Sending…';

  @override
  String sendFailed(String error) {
    return 'Send failed: $error';
  }

  @override
  String get testEmailSent => 'Test email sent';

  @override
  String get confirmSendTestEmailTitle => 'Send test email';

  @override
  String get confirmSendTestEmail =>
      'The test email uses the mail settings already saved on the server. The current page (including mail options) will be saved first. Continue?';

  @override
  String get runExternalProgram => 'Run external program';

  @override
  String get runOnTorrentAdded => 'Run on torrent added';

  @override
  String get runOnTorrentFinished => 'Run on torrent finished';

  @override
  String get autorunExampleHint => 'e.g. \"%N\"';

  @override
  String get autorunParametersHint =>
      'Supported parameters (case-sensitive):\n%N: Torrent name, %L: Category, %G: Tags (comma-separated), %F: Content path, %R: Root path, %D: Save path, %C: Number of files, %Z: Torrent size (bytes), %T: Tracker, %I/%J: Info hash, %K: ID, %M: Comment\nTip: wrap parameters in quotes to prevent splitting on whitespace (e.g. \"%N\")';

  @override
  String get torrentContentLayout => 'Torrent content layout';

  @override
  String get torrentStopCondition => 'Torrent stop condition';

  @override
  String get enableMailNotificationFirst => 'Enable email notifications first';

  @override
  String get enterDefaultSavePath => 'Enter a default save path';

  @override
  String get webUiRemoteControl => 'Web User Interface (Remote control)';

  @override
  String get ipAddress => 'IP address';

  @override
  String get useHttpsInsteadOfHttp => 'Use HTTPS instead of HTTP';

  @override
  String get certificate => 'Certificate';

  @override
  String get privateKey => 'Key';

  @override
  String get bypassAuthLocalhost =>
      'Bypass authentication for clients on localhost';

  @override
  String get bypassAuthWhitelist =>
      'Bypass authentication for clients in whitelist';

  @override
  String get subnetWhitelistHint => 'e.g. 192.168.1.0/24';

  @override
  String get banAfterFailedAttempts => 'Ban client after consecutive failures';

  @override
  String get banFor => 'Ban for';

  @override
  String get sessionTimeout => 'Session timeout';

  @override
  String get passwordLeaveBlank => 'Leave blank to keep the current password';

  @override
  String get copiedApiKey => 'API key copied';

  @override
  String get resetApiKey => 'Reset API key';

  @override
  String get generateApiKey => 'Generate API key';

  @override
  String get confirmResetApiKey =>
      'Reset this API key? The current key will stop working immediately and a new key will be generated. This app will update the locally saved key.';

  @override
  String get confirmGenerateApiKey =>
      'Generate an API key? This key can be used to interact with the qBittorrent API. This app will save it to the local server configuration.';

  @override
  String get resetting => 'Resetting…';

  @override
  String get generating => 'Generating…';

  @override
  String get apiKeyReset => 'API key reset';

  @override
  String get apiKeyGenerated => 'API key generated';

  @override
  String get deleteApiKey => 'Delete API key';

  @override
  String get confirmDeleteApiKey =>
      'Delete this API key? The current key will stop working immediately. This app will not be able to connect until you configure a new key in server settings.';

  @override
  String get apiKeyDeleted => 'API key deleted';

  @override
  String get useAlternativeWebUi => 'Use alternative WebUI';

  @override
  String get filePath => 'Files location';

  @override
  String get security => 'Security';

  @override
  String get clickjackingProtection => 'Enable clickjacking protection';

  @override
  String get csrfProtection =>
      'Enable Cross-Site Request Forgery (CSRF) protection';

  @override
  String get secureCookie =>
      'Enable cookie Secure flag (requires HTTPS or localhost)';

  @override
  String get hostHeaderValidation => 'Enable Host header validation';

  @override
  String get serverDomains => 'Server domains';

  @override
  String get customHttpHeaders => 'Add custom HTTP headers';

  @override
  String get oneHeaderPerLine => 'One header per line';

  @override
  String get reverseProxySupport => 'Enable reverse proxy support';

  @override
  String get trustedProxiesList => 'Trusted reverse proxies list';

  @override
  String get onePerLine => 'One per line';

  @override
  String get updateDynDns => 'Update my dynamic domain name';

  @override
  String get dynDnsService => 'Service';

  @override
  String get domain => 'Domain name';

  @override
  String get webUiWarning =>
      'These options configure the server’s own WebUI. Changing the address, port, HTTPS, authentication, or security options may prevent this app from connecting. Make sure you still have another way to reach qBittorrent.';

  @override
  String get confirmSaveWebUiTitle => 'Confirm saving WebUI settings';

  @override
  String get confirmSaveWebUi =>
      'Changing the address, port, HTTPS, credentials, or security options may temporarily disconnect this app. Make sure you can still reach qBittorrent another way. Continue saving?';

  @override
  String get cannotResetApiKey => 'Could not reset API key';

  @override
  String get cannotDeleteApiKey => 'Could not delete API key.';

  @override
  String get httpsCertPathRequired => 'HTTPS certificate path cannot be empty';

  @override
  String get httpsKeyPathRequired => 'HTTPS key path cannot be empty';

  @override
  String get webUiUsernameMinLength =>
      'WebUI username must be at least 3 characters';

  @override
  String get webUiUsernameNoColon => 'WebUI username cannot contain a colon';

  @override
  String get webUiPasswordMinLength =>
      'WebUI password must be at least 6 characters';

  @override
  String get altWebUiPathRequired =>
      'Alternative WebUI files location cannot be empty';

  @override
  String get webUiPortRange => 'WebUI port must be between 1 and 65535';

  @override
  String get resumeDataStorage => 'Resume data storage type (requires restart)';

  @override
  String get torrentContentRemoveOption => 'Delete torrent contents files';

  @override
  String get physicalMemoryLimit => 'Physical memory (RAM) usage limit';

  @override
  String get networkInterface => 'Network interface';

  @override
  String get optionalBindAddress => 'Optional IP address to bind to';

  @override
  String get saveResumeDataInterval => 'Save resume data interval';

  @override
  String get saveStatisticsInterval => 'Save statistics interval';

  @override
  String get torrentFileSizeLimit => '.torrent file size limit';

  @override
  String get confirmTorrentRecheck => 'Confirm torrent recheck';

  @override
  String get recheckCompletedTorrents => 'Recheck torrents on completion';

  @override
  String get appInstanceName => 'Customize application instance name';

  @override
  String get refreshInterval => 'Refresh interval';

  @override
  String get resolvePeerHostnames => 'Resolve peer host names';

  @override
  String get resolvePeerCountries => 'Resolve peer countries';

  @override
  String get enableEmbeddedTracker => 'Enable embedded tracker';

  @override
  String get embeddedTrackerPort => 'Embedded tracker port';

  @override
  String get embeddedTrackerPortForwarding =>
      'Enable port forwarding for embedded tracker';

  @override
  String get enableMotw =>
      'Enable Mark-of-the-Web for downloaded files (requires macOS or Windows)';

  @override
  String get ignoreSslErrors => 'Ignore SSL errors';

  @override
  String get asyncIoThreads => 'Asynchronous I/O threads';

  @override
  String get hashingThreads => 'Hashing threads';

  @override
  String get filePoolSize => 'File pool size';

  @override
  String get outstandingMemoryWhenChecking =>
      'Outstanding memory when checking torrents';

  @override
  String get diskCache => 'Disk cache';

  @override
  String get diskCacheTtl => 'Disk cache expiry interval';

  @override
  String get diskQueueSize => 'Disk queue size';

  @override
  String get diskIoType => 'Disk IO type (requires restart)';

  @override
  String get diskIoReadMode => 'Disk IO read mode';

  @override
  String get diskIoWriteMode => 'Disk IO write mode';

  @override
  String get coalesceReadsWrites => 'Coalesce reads & writes';

  @override
  String get pieceExtentAffinity => 'Use piece extent affinity';

  @override
  String get sendUploadPieceSuggestions => 'Send upload piece suggestions';

  @override
  String get sendBufferWatermark => 'Send buffer watermark';

  @override
  String get sendBufferLowWatermark => 'Send buffer low watermark';

  @override
  String get sendBufferWatermarkFactor => 'Send buffer watermark factor';

  @override
  String get outgoingConnectionsPerSecond => 'Outgoing connections per second';

  @override
  String get allowOutgoingWhenSeeding =>
      'Allow outgoing connections when seeding';

  @override
  String get socketSendBufferSize =>
      'Socket send buffer size (0: system default)';

  @override
  String get socketReceiveBufferSize =>
      'Socket receive buffer size (0: system default)';

  @override
  String get socketBacklogSize => 'Socket backlog size';

  @override
  String get outgoingPortsMin => 'Outgoing ports (Min) (0: disabled)';

  @override
  String get outgoingPortsMax => 'Outgoing ports (Max) (0: disabled)';

  @override
  String get peerTos => 'DSCP for connections to peers';

  @override
  String get resolverCacheTtl =>
      'Network address lookup caching expiry interval';

  @override
  String get idnSupport => 'Support internationalized domain names (IDN)';

  @override
  String get allowMultipleConnectionsFromSameIp =>
      'Allow multiple connections from the same IP address';

  @override
  String get validateHttpsTrackerCert => 'Validate HTTPS tracker certificates';

  @override
  String get ssrfMitigation => 'Server-side request forgery (SSRF) mitigation';

  @override
  String get blockPeersOnPrivilegedPorts =>
      'Disallow connections to peers on privileged ports';

  @override
  String get uploadSlotsBehavior => 'Upload slots behavior';

  @override
  String get uploadChokingAlgorithm => 'Upload choking algorithm';

  @override
  String get announceToAllTrackers =>
      'Always announce to all trackers in a tier';

  @override
  String get announceToAllTiers => 'Always announce to all tiers';

  @override
  String get announceIp => 'IP address reported to trackers (requires restart)';

  @override
  String get announcePort =>
      'Port reported to trackers (requires restart) (0: listening port)';

  @override
  String get maxConcurrentHttpAnnounces => 'Max concurrent HTTP announces';

  @override
  String get stopTrackerTimeout => 'Stop tracker timeout (0: disabled)';

  @override
  String get peerTurnover => 'Peer turnover disconnect percentage';

  @override
  String get peerTurnoverCutoff => 'Peer turnover threshold percentage';

  @override
  String get peerTurnoverInterval => 'Peer turnover disconnect interval';

  @override
  String get requestQueueSize =>
      'Maximum outstanding requests to a single peer';

  @override
  String get maxOutstandingPieceRequests =>
      'Maximum outstanding incoming block requests';

  @override
  String get dhtBootstrapNodes => 'DHT bootstrap nodes';

  @override
  String get i2pInboundQuantity => 'I2P inbound quantity';

  @override
  String get i2pOutboundQuantity => 'I2P outbound quantity';

  @override
  String get i2pInboundLength => 'I2P inbound length';

  @override
  String get i2pOutboundLength => 'I2P outbound length';

  @override
  String get i2pTunnel => 'I2P tunnel';

  @override
  String get upnpLeaseDuration => 'UPnP lease duration (0: permanent)';

  @override
  String get reannounceWhenAddressChanges =>
      'Reannounce to all trackers when IP or port changed';

  @override
  String get pythonExecutablePath =>
      'Python executable path (may require restart)';

  @override
  String get bdecodeTokenLimit => 'Bdecode token limit';

  @override
  String get bdecodeDepthLimit => 'Bdecode depth limit';

  @override
  String get utpTcpMixedMode => 'µTP-TCP mixed mode algorithm';

  @override
  String get allowMultipleConnectionsFromSamePeerId =>
      'Allow multiple connections from the same peer ID';

  @override
  String get invalidCheckingMemory =>
      'Outstanding memory when checking must be greater than 0 and less than 1024 MiB';

  @override
  String get invalidPeerDscp => 'Peer DSCP must be between 0 and 255';

  @override
  String get invalidAnnouncePort =>
      'Port reported to trackers must be between 0 and 65535';

  @override
  String get invalidPeerTurnover =>
      'Peer turnover disconnect percentage must be between 0 and 100';

  @override
  String get invalidPeerTurnoverCutoff =>
      'Peer turnover threshold percentage must be between 0 and 100';

  @override
  String get invalidPeerTurnoverInterval =>
      'Peer turnover disconnect interval must be 0 or greater';

  @override
  String get pythonPathNoQuotes =>
      'Python executable path must not start or end with quotes';

  @override
  String get searchLogsHint => 'Search logs…';

  @override
  String get closeSearch => 'Close search';

  @override
  String get logTabBannedIp => 'Banned IPs';

  @override
  String get noLogs => 'No logs';

  @override
  String get noLogsHint => 'The server has not produced any log entries yet';

  @override
  String get noMatchingLogs => 'No matching logs';

  @override
  String get adjustFiltersOrSearchHint =>
      'Try adjusting filters or search keywords';

  @override
  String get noBanRecords => 'No ban records';

  @override
  String get noBanRecordsHint => 'No peers have been blocked or banned yet';

  @override
  String get noMatchingRecords => 'No matching records';

  @override
  String get adjustSearchHint => 'Try adjusting the search keywords';

  @override
  String get logPeerBlocked => 'Blocked';

  @override
  String get logPeerBanned => 'Banned';

  @override
  String get pageNotFound => 'Page not found';
}
