// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'qBPanel';

  @override
  String get actionCancel => '取消';

  @override
  String get actionOk => '确定';

  @override
  String get actionConfirm => '确定';

  @override
  String get actionApply => '应用';

  @override
  String get actionRetry => '重试';

  @override
  String get actionSave => '保存';

  @override
  String get actionDelete => '删除';

  @override
  String get actionClose => '关闭';

  @override
  String get actionRename => '重命名';

  @override
  String get actionMore => '更多';

  @override
  String get loading => '加载中…';

  @override
  String get processing => '处理中…';

  @override
  String get emptyNoData => '暂无数据';

  @override
  String get loadFailed => '加载失败';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get notAvailable => 'N/A';

  @override
  String get emDash => '—';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsLanguage => '语言';

  @override
  String get localeFollowSystem => '跟随系统';

  @override
  String get localeChinese => '简体中文';

  @override
  String get localeChineseTraditional => '繁體中文';

  @override
  String get localeEnglish => 'English';

  @override
  String get settingsServer => '服务器';

  @override
  String get settingsServerSettings => '服务器设置';

  @override
  String get settingsServerSettingsSubtitle => '修改或添加服务器';

  @override
  String get settingsAppearance => '显示';

  @override
  String get settingsDisplayMode => '显示模式';

  @override
  String get settingsThemeSystem => '跟随系统';

  @override
  String get settingsThemeLight => '浅色';

  @override
  String get settingsThemeDark => '深色';

  @override
  String get settingsThemeHint => '跟随系统时，自动匹配设备的浅色 / 深色模式。';

  @override
  String get settingsThemeColor => '主题色';

  @override
  String get settingsUseDynamicColor => '使用系统强调色';

  @override
  String get settingsUseDynamicColorHint => '使用 Android 12+ 的 Material You 配色。';

  @override
  String get settingsCustomThemeColor => '自定义主题色';

  @override
  String get settingsCustomThemeColorHintDynamic => '关闭上方开关后生效；系统色不可用时也会回退到此颜色';

  @override
  String get settingsCustomThemeColorHint => '任意选取一个颜色，作为 Material 3 种子色';

  @override
  String get settingsPickThemeColor => '选择主题色';

  @override
  String get settingsPickColor => '取色';

  @override
  String get settingsPickColorHint => '选中后点「应用」立即生效';

  @override
  String get apiNoActiveServer => '没有激活的服务器，请先在设置中添加并选中';

  @override
  String get apiTimeout => '连接超时，请检查地址与端口';

  @override
  String get apiConnectionError => '无法连接服务器，请检查网络与配置';

  @override
  String get apiUnauthorized => 'API 密钥无效或无权限';

  @override
  String apiHttpStatus(int code) {
    return '服务器返回 $code';
  }

  @override
  String get apiBadCertificate => 'HTTPS 证书不受信任';

  @override
  String get apiCancelled => '请求已取消';

  @override
  String durationSeconds(int count) {
    return '$count 秒';
  }

  @override
  String durationMinutes(int count) {
    return '$count 分钟';
  }

  @override
  String durationHours(int count) {
    return '$count 小时';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours 小时 $minutes 分';
  }

  @override
  String durationDays(int count) {
    return '$count 天';
  }

  @override
  String durationDaysHours(int days, int hours) {
    return '$days 天 $hours 小时';
  }

  @override
  String durationMinutesSeconds(int minutes, int seconds) {
    return '$minutes 分钟 $seconds 秒';
  }

  @override
  String formatSeedingSuffix(String base, String seeding) {
    return '$base (做种 $seeding)';
  }

  @override
  String formatConnectionsUnlimited(int count) {
    return '$count (最多 ∞)';
  }

  @override
  String formatConnectionsLimited(int count, int limit) {
    return '$count (最多 $limit)';
  }

  @override
  String formatSession(String total, String session) {
    return '$total (本次 $session)';
  }

  @override
  String formatSpeedAvg(String current, String average) {
    return '$current (平均 $average)';
  }

  @override
  String formatCountTotal(int current, int total) {
    return '$current (共 $total)';
  }

  @override
  String formatPieces(int count, String size, int have) {
    return '$count × $size (已完成 $have)';
  }

  @override
  String get logToday => '今天';

  @override
  String get logYesterday => '昨天';

  @override
  String get connectionStatusConnected => '已连接';

  @override
  String get connectionStatusFirewalled => '无法入站';

  @override
  String get connectionStatusDisconnected => '未连接';

  @override
  String get connectionStatusUnknown => '未知';

  @override
  String get torrentStateError => '错误';

  @override
  String get torrentStateMissingFiles => '文件缺失';

  @override
  String get torrentStateUploading => '做种中';

  @override
  String get torrentStateStoppedUp => '已完成';

  @override
  String get torrentStateQueuedUp => '排队做种';

  @override
  String get torrentStateStalledUp => '做种已暂停';

  @override
  String get torrentStateCheckingUp => '校验中';

  @override
  String get torrentStateForcedUp => '强制做种';

  @override
  String get torrentStateAllocating => '分配空间';

  @override
  String get torrentStateDownloading => '下载中';

  @override
  String get torrentStateMetaDl => '获取元数据';

  @override
  String get torrentStateForcedMetaDl => '强制获取元数据';

  @override
  String get torrentStateStoppedDl => '已停止';

  @override
  String get torrentStateQueuedDl => '排队下载';

  @override
  String get torrentStateStalledDl => '下载已暂停';

  @override
  String get torrentStateCheckingDl => '校验中';

  @override
  String get torrentStateForcedDl => '强制下载';

  @override
  String get torrentStateCheckingResumeData => '检查恢复数据';

  @override
  String get torrentStateMoving => '移动中';

  @override
  String get torrentStateUnknown => '未知';

  @override
  String get filterAll => '全部';

  @override
  String get filterDownloading => '下载';

  @override
  String get filterSeeding => '做种';

  @override
  String get filterCompleted => '完成';

  @override
  String get filterRunning => '正运行';

  @override
  String get filterStopped => '已停止';

  @override
  String get filterActive => '活动';

  @override
  String get filterInactive => '空闲';

  @override
  String get filterStalled => '暂停';

  @override
  String get filterStalledUploading => '上传已暂停';

  @override
  String get filterStalledDownloading => '下载已暂停';

  @override
  String get filterChecking => '正在检查';

  @override
  String get filterMoving => '正在移动';

  @override
  String get filterErrored => '错误';

  @override
  String get filterUncategorized => '未分类';

  @override
  String get filterUntagged => '无标签';

  @override
  String get sortState => '状态';

  @override
  String get sortName => '名称';

  @override
  String get sortProgress => '进度';

  @override
  String get sortSize => '大小';

  @override
  String get sortDownloadSpeed => '下载速度';

  @override
  String get sortUploadSpeed => '上传速度';

  @override
  String get sortDownloaded => '已下载';

  @override
  String get sortUploaded => '已上传';

  @override
  String get sortEta => '剩余时间';

  @override
  String get sortAmountLeft => '剩余大小';

  @override
  String get sortRatio => '分享率';

  @override
  String get sortAddedOn => '添加时间';

  @override
  String get sortCompletionOn => '完成时间';

  @override
  String get sortLastActivity => '最后活动';

  @override
  String get sortNumSeeds => '种子数';

  @override
  String get sortNumLeechs => '下载用户';

  @override
  String get sortAvailability => '可用性';

  @override
  String get sortPriority => '优先级';

  @override
  String get sortTimeActive => '活动时间';

  @override
  String get sortSeedingTime => '做种时间';

  @override
  String get sortCountry => '国家/地区';

  @override
  String get sortIp => 'IP/地址';

  @override
  String get sortPort => '端口';

  @override
  String get sortConnection => '连接';

  @override
  String get sortFlags => '标志';

  @override
  String get sortClient => '客户端';

  @override
  String get sortPeerIdClient => '对等节点 ID 客户端';

  @override
  String get sortRelevance => '文件关联';

  @override
  String get sortFiles => '文件';

  @override
  String get sortUrl => 'URL';

  @override
  String get sortTier => '层级';

  @override
  String get sortStatus => '状态';

  @override
  String get sortSeeds => '种子';

  @override
  String get sortPeers => '用户';

  @override
  String get sortLeeches => '下载者';

  @override
  String get sortDownloadCount => '完成次数';

  @override
  String get sortMessage => '消息';

  @override
  String get sortNextAnnounce => '下次宣告';

  @override
  String get sortMinAnnounce => '最短宣告间隔';

  @override
  String get sortContentPriority => '下载优先级';

  @override
  String get sortTotalSize => '总大小';

  @override
  String get sortRemaining => '剩余';

  @override
  String get shareLimitUseDefault => '使用全局设置';

  @override
  String get shareLimitStop => '停止种子';

  @override
  String get shareLimitRemove => '删除种子';

  @override
  String get shareLimitRemoveWithContent => '删除种子和文件';

  @override
  String get shareLimitSuperSeeding => '开启超级做种';

  @override
  String get logLevelNormal => '普通';

  @override
  String get logLevelInfo => '信息';

  @override
  String get logLevelWarning => '警告';

  @override
  String get logLevelCritical => '严重';

  @override
  String get searchPluginEnabled => '已启用';

  @override
  String get searchPluginAll => '全部';

  @override
  String get searchPluginSingle => '指定插件';

  @override
  String get addModeManual => '手动';

  @override
  String get addModeAutomatic => '自动';

  @override
  String get addStopNone => '无';

  @override
  String get addStopMetadataReceived => '已收到元数据';

  @override
  String get addStopFilesChecked => '文件已被检查';

  @override
  String get addLayoutOriginal => '原始';

  @override
  String get addLayoutSubfolder => '创建子文件夹';

  @override
  String get addLayoutNoSubfolder => '不创建子文件夹';

  @override
  String get speedPeriod30s => '30 秒';

  @override
  String get speedPeriod1m => '1 分钟';

  @override
  String get speedPeriod5m => '5 分钟';

  @override
  String get speedPeriod10m => '10 分钟';

  @override
  String get speedPeriod30m => '30 分钟';

  @override
  String get homeFilter => '筛选';

  @override
  String get homeFiltering => '筛选中';

  @override
  String get homeClearSearch => '清除搜索';

  @override
  String get searchTorrentsHint => '过滤种子';

  @override
  String get homeSort => '排序';

  @override
  String get homeSorting => '排序中';

  @override
  String get homeStartAll => '一键开始';

  @override
  String get homeStopAll => '一键停止';

  @override
  String get homeSearchTorrents => '搜索种子';

  @override
  String get homeLogs => '日志';

  @override
  String get homeSettings => '设置';

  @override
  String get homeAddTorrent => '添加种子';

  @override
  String get homeNoActiveServer => '还没有活跃的服务器';

  @override
  String get homeNoActiveServerHint => '去服务器列表添加或点选一台';

  @override
  String get homeChooseServer => '去选择服务器';

  @override
  String get homeNoMatchingTorrents => '没有符合条件的种子';

  @override
  String get homeClearFilters => '清除筛选';

  @override
  String get homeNoTorrents => '暂无种子';

  @override
  String get homeNoTorrentsInList => '当前列表没有种子';

  @override
  String homeConfirmBatch(String action, int count) {
    return '确定$action当前列表中的 $count 个种子？';
  }

  @override
  String homeBatchStarted(int count) {
    return '已开始 $count 个种子';
  }

  @override
  String homeBatchStopped(int count) {
    return '已停止 $count 个种子';
  }

  @override
  String homeBatchFailed(String label, String error) {
    return '$label：$error';
  }

  @override
  String get homeStartAllFailed => '一键开始失败';

  @override
  String get homeStopAllFailed => '一键停止失败';

  @override
  String get homeStarting => '开始中…';

  @override
  String get homeStopping => '停止中…';

  @override
  String get homeStart => '开始';

  @override
  String get homeStop => '停止';

  @override
  String get homeSavedAltSpeed => '已保存备用限速';

  @override
  String get homeSavedGlobalSpeed => '已保存全局限速';

  @override
  String homeAltSpeedToggleFailed(String error) {
    return '切换备用速度限制失败：$error';
  }

  @override
  String get homeAltSpeedOn => '已开启备用速度限制';

  @override
  String get homeAltSpeedOff => '已关闭备用速度限制';

  @override
  String get homeServerStatus => '服务器状态';

  @override
  String get renameTitle => '重命名';

  @override
  String copiedWithLabel(String label) {
    return '已复制 $label';
  }

  @override
  String get actionBack => '返回';

  @override
  String get actionAdd => '添加';

  @override
  String get actionEnable => '开启';

  @override
  String get actionDisable => '关闭';

  @override
  String get actionGotIt => '知道了';

  @override
  String get enabling => '开启中…';

  @override
  String get disabling => '关闭中…';

  @override
  String get deleting => '删除中…';

  @override
  String get settingInProgress => '设置中…';

  @override
  String deleteFailed(String error) {
    return '删除失败：$error';
  }

  @override
  String errorWithDetail(String label, String error) {
    return '$label：$error';
  }

  @override
  String get onLabel => '开';

  @override
  String get offLabel => '关';

  @override
  String get unlimited => '无限制';

  @override
  String get unlimitedSpeed => '不限';

  @override
  String get custom => '自定义';

  @override
  String get minutes => '分钟';

  @override
  String get download => '下载';

  @override
  String get upload => '上传';

  @override
  String get status => '状态';

  @override
  String get category => '分类';

  @override
  String get tags => '标签';

  @override
  String get queue => '队列';

  @override
  String get copy => '复制';

  @override
  String get connection => '连接';

  @override
  String get transfer => '传输';

  @override
  String get info => '信息';

  @override
  String get application => '应用';

  @override
  String get never => '从未';

  @override
  String get unknown => '未知';

  @override
  String get enterName => '请输入名称';

  @override
  String get nameInvalid => '名称无效';

  @override
  String get invalidTorrent => '无效的种子';

  @override
  String get invalidParam => '参数无效';

  @override
  String get torrentNotFound => '种子不存在';

  @override
  String get actionForceStart => '强制启动';

  @override
  String get actionStartFailed => '开始失败';

  @override
  String get actionStopFailed => '停止失败';

  @override
  String get actionForceStartFailed => '强制启动失败';

  @override
  String get setSaveLocation => '设置保存位置';

  @override
  String get autoTmm => '自动种子管理';

  @override
  String get uploadLimit => '上传限速';

  @override
  String get uploadDownloadLimit => '上传/下载限速';

  @override
  String get shareLimit => '分享率限制';

  @override
  String get superSeeding => '超级做种模式';

  @override
  String get sequentialDownload => '顺序下载';

  @override
  String get firstLastPiece => '先下首尾块';

  @override
  String get forceRecheck => '强制重新校验';

  @override
  String get forceReannounce => '强制重新汇报';

  @override
  String get shareTorrent => '分享种子';

  @override
  String get queueTop => '置顶';

  @override
  String get queueUp => '上移';

  @override
  String get queueDown => '下移';

  @override
  String get queueBottom => '置底';

  @override
  String get queueTopFailed => '置顶失败';

  @override
  String get queueUpFailed => '上移失败';

  @override
  String get queueDownFailed => '下移失败';

  @override
  String get queueBottomFailed => '置底失败';

  @override
  String get sequentialFailed => '设置顺序下载失败';

  @override
  String get firstLastFailed => '设置先下首尾块失败';

  @override
  String get recheckFailed => '重新校验失败';

  @override
  String get reannounceFailed => '重新汇报失败';

  @override
  String get preparingShare => '准备分享…';

  @override
  String shareFailed(String error) {
    return '分享失败：$error';
  }

  @override
  String get renameTorrentHint => '修改的是种子在列表中的显示名称，不会改动服务器上的文件或文件夹。';

  @override
  String setLocationFailed(String error) {
    return '设置保存位置失败：$error';
  }

  @override
  String get enableAutoTmmTitle => '开启自动种子管理';

  @override
  String get enableAutoTmmMessage => '确定开启自动种子管理？种子可能会按分类的保存路径被移动。';

  @override
  String autoTmmFailed(String action, String error) {
    return '$action自动管理失败：$error';
  }

  @override
  String superSeedingFailed(String action, String error) {
    return '$action超级做种失败：$error';
  }

  @override
  String get deleteTorrentTitle => '删除种子';

  @override
  String get confirmDeleteTorrent => '确定删除该种子？';

  @override
  String confirmDeleteTorrentNamed(String name) {
    return '确定删除「$name」？';
  }

  @override
  String get deleteFilesToo => '同时删除文件';

  @override
  String get noTorrentsToOperate => '当前没有可操作的种子';

  @override
  String get invalidTorrentFile => '无效的种子文件';

  @override
  String get torrentFileNotReady => '种子文件尚未就绪';

  @override
  String get shareContentEmpty => '分享内容为空';

  @override
  String get prepareShareFailed => '准备分享文件失败';

  @override
  String get savePathRequired => '保存路径不能为空';

  @override
  String get savePathNoPermission => '没有该目录的写入权限';

  @override
  String get savePathCreateFailed => '无法创建保存路径';

  @override
  String get queueingDisabled => '未开启种子排队';

  @override
  String get categoryNotFound => '分类不存在';

  @override
  String get magnetLink => '磁力链接';

  @override
  String get contentPath => '内容路径';

  @override
  String get remaining => '剩余';

  @override
  String get addCategory => '添加分类';

  @override
  String get addSubcategory => '添加子分类';

  @override
  String get editCategory => '编辑分类';

  @override
  String get deleteCategory => '删除分类';

  @override
  String get deleteUnusedCategories => '删除未使用的分类';

  @override
  String get addTag => '添加标签';

  @override
  String get deleteTag => '删除标签';

  @override
  String get deleteUnusedTags => '删除未使用的标签';

  @override
  String confirmDeleteTag(String tag) {
    return '确定删除标签「$tag」？种子不会被删除。';
  }

  @override
  String confirmDeleteUnusedTags(int count) {
    return '确定删除 $count 个未使用的标签？种子不会被删除。';
  }

  @override
  String confirmDeleteCategory(String name) {
    return '确定删除分类「$name」？种子不会被删除。';
  }

  @override
  String confirmDeleteCategoryWithChildren(String name) {
    return '确定删除分类「$name」？其子分类也会一并删除。种子不会被删除。';
  }

  @override
  String confirmDeleteUnusedCategories(int count) {
    return '确定删除 $count 个未使用的分类？种子不会被删除。';
  }

  @override
  String get noUnusedTags => '没有未使用的标签';

  @override
  String get noUnusedCategories => '没有未使用的分类';

  @override
  String get noTagsHint => '暂无标签，点右上角新建';

  @override
  String get removeTags => '取消标签';

  @override
  String get tagsRemoved => '已取消标签';

  @override
  String get switchServer => '切换服务器';

  @override
  String get noServers => '暂无服务器';

  @override
  String get enterSavePath => '请输入保存路径';

  @override
  String get savePath => '保存路径';

  @override
  String get autoTmmLocationHint => '已开启自动种子管理。确定后将关闭自动管理，并改用上面的手动路径。';

  @override
  String get enterTagName => '请输入标签名称';

  @override
  String get tagNameNoComma => '标签名称不能包含逗号';

  @override
  String get tagName => '标签名称';

  @override
  String get enterCategoryName => '请输入分类名称';

  @override
  String get categoryNameInvalid => '分类名称无效';

  @override
  String get parentCategory => '父分类';

  @override
  String get categoryName => '分类名称';

  @override
  String get incompleteUseAnotherPath => '对不完整的 Torrent 使用另一个路径';

  @override
  String get defaultOption => '默认';

  @override
  String get path => '路径';

  @override
  String queuePosition(int position) {
    return '第 $position 位';
  }

  @override
  String get notInQueue => '不在队列中';

  @override
  String get seedingTime => '做种时间';

  @override
  String get inactive => '不活跃';

  @override
  String get afterLimitReached => '达到上限后';

  @override
  String get enterValidLimit => '请输入有效的限制';

  @override
  String get shareLimitSaved => '已保存分享率限制';

  @override
  String get enterValidSpeed => '请输入有效的速度';

  @override
  String get altSpeedLimit => '备用速度限制';

  @override
  String get globalSpeedLimit => '全局速度限制';

  @override
  String get altSpeedLimitHint => '当前已开启备用限速，修改将作用于备用值';

  @override
  String get speedLimitSaved => '已保存限速';

  @override
  String get altSpeedOffTooltip => '关闭备用速度限制';

  @override
  String get altSpeedOnTooltip => '开启备用速度限制';

  @override
  String get ssConnectionStatus => '连接状态';

  @override
  String get ssDhtNodes => 'DHT 节点';

  @override
  String get ssPeerConnections => 'Peer 连接';

  @override
  String get ssExternalIpv4 => '外网 IPv4';

  @override
  String get ssExternalIpv6 => '外网 IPv6';

  @override
  String get ssSessionDownload => '本次下载';

  @override
  String get ssSessionUpload => '本次上传';

  @override
  String get ssAllTimeDownload => '累计下载';

  @override
  String get ssAllTimeUpload => '累计上传';

  @override
  String get ssSessionWasted => '本次丢弃';

  @override
  String get ssDlRateLimit => '下载限速';

  @override
  String get ssUpRateLimit => '上传限速';

  @override
  String get ssAltSpeed => '备用限速';

  @override
  String get ssDiskAndQueue => '磁盘与队列';

  @override
  String get ssFreeSpace => '磁盘剩余';

  @override
  String get ssTorrentQueueing => '种子排队';

  @override
  String get ssDiskQueue => '磁盘队列';

  @override
  String get ssTrackerQueue => 'Tracker 排队';

  @override
  String get ssWritePending => '待写入';

  @override
  String get ssQueued => '队列等待';

  @override
  String get ssCache => '缓存';

  @override
  String get ssCacheUsed => '缓存占用';

  @override
  String get ssReadCacheHits => '读缓存命中';

  @override
  String get ssReadCacheOverload => '读缓存过载';

  @override
  String get ssWriteCacheOverload => '写缓存过载';

  @override
  String get ssAppVersion => '应用版本';

  @override
  String get ssApiVersion => 'API 版本';

  @override
  String get ssBitness => '位数';

  @override
  String get ssPlatform => '平台';

  @override
  String milliseconds(int count) {
    return '$count 毫秒';
  }

  @override
  String bitnessValue(int bitness) {
    return '$bitness 位';
  }

  @override
  String get torrentDetail => '种子详情';

  @override
  String get tabGeneral => '普通';

  @override
  String get tabPeers => '用户';

  @override
  String get tabContent => '内容';

  @override
  String get tabTrackers => 'Tracker';

  @override
  String get tabHttpSeeds => 'HTTP 源';

  @override
  String get sortPeersTitle => '用户排序';

  @override
  String get sortContent => '内容排序';

  @override
  String get sortTrackers => 'Tracker 排序';

  @override
  String get progress => '进度';

  @override
  String get availability => '可用性';

  @override
  String get timeActive => '活动时间';

  @override
  String get eta => '剩余时间';

  @override
  String get connections => '连接';

  @override
  String get seeds => '种子';

  @override
  String get peers => '用户';

  @override
  String get dlLimit => '下载限制';

  @override
  String get upLimit => '上传限制';

  @override
  String get wasted => '已丢弃';

  @override
  String get nextAnnounce => '下次汇报';

  @override
  String get lastSeen => '最后完整可见';

  @override
  String get popularity => '流行度';

  @override
  String get totalSize => '总大小';

  @override
  String get pieces => '区块';

  @override
  String get createdBy => '创建';

  @override
  String get addedOn => '添加于';

  @override
  String get completedOn => '完成于';

  @override
  String get createdOn => '创建于';

  @override
  String get privateTorrent => '私有';

  @override
  String get infohashV1 => '信息哈希值 v1';

  @override
  String get infohashV2 => '信息哈希值 v2';

  @override
  String get comment => '注释';

  @override
  String get speed => '速度';

  @override
  String get downloadAvg => '下载平均';

  @override
  String get uploadAvg => '上传平均';

  @override
  String get sampling => '采样中…';

  @override
  String get tier => '层级';

  @override
  String get leeches => '下载者';

  @override
  String get timesCompleted => '完成次数';

  @override
  String get message => '消息';

  @override
  String get minAnnounce => '最短宣告间隔';

  @override
  String get btProtocol => 'BT 协议';

  @override
  String get relevance => '关联度';

  @override
  String get contribution => '贡献';

  @override
  String get flags => '标志';

  @override
  String get downloadingFile => '正在下载';

  @override
  String downloadingFiles(int count) {
    return '正在下载 $count 个文件';
  }

  @override
  String get noHttpSeeds => '暂无 HTTP 源';

  @override
  String get noHttpSeedsHint => '当前种子还没有 HTTP 源';

  @override
  String get addHttpSeed => '添加 HTTP 源';

  @override
  String get editHttpSeed => '编辑 HTTP 源 URL';

  @override
  String get deleteHttpSeed => '删除 HTTP 源';

  @override
  String get copyHttpSeed => '复制 HTTP 源 URL';

  @override
  String get copiedHttpSeed => '已复制 HTTP 源 URL';

  @override
  String confirmDeleteHttpSeed(String url) {
    return '确定删除 $url？';
  }

  @override
  String get addedHttpSeed => '已添加 HTTP 源';

  @override
  String get enterHttpSeeds => '请输入至少一个 HTTP 源';

  @override
  String get enterHttpSeedUrl => '请输入 HTTP 源 URL';

  @override
  String get invalidUrl => 'URL 无效';

  @override
  String get httpSeedNotFound => 'HTTP 源不存在';

  @override
  String get invalidHttpSeed => '无效的 HTTP 源';

  @override
  String get httpSeedUrl => 'HTTP 源 URL';

  @override
  String get httpSeedListHint => '要添加的 HTTP 源列表（每行一个）';

  @override
  String get noTrackers => '暂无 Tracker';

  @override
  String get noTrackersHint => '当前种子还没有 Tracker';

  @override
  String get addTracker => '添加 Tracker';

  @override
  String get editTracker => '编辑 Tracker URL';

  @override
  String get deleteTracker => '删除 Tracker';

  @override
  String get copyTracker => '复制 Tracker URL';

  @override
  String get copiedTracker => '已复制 Tracker URL';

  @override
  String confirmDeleteTracker(String name) {
    return '确定删除 $name？';
  }

  @override
  String get reannounceSelected => '强制重新宣告选中的 Tracker';

  @override
  String get reannounceAll => '强制重新宣告全部 Tracker';

  @override
  String get reannouncedAll => '已重新宣告全部 Tracker';

  @override
  String get reannouncedOne => '已重新宣告该 Tracker';

  @override
  String reannounceFailedOne(String error) {
    return '重新宣告失败：$error';
  }

  @override
  String get addedTracker => '已添加 Tracker';

  @override
  String get enterTrackers => '请输入至少一个 Tracker';

  @override
  String get enterTrackerUrl => '请输入 Tracker URL';

  @override
  String get trackerUrl => 'Tracker URL';

  @override
  String get tierRange => '层级必须是 0–255';

  @override
  String get enterTier => '请输入层级';

  @override
  String get trackerNotFound => 'Tracker 不存在';

  @override
  String get trackerUrlTaken => 'Tracker 不存在或新 URL 已被占用';

  @override
  String get invalidTracker => '无效的 Tracker';

  @override
  String get trackerListHint => '要添加的 Tracker 列表（每行一个）';

  @override
  String get noPeers => '暂无用户';

  @override
  String get noPeersHint => '当前没有连上的 Peer';

  @override
  String get startRefresh => '开始刷新';

  @override
  String get pauseRefresh => '暂停刷新';

  @override
  String get flagsHelp => '标志说明';

  @override
  String get copiedEndpoint => '已复制 IP 端口';

  @override
  String get banPeerTitle => '永久禁止用户';

  @override
  String banPeerMessage(String endpoint) {
    return '确定永久禁止 $endpoint？该用户将无法再连接。';
  }

  @override
  String get ban => '禁止';

  @override
  String get peerBanned => '已禁止该用户';

  @override
  String banFailed(String error) {
    return '禁止失败：$error';
  }

  @override
  String get addPeers => '添加对等节点';

  @override
  String get copyEndpoint => '复制IP端口';

  @override
  String get banPeer => '永久禁止用户';

  @override
  String get addedPeers => '已添加对等节点';

  @override
  String get peerListHint => '要添加的用户列表（每行一个 IP）';

  @override
  String get peerFormatHint => '格式：IPV4:端口/IPV6:端口';

  @override
  String get enterPeers => '请输入至少一个对等节点';

  @override
  String get noValidPeers => '没有有效的对等节点';

  @override
  String get invalidPeer => '无效的对等节点';

  @override
  String get noFiles => '暂无文件';

  @override
  String get noFilesHint => '还没有元数据，或种子里没有文件';

  @override
  String priorityFailed(String error) {
    return '设置优先级失败：$error';
  }

  @override
  String get priorityInvalid => '优先级无效';

  @override
  String get metadataNotReady => '元数据未就绪，或文件不存在';

  @override
  String get enterNewName => '请输入新名称';

  @override
  String get nameTaken => '名称无效或已被占用';

  @override
  String get nameNoPathSeparator => '名称不能包含路径分隔符';

  @override
  String get folderName => '文件夹名称';

  @override
  String get fileName => '文件名称';

  @override
  String get renameFolderHint => '修改的是服务器上这个文件夹的名称，其中的文件路径会一起变更。';

  @override
  String get renameFileHint => '修改的是服务器上这个文件的名称，磁盘路径会一起变更。';

  @override
  String get priorityDoNotDownload => '不下载';

  @override
  String get priorityHigh => '较高';

  @override
  String get priorityMaximum => '最高';

  @override
  String get priorityMixed => '混合';

  @override
  String get priorityNormal => '正常';

  @override
  String get trackerUpdating => '正在更新...';

  @override
  String get trackerDisabled => '已禁用';

  @override
  String get trackerNotContacted => '尚未联系';

  @override
  String get trackerWorking => '工作';

  @override
  String get trackerNotWorking => '未工作';

  @override
  String get trackerError => 'Tracker 错误';

  @override
  String get trackerUnreachable => '无法访问';

  @override
  String get peerFlagD => '本端想下且未被阻塞';

  @override
  String get peerFlagd => '本端想下但对端阻塞';

  @override
  String get peerFlagU => '对端想下且未被阻塞';

  @override
  String get peerFlagu => '对端想下但本端阻塞';

  @override
  String get peerFlagK => '本端不想下，对端未阻塞';

  @override
  String get peerFlagQuestion => '对端不想下，本端未阻塞';

  @override
  String get peerFlagO => '乐观解除阻塞';

  @override
  String get peerFlagS => '对方被冷落';

  @override
  String get peerFlagI => '传入连接';

  @override
  String get peerFlagH => '来自 DHT';

  @override
  String get peerFlagX => '来自 PEX';

  @override
  String get peerFlagL => '来自 LSD';

  @override
  String get peerFlagE => '加密传输';

  @override
  String get peerFlage => '加密握手';

  @override
  String get peerFlagP => 'μTP';

  @override
  String get peerFlagh => 'NAT 打洞';

  @override
  String get optional => '可选';

  @override
  String get unavailable => '暂不可用';

  @override
  String get notEnabled => '未启用';

  @override
  String get adding => '添加中…';

  @override
  String get saved => '已保存';

  @override
  String get saving => '保存中…';

  @override
  String saveFailed(String error) {
    return '保存失败：$error';
  }

  @override
  String addFailed(String error) {
    return '添加失败：$error';
  }

  @override
  String get loadSettingsFailed => '加载设置失败';

  @override
  String get actionClear => '清除';

  @override
  String get actionImport => '导入';

  @override
  String get actionInstall => '安装';

  @override
  String get actionSearch => '搜索';

  @override
  String get addTorrentSettings => '种子设置';

  @override
  String get noTags => '暂无标签';

  @override
  String get contentLayout => '内容布局';

  @override
  String get stopCondition => '停止条件';

  @override
  String get startTorrent => '开始 Torrent';

  @override
  String get addToTopOfQueue => '添加到队列顶部';

  @override
  String get skipHashCheck => '跳过哈希校验';

  @override
  String get limitDownloadRate => '限制下载速率';

  @override
  String get limitUploadRate => '限制上传速率';

  @override
  String get saveTo => '保存在';

  @override
  String get torrentManagementMode => '种子管理模式';

  @override
  String get saveFilesTo => '保存文件到';

  @override
  String get autoTmmDecides => '由自动管理决定';

  @override
  String get incompleteTorrentPath => '对不完整的种子使用另一个路径';

  @override
  String get incompleteSavePath => '不完整种子保存路径';

  @override
  String get importMagnet => '从磁力链接导入';

  @override
  String get importFile => '从文件导入';

  @override
  String get tapToChangeLink => '点击更换链接';

  @override
  String get enterMagnetOrHttp => '输入磁力链接或 HTTP(S) 地址';

  @override
  String get tapToChangeFile => '点击更换文件';

  @override
  String get selectTorrentFile => '选择 .torrent 文件';

  @override
  String get magnetOrUrl => '磁力链接或 URL';

  @override
  String get enterMagnetOrUrl => '请输入磁力链接或 HTTP(S) 地址';

  @override
  String get importOneTorrentOnly => '一次只能导入一个种子';

  @override
  String get torrentInfo => '种子信息';

  @override
  String get date => '日期';

  @override
  String get fetchingMetadata => '正在获取元数据…';

  @override
  String get metadataFailed => '获取元数据失败';

  @override
  String metadataFailedWithError(String error) {
    return '获取元数据失败：$error';
  }

  @override
  String get filesAfterImport => '导入种子后显示文件列表';

  @override
  String get cannotReadTorrentFile => '无法读取种子文件';

  @override
  String get cannotReadSelectedFile => '无法读取所选文件';

  @override
  String get importTorrentFirst => '请先导入种子';

  @override
  String get fetchingMetadataWait => '正在获取元数据，请稍候';

  @override
  String get cannotAdd => '无法添加';

  @override
  String get searchTorrents => '搜索种子';

  @override
  String get searchPlugins => '搜索插件';

  @override
  String get filterResults => '筛选结果';

  @override
  String get stopSearch => '停止搜索';

  @override
  String get searchKeyword => '搜索关键词';

  @override
  String get searchStarting => '启动中…';

  @override
  String get collapse => '收起';

  @override
  String get expandSearchForm => '展开搜索条件';

  @override
  String get searchCriteria => '搜索条件';

  @override
  String get filterResultName => '筛选结果名称…';

  @override
  String get enabledPlugins => '已启用插件';

  @override
  String get allPlugins => '全部插件';

  @override
  String get plugin => '插件';

  @override
  String searchingFound(int total) {
    return '搜索中 · 已找到 $total 条';
  }

  @override
  String searchingFoundVisible(int total, int visible) {
    return '搜索中 · 已找到 $total 条（显示 $visible 条）';
  }

  @override
  String get pythonRequired => '服务器未安装 Python，无法使用搜索功能';

  @override
  String get searchLimitReached => '进行中的搜索已达上限（最多 5 个）';

  @override
  String get startSearchFailed => '开始搜索失败';

  @override
  String get loadPluginsFailed => '加载搜索插件失败';

  @override
  String get noSearchPlugins => '未安装搜索插件';

  @override
  String get noSearchPluginsHint => '请在 qBittorrent Web 端安装并启用搜索插件';

  @override
  String get searchIdleHint => '输入关键词并选择分类 / 插件后开始搜索';

  @override
  String get searching => '搜索中';

  @override
  String get searchingHint => '正在从插件获取结果…';

  @override
  String get noMatchingResults => '无匹配结果';

  @override
  String get noResults => '未找到结果';

  @override
  String get adjustFiltersHint => '试试调整筛选条件';

  @override
  String get retrySearchHint => '可更换关键词或插件重试';

  @override
  String get allCategories => '全部分类';

  @override
  String get searchCategoryAnime => '动画';

  @override
  String get searchCategoryBooks => '书籍';

  @override
  String get searchCategoryGames => '游戏';

  @override
  String get searchCategoryMovies => '电影';

  @override
  String get searchCategoryMusic => '音乐';

  @override
  String get searchCategoryPictures => '图片';

  @override
  String get searchCategorySoftware => '软件';

  @override
  String get searchCategoryTv => '电视节目';

  @override
  String get searchJobNotFound => '搜索任务不存在';

  @override
  String get searchResultsUnavailable => '搜索结果已不可用';

  @override
  String seedingCount(String count) {
    return '做种 $count';
  }

  @override
  String leechingCount(String count) {
    return '下载 $count';
  }

  @override
  String get unknownSize => '未知大小';

  @override
  String get cannotOpenDescription => '无法打开描述页';

  @override
  String get copiedName => '已复制名称';

  @override
  String get copiedDownloadLink => '已复制下载链接';

  @override
  String get copiedDescriptionUrl => '已复制描述页 URL';

  @override
  String get openDescription => '打开描述页';

  @override
  String get copyName => '复制名称';

  @override
  String get copyDownloadLink => '复制下载链接';

  @override
  String get copyDescriptionUrl => '复制描述页 URL';

  @override
  String get resultFilter => '结果筛选';

  @override
  String get resultFilterHint => '对齐 Web 端：0 表示不限制。大小单位按 1024 进制换算。';

  @override
  String get seeders => '做种数';

  @override
  String get minValue => '最小';

  @override
  String get maxValue => '最大';

  @override
  String get rangeTo => '至';

  @override
  String pluginVersion(String version) {
    return '版本 $version';
  }

  @override
  String get deletePlugin => '删除插件';

  @override
  String get installPlugin => '安装插件';

  @override
  String get checkingUpdates => '检查中…';

  @override
  String get checkUpdates => '检查更新';

  @override
  String get searchPluginCopyrightWarning =>
      '警告：在下载来自这些搜索引擎的 torrent 时，请确认它符合您所在国家的版权法。';

  @override
  String get searchPluginGetMore => '你可以在这里获取新的搜索引擎插件：';

  @override
  String get noSearchPluginsList => '暂无搜索插件';

  @override
  String get noSearchPluginsListHint => '点击「安装插件」或「检查更新」获取官方插件';

  @override
  String get cannotOpenLink => '无法打开链接';

  @override
  String get installing => '安装中…';

  @override
  String get pluginInstalled => '插件已安装';

  @override
  String installFailed(String error) {
    return '安装失败：$error';
  }

  @override
  String get pluginsUpdated => '插件列表已更新';

  @override
  String checkUpdatesFailed(String error) {
    return '检查更新失败：$error';
  }

  @override
  String operationFailed(String error) {
    return '操作失败：$error';
  }

  @override
  String confirmUninstallPlugin(String name) {
    return '确定卸载 $name？';
  }

  @override
  String get pluginDeleted => '插件已删除';

  @override
  String get enterPluginSource => '请输入插件 URL 或路径';

  @override
  String get installSearchPlugin => '安装搜索插件';

  @override
  String get installPluginHint => '输入插件 .py 的 URL，或 qB 服务器上的文件路径。多个来源可用换行分隔。';

  @override
  String get pluginSource => '插件来源';

  @override
  String get actionEdit => '编辑';

  @override
  String get actionReset => '重置';

  @override
  String get actionGenerate => '生成';

  @override
  String get actionSend => '发送';

  @override
  String get validating => '校验中…';

  @override
  String get listSeparator => '、';

  @override
  String pleaseFillFields(String fields) {
    return '请填写：$fields';
  }

  @override
  String get serverNotFound => '服务器不存在或已删除';

  @override
  String get cannotGetApiVersion => '无法获取 API 版本';

  @override
  String probeFailed(String error) {
    return '校验失败：$error';
  }

  @override
  String get saveFailedServerGone => '保存失败：服务器不存在或已删除';

  @override
  String get unitSeconds => '秒';

  @override
  String get unitMilliseconds => '毫秒';

  @override
  String get unlimitedHint => '0 为无限制';

  @override
  String get qbSetBehavior => '行为';

  @override
  String get qbSetDownloads => '下载';

  @override
  String get qbSetConnection => '连接';

  @override
  String get qbSetSpeed => '速度';

  @override
  String get qbSetAdvanced => '高级';

  @override
  String get qbSetDisclaimer =>
      '此处修改的是当前 qBittorrent 服务器的选项。部分设置仅作用于服务器或 WebUI，不会影响本 App 的界面与行为。';

  @override
  String get currentServerSettings => '当前服务器设置';

  @override
  String get addServer => '添加服务器';

  @override
  String get editServer => '编辑服务器';

  @override
  String get serverListHint => '点击切换服务器，点击右上角可以修改服务器设置';

  @override
  String get noServersHint => '点击右下角添加一台 qBittorrent 服务器';

  @override
  String get deleteServer => '删除服务器';

  @override
  String confirmDeleteServer(String name) {
    return '确定删除「$name」吗？此操作不可恢复。';
  }

  @override
  String get serverName => '服务器名称';

  @override
  String get serverNameHint => '服务器名称，例如：我的NAS';

  @override
  String get host => '域名或IP';

  @override
  String get hostHint => '域名或IP，例如：my.nas.com, 192.168.1.1';

  @override
  String get port => '端口';

  @override
  String get portHint => '端口，例如：8888';

  @override
  String get pathHint => '路径，不包含“/”符号，例如：nas/qb';

  @override
  String get apiKey => 'API密钥';

  @override
  String get apiKeyHint => 'API密钥，请在WebUI上生成密钥';

  @override
  String get useHttps => '使用HTTPS';

  @override
  String get schedulerEveryDay => '每天';

  @override
  String get schedulerWeekdays => '工作日';

  @override
  String get schedulerWeekends => '周末';

  @override
  String get schedulerMonday => '周一';

  @override
  String get schedulerTuesday => '周二';

  @override
  String get schedulerWednesday => '周三';

  @override
  String get schedulerThursday => '周四';

  @override
  String get schedulerFriday => '周五';

  @override
  String get schedulerSaturday => '周六';

  @override
  String get schedulerSunday => '周日';

  @override
  String get peerProtocolTcpAndUtp => 'TCP 和 μTP';

  @override
  String get proxyTypeNone => '(无)';

  @override
  String get btEncryptAllow => '允许加密';

  @override
  String get btEncryptRequire => '强制加密';

  @override
  String get btEncryptDisable => '禁用加密';

  @override
  String get btRatioStop => '停止 torrent';

  @override
  String get btRatioRemove => '删除 torrent';

  @override
  String get btRatioRemoveAndFiles => '删除 torrent 及所属文件';

  @override
  String get btRatioSuperSeeding => '为 torrent 启用超级做种';

  @override
  String get logAgeDays => '天';

  @override
  String get logAgeMonths => '月';

  @override
  String get logAgeYears => '年';

  @override
  String get tmmRelocateTorrent => '重新定位 Torrent';

  @override
  String get tmmRelocateAffected => '重新定位受影响的 Torrent';

  @override
  String get tmmSwitchTorrentManual => '切换 Torrent 到手动模式';

  @override
  String get tmmSwitchAffectedManual => '切换受影响的 torrent 至手动模式';

  @override
  String get resumeFastresume => 'Fastresume 文件';

  @override
  String get resumeSqlite => 'SQLite 数据库（实验性）';

  @override
  String get removeDeleteFiles => '永久删除文件';

  @override
  String get removeMoveToTrash => '移到回收站（如可能）';

  @override
  String get diskIoMemoryMapped => '内存映射文件';

  @override
  String get diskIoPosix => 'POSIX 兼容';

  @override
  String get diskIoSimplePread => '简单 pread/pwrite';

  @override
  String get osCacheDisable => '禁用 OS 缓存';

  @override
  String get osCacheEnable => '启用 OS 缓存';

  @override
  String get osCacheWriteThrough => '直写';

  @override
  String get utpPreferTcp => '首选 TCP';

  @override
  String get utpPeerProportional => '与 peer 成比例（限制 TCP）';

  @override
  String get uploadSlotsFixed => '固定槽位';

  @override
  String get uploadSlotsRateBased => '基于上传速率';

  @override
  String get chokeRoundRobin => '轮询';

  @override
  String get chokeFastestUpload => '最快上传';

  @override
  String get chokeAntiLeech => '反吸血';

  @override
  String get bindAllAddresses => '所有地址';

  @override
  String get bindAllIpv4 => '所有 IPv4 地址';

  @override
  String get bindAllIpv6 => '所有 IPv6 地址';

  @override
  String get anyInterface => '任意接口';

  @override
  String get qbWebUiLanguage => '用户界面语言';

  @override
  String get transferList => '传输列表';

  @override
  String get confirmTorrentDeletion => '删除 Torrent 时提示确认';

  @override
  String get showExternalIp => '在状态栏展示外部 IP';

  @override
  String get logFile => '日志文件';

  @override
  String get enableLogFile => '启用日志文件';

  @override
  String get backupLogWhenLarger => '当大于指定大小时备份日志文件';

  @override
  String get deleteOldBackupLogs => '删除早于指定时间的备份日志文件';

  @override
  String get logAge => '时间';

  @override
  String get logPerformanceWarning => '记录性能警报';

  @override
  String get invalidLogBackupSize => '请填写有效的日志备份大小';

  @override
  String get invalidLogRetention => '请填写有效的日志保留时间';

  @override
  String get scheduleAltSpeed => '计划备用速度限制的启用时间';

  @override
  String get scheduleFrom => '从';

  @override
  String get scheduleTo => '到';

  @override
  String get scheduleWhen => '时间';

  @override
  String get rateLimitOptions => '设置速度限制';

  @override
  String get limitUtpRate => '对 µTP 协议进行速度限制';

  @override
  String get limitOverhead => '对传送总开销进行速度限制';

  @override
  String get limitLanPeers => '对本地网络用户进行速度限制';

  @override
  String get invalidSpeedLimit => '速度限制必须大于等于 0（0 为无限制）';

  @override
  String get peerConnectionProtocol => '对等节点连接协议';

  @override
  String get listeningPort => '监听端口';

  @override
  String get incomingConnectionsPort => '用于传入连接的端口';

  @override
  String get actionRandom => '随机';

  @override
  String get upnpPortForward => '使用我的路由器的 UPnP / NAT-PMP 端口转发';

  @override
  String get connectionLimits => '连接限制';

  @override
  String get maxConnectionsGlobal => '全局最大连接数';

  @override
  String get maxConnectionsPerTorrent => '每 torrent 最大连接数';

  @override
  String get maxUploadsGlobal => '全局上传窗口数上限';

  @override
  String get maxUploadsPerTorrent => '每个 torrent 上传窗口数上限';

  @override
  String get i2pExperimental => 'I2P（实验性）';

  @override
  String get mixedMode => '混合模式';

  @override
  String get proxyServer => '代理服务器';

  @override
  String get proxyType => '类型';

  @override
  String get proxyHostnameLookup => '通过代理查找主机名';

  @override
  String get authentication => '验证';

  @override
  String get username => '用户名';

  @override
  String get password => '密码';

  @override
  String get passwordStoredUnencrypted => '注意：密码以非加密形式保存';

  @override
  String get proxyForBittorrent => '对 BitTorrent 目的使用代理';

  @override
  String get proxyForPeerConnections => '使用代理服务器进行用户连接';

  @override
  String get proxyForRss => '对 RSS 目的使用代理';

  @override
  String get proxyForGeneral => '对常规目的使用代理';

  @override
  String get ipFiltering => 'IP 过滤';

  @override
  String get ipFilterPath => '过滤规则路径 (.dat, .p2p, .p2b)';

  @override
  String get filterTrackers => '匹配 tracker';

  @override
  String get manuallyBannedIps => '手动屏蔽 IP 地址';

  @override
  String get oneIpPerLine => '每行一个 IP';

  @override
  String get invalidListenPort => '用于传入连接的端口必须在 0 到 65535 之间';

  @override
  String get invalidMaxConnections => '全局最大连接数必须大于 0 或关闭';

  @override
  String get invalidMaxConnectionsPerTorrent => '每 torrent 最大连接数必须大于 0 或关闭';

  @override
  String get invalidMaxUploads => '全局上传窗口数上限必须大于 0 或关闭';

  @override
  String get invalidMaxUploadsPerTorrent => '每个 torrent 上传窗口数上限必须大于 0 或关闭';

  @override
  String get invalidProxyPort => '代理端口必须在 0 到 65535 之间';

  @override
  String get invalidI2pPort => 'I2P 端口必须在 0 到 65535 之间';

  @override
  String get privacy => '隐私';

  @override
  String get enableDht => '启用 DHT (去中心化网络) 以找到更多用户';

  @override
  String get enablePex => '启用用户交换 (PeX) 以找到更多用户';

  @override
  String get enableLsd => '启用本地用户发现以找到更多用户';

  @override
  String get encryptionMode => '加密模式';

  @override
  String get anonymousMode => '启用匿名模式';

  @override
  String get maxActiveCheckingTorrents => '最大活跃检查 Torrent 数';

  @override
  String get maxActiveDownloads => '最大活动的下载数';

  @override
  String get maxActiveUploads => '最大活动的上传数';

  @override
  String get maxActiveTorrents => '最大活动的 torrent 数';

  @override
  String get ignoreSlowTorrents => '慢速 torrent 不计入限制内';

  @override
  String get downloadRateThreshold => '下载速度阈值';

  @override
  String get uploadRateThreshold => '上传速度阈值';

  @override
  String get torrentInactivityTimer => 'Torrent 非活动计时器';

  @override
  String get seedingLimits => '做种限制';

  @override
  String get whenRatioReaches => '当分享率达到';

  @override
  String get whenSeedingTimeReaches => '达到总做种时间时';

  @override
  String get whenInactiveSeedingTimeReaches => '达到不活跃做种时间时';

  @override
  String get then => '然后';

  @override
  String get autoAddTrackers => '自动附加这些 tracker 到新下载';

  @override
  String get oneTrackerPerLine => '每行一个 tracker';

  @override
  String get autoAddTrackersFromUrl => '自动添加 URL 中的 trackers 到新的下载';

  @override
  String get url => '网址';

  @override
  String get fetchedTrackers => '获取 tracker';

  @override
  String get invalidMaxActiveChecking => '最大活跃检查 Torrent 数必须大于 -1';

  @override
  String get invalidMaxActiveDownloads => '最大活动的下载数必须大于 -1';

  @override
  String get invalidMaxActiveUploads => '最大活动的上传数必须大于 -1';

  @override
  String get invalidMaxActiveTorrents => '最大活动的 torrent 数必须大于 -1';

  @override
  String get invalidDownloadRateThreshold => '下载速度阈值必须大于 0';

  @override
  String get invalidUploadRateThreshold => '上传速度阈值必须大于 0';

  @override
  String get invalidTorrentInactivityTimer => 'Torrent 非活动计时器必须大于 0';

  @override
  String get invalidShareRatio => '分享率限制不能为负数';

  @override
  String get invalidSeedingTime => '做种时间限制不能为负数';

  @override
  String get invalidInactiveSeedingTime => '不活跃做种时间限制不能为负数';

  @override
  String get whenAddingTorrent => '添加 torrent 时';

  @override
  String get doNotStartDownload => '不要自动开始下载';

  @override
  String get whenDuplicateTorrent => '添加重复种子时';

  @override
  String get mergeTrackers => '合并 tracker 到现有 torrent';

  @override
  String get deleteTorrentFileWhenDone => '完成后删除 .torrent 文件';

  @override
  String get preallocateAll => '为所有文件预分配磁盘空间';

  @override
  String get appendIncompleteExt => '为不完整的文件添加扩展名 .!qB';

  @override
  String get keepUnwantedInFolder => '将未选中的文件保留在 \".unwanted\" 文件夹中';

  @override
  String get saveManagement => '保存管理';

  @override
  String get defaultTmmMode => '默认 Torrent 管理模式';

  @override
  String get whenTorrentCategoryChanged => '当 Torrent 分类修改时';

  @override
  String get whenDefaultSavePathChanged => '当默认保存路径修改时';

  @override
  String get whenCategorySavePathChanged => '当分类保存路径修改时';

  @override
  String get useCategoryPathsInManualMode => '在手动模式下使用分类路径';

  @override
  String get defaultSavePath => '默认保存路径';

  @override
  String get saveIncompleteTorrentsTo => '保存未完成的 torrent 到';

  @override
  String get copyTorrentFilesTo => '复制 .torrent 文件到';

  @override
  String get copyFinishedTorrentFilesTo => '复制下载完成的 .torrent 文件到';

  @override
  String get excludedFileNames => '排除的文件名';

  @override
  String get oneRulePerLine => '每行一个规则';

  @override
  String get emailOnTorrentCompletion => '下载完成时发送电子邮件通知';

  @override
  String get mailSender => '发件人';

  @override
  String get mailRecipient => '收件人';

  @override
  String get smtpServer => 'SMTP 服务器';

  @override
  String get smtpRequiresSsl => '该服务器需要安全链接（SSL）';

  @override
  String get sendTestEmail => '发送测试邮件';

  @override
  String get sending => '发送中…';

  @override
  String sendFailed(String error) {
    return '发送失败：$error';
  }

  @override
  String get testEmailSent => '测试邮件已发送';

  @override
  String get confirmSendTestEmailTitle => '发送测试邮件';

  @override
  String get confirmSendTestEmail =>
      '测试邮件会使用服务器已保存的邮件设置发送。继续前将先保存当前本页设置（含邮件相关项），确定继续吗？';

  @override
  String get runExternalProgram => '运行外部程序';

  @override
  String get runOnTorrentAdded => '新增 Torrent 时运行';

  @override
  String get runOnTorrentFinished => 'torrent 完成时运行';

  @override
  String get autorunExampleHint => '例如：\"%N\"';

  @override
  String get autorunParametersHint =>
      '支持的参数（区分大小写）：\n%N：Torrent 名称，%L：分类，%G：标签（以逗号分隔），%F：内容路径，%R：根目录，%D：保存路径，%C：文件数，%Z：Torrent 大小（字节），%T：Tracker，%I/%J：Info hash，%K：ID，%M：备注\n提示：使用引号将参数扩起以防止文本被空白符分割（例如：\"%N\"）';

  @override
  String get torrentContentLayout => 'Torrent 内容布局';

  @override
  String get torrentStopCondition => 'Torrent 停止条件';

  @override
  String get enableMailNotificationFirst => '请先启用邮件通知';

  @override
  String get enterDefaultSavePath => '请填写默认保存路径';

  @override
  String get webUiRemoteControl => 'Web 用户界面（远程控制）';

  @override
  String get ipAddress => 'IP 地址';

  @override
  String get useHttpsInsteadOfHttp => '使用 HTTPS 而不是 HTTP';

  @override
  String get certificate => '证书';

  @override
  String get privateKey => '密钥';

  @override
  String get bypassAuthLocalhost => '对本地主机上的客户端跳过身份验证';

  @override
  String get bypassAuthWhitelist => '对 IP 子网白名单中的客户端跳过身份验证';

  @override
  String get subnetWhitelistHint => '例如 192.168.1.0/24';

  @override
  String get banAfterFailedAttempts => '连续失败后禁止客户端';

  @override
  String get banFor => '禁止';

  @override
  String get sessionTimeout => '会话超时';

  @override
  String get passwordLeaveBlank => '留空表示不修改';

  @override
  String get copiedApiKey => '已复制 API 密钥';

  @override
  String get resetApiKey => '重置 API key';

  @override
  String get generateApiKey => '生成 API 密钥';

  @override
  String get confirmResetApiKey =>
      '重置该 API key 吗？当前 key 会立即停止工作，会生成新 key。本 App 会自动更新本地保存的密钥。';

  @override
  String get confirmGenerateApiKey =>
      '生成 API key 吗？这枚 key 可用于和 qBittorrent 的 API 互动。本 App 会自动保存到本地服务器配置。';

  @override
  String get resetting => '重置中…';

  @override
  String get generating => '生成中…';

  @override
  String get apiKeyReset => '已重置 API key';

  @override
  String get apiKeyGenerated => '已生成 API 密钥';

  @override
  String get deleteApiKey => '删除 API 密钥';

  @override
  String get confirmDeleteApiKey =>
      '删除此 API key 吗？当前 key 会立即停止工作。本 App 将无法继续连接，请随后在服务器设置中重新配置密钥。';

  @override
  String get apiKeyDeleted => '已删除 API 密钥';

  @override
  String get useAlternativeWebUi => '使用备选 WebUI';

  @override
  String get filePath => '文件路径';

  @override
  String get security => '安全';

  @override
  String get clickjackingProtection => '启用“点击劫持”保护';

  @override
  String get csrfProtection => '启用跨站请求伪造 (CSRF) 保护';

  @override
  String get secureCookie => '启用 cookie Secure 标志（需要 HTTPS 或本机连接）';

  @override
  String get hostHeaderValidation => '启用 Host 标头验证';

  @override
  String get serverDomains => '服务器域名';

  @override
  String get customHttpHeaders => '启用自定义 HTTP 头';

  @override
  String get oneHeaderPerLine => '每行一个 Header';

  @override
  String get reverseProxySupport => '启用反向代理支持';

  @override
  String get trustedProxiesList => '受信任的代理列表';

  @override
  String get onePerLine => '每行一个';

  @override
  String get updateDynDns => '更新我的动态域名';

  @override
  String get dynDnsService => '服务';

  @override
  String get domain => '域名';

  @override
  String get webUiWarning =>
      '此处修改的是服务器 WebUI 自身配置。错误地更改地址、端口、HTTPS、认证或安全选项可能导致本 App 无法再连接该服务器，请谨慎操作并确保仍有其他方式访问 qBittorrent。';

  @override
  String get confirmSaveWebUiTitle => '确认保存 WebUI 设置';

  @override
  String get confirmSaveWebUi =>
      '修改地址、端口、HTTPS、用户名密码或安全选项后，本 App 可能暂时无法连接服务器。请确认你仍能通过其他方式访问 qBittorrent。确定继续保存吗？';

  @override
  String get cannotResetApiKey => '无法重置 API key';

  @override
  String get cannotDeleteApiKey => '无法删除 API 密钥。';

  @override
  String get httpsCertPathRequired => 'HTTPS 证书路径不能为空';

  @override
  String get httpsKeyPathRequired => 'HTTPS 密钥路径不能为空';

  @override
  String get webUiUsernameMinLength => 'WebUI 用户名至少需要 3 个字符';

  @override
  String get webUiUsernameNoColon => 'WebUI 用户名不能包含冒号';

  @override
  String get webUiPasswordMinLength => 'WebUI 密码至少需要 6 个字符';

  @override
  String get altWebUiPathRequired => '备选 WebUI 文件路径不能为空';

  @override
  String get webUiPortRange => 'WebUI 端口必须在 1 到 65535 之间';

  @override
  String get resumeDataStorage => '恢复数据存储类型（需重启）';

  @override
  String get torrentContentRemoveOption => '删除种子内容方式';

  @override
  String get physicalMemoryLimit => '物理内存 (RAM) 使用上限';

  @override
  String get networkInterface => '网络接口';

  @override
  String get optionalBindAddress => '可选绑定 IP 地址';

  @override
  String get saveResumeDataInterval => '保存恢复数据间隔';

  @override
  String get saveStatisticsInterval => '保存统计信息间隔';

  @override
  String get torrentFileSizeLimit => '.torrent 文件大小限制';

  @override
  String get confirmTorrentRecheck => '确认重新检查种子';

  @override
  String get recheckCompletedTorrents => '完成时重新检查种子';

  @override
  String get appInstanceName => '自定义应用程序实例名称';

  @override
  String get refreshInterval => '刷新间隔';

  @override
  String get resolvePeerHostnames => '解析 peer 主机名';

  @override
  String get resolvePeerCountries => '解析 peer 国家/地区';

  @override
  String get enableEmbeddedTracker => '启用嵌入式 tracker';

  @override
  String get embeddedTrackerPort => '嵌入式 tracker 端口';

  @override
  String get embeddedTrackerPortForwarding => '为嵌入式 tracker 启用端口转发';

  @override
  String get enableMotw => '为下载的文件启用 Mark-of-the-Web（需 macOS 或 Windows）';

  @override
  String get ignoreSslErrors => '忽略 SSL 错误';

  @override
  String get asyncIoThreads => '异步 I/O 线程数';

  @override
  String get hashingThreads => '哈希线程数';

  @override
  String get filePoolSize => '文件池大小';

  @override
  String get outstandingMemoryWhenChecking => '检查种子时的未决内存';

  @override
  String get diskCache => '磁盘缓存';

  @override
  String get diskCacheTtl => '磁盘缓存过期间隔';

  @override
  String get diskQueueSize => '磁盘队列大小';

  @override
  String get diskIoType => '磁盘 IO 类型（需重启）';

  @override
  String get diskIoReadMode => '磁盘 IO 读取模式';

  @override
  String get diskIoWriteMode => '磁盘 IO 写入模式';

  @override
  String get coalesceReadsWrites => '合并读写';

  @override
  String get pieceExtentAffinity => '使用分块范围亲和性';

  @override
  String get sendUploadPieceSuggestions => '发送上传分块建议';

  @override
  String get sendBufferWatermark => '发送缓冲区水位线';

  @override
  String get sendBufferLowWatermark => '发送缓冲区低水位线';

  @override
  String get sendBufferWatermarkFactor => '发送缓冲区水位线系数';

  @override
  String get outgoingConnectionsPerSecond => '每秒传出连接数';

  @override
  String get allowOutgoingWhenSeeding => '做种时允许传出连接';

  @override
  String get socketSendBufferSize => '套接字发送缓冲区大小（0：系统默认）';

  @override
  String get socketReceiveBufferSize => '套接字接收缓冲区大小（0：系统默认）';

  @override
  String get socketBacklogSize => '套接字 backlog 大小';

  @override
  String get outgoingPortsMin => '传出端口（最小，0：禁用）';

  @override
  String get outgoingPortsMax => '传出端口（最大，0：禁用）';

  @override
  String get peerTos => '连接 peer 的 DSCP';

  @override
  String get resolverCacheTtl => '内部主机名解析器缓存过期间隔';

  @override
  String get idnSupport => '支持国际化域名 (IDN)';

  @override
  String get allowMultipleConnectionsFromSameIp => '允许来自同一 IP 地址的多个连接';

  @override
  String get validateHttpsTrackerCert => '验证 HTTPS tracker 证书';

  @override
  String get ssrfMitigation => '服务端请求伪造 (SSRF) 缓解';

  @override
  String get blockPeersOnPrivilegedPorts => '禁止连接到特权端口上的 peer';

  @override
  String get uploadSlotsBehavior => '上传槽行为';

  @override
  String get uploadChokingAlgorithm => '上传阻塞算法';

  @override
  String get announceToAllTrackers => '始终向层级内所有 tracker 宣布';

  @override
  String get announceToAllTiers => '始终向 tier 内所有 tracker 宣布';

  @override
  String get announceIp => '向 tracker 报告的 IP（需重启）';

  @override
  String get announcePort => '向 tracker 报告的端口（需重启，0：监听端口）';

  @override
  String get maxConcurrentHttpAnnounces => '最大并发 HTTP announce 数';

  @override
  String get stopTrackerTimeout => '停止 tracker 超时（0：禁用）';

  @override
  String get peerTurnover => 'Peer 轮换断开百分比';

  @override
  String get peerTurnoverCutoff => 'Peer 轮换阈值百分比';

  @override
  String get peerTurnoverInterval => 'Peer 轮换断开间隔';

  @override
  String get requestQueueSize => '对单个 peer 的最大未完成请求数';

  @override
  String get maxOutstandingPieceRequests => '来自 peer 的最大未完成块请求数';

  @override
  String get dhtBootstrapNodes => 'DHT 引导节点';

  @override
  String get i2pInboundQuantity => 'I2P 入站数量';

  @override
  String get i2pOutboundQuantity => 'I2P 出站数量';

  @override
  String get i2pInboundLength => 'I2P 入站长度';

  @override
  String get i2pOutboundLength => 'I2P 出站长度';

  @override
  String get i2pTunnel => 'I2P 隧道';

  @override
  String get upnpLeaseDuration => 'UPnP 租约时长（0：永久）';

  @override
  String get reannounceWhenAddressChanges => 'IP 或端口变化时向所有 tracker 重新 announce';

  @override
  String get pythonExecutablePath => 'Python 可执行文件路径（可能需要重启）';

  @override
  String get bdecodeTokenLimit => 'Bdecode 令牌限制';

  @override
  String get bdecodeDepthLimit => 'Bdecode 深度限制';

  @override
  String get utpTcpMixedMode => 'μTP-TCP 混合模式算法';

  @override
  String get allowMultipleConnectionsFromSamePeerId => '允许来自同一 Peer ID 的多个连接';

  @override
  String get invalidCheckingMemory => '检查种子时的未决内存必须大于 0 且小于 1024 MiB';

  @override
  String get invalidPeerDscp => 'Peer DSCP 必须在 0 到 255 之间';

  @override
  String get invalidAnnouncePort => '向 tracker 报告的端口必须在 0 到 65535 之间';

  @override
  String get invalidPeerTurnover => 'Peer 轮换断开百分比必须在 0 到 100 之间';

  @override
  String get invalidPeerTurnoverCutoff => 'Peer 轮换阈值百分比必须在 0 到 100 之间';

  @override
  String get invalidPeerTurnoverInterval => 'Peer 轮换断开间隔必须大于等于 0';

  @override
  String get pythonPathNoQuotes => 'Python 可执行文件路径首尾不能包含引号';

  @override
  String get searchLogsHint => '搜索日志…';

  @override
  String get closeSearch => '关闭搜索';

  @override
  String get logTabBannedIp => '封禁 IP';

  @override
  String get noLogs => '暂无日志';

  @override
  String get noLogsHint => '服务器尚未产生日志记录';

  @override
  String get noMatchingLogs => '无匹配日志';

  @override
  String get adjustFiltersOrSearchHint => '试试调整筛选或搜索关键词';

  @override
  String get noBanRecords => '暂无封禁记录';

  @override
  String get noBanRecordsHint => '尚未有 Peer 被屏蔽或封禁';

  @override
  String get noMatchingRecords => '无匹配记录';

  @override
  String get adjustSearchHint => '试试调整搜索关键词';

  @override
  String get logPeerBlocked => '已屏蔽';

  @override
  String get logPeerBanned => '已封禁';

  @override
  String get pageNotFound => '页面不存在';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => 'qBPanel';

  @override
  String get actionCancel => '取消';

  @override
  String get actionOk => '確定';

  @override
  String get actionConfirm => '確定';

  @override
  String get actionApply => '套用';

  @override
  String get actionRetry => '重試';

  @override
  String get actionSave => '儲存';

  @override
  String get actionDelete => '刪除';

  @override
  String get actionClose => '關閉';

  @override
  String get actionRename => '重新命名';

  @override
  String get actionMore => '更多';

  @override
  String get loading => '載入中…';

  @override
  String get processing => '處理中…';

  @override
  String get emptyNoData => '暫無資料';

  @override
  String get loadFailed => '載入失敗';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get notAvailable => 'N/A';

  @override
  String get emDash => '—';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsLanguage => '語言';

  @override
  String get localeFollowSystem => '跟隨系統';

  @override
  String get localeChinese => '簡體中文';

  @override
  String get localeChineseTraditional => '繁體中文';

  @override
  String get localeEnglish => 'English';

  @override
  String get settingsServer => '伺服器';

  @override
  String get settingsServerSettings => '伺服器設定';

  @override
  String get settingsServerSettingsSubtitle => '修改或添加伺服器';

  @override
  String get settingsAppearance => '顯示';

  @override
  String get settingsDisplayMode => '顯示模式';

  @override
  String get settingsThemeSystem => '跟隨系統';

  @override
  String get settingsThemeLight => '淺色';

  @override
  String get settingsThemeDark => '深色';

  @override
  String get settingsThemeHint => '跟隨系統時，自動匹配裝置的淺色 / 深色模式。';

  @override
  String get settingsThemeColor => '主題色';

  @override
  String get settingsUseDynamicColor => '使用系統強調色';

  @override
  String get settingsUseDynamicColorHint => '使用 Android 12+ 的 Material You 配色。';

  @override
  String get settingsCustomThemeColor => '自訂主題色';

  @override
  String get settingsCustomThemeColorHintDynamic => '關閉上方開關後生效；系統色不可用時也會回退到此顏色';

  @override
  String get settingsCustomThemeColorHint => '任意選取一個顏色，作為 Material 3 種子色';

  @override
  String get settingsPickThemeColor => '選擇主題色';

  @override
  String get settingsPickColor => '取色';

  @override
  String get settingsPickColorHint => '選中後點「套用」立即生效';

  @override
  String get apiNoActiveServer => '沒有作用中的伺服器，請先在設定中新增並選取';

  @override
  String get apiTimeout => '連接超時，請檢查地址與連接埠';

  @override
  String get apiConnectionError => '無法連接伺服器，請檢查網路與設定';

  @override
  String get apiUnauthorized => 'API 金鑰無效或無權限';

  @override
  String apiHttpStatus(int code) {
    return '伺服器返回 $code';
  }

  @override
  String get apiBadCertificate => 'HTTPS 證書不受信任';

  @override
  String get apiCancelled => '請求已取消';

  @override
  String durationSeconds(int count) {
    return '$count 秒';
  }

  @override
  String durationMinutes(int count) {
    return '$count 分鐘';
  }

  @override
  String durationHours(int count) {
    return '$count 小時';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours 小時 $minutes 分';
  }

  @override
  String durationDays(int count) {
    return '$count 天';
  }

  @override
  String durationDaysHours(int days, int hours) {
    return '$days 天 $hours 小時';
  }

  @override
  String durationMinutesSeconds(int minutes, int seconds) {
    return '$minutes 分鐘 $seconds 秒';
  }

  @override
  String formatSeedingSuffix(String base, String seeding) {
    return '$base (做種 $seeding)';
  }

  @override
  String formatConnectionsUnlimited(int count) {
    return '$count (最多 ∞)';
  }

  @override
  String formatConnectionsLimited(int count, int limit) {
    return '$count (最多 $limit)';
  }

  @override
  String formatSession(String total, String session) {
    return '$total (本次 $session)';
  }

  @override
  String formatSpeedAvg(String current, String average) {
    return '$current (平均 $average)';
  }

  @override
  String formatCountTotal(int current, int total) {
    return '$current (共 $total)';
  }

  @override
  String formatPieces(int count, String size, int have) {
    return '$count × $size (已完成 $have)';
  }

  @override
  String get logToday => '今天';

  @override
  String get logYesterday => '昨天';

  @override
  String get connectionStatusConnected => '已連接';

  @override
  String get connectionStatusFirewalled => '無法入站';

  @override
  String get connectionStatusDisconnected => '未連接';

  @override
  String get connectionStatusUnknown => '未知';

  @override
  String get torrentStateError => '錯誤';

  @override
  String get torrentStateMissingFiles => '檔案缺失';

  @override
  String get torrentStateUploading => '做種中';

  @override
  String get torrentStateStoppedUp => '已完成';

  @override
  String get torrentStateQueuedUp => '排隊做種';

  @override
  String get torrentStateStalledUp => '做種已暫停';

  @override
  String get torrentStateCheckingUp => '校驗中';

  @override
  String get torrentStateForcedUp => '強制做種';

  @override
  String get torrentStateAllocating => '分配空間';

  @override
  String get torrentStateDownloading => '下載中';

  @override
  String get torrentStateMetaDl => '獲取元資料';

  @override
  String get torrentStateForcedMetaDl => '強制獲取元資料';

  @override
  String get torrentStateStoppedDl => '已停止';

  @override
  String get torrentStateQueuedDl => '排隊下載';

  @override
  String get torrentStateStalledDl => '下載已暫停';

  @override
  String get torrentStateCheckingDl => '校驗中';

  @override
  String get torrentStateForcedDl => '強制下載';

  @override
  String get torrentStateCheckingResumeData => '檢查恢復資料';

  @override
  String get torrentStateMoving => '移動中';

  @override
  String get torrentStateUnknown => '未知';

  @override
  String get filterAll => '全部';

  @override
  String get filterDownloading => '下載';

  @override
  String get filterSeeding => '做種';

  @override
  String get filterCompleted => '完成';

  @override
  String get filterRunning => '正運行';

  @override
  String get filterStopped => '已停止';

  @override
  String get filterActive => '活動';

  @override
  String get filterInactive => '空閒';

  @override
  String get filterStalled => '暫停';

  @override
  String get filterStalledUploading => '上傳已暫停';

  @override
  String get filterStalledDownloading => '下載已暫停';

  @override
  String get filterChecking => '正在檢查';

  @override
  String get filterMoving => '正在移動';

  @override
  String get filterErrored => '錯誤';

  @override
  String get filterUncategorized => '未分類';

  @override
  String get filterUntagged => '無標籤';

  @override
  String get sortState => '狀態';

  @override
  String get sortName => '名稱';

  @override
  String get sortProgress => '進度';

  @override
  String get sortSize => '大小';

  @override
  String get sortDownloadSpeed => '下載速度';

  @override
  String get sortUploadSpeed => '上傳速度';

  @override
  String get sortDownloaded => '已下載';

  @override
  String get sortUploaded => '已上傳';

  @override
  String get sortEta => '剩餘時間';

  @override
  String get sortAmountLeft => '剩餘大小';

  @override
  String get sortRatio => '分享率';

  @override
  String get sortAddedOn => '添加時間';

  @override
  String get sortCompletionOn => '完成時間';

  @override
  String get sortLastActivity => '最後活動';

  @override
  String get sortNumSeeds => '種子數';

  @override
  String get sortNumLeechs => '下載使用者';

  @override
  String get sortAvailability => '可用性';

  @override
  String get sortPriority => '優先級';

  @override
  String get sortTimeActive => '活動時間';

  @override
  String get sortSeedingTime => '做種時間';

  @override
  String get sortCountry => '國家/地區';

  @override
  String get sortIp => 'IP/地址';

  @override
  String get sortPort => '連接埠';

  @override
  String get sortConnection => '連接';

  @override
  String get sortFlags => '標誌';

  @override
  String get sortClient => '客戶端';

  @override
  String get sortPeerIdClient => '對等節點 ID 客戶端';

  @override
  String get sortRelevance => '檔案關聯';

  @override
  String get sortFiles => '檔案';

  @override
  String get sortUrl => 'URL';

  @override
  String get sortTier => '層級';

  @override
  String get sortStatus => '狀態';

  @override
  String get sortSeeds => '種子';

  @override
  String get sortPeers => '使用者';

  @override
  String get sortLeeches => '下載者';

  @override
  String get sortDownloadCount => '完成次數';

  @override
  String get sortMessage => '消息';

  @override
  String get sortNextAnnounce => '下次宣告';

  @override
  String get sortMinAnnounce => '最短宣告間隔';

  @override
  String get sortContentPriority => '下載優先級';

  @override
  String get sortTotalSize => '總大小';

  @override
  String get sortRemaining => '剩餘';

  @override
  String get shareLimitUseDefault => '使用全局設定';

  @override
  String get shareLimitStop => '停止種子';

  @override
  String get shareLimitRemove => '刪除種子';

  @override
  String get shareLimitRemoveWithContent => '刪除種子和檔案';

  @override
  String get shareLimitSuperSeeding => '開啟超級做種';

  @override
  String get logLevelNormal => '普通';

  @override
  String get logLevelInfo => '資訊';

  @override
  String get logLevelWarning => '警告';

  @override
  String get logLevelCritical => '嚴重';

  @override
  String get searchPluginEnabled => '已啟用';

  @override
  String get searchPluginAll => '全部';

  @override
  String get searchPluginSingle => '指定外掛';

  @override
  String get addModeManual => '手動';

  @override
  String get addModeAutomatic => '自動';

  @override
  String get addStopNone => '無';

  @override
  String get addStopMetadataReceived => '已收到元資料';

  @override
  String get addStopFilesChecked => '檔案已被檢查';

  @override
  String get addLayoutOriginal => '原始';

  @override
  String get addLayoutSubfolder => '建立子資料夾';

  @override
  String get addLayoutNoSubfolder => '不建立子資料夾';

  @override
  String get speedPeriod30s => '30 秒';

  @override
  String get speedPeriod1m => '1 分鐘';

  @override
  String get speedPeriod5m => '5 分鐘';

  @override
  String get speedPeriod10m => '10 分鐘';

  @override
  String get speedPeriod30m => '30 分鐘';

  @override
  String get homeFilter => '篩選';

  @override
  String get homeFiltering => '篩選中';

  @override
  String get homeClearSearch => '清除搜尋';

  @override
  String get searchTorrentsHint => '過濾種子';

  @override
  String get homeSort => '排序';

  @override
  String get homeSorting => '排序中';

  @override
  String get homeStartAll => '一鍵開始';

  @override
  String get homeStopAll => '一鍵停止';

  @override
  String get homeSearchTorrents => '搜尋種子';

  @override
  String get homeLogs => '日誌';

  @override
  String get homeSettings => '設定';

  @override
  String get homeAddTorrent => '添加種子';

  @override
  String get homeNoActiveServer => '還沒有活躍的伺服器';

  @override
  String get homeNoActiveServerHint => '去伺服器列表添加或點選一臺';

  @override
  String get homeChooseServer => '去選擇伺服器';

  @override
  String get homeNoMatchingTorrents => '沒有符合條件的種子';

  @override
  String get homeClearFilters => '清除篩選';

  @override
  String get homeNoTorrents => '暫無種子';

  @override
  String get homeNoTorrentsInList => '當前列表沒有種子';

  @override
  String homeConfirmBatch(String action, int count) {
    return '確定$action當前列表中的 $count 個種子？';
  }

  @override
  String homeBatchStarted(int count) {
    return '已開始 $count 個種子';
  }

  @override
  String homeBatchStopped(int count) {
    return '已停止 $count 個種子';
  }

  @override
  String homeBatchFailed(String label, String error) {
    return '$label：$error';
  }

  @override
  String get homeStartAllFailed => '一鍵開始失敗';

  @override
  String get homeStopAllFailed => '一鍵停止失敗';

  @override
  String get homeStarting => '開始中…';

  @override
  String get homeStopping => '停止中…';

  @override
  String get homeStart => '開始';

  @override
  String get homeStop => '停止';

  @override
  String get homeSavedAltSpeed => '已儲存備用限速';

  @override
  String get homeSavedGlobalSpeed => '已儲存全侷限速';

  @override
  String homeAltSpeedToggleFailed(String error) {
    return '切換備用速度限制失敗：$error';
  }

  @override
  String get homeAltSpeedOn => '已開啟備用速度限制';

  @override
  String get homeAltSpeedOff => '已關閉備用速度限制';

  @override
  String get homeServerStatus => '伺服器狀態';

  @override
  String get renameTitle => '重新命名';

  @override
  String copiedWithLabel(String label) {
    return '已複製 $label';
  }

  @override
  String get actionBack => '返回';

  @override
  String get actionAdd => '添加';

  @override
  String get actionEnable => '開啟';

  @override
  String get actionDisable => '關閉';

  @override
  String get actionGotIt => '知道了';

  @override
  String get enabling => '開啟中…';

  @override
  String get disabling => '關閉中…';

  @override
  String get deleting => '刪除中…';

  @override
  String get settingInProgress => '設定中…';

  @override
  String deleteFailed(String error) {
    return '刪除失敗：$error';
  }

  @override
  String errorWithDetail(String label, String error) {
    return '$label：$error';
  }

  @override
  String get onLabel => '開';

  @override
  String get offLabel => '關';

  @override
  String get unlimited => '無限制';

  @override
  String get unlimitedSpeed => '不限';

  @override
  String get custom => '自訂';

  @override
  String get minutes => '分鐘';

  @override
  String get download => '下載';

  @override
  String get upload => '上傳';

  @override
  String get status => '狀態';

  @override
  String get category => '分類';

  @override
  String get tags => '標籤';

  @override
  String get queue => '佇列';

  @override
  String get copy => '複製';

  @override
  String get connection => '連接';

  @override
  String get transfer => '傳輸';

  @override
  String get info => '資訊';

  @override
  String get application => '應用';

  @override
  String get never => '從未';

  @override
  String get unknown => '未知';

  @override
  String get enterName => '請輸入名稱';

  @override
  String get nameInvalid => '名稱無效';

  @override
  String get invalidTorrent => '無效的種子';

  @override
  String get invalidParam => '參數無效';

  @override
  String get torrentNotFound => '種子不存在';

  @override
  String get actionForceStart => '強制啟動';

  @override
  String get actionStartFailed => '開始失敗';

  @override
  String get actionStopFailed => '停止失敗';

  @override
  String get actionForceStartFailed => '強制啟動失敗';

  @override
  String get setSaveLocation => '設定儲存位置';

  @override
  String get autoTmm => '自動種子管理';

  @override
  String get uploadLimit => '上傳限速';

  @override
  String get uploadDownloadLimit => '上傳/下載限速';

  @override
  String get shareLimit => '分享率限制';

  @override
  String get superSeeding => '超級做種模式';

  @override
  String get sequentialDownload => '順序下載';

  @override
  String get firstLastPiece => '先下首尾塊';

  @override
  String get forceRecheck => '強制重新校驗';

  @override
  String get forceReannounce => '強制重新彙報';

  @override
  String get shareTorrent => '分享種子';

  @override
  String get queueTop => '置頂';

  @override
  String get queueUp => '上移';

  @override
  String get queueDown => '下移';

  @override
  String get queueBottom => '置底';

  @override
  String get queueTopFailed => '置頂失敗';

  @override
  String get queueUpFailed => '上移失敗';

  @override
  String get queueDownFailed => '下移失敗';

  @override
  String get queueBottomFailed => '置底失敗';

  @override
  String get sequentialFailed => '設定順序下載失敗';

  @override
  String get firstLastFailed => '設定先下首尾塊失敗';

  @override
  String get recheckFailed => '重新校驗失敗';

  @override
  String get reannounceFailed => '重新彙報失敗';

  @override
  String get preparingShare => '準備分享…';

  @override
  String shareFailed(String error) {
    return '分享失敗：$error';
  }

  @override
  String get renameTorrentHint => '修改的是種子在列表中的顯示名稱，不會改動伺服器上的檔案或資料夾。';

  @override
  String setLocationFailed(String error) {
    return '設定儲存位置失敗：$error';
  }

  @override
  String get enableAutoTmmTitle => '開啟自動種子管理';

  @override
  String get enableAutoTmmMessage => '確定開啟自動種子管理？種子可能會按分類的儲存路徑被移動。';

  @override
  String autoTmmFailed(String action, String error) {
    return '$action自動管理失敗：$error';
  }

  @override
  String superSeedingFailed(String action, String error) {
    return '$action超級做種失敗：$error';
  }

  @override
  String get deleteTorrentTitle => '刪除種子';

  @override
  String get confirmDeleteTorrent => '確定刪除該種子？';

  @override
  String confirmDeleteTorrentNamed(String name) {
    return '確定刪除「$name」？';
  }

  @override
  String get deleteFilesToo => '同時刪除檔案';

  @override
  String get noTorrentsToOperate => '當前沒有可操作的種子';

  @override
  String get invalidTorrentFile => '無效的種子檔案';

  @override
  String get torrentFileNotReady => '種子檔案尚未就緒';

  @override
  String get shareContentEmpty => '分享內容為空';

  @override
  String get prepareShareFailed => '準備分享檔案失敗';

  @override
  String get savePathRequired => '儲存路徑不能為空';

  @override
  String get savePathNoPermission => '沒有該目錄的寫入權限';

  @override
  String get savePathCreateFailed => '無法建立儲存路徑';

  @override
  String get queueingDisabled => '未開啟種子排隊';

  @override
  String get categoryNotFound => '分類不存在';

  @override
  String get magnetLink => '磁力連結';

  @override
  String get contentPath => '內容路徑';

  @override
  String get remaining => '剩餘';

  @override
  String get addCategory => '添加分類';

  @override
  String get addSubcategory => '添加子分類';

  @override
  String get editCategory => '編輯分類';

  @override
  String get deleteCategory => '刪除分類';

  @override
  String get deleteUnusedCategories => '刪除未使用的分類';

  @override
  String get addTag => '添加標籤';

  @override
  String get deleteTag => '刪除標籤';

  @override
  String get deleteUnusedTags => '刪除未使用的標籤';

  @override
  String confirmDeleteTag(String tag) {
    return '確定刪除標籤「$tag」？種子不會被刪除。';
  }

  @override
  String confirmDeleteUnusedTags(int count) {
    return '確定刪除 $count 個未使用的標籤？種子不會被刪除。';
  }

  @override
  String confirmDeleteCategory(String name) {
    return '確定刪除分類「$name」？種子不會被刪除。';
  }

  @override
  String confirmDeleteCategoryWithChildren(String name) {
    return '確定刪除分類「$name」？其子分類也會一併刪除。種子不會被刪除。';
  }

  @override
  String confirmDeleteUnusedCategories(int count) {
    return '確定刪除 $count 個未使用的分類？種子不會被刪除。';
  }

  @override
  String get noUnusedTags => '沒有未使用的標籤';

  @override
  String get noUnusedCategories => '沒有未使用的分類';

  @override
  String get noTagsHint => '暫無標籤，點右上角新建';

  @override
  String get removeTags => '取消標籤';

  @override
  String get tagsRemoved => '已取消標籤';

  @override
  String get switchServer => '切換伺服器';

  @override
  String get noServers => '暫無伺服器';

  @override
  String get enterSavePath => '請輸入儲存路徑';

  @override
  String get savePath => '儲存路徑';

  @override
  String get autoTmmLocationHint => '已開啟自動種子管理。確定後將關閉自動管理，並改用上面的手動路徑。';

  @override
  String get enterTagName => '請輸入標籤名稱';

  @override
  String get tagNameNoComma => '標籤名稱不能包含逗號';

  @override
  String get tagName => '標籤名稱';

  @override
  String get enterCategoryName => '請輸入分類名稱';

  @override
  String get categoryNameInvalid => '分類名稱無效';

  @override
  String get parentCategory => '父分類';

  @override
  String get categoryName => '分類名稱';

  @override
  String get incompleteUseAnotherPath => '對不完整的 Torrent 使用另一個路徑';

  @override
  String get defaultOption => '預設';

  @override
  String get path => '路徑';

  @override
  String queuePosition(int position) {
    return '第 $position 位';
  }

  @override
  String get notInQueue => '不在佇列中';

  @override
  String get seedingTime => '做種時間';

  @override
  String get inactive => '不活躍';

  @override
  String get afterLimitReached => '達到上限後';

  @override
  String get enterValidLimit => '請輸入有效的限制';

  @override
  String get shareLimitSaved => '已儲存分享率限制';

  @override
  String get enterValidSpeed => '請輸入有效的速度';

  @override
  String get altSpeedLimit => '備用速度限制';

  @override
  String get globalSpeedLimit => '全局速度限制';

  @override
  String get altSpeedLimitHint => '當前已開啟備用限速，修改將作用於備用值';

  @override
  String get speedLimitSaved => '已儲存限速';

  @override
  String get altSpeedOffTooltip => '關閉備用速度限制';

  @override
  String get altSpeedOnTooltip => '開啟備用速度限制';

  @override
  String get ssConnectionStatus => '連接狀態';

  @override
  String get ssDhtNodes => 'DHT 節點';

  @override
  String get ssPeerConnections => 'Peer 連接';

  @override
  String get ssExternalIpv4 => '外網 IPv4';

  @override
  String get ssExternalIpv6 => '外網 IPv6';

  @override
  String get ssSessionDownload => '本次下載';

  @override
  String get ssSessionUpload => '本次上傳';

  @override
  String get ssAllTimeDownload => '累計下載';

  @override
  String get ssAllTimeUpload => '累計上傳';

  @override
  String get ssSessionWasted => '本次丟棄';

  @override
  String get ssDlRateLimit => '下載限速';

  @override
  String get ssUpRateLimit => '上傳限速';

  @override
  String get ssAltSpeed => '備用限速';

  @override
  String get ssDiskAndQueue => '磁盤與佇列';

  @override
  String get ssFreeSpace => '磁盤剩餘';

  @override
  String get ssTorrentQueueing => '種子排隊';

  @override
  String get ssDiskQueue => '磁盤佇列';

  @override
  String get ssTrackerQueue => 'Tracker 排隊';

  @override
  String get ssWritePending => '待寫入';

  @override
  String get ssQueued => '佇列等待';

  @override
  String get ssCache => '快取';

  @override
  String get ssCacheUsed => '快取佔用';

  @override
  String get ssReadCacheHits => '讀快取命中';

  @override
  String get ssReadCacheOverload => '讀快取過載';

  @override
  String get ssWriteCacheOverload => '寫快取過載';

  @override
  String get ssAppVersion => '應用版本';

  @override
  String get ssApiVersion => 'API 版本';

  @override
  String get ssBitness => '位數';

  @override
  String get ssPlatform => '平臺';

  @override
  String milliseconds(int count) {
    return '$count 毫秒';
  }

  @override
  String bitnessValue(int bitness) {
    return '$bitness 位';
  }

  @override
  String get torrentDetail => '種子詳情';

  @override
  String get tabGeneral => '普通';

  @override
  String get tabPeers => '使用者';

  @override
  String get tabContent => '內容';

  @override
  String get tabTrackers => 'Tracker';

  @override
  String get tabHttpSeeds => 'HTTP 源';

  @override
  String get sortPeersTitle => '使用者排序';

  @override
  String get sortContent => '內容排序';

  @override
  String get sortTrackers => 'Tracker 排序';

  @override
  String get progress => '進度';

  @override
  String get availability => '可用性';

  @override
  String get timeActive => '活動時間';

  @override
  String get eta => '剩餘時間';

  @override
  String get connections => '連接';

  @override
  String get seeds => '種子';

  @override
  String get peers => '使用者';

  @override
  String get dlLimit => '下載限制';

  @override
  String get upLimit => '上傳限制';

  @override
  String get wasted => '已丟棄';

  @override
  String get nextAnnounce => '下次彙報';

  @override
  String get lastSeen => '最後完整可見';

  @override
  String get popularity => '流行度';

  @override
  String get totalSize => '總大小';

  @override
  String get pieces => '區塊';

  @override
  String get createdBy => '建立';

  @override
  String get addedOn => '添加於';

  @override
  String get completedOn => '完成於';

  @override
  String get createdOn => '建立於';

  @override
  String get privateTorrent => '私有';

  @override
  String get infohashV1 => '資訊雜湊值 v1';

  @override
  String get infohashV2 => '資訊雜湊值 v2';

  @override
  String get comment => '註釋';

  @override
  String get speed => '速度';

  @override
  String get downloadAvg => '下載平均';

  @override
  String get uploadAvg => '上傳平均';

  @override
  String get sampling => '採樣中…';

  @override
  String get tier => '層級';

  @override
  String get leeches => '下載者';

  @override
  String get timesCompleted => '完成次數';

  @override
  String get message => '消息';

  @override
  String get minAnnounce => '最短宣告間隔';

  @override
  String get btProtocol => 'BT 協議';

  @override
  String get relevance => '關聯度';

  @override
  String get contribution => '貢獻';

  @override
  String get flags => '標誌';

  @override
  String get downloadingFile => '正在下載';

  @override
  String downloadingFiles(int count) {
    return '正在下載 $count 個檔案';
  }

  @override
  String get noHttpSeeds => '暫無 HTTP 源';

  @override
  String get noHttpSeedsHint => '當前種子還沒有 HTTP 源';

  @override
  String get addHttpSeed => '添加 HTTP 源';

  @override
  String get editHttpSeed => '編輯 HTTP 源 URL';

  @override
  String get deleteHttpSeed => '刪除 HTTP 源';

  @override
  String get copyHttpSeed => '複製 HTTP 源 URL';

  @override
  String get copiedHttpSeed => '已複製 HTTP 源 URL';

  @override
  String confirmDeleteHttpSeed(String url) {
    return '確定刪除 $url？';
  }

  @override
  String get addedHttpSeed => '已添加 HTTP 源';

  @override
  String get enterHttpSeeds => '請輸入至少一個 HTTP 源';

  @override
  String get enterHttpSeedUrl => '請輸入 HTTP 源 URL';

  @override
  String get invalidUrl => 'URL 無效';

  @override
  String get httpSeedNotFound => 'HTTP 源不存在';

  @override
  String get invalidHttpSeed => '無效的 HTTP 源';

  @override
  String get httpSeedUrl => 'HTTP 源 URL';

  @override
  String get httpSeedListHint => '要添加的 HTTP 源列表（每行一個）';

  @override
  String get noTrackers => '暫無 Tracker';

  @override
  String get noTrackersHint => '當前種子還沒有 Tracker';

  @override
  String get addTracker => '添加 Tracker';

  @override
  String get editTracker => '編輯 Tracker URL';

  @override
  String get deleteTracker => '刪除 Tracker';

  @override
  String get copyTracker => '複製 Tracker URL';

  @override
  String get copiedTracker => '已複製 Tracker URL';

  @override
  String confirmDeleteTracker(String name) {
    return '確定刪除 $name？';
  }

  @override
  String get reannounceSelected => '強制重新宣告選中的 Tracker';

  @override
  String get reannounceAll => '強制重新宣告全部 Tracker';

  @override
  String get reannouncedAll => '已重新宣告全部 Tracker';

  @override
  String get reannouncedOne => '已重新宣告該 Tracker';

  @override
  String reannounceFailedOne(String error) {
    return '重新宣告失敗：$error';
  }

  @override
  String get addedTracker => '已添加 Tracker';

  @override
  String get enterTrackers => '請輸入至少一個 Tracker';

  @override
  String get enterTrackerUrl => '請輸入 Tracker URL';

  @override
  String get trackerUrl => 'Tracker URL';

  @override
  String get tierRange => '層級必須是 0–255';

  @override
  String get enterTier => '請輸入層級';

  @override
  String get trackerNotFound => 'Tracker 不存在';

  @override
  String get trackerUrlTaken => 'Tracker 不存在或新 URL 已被佔用';

  @override
  String get invalidTracker => '無效的 Tracker';

  @override
  String get trackerListHint => '要添加的 Tracker 列表（每行一個）';

  @override
  String get noPeers => '暫無使用者';

  @override
  String get noPeersHint => '當前沒有連上的 Peer';

  @override
  String get startRefresh => '開始刷新';

  @override
  String get pauseRefresh => '暫停刷新';

  @override
  String get flagsHelp => '標誌說明';

  @override
  String get copiedEndpoint => '已複製 IP 連接埠';

  @override
  String get banPeerTitle => '永久禁止使用者';

  @override
  String banPeerMessage(String endpoint) {
    return '確定永久禁止 $endpoint？該使用者將無法再連接。';
  }

  @override
  String get ban => '禁止';

  @override
  String get peerBanned => '已禁止該使用者';

  @override
  String banFailed(String error) {
    return '禁止失敗：$error';
  }

  @override
  String get addPeers => '添加對等節點';

  @override
  String get copyEndpoint => '複製IP連接埠';

  @override
  String get banPeer => '永久禁止使用者';

  @override
  String get addedPeers => '已添加對等節點';

  @override
  String get peerListHint => '要添加的使用者列表（每行一個 IP）';

  @override
  String get peerFormatHint => '格式：IPV4:連接埠/IPV6:連接埠';

  @override
  String get enterPeers => '請輸入至少一個對等節點';

  @override
  String get noValidPeers => '沒有有效的對等節點';

  @override
  String get invalidPeer => '無效的對等節點';

  @override
  String get noFiles => '暫無檔案';

  @override
  String get noFilesHint => '還沒有元資料，或種子裡沒有檔案';

  @override
  String priorityFailed(String error) {
    return '設定優先級失敗：$error';
  }

  @override
  String get priorityInvalid => '優先級無效';

  @override
  String get metadataNotReady => '元資料未就緒，或檔案不存在';

  @override
  String get enterNewName => '請輸入新名稱';

  @override
  String get nameTaken => '名稱無效或已被佔用';

  @override
  String get nameNoPathSeparator => '名稱不能包含路徑分隔符';

  @override
  String get folderName => '資料夾名稱';

  @override
  String get fileName => '檔案名稱';

  @override
  String get renameFolderHint => '修改的是伺服器上這個資料夾的名稱，其中的檔案路徑會一起變更。';

  @override
  String get renameFileHint => '修改的是伺服器上這個檔案的名稱，磁盤路徑會一起變更。';

  @override
  String get priorityDoNotDownload => '不下載';

  @override
  String get priorityHigh => '較高';

  @override
  String get priorityMaximum => '最高';

  @override
  String get priorityMixed => '混合';

  @override
  String get priorityNormal => '正常';

  @override
  String get trackerUpdating => '正在更新...';

  @override
  String get trackerDisabled => '已禁用';

  @override
  String get trackerNotContacted => '尚未聯繫';

  @override
  String get trackerWorking => '工作';

  @override
  String get trackerNotWorking => '未工作';

  @override
  String get trackerError => 'Tracker 錯誤';

  @override
  String get trackerUnreachable => '無法訪問';

  @override
  String get peerFlagD => '本端想下且未被阻塞';

  @override
  String get peerFlagd => '本端想下但對端阻塞';

  @override
  String get peerFlagU => '對端想下且未被阻塞';

  @override
  String get peerFlagu => '對端想下但本端阻塞';

  @override
  String get peerFlagK => '本端不想下，對端未阻塞';

  @override
  String get peerFlagQuestion => '對端不想下，本端未阻塞';

  @override
  String get peerFlagO => '樂觀解除阻塞';

  @override
  String get peerFlagS => '對方被冷落';

  @override
  String get peerFlagI => '傳入連接';

  @override
  String get peerFlagH => '來自 DHT';

  @override
  String get peerFlagX => '來自 PEX';

  @override
  String get peerFlagL => '來自 LSD';

  @override
  String get peerFlagE => '加密傳輸';

  @override
  String get peerFlage => '加密握手';

  @override
  String get peerFlagP => 'μTP';

  @override
  String get peerFlagh => 'NAT 打洞';

  @override
  String get optional => '可選';

  @override
  String get unavailable => '暫不可用';

  @override
  String get notEnabled => '未啟用';

  @override
  String get adding => '添加中…';

  @override
  String get saved => '已儲存';

  @override
  String get saving => '儲存中…';

  @override
  String saveFailed(String error) {
    return '儲存失敗：$error';
  }

  @override
  String addFailed(String error) {
    return '添加失敗：$error';
  }

  @override
  String get loadSettingsFailed => '載入設定失敗';

  @override
  String get actionClear => '清除';

  @override
  String get actionImport => '匯入';

  @override
  String get actionInstall => '安裝';

  @override
  String get actionSearch => '搜尋';

  @override
  String get addTorrentSettings => '種子設定';

  @override
  String get noTags => '暫無標籤';

  @override
  String get contentLayout => '內容佈局';

  @override
  String get stopCondition => '停止條件';

  @override
  String get startTorrent => '開始 Torrent';

  @override
  String get addToTopOfQueue => '添加到佇列頂部';

  @override
  String get skipHashCheck => '跳過雜湊校驗';

  @override
  String get limitDownloadRate => '限制下載速率';

  @override
  String get limitUploadRate => '限制上傳速率';

  @override
  String get saveTo => '儲存在';

  @override
  String get torrentManagementMode => '種子管理模式';

  @override
  String get saveFilesTo => '儲存檔案到';

  @override
  String get autoTmmDecides => '由自動管理決定';

  @override
  String get incompleteTorrentPath => '對不完整的種子使用另一個路徑';

  @override
  String get incompleteSavePath => '不完整種子儲存路徑';

  @override
  String get importMagnet => '從磁力連結匯入';

  @override
  String get importFile => '從檔案匯入';

  @override
  String get tapToChangeLink => '點選更換連結';

  @override
  String get enterMagnetOrHttp => '輸入磁力連結或 HTTP(S) 地址';

  @override
  String get tapToChangeFile => '點選更換檔案';

  @override
  String get selectTorrentFile => '選擇 .torrent 檔案';

  @override
  String get magnetOrUrl => '磁力連結或 URL';

  @override
  String get enterMagnetOrUrl => '請輸入磁力連結或 HTTP(S) 地址';

  @override
  String get importOneTorrentOnly => '一次只能匯入一個種子';

  @override
  String get torrentInfo => '種子資訊';

  @override
  String get date => '日期';

  @override
  String get fetchingMetadata => '正在獲取元資料…';

  @override
  String get metadataFailed => '獲取元資料失敗';

  @override
  String metadataFailedWithError(String error) {
    return '獲取元資料失敗：$error';
  }

  @override
  String get filesAfterImport => '匯入種子後顯示檔案列表';

  @override
  String get cannotReadTorrentFile => '無法讀取種子檔案';

  @override
  String get cannotReadSelectedFile => '無法讀取所選檔案';

  @override
  String get importTorrentFirst => '請先匯入種子';

  @override
  String get fetchingMetadataWait => '正在獲取元資料，請稍候';

  @override
  String get cannotAdd => '無法添加';

  @override
  String get searchTorrents => '搜尋種子';

  @override
  String get searchPlugins => '搜尋外掛';

  @override
  String get filterResults => '篩選結果';

  @override
  String get stopSearch => '停止搜尋';

  @override
  String get searchKeyword => '搜尋關鍵詞';

  @override
  String get searchStarting => '啟動中…';

  @override
  String get collapse => '收起';

  @override
  String get expandSearchForm => '展開搜尋條件';

  @override
  String get searchCriteria => '搜尋條件';

  @override
  String get filterResultName => '篩選結果名稱…';

  @override
  String get enabledPlugins => '已啟用外掛';

  @override
  String get allPlugins => '全部外掛';

  @override
  String get plugin => '外掛';

  @override
  String searchingFound(int total) {
    return '搜尋中 · 已找到 $total 條';
  }

  @override
  String searchingFoundVisible(int total, int visible) {
    return '搜尋中 · 已找到 $total 條（顯示 $visible 條）';
  }

  @override
  String get pythonRequired => '伺服器未安裝 Python，無法使用搜尋功能';

  @override
  String get searchLimitReached => '進行中的搜尋已達上限（最多 5 個）';

  @override
  String get startSearchFailed => '開始搜尋失敗';

  @override
  String get loadPluginsFailed => '載入搜尋外掛失敗';

  @override
  String get noSearchPlugins => '未安裝搜尋外掛';

  @override
  String get noSearchPluginsHint => '請在 qBittorrent Web 端安裝並啟用搜尋外掛';

  @override
  String get searchIdleHint => '輸入關鍵詞並選擇分類 / 外掛後開始搜尋';

  @override
  String get searching => '搜尋中';

  @override
  String get searchingHint => '正在從外掛獲取結果…';

  @override
  String get noMatchingResults => '無匹配結果';

  @override
  String get noResults => '未找到結果';

  @override
  String get adjustFiltersHint => '試試調整篩選條件';

  @override
  String get retrySearchHint => '可更換關鍵詞或外掛重試';

  @override
  String get allCategories => '全部分類';

  @override
  String get searchCategoryAnime => '動畫';

  @override
  String get searchCategoryBooks => '書籍';

  @override
  String get searchCategoryGames => '遊戲';

  @override
  String get searchCategoryMovies => '電影';

  @override
  String get searchCategoryMusic => '音樂';

  @override
  String get searchCategoryPictures => '圖片';

  @override
  String get searchCategorySoftware => '軟體';

  @override
  String get searchCategoryTv => '電視節目';

  @override
  String get searchJobNotFound => '搜尋任務不存在';

  @override
  String get searchResultsUnavailable => '搜尋結果已不可用';

  @override
  String seedingCount(String count) {
    return '做種 $count';
  }

  @override
  String leechingCount(String count) {
    return '下載 $count';
  }

  @override
  String get unknownSize => '未知大小';

  @override
  String get cannotOpenDescription => '無法打開描述頁';

  @override
  String get copiedName => '已複製名稱';

  @override
  String get copiedDownloadLink => '已複製下載連結';

  @override
  String get copiedDescriptionUrl => '已複製描述頁 URL';

  @override
  String get openDescription => '打開描述頁';

  @override
  String get copyName => '複製名稱';

  @override
  String get copyDownloadLink => '複製下載連結';

  @override
  String get copyDescriptionUrl => '複製描述頁 URL';

  @override
  String get resultFilter => '結果篩選';

  @override
  String get resultFilterHint => '對齊 Web 端：0 表示不限制。大小單位按 1024 進制換算。';

  @override
  String get seeders => '做種數';

  @override
  String get minValue => '最小';

  @override
  String get maxValue => '最大';

  @override
  String get rangeTo => '至';

  @override
  String pluginVersion(String version) {
    return '版本 $version';
  }

  @override
  String get deletePlugin => '刪除外掛';

  @override
  String get installPlugin => '安裝外掛';

  @override
  String get checkingUpdates => '檢查中…';

  @override
  String get checkUpdates => '檢查更新';

  @override
  String get searchPluginCopyrightWarning =>
      '警告：在下載來自這些搜尋引擎的 torrent 時，請確認它符合您所在國家的版權法。';

  @override
  String get searchPluginGetMore => '你可以在這裡獲取新的搜尋引擎外掛：';

  @override
  String get noSearchPluginsList => '暫無搜尋外掛';

  @override
  String get noSearchPluginsListHint => '點選「安裝外掛」或「檢查更新」獲取官方外掛';

  @override
  String get cannotOpenLink => '無法打開連結';

  @override
  String get installing => '安裝中…';

  @override
  String get pluginInstalled => '外掛已安裝';

  @override
  String installFailed(String error) {
    return '安裝失敗：$error';
  }

  @override
  String get pluginsUpdated => '外掛列表已更新';

  @override
  String checkUpdatesFailed(String error) {
    return '檢查更新失敗：$error';
  }

  @override
  String operationFailed(String error) {
    return '操作失敗：$error';
  }

  @override
  String confirmUninstallPlugin(String name) {
    return '確定卸載 $name？';
  }

  @override
  String get pluginDeleted => '外掛已刪除';

  @override
  String get enterPluginSource => '請輸入外掛 URL 或路徑';

  @override
  String get installSearchPlugin => '安裝搜尋外掛';

  @override
  String get installPluginHint => '輸入外掛 .py 的 URL，或 qB 伺服器上的檔案路徑。多個來源可用換行分隔。';

  @override
  String get pluginSource => '外掛來源';

  @override
  String get actionEdit => '編輯';

  @override
  String get actionReset => '重置';

  @override
  String get actionGenerate => '生成';

  @override
  String get actionSend => '發送';

  @override
  String get validating => '校驗中…';

  @override
  String get listSeparator => '、';

  @override
  String pleaseFillFields(String fields) {
    return '請填寫：$fields';
  }

  @override
  String get serverNotFound => '伺服器不存在或已刪除';

  @override
  String get cannotGetApiVersion => '無法獲取 API 版本';

  @override
  String probeFailed(String error) {
    return '校驗失敗：$error';
  }

  @override
  String get saveFailedServerGone => '儲存失敗：伺服器不存在或已刪除';

  @override
  String get unitSeconds => '秒';

  @override
  String get unitMilliseconds => '毫秒';

  @override
  String get unlimitedHint => '0 為無限制';

  @override
  String get qbSetBehavior => '行為';

  @override
  String get qbSetDownloads => '下載';

  @override
  String get qbSetConnection => '連接';

  @override
  String get qbSetSpeed => '速度';

  @override
  String get qbSetAdvanced => '高級';

  @override
  String get qbSetDisclaimer =>
      '此處修改的是當前 qBittorrent 伺服器的選項。部分設定僅作用於伺服器或 WebUI，不會影響本 App 的界面與行為。';

  @override
  String get currentServerSettings => '當前伺服器設定';

  @override
  String get addServer => '添加伺服器';

  @override
  String get editServer => '編輯伺服器';

  @override
  String get serverListHint => '點選切換伺服器，點選右上角可以修改伺服器設定';

  @override
  String get noServersHint => '點選右下角添加一臺 qBittorrent 伺服器';

  @override
  String get deleteServer => '刪除伺服器';

  @override
  String confirmDeleteServer(String name) {
    return '確定刪除「$name」嗎？此操作不可恢復。';
  }

  @override
  String get serverName => '伺服器名稱';

  @override
  String get serverNameHint => '伺服器名稱，例如：我的NAS';

  @override
  String get host => '域名或IP';

  @override
  String get hostHint => '域名或IP，例如：my.nas.com, 192.168.1.1';

  @override
  String get port => '連接埠';

  @override
  String get portHint => '連接埠，例如：8888';

  @override
  String get pathHint => '路徑，不包含“/”符號，例如：nas/qb';

  @override
  String get apiKey => 'API金鑰';

  @override
  String get apiKeyHint => 'API金鑰，請在WebUI上生成金鑰';

  @override
  String get useHttps => '使用HTTPS';

  @override
  String get schedulerEveryDay => '每天';

  @override
  String get schedulerWeekdays => '工作日';

  @override
  String get schedulerWeekends => '週末';

  @override
  String get schedulerMonday => '週一';

  @override
  String get schedulerTuesday => '週二';

  @override
  String get schedulerWednesday => '週三';

  @override
  String get schedulerThursday => '週四';

  @override
  String get schedulerFriday => '週五';

  @override
  String get schedulerSaturday => '週六';

  @override
  String get schedulerSunday => '週日';

  @override
  String get peerProtocolTcpAndUtp => 'TCP 和 μTP';

  @override
  String get proxyTypeNone => '(無)';

  @override
  String get btEncryptAllow => '允許加密';

  @override
  String get btEncryptRequire => '強制加密';

  @override
  String get btEncryptDisable => '禁用加密';

  @override
  String get btRatioStop => '停止 torrent';

  @override
  String get btRatioRemove => '刪除 torrent';

  @override
  String get btRatioRemoveAndFiles => '刪除 torrent 及所屬檔案';

  @override
  String get btRatioSuperSeeding => '為 torrent 啟用超級做種';

  @override
  String get logAgeDays => '天';

  @override
  String get logAgeMonths => '月';

  @override
  String get logAgeYears => '年';

  @override
  String get tmmRelocateTorrent => '重新定位 Torrent';

  @override
  String get tmmRelocateAffected => '重新定位受影響的 Torrent';

  @override
  String get tmmSwitchTorrentManual => '切換 Torrent 到手動模式';

  @override
  String get tmmSwitchAffectedManual => '切換受影響的 torrent 至手動模式';

  @override
  String get resumeFastresume => 'Fastresume 檔案';

  @override
  String get resumeSqlite => 'SQLite 資料庫（實驗性）';

  @override
  String get removeDeleteFiles => '永久刪除檔案';

  @override
  String get removeMoveToTrash => '移到回收站（如可能）';

  @override
  String get diskIoMemoryMapped => '記憶體映射檔案';

  @override
  String get diskIoPosix => 'POSIX 兼容';

  @override
  String get diskIoSimplePread => '簡單 pread/pwrite';

  @override
  String get osCacheDisable => '禁用 OS 快取';

  @override
  String get osCacheEnable => '啟用 OS 快取';

  @override
  String get osCacheWriteThrough => '直寫';

  @override
  String get utpPreferTcp => '首選 TCP';

  @override
  String get utpPeerProportional => '與 peer 成比例（限制 TCP）';

  @override
  String get uploadSlotsFixed => '固定槽位';

  @override
  String get uploadSlotsRateBased => '基於上傳速率';

  @override
  String get chokeRoundRobin => '輪詢';

  @override
  String get chokeFastestUpload => '最快上傳';

  @override
  String get chokeAntiLeech => '反吸血';

  @override
  String get bindAllAddresses => '所有地址';

  @override
  String get bindAllIpv4 => '所有 IPv4 地址';

  @override
  String get bindAllIpv6 => '所有 IPv6 地址';

  @override
  String get anyInterface => '任意接口';

  @override
  String get qbWebUiLanguage => '使用者介面語言';

  @override
  String get transferList => '傳輸列表';

  @override
  String get confirmTorrentDeletion => '刪除 Torrent 時提示確認';

  @override
  String get showExternalIp => '在狀態欄展示外部 IP';

  @override
  String get logFile => '日誌檔案';

  @override
  String get enableLogFile => '啟用日誌檔案';

  @override
  String get backupLogWhenLarger => '當大於指定大小時備份日誌檔案';

  @override
  String get deleteOldBackupLogs => '刪除早於指定時間的備份日誌檔案';

  @override
  String get logAge => '時間';

  @override
  String get logPerformanceWarning => '記錄性能警報';

  @override
  String get invalidLogBackupSize => '請填寫有效的日誌備份大小';

  @override
  String get invalidLogRetention => '請填寫有效的日誌保留時間';

  @override
  String get scheduleAltSpeed => '計劃備用速度限制的啟用時間';

  @override
  String get scheduleFrom => '從';

  @override
  String get scheduleTo => '到';

  @override
  String get scheduleWhen => '時間';

  @override
  String get rateLimitOptions => '設定速度限制';

  @override
  String get limitUtpRate => '對 µTP 協議進行速度限制';

  @override
  String get limitOverhead => '對傳送總開銷進行速度限制';

  @override
  String get limitLanPeers => '對本地網路使用者進行速度限制';

  @override
  String get invalidSpeedLimit => '速度限制必須大於等於 0（0 為無限制）';

  @override
  String get peerConnectionProtocol => '對等節點連接協議';

  @override
  String get listeningPort => '監聽連接埠';

  @override
  String get incomingConnectionsPort => '用於傳入連接的連接埠';

  @override
  String get actionRandom => '隨機';

  @override
  String get upnpPortForward => '使用我的路由器的 UPnP / NAT-PMP 連接埠轉發';

  @override
  String get connectionLimits => '連接限制';

  @override
  String get maxConnectionsGlobal => '全局最大連接數';

  @override
  String get maxConnectionsPerTorrent => '每 torrent 最大連接數';

  @override
  String get maxUploadsGlobal => '全局上傳窗口數上限';

  @override
  String get maxUploadsPerTorrent => '每個 torrent 上傳窗口數上限';

  @override
  String get i2pExperimental => 'I2P（實驗性）';

  @override
  String get mixedMode => '混合模式';

  @override
  String get proxyServer => '代理伺服器';

  @override
  String get proxyType => '類型';

  @override
  String get proxyHostnameLookup => '通過代理查找主機名';

  @override
  String get authentication => '驗證';

  @override
  String get username => '使用者名';

  @override
  String get password => '密碼';

  @override
  String get passwordStoredUnencrypted => '注意：密碼以非加密形式儲存';

  @override
  String get proxyForBittorrent => '對 BitTorrent 目的使用代理';

  @override
  String get proxyForPeerConnections => '使用代理伺服器進行使用者連接';

  @override
  String get proxyForRss => '對 RSS 目的使用代理';

  @override
  String get proxyForGeneral => '對常規目的使用代理';

  @override
  String get ipFiltering => 'IP 過濾';

  @override
  String get ipFilterPath => '過濾規則路徑 (.dat, .p2p, .p2b)';

  @override
  String get filterTrackers => '匹配 tracker';

  @override
  String get manuallyBannedIps => '手動屏蔽 IP 地址';

  @override
  String get oneIpPerLine => '每行一個 IP';

  @override
  String get invalidListenPort => '用於傳入連接的連接埠必須在 0 到 65535 之間';

  @override
  String get invalidMaxConnections => '全局最大連接數必須大於 0 或關閉';

  @override
  String get invalidMaxConnectionsPerTorrent => '每 torrent 最大連接數必須大於 0 或關閉';

  @override
  String get invalidMaxUploads => '全局上傳窗口數上限必須大於 0 或關閉';

  @override
  String get invalidMaxUploadsPerTorrent => '每個 torrent 上傳窗口數上限必須大於 0 或關閉';

  @override
  String get invalidProxyPort => '代理連接埠必須在 0 到 65535 之間';

  @override
  String get invalidI2pPort => 'I2P 連接埠必須在 0 到 65535 之間';

  @override
  String get privacy => '隱私';

  @override
  String get enableDht => '啟用 DHT (去中心化網路) 以找到更多使用者';

  @override
  String get enablePex => '啟用使用者交換 (PeX) 以找到更多使用者';

  @override
  String get enableLsd => '啟用本地使用者發現以找到更多使用者';

  @override
  String get encryptionMode => '加密模式';

  @override
  String get anonymousMode => '啟用匿名模式';

  @override
  String get maxActiveCheckingTorrents => '最大活躍檢查 Torrent 數';

  @override
  String get maxActiveDownloads => '最大活動的下載數';

  @override
  String get maxActiveUploads => '最大活動的上傳數';

  @override
  String get maxActiveTorrents => '最大活動的 torrent 數';

  @override
  String get ignoreSlowTorrents => '慢速 torrent 不計入限制內';

  @override
  String get downloadRateThreshold => '下載速度閾值';

  @override
  String get uploadRateThreshold => '上傳速度閾值';

  @override
  String get torrentInactivityTimer => 'Torrent 非活動計時器';

  @override
  String get seedingLimits => '做種限制';

  @override
  String get whenRatioReaches => '當分享率達到';

  @override
  String get whenSeedingTimeReaches => '達到總做種時間時';

  @override
  String get whenInactiveSeedingTimeReaches => '達到不活躍做種時間時';

  @override
  String get then => '然後';

  @override
  String get autoAddTrackers => '自動附加這些 tracker 到新下載';

  @override
  String get oneTrackerPerLine => '每行一個 tracker';

  @override
  String get autoAddTrackersFromUrl => '自動添加 URL 中的 trackers 到新的下載';

  @override
  String get url => '網址';

  @override
  String get fetchedTrackers => '獲取 tracker';

  @override
  String get invalidMaxActiveChecking => '最大活躍檢查 Torrent 數必須大於 -1';

  @override
  String get invalidMaxActiveDownloads => '最大活動的下載數必須大於 -1';

  @override
  String get invalidMaxActiveUploads => '最大活動的上傳數必須大於 -1';

  @override
  String get invalidMaxActiveTorrents => '最大活動的 torrent 數必須大於 -1';

  @override
  String get invalidDownloadRateThreshold => '下載速度閾值必須大於 0';

  @override
  String get invalidUploadRateThreshold => '上傳速度閾值必須大於 0';

  @override
  String get invalidTorrentInactivityTimer => 'Torrent 非活動計時器必須大於 0';

  @override
  String get invalidShareRatio => '分享率限制不能為負數';

  @override
  String get invalidSeedingTime => '做種時間限制不能為負數';

  @override
  String get invalidInactiveSeedingTime => '不活躍做種時間限制不能為負數';

  @override
  String get whenAddingTorrent => '添加 torrent 時';

  @override
  String get doNotStartDownload => '不要自動開始下載';

  @override
  String get whenDuplicateTorrent => '添加重複種子時';

  @override
  String get mergeTrackers => '合併 tracker 到現有 torrent';

  @override
  String get deleteTorrentFileWhenDone => '完成後刪除 .torrent 檔案';

  @override
  String get preallocateAll => '為所有檔案預分配磁盤空間';

  @override
  String get appendIncompleteExt => '為不完整的檔案添加擴展名 .!qB';

  @override
  String get keepUnwantedInFolder => '將未選中的檔案保留在 \".unwanted\" 資料夾中';

  @override
  String get saveManagement => '儲存管理';

  @override
  String get defaultTmmMode => '預設 Torrent 管理模式';

  @override
  String get whenTorrentCategoryChanged => '當 Torrent 分類修改時';

  @override
  String get whenDefaultSavePathChanged => '當預設儲存路徑修改時';

  @override
  String get whenCategorySavePathChanged => '當分類儲存路徑修改時';

  @override
  String get useCategoryPathsInManualMode => '在手動模式下使用分類路徑';

  @override
  String get defaultSavePath => '預設儲存路徑';

  @override
  String get saveIncompleteTorrentsTo => '儲存未完成的 torrent 到';

  @override
  String get copyTorrentFilesTo => '複製 .torrent 檔案到';

  @override
  String get copyFinishedTorrentFilesTo => '複製下載完成的 .torrent 檔案到';

  @override
  String get excludedFileNames => '排除的檔名';

  @override
  String get oneRulePerLine => '每行一個規則';

  @override
  String get emailOnTorrentCompletion => '下載完成時發送電子郵件通知';

  @override
  String get mailSender => '發件人';

  @override
  String get mailRecipient => '收件人';

  @override
  String get smtpServer => 'SMTP 伺服器';

  @override
  String get smtpRequiresSsl => '該伺服器需要安全連結（SSL）';

  @override
  String get sendTestEmail => '發送測試郵件';

  @override
  String get sending => '發送中…';

  @override
  String sendFailed(String error) {
    return '發送失敗：$error';
  }

  @override
  String get testEmailSent => '測試郵件已發送';

  @override
  String get confirmSendTestEmailTitle => '發送測試郵件';

  @override
  String get confirmSendTestEmail =>
      '測試郵件會使用伺服器已儲存的郵件設定發送。繼續前將先儲存當前本頁設定（含郵件相關項），確定繼續嗎？';

  @override
  String get runExternalProgram => '運行外部程式';

  @override
  String get runOnTorrentAdded => '新增 Torrent 時運行';

  @override
  String get runOnTorrentFinished => 'torrent 完成時運行';

  @override
  String get autorunExampleHint => '例如：\"%N\"';

  @override
  String get autorunParametersHint =>
      '支持的參數（區分大小寫）：\n%N：Torrent 名稱，%L：分類，%G：標籤（以逗號分隔），%F：內容路徑，%R：根目錄，%D：儲存路徑，%C：檔案數，%Z：Torrent 大小（字節），%T：Tracker，%I/%J：Info hash，%K：ID，%M：備註\n提示：使用引號將參數擴起以防止文本被空白符分割（例如：\"%N\"）';

  @override
  String get torrentContentLayout => 'Torrent 內容佈局';

  @override
  String get torrentStopCondition => 'Torrent 停止條件';

  @override
  String get enableMailNotificationFirst => '請先啟用郵件通知';

  @override
  String get enterDefaultSavePath => '請填寫預設儲存路徑';

  @override
  String get webUiRemoteControl => 'Web 使用者介面（遠程控制）';

  @override
  String get ipAddress => 'IP 地址';

  @override
  String get useHttpsInsteadOfHttp => '使用 HTTPS 而不是 HTTP';

  @override
  String get certificate => '證書';

  @override
  String get privateKey => '金鑰';

  @override
  String get bypassAuthLocalhost => '對本地主機上的客戶端跳過身份驗證';

  @override
  String get bypassAuthWhitelist => '對 IP 子網白名單中的客戶端跳過身份驗證';

  @override
  String get subnetWhitelistHint => '例如 192.168.1.0/24';

  @override
  String get banAfterFailedAttempts => '連續失敗後禁止客戶端';

  @override
  String get banFor => '禁止';

  @override
  String get sessionTimeout => '會話超時';

  @override
  String get passwordLeaveBlank => '留空表示不修改';

  @override
  String get copiedApiKey => '已複製 API 金鑰';

  @override
  String get resetApiKey => '重置 API key';

  @override
  String get generateApiKey => '生成 API 金鑰';

  @override
  String get confirmResetApiKey =>
      '重置該 API key 嗎？當前 key 會立即停止工作，會生成新 key。本 App 會自動更新本地儲存的金鑰。';

  @override
  String get confirmGenerateApiKey =>
      '生成 API key 嗎？這枚 key 可用於和 qBittorrent 的 API 互動。本 App 會自動儲存到本地伺服器設定。';

  @override
  String get resetting => '重置中…';

  @override
  String get generating => '生成中…';

  @override
  String get apiKeyReset => '已重置 API key';

  @override
  String get apiKeyGenerated => '已生成 API 金鑰';

  @override
  String get deleteApiKey => '刪除 API 金鑰';

  @override
  String get confirmDeleteApiKey =>
      '刪除此 API key 嗎？當前 key 會立即停止工作。本 App 將無法繼續連接，請隨後在伺服器設定中重新設定金鑰。';

  @override
  String get apiKeyDeleted => '已刪除 API 金鑰';

  @override
  String get useAlternativeWebUi => '使用備選 WebUI';

  @override
  String get filePath => '檔案路徑';

  @override
  String get security => '安全';

  @override
  String get clickjackingProtection => '啟用“點選劫持”保護';

  @override
  String get csrfProtection => '啟用跨站請求偽造 (CSRF) 保護';

  @override
  String get secureCookie => '啟用 cookie Secure 標誌（需要 HTTPS 或本機連接）';

  @override
  String get hostHeaderValidation => '啟用 Host 標頭驗證';

  @override
  String get serverDomains => '伺服器域名';

  @override
  String get customHttpHeaders => '啟用自訂 HTTP 頭';

  @override
  String get oneHeaderPerLine => '每行一個 Header';

  @override
  String get reverseProxySupport => '啟用反向代理支持';

  @override
  String get trustedProxiesList => '受信任的代理列表';

  @override
  String get onePerLine => '每行一個';

  @override
  String get updateDynDns => '更新我的動態域名';

  @override
  String get dynDnsService => '服務';

  @override
  String get domain => '域名';

  @override
  String get webUiWarning =>
      '此處修改的是伺服器 WebUI 自身設定。錯誤地更改地址、連接埠、HTTPS、認證或安全選項可能導致本 App 無法再連接該伺服器，請謹慎操作並確保仍有其他方式訪問 qBittorrent。';

  @override
  String get confirmSaveWebUiTitle => '確認儲存 WebUI 設定';

  @override
  String get confirmSaveWebUi =>
      '修改地址、連接埠、HTTPS、使用者名密碼或安全選項後，本 App 可能暫時無法連接伺服器。請確認你仍能通過其他方式訪問 qBittorrent。確定繼續儲存嗎？';

  @override
  String get cannotResetApiKey => '無法重置 API key';

  @override
  String get cannotDeleteApiKey => '無法刪除 API 金鑰。';

  @override
  String get httpsCertPathRequired => 'HTTPS 證書路徑不能為空';

  @override
  String get httpsKeyPathRequired => 'HTTPS 金鑰路徑不能為空';

  @override
  String get webUiUsernameMinLength => 'WebUI 使用者名至少需要 3 個字元';

  @override
  String get webUiUsernameNoColon => 'WebUI 使用者名不能包含冒號';

  @override
  String get webUiPasswordMinLength => 'WebUI 密碼至少需要 6 個字元';

  @override
  String get altWebUiPathRequired => '備選 WebUI 檔案路徑不能為空';

  @override
  String get webUiPortRange => 'WebUI 連接埠必須在 1 到 65535 之間';

  @override
  String get resumeDataStorage => '恢復資料存儲類型（需重啟）';

  @override
  String get torrentContentRemoveOption => '刪除種子內容方式';

  @override
  String get physicalMemoryLimit => '物理記憶體 (RAM) 使用上限';

  @override
  String get networkInterface => '網路接口';

  @override
  String get optionalBindAddress => '可選綁定 IP 地址';

  @override
  String get saveResumeDataInterval => '儲存恢復資料間隔';

  @override
  String get saveStatisticsInterval => '儲存統計資訊間隔';

  @override
  String get torrentFileSizeLimit => '.torrent 檔案大小限制';

  @override
  String get confirmTorrentRecheck => '確認重新檢查種子';

  @override
  String get recheckCompletedTorrents => '完成時重新檢查種子';

  @override
  String get appInstanceName => '自訂應用程式實例名稱';

  @override
  String get refreshInterval => '刷新間隔';

  @override
  String get resolvePeerHostnames => '解析 peer 主機名';

  @override
  String get resolvePeerCountries => '解析 peer 國家/地區';

  @override
  String get enableEmbeddedTracker => '啟用嵌入式 tracker';

  @override
  String get embeddedTrackerPort => '嵌入式 tracker 連接埠';

  @override
  String get embeddedTrackerPortForwarding => '為嵌入式 tracker 啟用連接埠轉發';

  @override
  String get enableMotw => '為下載的檔案啟用 Mark-of-the-Web（需 macOS 或 Windows）';

  @override
  String get ignoreSslErrors => '忽略 SSL 錯誤';

  @override
  String get asyncIoThreads => '異步 I/O 執行緒數';

  @override
  String get hashingThreads => '雜湊執行緒數';

  @override
  String get filePoolSize => '檔案池大小';

  @override
  String get outstandingMemoryWhenChecking => '檢查種子時的未決記憶體';

  @override
  String get diskCache => '磁盤快取';

  @override
  String get diskCacheTtl => '磁盤快取過期間隔';

  @override
  String get diskQueueSize => '磁盤佇列大小';

  @override
  String get diskIoType => '磁盤 IO 類型（需重啟）';

  @override
  String get diskIoReadMode => '磁盤 IO 讀取模式';

  @override
  String get diskIoWriteMode => '磁盤 IO 寫入模式';

  @override
  String get coalesceReadsWrites => '合併讀寫';

  @override
  String get pieceExtentAffinity => '使用分塊範圍親和性';

  @override
  String get sendUploadPieceSuggestions => '發送上傳分塊建議';

  @override
  String get sendBufferWatermark => '發送緩衝區水位線';

  @override
  String get sendBufferLowWatermark => '發送緩衝區低水位線';

  @override
  String get sendBufferWatermarkFactor => '發送緩衝區水位線係數';

  @override
  String get outgoingConnectionsPerSecond => '每秒傳出連接數';

  @override
  String get allowOutgoingWhenSeeding => '做種時允許傳出連接';

  @override
  String get socketSendBufferSize => '套接字發送緩衝區大小（0：系統預設）';

  @override
  String get socketReceiveBufferSize => '套接字接收緩衝區大小（0：系統預設）';

  @override
  String get socketBacklogSize => '套接字 backlog 大小';

  @override
  String get outgoingPortsMin => '傳出連接埠（最小，0：禁用）';

  @override
  String get outgoingPortsMax => '傳出連接埠（最大，0：禁用）';

  @override
  String get peerTos => '連接 peer 的 DSCP';

  @override
  String get resolverCacheTtl => '內部主機名解析器快取過期間隔';

  @override
  String get idnSupport => '支持國際化域名 (IDN)';

  @override
  String get allowMultipleConnectionsFromSameIp => '允許來自同一 IP 地址的多個連接';

  @override
  String get validateHttpsTrackerCert => '驗證 HTTPS tracker 證書';

  @override
  String get ssrfMitigation => '服務端請求偽造 (SSRF) 緩解';

  @override
  String get blockPeersOnPrivilegedPorts => '禁止連接到特權連接埠上的 peer';

  @override
  String get uploadSlotsBehavior => '上傳槽行為';

  @override
  String get uploadChokingAlgorithm => '上傳阻塞演算法';

  @override
  String get announceToAllTrackers => '始終向層級內所有 tracker 宣佈';

  @override
  String get announceToAllTiers => '始終向 tier 內所有 tracker 宣佈';

  @override
  String get announceIp => '向 tracker 報告的 IP（需重啟）';

  @override
  String get announcePort => '向 tracker 報告的連接埠（需重啟，0：監聽連接埠）';

  @override
  String get maxConcurrentHttpAnnounces => '最大併發 HTTP announce 數';

  @override
  String get stopTrackerTimeout => '停止 tracker 超時（0：禁用）';

  @override
  String get peerTurnover => 'Peer 輪換斷開百分比';

  @override
  String get peerTurnoverCutoff => 'Peer 輪換閾值百分比';

  @override
  String get peerTurnoverInterval => 'Peer 輪換斷開間隔';

  @override
  String get requestQueueSize => '對單個 peer 的最大未完成請求數';

  @override
  String get maxOutstandingPieceRequests => '來自 peer 的最大未完成塊請求數';

  @override
  String get dhtBootstrapNodes => 'DHT 引導節點';

  @override
  String get i2pInboundQuantity => 'I2P 入站數量';

  @override
  String get i2pOutboundQuantity => 'I2P 出站數量';

  @override
  String get i2pInboundLength => 'I2P 入站長度';

  @override
  String get i2pOutboundLength => 'I2P 出站長度';

  @override
  String get i2pTunnel => 'I2P 隧道';

  @override
  String get upnpLeaseDuration => 'UPnP 租約時長（0：永久）';

  @override
  String get reannounceWhenAddressChanges =>
      'IP 或連接埠變化時向所有 tracker 重新 announce';

  @override
  String get pythonExecutablePath => 'Python 可執行檔案路徑（可能需要重啟）';

  @override
  String get bdecodeTokenLimit => 'Bdecode 令牌限制';

  @override
  String get bdecodeDepthLimit => 'Bdecode 深度限制';

  @override
  String get utpTcpMixedMode => 'μTP-TCP 混合模式演算法';

  @override
  String get allowMultipleConnectionsFromSamePeerId => '允許來自同一 Peer ID 的多個連接';

  @override
  String get invalidCheckingMemory => '檢查種子時的未決記憶體必須大於 0 且小於 1024 MiB';

  @override
  String get invalidPeerDscp => 'Peer DSCP 必須在 0 到 255 之間';

  @override
  String get invalidAnnouncePort => '向 tracker 報告的連接埠必須在 0 到 65535 之間';

  @override
  String get invalidPeerTurnover => 'Peer 輪換斷開百分比必須在 0 到 100 之間';

  @override
  String get invalidPeerTurnoverCutoff => 'Peer 輪換閾值百分比必須在 0 到 100 之間';

  @override
  String get invalidPeerTurnoverInterval => 'Peer 輪換斷開間隔必須大於等於 0';

  @override
  String get pythonPathNoQuotes => 'Python 可執行檔案路徑首尾不能包含引號';

  @override
  String get searchLogsHint => '搜尋日誌…';

  @override
  String get closeSearch => '關閉搜尋';

  @override
  String get logTabBannedIp => '封禁 IP';

  @override
  String get noLogs => '暫無日誌';

  @override
  String get noLogsHint => '伺服器尚未產生日誌記錄';

  @override
  String get noMatchingLogs => '無匹配日誌';

  @override
  String get adjustFiltersOrSearchHint => '試試調整篩選或搜尋關鍵詞';

  @override
  String get noBanRecords => '暫無封禁記錄';

  @override
  String get noBanRecordsHint => '尚未有 Peer 被屏蔽或封禁';

  @override
  String get noMatchingRecords => '無匹配記錄';

  @override
  String get adjustSearchHint => '試試調整搜尋關鍵詞';

  @override
  String get logPeerBlocked => '已屏蔽';

  @override
  String get logPeerBanned => '已封禁';

  @override
  String get pageNotFound => '頁面不存在';
}
