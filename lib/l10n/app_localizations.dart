import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('zh'),
    Locale('zh', 'TW'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'qBPanel'**
  String get appTitle;

  /// No description provided for @actionCancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get actionCancel;

  /// No description provided for @actionOk.
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get actionOk;

  /// No description provided for @actionConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get actionConfirm;

  /// No description provided for @actionApply.
  ///
  /// In zh, this message translates to:
  /// **'应用'**
  String get actionApply;

  /// No description provided for @actionRetry.
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get actionRetry;

  /// No description provided for @actionSave.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get actionSave;

  /// No description provided for @actionDelete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get actionDelete;

  /// No description provided for @actionClose.
  ///
  /// In zh, this message translates to:
  /// **'关闭'**
  String get actionClose;

  /// No description provided for @actionRename.
  ///
  /// In zh, this message translates to:
  /// **'重命名'**
  String get actionRename;

  /// No description provided for @actionMore.
  ///
  /// In zh, this message translates to:
  /// **'更多'**
  String get actionMore;

  /// No description provided for @loading.
  ///
  /// In zh, this message translates to:
  /// **'加载中…'**
  String get loading;

  /// No description provided for @processing.
  ///
  /// In zh, this message translates to:
  /// **'处理中…'**
  String get processing;

  /// No description provided for @emptyNoData.
  ///
  /// In zh, this message translates to:
  /// **'暂无数据'**
  String get emptyNoData;

  /// No description provided for @loadFailed.
  ///
  /// In zh, this message translates to:
  /// **'加载失败'**
  String get loadFailed;

  /// No description provided for @yes.
  ///
  /// In zh, this message translates to:
  /// **'是'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In zh, this message translates to:
  /// **'否'**
  String get no;

  /// No description provided for @notAvailable.
  ///
  /// In zh, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @emDash.
  ///
  /// In zh, this message translates to:
  /// **'—'**
  String get emDash;

  /// No description provided for @settingsTitle.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get settingsLanguage;

  /// No description provided for @localeFollowSystem.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get localeFollowSystem;

  /// No description provided for @localeChinese.
  ///
  /// In zh, this message translates to:
  /// **'简体中文'**
  String get localeChinese;

  /// No description provided for @localeChineseTraditional.
  ///
  /// In zh, this message translates to:
  /// **'繁體中文'**
  String get localeChineseTraditional;

  /// No description provided for @localeEnglish.
  ///
  /// In zh, this message translates to:
  /// **'English'**
  String get localeEnglish;

  /// No description provided for @settingsServer.
  ///
  /// In zh, this message translates to:
  /// **'服务器'**
  String get settingsServer;

  /// No description provided for @settingsServerSettings.
  ///
  /// In zh, this message translates to:
  /// **'服务器设置'**
  String get settingsServerSettings;

  /// No description provided for @settingsServerSettingsSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'修改或添加服务器'**
  String get settingsServerSettingsSubtitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In zh, this message translates to:
  /// **'显示'**
  String get settingsAppearance;

  /// No description provided for @settingsDisplayMode.
  ///
  /// In zh, this message translates to:
  /// **'显示模式'**
  String get settingsDisplayMode;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In zh, this message translates to:
  /// **'浅色'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In zh, this message translates to:
  /// **'深色'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeHint.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统时，自动匹配设备的浅色 / 深色模式。'**
  String get settingsThemeHint;

  /// No description provided for @settingsThemeColor.
  ///
  /// In zh, this message translates to:
  /// **'主题色'**
  String get settingsThemeColor;

  /// No description provided for @settingsUseDynamicColor.
  ///
  /// In zh, this message translates to:
  /// **'使用系统强调色'**
  String get settingsUseDynamicColor;

  /// No description provided for @settingsUseDynamicColorHint.
  ///
  /// In zh, this message translates to:
  /// **'使用 Android 12+ 的 Material You 配色。'**
  String get settingsUseDynamicColorHint;

  /// No description provided for @settingsCustomThemeColor.
  ///
  /// In zh, this message translates to:
  /// **'自定义主题色'**
  String get settingsCustomThemeColor;

  /// No description provided for @settingsCustomThemeColorHintDynamic.
  ///
  /// In zh, this message translates to:
  /// **'关闭上方开关后生效；系统色不可用时也会回退到此颜色'**
  String get settingsCustomThemeColorHintDynamic;

  /// No description provided for @settingsCustomThemeColorHint.
  ///
  /// In zh, this message translates to:
  /// **'任意选取一个颜色，作为 Material 3 种子色'**
  String get settingsCustomThemeColorHint;

  /// No description provided for @settingsPickThemeColor.
  ///
  /// In zh, this message translates to:
  /// **'选择主题色'**
  String get settingsPickThemeColor;

  /// No description provided for @settingsPickColor.
  ///
  /// In zh, this message translates to:
  /// **'取色'**
  String get settingsPickColor;

  /// No description provided for @settingsPickColorHint.
  ///
  /// In zh, this message translates to:
  /// **'选中后点「应用」立即生效'**
  String get settingsPickColorHint;

  /// No description provided for @apiNoActiveServer.
  ///
  /// In zh, this message translates to:
  /// **'没有激活的服务器，请先在设置中添加并选中'**
  String get apiNoActiveServer;

  /// No description provided for @apiTimeout.
  ///
  /// In zh, this message translates to:
  /// **'连接超时，请检查地址与端口'**
  String get apiTimeout;

  /// No description provided for @apiConnectionError.
  ///
  /// In zh, this message translates to:
  /// **'无法连接服务器，请检查网络与配置'**
  String get apiConnectionError;

  /// No description provided for @apiUnauthorized.
  ///
  /// In zh, this message translates to:
  /// **'API 密钥无效或无权限'**
  String get apiUnauthorized;

  /// No description provided for @apiHttpStatus.
  ///
  /// In zh, this message translates to:
  /// **'服务器返回 {code}'**
  String apiHttpStatus(int code);

  /// No description provided for @apiBadCertificate.
  ///
  /// In zh, this message translates to:
  /// **'HTTPS 证书不受信任'**
  String get apiBadCertificate;

  /// No description provided for @apiCancelled.
  ///
  /// In zh, this message translates to:
  /// **'请求已取消'**
  String get apiCancelled;

  /// No description provided for @durationSeconds.
  ///
  /// In zh, this message translates to:
  /// **'{count} 秒'**
  String durationSeconds(int count);

  /// No description provided for @durationMinutes.
  ///
  /// In zh, this message translates to:
  /// **'{count} 分钟'**
  String durationMinutes(int count);

  /// No description provided for @durationHours.
  ///
  /// In zh, this message translates to:
  /// **'{count} 小时'**
  String durationHours(int count);

  /// No description provided for @durationHoursMinutes.
  ///
  /// In zh, this message translates to:
  /// **'{hours} 小时 {minutes} 分'**
  String durationHoursMinutes(int hours, int minutes);

  /// No description provided for @durationDays.
  ///
  /// In zh, this message translates to:
  /// **'{count} 天'**
  String durationDays(int count);

  /// No description provided for @durationDaysHours.
  ///
  /// In zh, this message translates to:
  /// **'{days} 天 {hours} 小时'**
  String durationDaysHours(int days, int hours);

  /// No description provided for @durationMinutesSeconds.
  ///
  /// In zh, this message translates to:
  /// **'{minutes} 分钟 {seconds} 秒'**
  String durationMinutesSeconds(int minutes, int seconds);

  /// No description provided for @formatSeedingSuffix.
  ///
  /// In zh, this message translates to:
  /// **'{base} (做种 {seeding})'**
  String formatSeedingSuffix(String base, String seeding);

  /// No description provided for @formatConnectionsUnlimited.
  ///
  /// In zh, this message translates to:
  /// **'{count} (最多 ∞)'**
  String formatConnectionsUnlimited(int count);

  /// No description provided for @formatConnectionsLimited.
  ///
  /// In zh, this message translates to:
  /// **'{count} (最多 {limit})'**
  String formatConnectionsLimited(int count, int limit);

  /// No description provided for @formatSession.
  ///
  /// In zh, this message translates to:
  /// **'{total} (本次 {session})'**
  String formatSession(String total, String session);

  /// No description provided for @formatSpeedAvg.
  ///
  /// In zh, this message translates to:
  /// **'{current} (平均 {average})'**
  String formatSpeedAvg(String current, String average);

  /// No description provided for @formatCountTotal.
  ///
  /// In zh, this message translates to:
  /// **'{current} (共 {total})'**
  String formatCountTotal(int current, int total);

  /// No description provided for @formatPieces.
  ///
  /// In zh, this message translates to:
  /// **'{count} × {size} (已完成 {have})'**
  String formatPieces(int count, String size, int have);

  /// No description provided for @logToday.
  ///
  /// In zh, this message translates to:
  /// **'今天'**
  String get logToday;

  /// No description provided for @logYesterday.
  ///
  /// In zh, this message translates to:
  /// **'昨天'**
  String get logYesterday;

  /// No description provided for @connectionStatusConnected.
  ///
  /// In zh, this message translates to:
  /// **'已连接'**
  String get connectionStatusConnected;

  /// No description provided for @connectionStatusFirewalled.
  ///
  /// In zh, this message translates to:
  /// **'无法入站'**
  String get connectionStatusFirewalled;

  /// No description provided for @connectionStatusDisconnected.
  ///
  /// In zh, this message translates to:
  /// **'未连接'**
  String get connectionStatusDisconnected;

  /// No description provided for @connectionStatusUnknown.
  ///
  /// In zh, this message translates to:
  /// **'未知'**
  String get connectionStatusUnknown;

  /// No description provided for @torrentStateError.
  ///
  /// In zh, this message translates to:
  /// **'错误'**
  String get torrentStateError;

  /// No description provided for @torrentStateMissingFiles.
  ///
  /// In zh, this message translates to:
  /// **'文件缺失'**
  String get torrentStateMissingFiles;

  /// No description provided for @torrentStateUploading.
  ///
  /// In zh, this message translates to:
  /// **'做种中'**
  String get torrentStateUploading;

  /// No description provided for @torrentStateStoppedUp.
  ///
  /// In zh, this message translates to:
  /// **'已完成'**
  String get torrentStateStoppedUp;

  /// No description provided for @torrentStateQueuedUp.
  ///
  /// In zh, this message translates to:
  /// **'排队做种'**
  String get torrentStateQueuedUp;

  /// No description provided for @torrentStateStalledUp.
  ///
  /// In zh, this message translates to:
  /// **'做种已暂停'**
  String get torrentStateStalledUp;

  /// No description provided for @torrentStateCheckingUp.
  ///
  /// In zh, this message translates to:
  /// **'校验中'**
  String get torrentStateCheckingUp;

  /// No description provided for @torrentStateForcedUp.
  ///
  /// In zh, this message translates to:
  /// **'强制做种'**
  String get torrentStateForcedUp;

  /// No description provided for @torrentStateAllocating.
  ///
  /// In zh, this message translates to:
  /// **'分配空间'**
  String get torrentStateAllocating;

  /// No description provided for @torrentStateDownloading.
  ///
  /// In zh, this message translates to:
  /// **'下载中'**
  String get torrentStateDownloading;

  /// No description provided for @torrentStateMetaDl.
  ///
  /// In zh, this message translates to:
  /// **'获取元数据'**
  String get torrentStateMetaDl;

  /// No description provided for @torrentStateForcedMetaDl.
  ///
  /// In zh, this message translates to:
  /// **'强制获取元数据'**
  String get torrentStateForcedMetaDl;

  /// No description provided for @torrentStateStoppedDl.
  ///
  /// In zh, this message translates to:
  /// **'已停止'**
  String get torrentStateStoppedDl;

  /// No description provided for @torrentStateQueuedDl.
  ///
  /// In zh, this message translates to:
  /// **'排队下载'**
  String get torrentStateQueuedDl;

  /// No description provided for @torrentStateStalledDl.
  ///
  /// In zh, this message translates to:
  /// **'下载已暂停'**
  String get torrentStateStalledDl;

  /// No description provided for @torrentStateCheckingDl.
  ///
  /// In zh, this message translates to:
  /// **'校验中'**
  String get torrentStateCheckingDl;

  /// No description provided for @torrentStateForcedDl.
  ///
  /// In zh, this message translates to:
  /// **'强制下载'**
  String get torrentStateForcedDl;

  /// No description provided for @torrentStateCheckingResumeData.
  ///
  /// In zh, this message translates to:
  /// **'检查恢复数据'**
  String get torrentStateCheckingResumeData;

  /// No description provided for @torrentStateMoving.
  ///
  /// In zh, this message translates to:
  /// **'移动中'**
  String get torrentStateMoving;

  /// No description provided for @torrentStateUnknown.
  ///
  /// In zh, this message translates to:
  /// **'未知'**
  String get torrentStateUnknown;

  /// No description provided for @filterAll.
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get filterAll;

  /// No description provided for @filterDownloading.
  ///
  /// In zh, this message translates to:
  /// **'下载'**
  String get filterDownloading;

  /// No description provided for @filterSeeding.
  ///
  /// In zh, this message translates to:
  /// **'做种'**
  String get filterSeeding;

  /// No description provided for @filterCompleted.
  ///
  /// In zh, this message translates to:
  /// **'完成'**
  String get filterCompleted;

  /// No description provided for @filterRunning.
  ///
  /// In zh, this message translates to:
  /// **'正运行'**
  String get filterRunning;

  /// No description provided for @filterStopped.
  ///
  /// In zh, this message translates to:
  /// **'已停止'**
  String get filterStopped;

  /// No description provided for @filterActive.
  ///
  /// In zh, this message translates to:
  /// **'活动'**
  String get filterActive;

  /// No description provided for @filterInactive.
  ///
  /// In zh, this message translates to:
  /// **'空闲'**
  String get filterInactive;

  /// No description provided for @filterStalled.
  ///
  /// In zh, this message translates to:
  /// **'暂停'**
  String get filterStalled;

  /// No description provided for @filterStalledUploading.
  ///
  /// In zh, this message translates to:
  /// **'上传已暂停'**
  String get filterStalledUploading;

  /// No description provided for @filterStalledDownloading.
  ///
  /// In zh, this message translates to:
  /// **'下载已暂停'**
  String get filterStalledDownloading;

  /// No description provided for @filterChecking.
  ///
  /// In zh, this message translates to:
  /// **'正在检查'**
  String get filterChecking;

  /// No description provided for @filterMoving.
  ///
  /// In zh, this message translates to:
  /// **'正在移动'**
  String get filterMoving;

  /// No description provided for @filterErrored.
  ///
  /// In zh, this message translates to:
  /// **'错误'**
  String get filterErrored;

  /// No description provided for @filterUncategorized.
  ///
  /// In zh, this message translates to:
  /// **'未分类'**
  String get filterUncategorized;

  /// No description provided for @filterUntagged.
  ///
  /// In zh, this message translates to:
  /// **'无标签'**
  String get filterUntagged;

  /// No description provided for @sortState.
  ///
  /// In zh, this message translates to:
  /// **'状态'**
  String get sortState;

  /// No description provided for @sortName.
  ///
  /// In zh, this message translates to:
  /// **'名称'**
  String get sortName;

  /// No description provided for @sortProgress.
  ///
  /// In zh, this message translates to:
  /// **'进度'**
  String get sortProgress;

  /// No description provided for @sortSize.
  ///
  /// In zh, this message translates to:
  /// **'大小'**
  String get sortSize;

  /// No description provided for @sortDownloadSpeed.
  ///
  /// In zh, this message translates to:
  /// **'下载速度'**
  String get sortDownloadSpeed;

  /// No description provided for @sortUploadSpeed.
  ///
  /// In zh, this message translates to:
  /// **'上传速度'**
  String get sortUploadSpeed;

  /// No description provided for @sortDownloaded.
  ///
  /// In zh, this message translates to:
  /// **'已下载'**
  String get sortDownloaded;

  /// No description provided for @sortUploaded.
  ///
  /// In zh, this message translates to:
  /// **'已上传'**
  String get sortUploaded;

  /// No description provided for @sortEta.
  ///
  /// In zh, this message translates to:
  /// **'剩余时间'**
  String get sortEta;

  /// No description provided for @sortAmountLeft.
  ///
  /// In zh, this message translates to:
  /// **'剩余大小'**
  String get sortAmountLeft;

  /// No description provided for @sortRatio.
  ///
  /// In zh, this message translates to:
  /// **'分享率'**
  String get sortRatio;

  /// No description provided for @sortAddedOn.
  ///
  /// In zh, this message translates to:
  /// **'添加时间'**
  String get sortAddedOn;

  /// No description provided for @sortCompletionOn.
  ///
  /// In zh, this message translates to:
  /// **'完成时间'**
  String get sortCompletionOn;

  /// No description provided for @sortLastActivity.
  ///
  /// In zh, this message translates to:
  /// **'最后活动'**
  String get sortLastActivity;

  /// No description provided for @sortNumSeeds.
  ///
  /// In zh, this message translates to:
  /// **'种子数'**
  String get sortNumSeeds;

  /// No description provided for @sortNumLeechs.
  ///
  /// In zh, this message translates to:
  /// **'下载用户'**
  String get sortNumLeechs;

  /// No description provided for @sortAvailability.
  ///
  /// In zh, this message translates to:
  /// **'可用性'**
  String get sortAvailability;

  /// No description provided for @sortPriority.
  ///
  /// In zh, this message translates to:
  /// **'优先级'**
  String get sortPriority;

  /// No description provided for @sortTimeActive.
  ///
  /// In zh, this message translates to:
  /// **'活动时间'**
  String get sortTimeActive;

  /// No description provided for @sortSeedingTime.
  ///
  /// In zh, this message translates to:
  /// **'做种时间'**
  String get sortSeedingTime;

  /// No description provided for @sortCountry.
  ///
  /// In zh, this message translates to:
  /// **'国家/地区'**
  String get sortCountry;

  /// No description provided for @sortIp.
  ///
  /// In zh, this message translates to:
  /// **'IP/地址'**
  String get sortIp;

  /// No description provided for @sortPort.
  ///
  /// In zh, this message translates to:
  /// **'端口'**
  String get sortPort;

  /// No description provided for @sortConnection.
  ///
  /// In zh, this message translates to:
  /// **'连接'**
  String get sortConnection;

  /// No description provided for @sortFlags.
  ///
  /// In zh, this message translates to:
  /// **'标志'**
  String get sortFlags;

  /// No description provided for @sortClient.
  ///
  /// In zh, this message translates to:
  /// **'客户端'**
  String get sortClient;

  /// No description provided for @sortPeerIdClient.
  ///
  /// In zh, this message translates to:
  /// **'对等节点 ID 客户端'**
  String get sortPeerIdClient;

  /// No description provided for @sortRelevance.
  ///
  /// In zh, this message translates to:
  /// **'文件关联'**
  String get sortRelevance;

  /// No description provided for @sortFiles.
  ///
  /// In zh, this message translates to:
  /// **'文件'**
  String get sortFiles;

  /// No description provided for @sortUrl.
  ///
  /// In zh, this message translates to:
  /// **'URL'**
  String get sortUrl;

  /// No description provided for @sortTier.
  ///
  /// In zh, this message translates to:
  /// **'层级'**
  String get sortTier;

  /// No description provided for @sortStatus.
  ///
  /// In zh, this message translates to:
  /// **'状态'**
  String get sortStatus;

  /// No description provided for @sortSeeds.
  ///
  /// In zh, this message translates to:
  /// **'种子'**
  String get sortSeeds;

  /// No description provided for @sortPeers.
  ///
  /// In zh, this message translates to:
  /// **'用户'**
  String get sortPeers;

  /// No description provided for @sortLeeches.
  ///
  /// In zh, this message translates to:
  /// **'下载者'**
  String get sortLeeches;

  /// No description provided for @sortDownloadCount.
  ///
  /// In zh, this message translates to:
  /// **'完成次数'**
  String get sortDownloadCount;

  /// No description provided for @sortMessage.
  ///
  /// In zh, this message translates to:
  /// **'消息'**
  String get sortMessage;

  /// No description provided for @sortNextAnnounce.
  ///
  /// In zh, this message translates to:
  /// **'下次宣告'**
  String get sortNextAnnounce;

  /// No description provided for @sortMinAnnounce.
  ///
  /// In zh, this message translates to:
  /// **'最短宣告间隔'**
  String get sortMinAnnounce;

  /// No description provided for @sortContentPriority.
  ///
  /// In zh, this message translates to:
  /// **'下载优先级'**
  String get sortContentPriority;

  /// No description provided for @sortTotalSize.
  ///
  /// In zh, this message translates to:
  /// **'总大小'**
  String get sortTotalSize;

  /// No description provided for @sortRemaining.
  ///
  /// In zh, this message translates to:
  /// **'剩余'**
  String get sortRemaining;

  /// No description provided for @shareLimitUseDefault.
  ///
  /// In zh, this message translates to:
  /// **'使用全局设置'**
  String get shareLimitUseDefault;

  /// No description provided for @shareLimitStop.
  ///
  /// In zh, this message translates to:
  /// **'停止种子'**
  String get shareLimitStop;

  /// No description provided for @shareLimitRemove.
  ///
  /// In zh, this message translates to:
  /// **'删除种子'**
  String get shareLimitRemove;

  /// No description provided for @shareLimitRemoveWithContent.
  ///
  /// In zh, this message translates to:
  /// **'删除种子和文件'**
  String get shareLimitRemoveWithContent;

  /// No description provided for @shareLimitSuperSeeding.
  ///
  /// In zh, this message translates to:
  /// **'开启超级做种'**
  String get shareLimitSuperSeeding;

  /// No description provided for @logLevelNormal.
  ///
  /// In zh, this message translates to:
  /// **'普通'**
  String get logLevelNormal;

  /// No description provided for @logLevelInfo.
  ///
  /// In zh, this message translates to:
  /// **'信息'**
  String get logLevelInfo;

  /// No description provided for @logLevelWarning.
  ///
  /// In zh, this message translates to:
  /// **'警告'**
  String get logLevelWarning;

  /// No description provided for @logLevelCritical.
  ///
  /// In zh, this message translates to:
  /// **'严重'**
  String get logLevelCritical;

  /// No description provided for @searchPluginEnabled.
  ///
  /// In zh, this message translates to:
  /// **'已启用'**
  String get searchPluginEnabled;

  /// No description provided for @searchPluginAll.
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get searchPluginAll;

  /// No description provided for @searchPluginSingle.
  ///
  /// In zh, this message translates to:
  /// **'指定插件'**
  String get searchPluginSingle;

  /// No description provided for @addModeManual.
  ///
  /// In zh, this message translates to:
  /// **'手动'**
  String get addModeManual;

  /// No description provided for @addModeAutomatic.
  ///
  /// In zh, this message translates to:
  /// **'自动'**
  String get addModeAutomatic;

  /// No description provided for @addStopNone.
  ///
  /// In zh, this message translates to:
  /// **'无'**
  String get addStopNone;

  /// No description provided for @addStopMetadataReceived.
  ///
  /// In zh, this message translates to:
  /// **'已收到元数据'**
  String get addStopMetadataReceived;

  /// No description provided for @addStopFilesChecked.
  ///
  /// In zh, this message translates to:
  /// **'文件已被检查'**
  String get addStopFilesChecked;

  /// No description provided for @addLayoutOriginal.
  ///
  /// In zh, this message translates to:
  /// **'原始'**
  String get addLayoutOriginal;

  /// No description provided for @addLayoutSubfolder.
  ///
  /// In zh, this message translates to:
  /// **'创建子文件夹'**
  String get addLayoutSubfolder;

  /// No description provided for @addLayoutNoSubfolder.
  ///
  /// In zh, this message translates to:
  /// **'不创建子文件夹'**
  String get addLayoutNoSubfolder;

  /// No description provided for @speedPeriod30s.
  ///
  /// In zh, this message translates to:
  /// **'30 秒'**
  String get speedPeriod30s;

  /// No description provided for @speedPeriod1m.
  ///
  /// In zh, this message translates to:
  /// **'1 分钟'**
  String get speedPeriod1m;

  /// No description provided for @speedPeriod5m.
  ///
  /// In zh, this message translates to:
  /// **'5 分钟'**
  String get speedPeriod5m;

  /// No description provided for @speedPeriod10m.
  ///
  /// In zh, this message translates to:
  /// **'10 分钟'**
  String get speedPeriod10m;

  /// No description provided for @speedPeriod30m.
  ///
  /// In zh, this message translates to:
  /// **'30 分钟'**
  String get speedPeriod30m;

  /// No description provided for @homeFilter.
  ///
  /// In zh, this message translates to:
  /// **'筛选'**
  String get homeFilter;

  /// No description provided for @homeFiltering.
  ///
  /// In zh, this message translates to:
  /// **'筛选中'**
  String get homeFiltering;

  /// No description provided for @homeClearSearch.
  ///
  /// In zh, this message translates to:
  /// **'清除搜索'**
  String get homeClearSearch;

  /// No description provided for @searchTorrentsHint.
  ///
  /// In zh, this message translates to:
  /// **'过滤种子'**
  String get searchTorrentsHint;

  /// No description provided for @homeSort.
  ///
  /// In zh, this message translates to:
  /// **'排序'**
  String get homeSort;

  /// No description provided for @homeSorting.
  ///
  /// In zh, this message translates to:
  /// **'排序中'**
  String get homeSorting;

  /// No description provided for @homeStartAll.
  ///
  /// In zh, this message translates to:
  /// **'一键开始'**
  String get homeStartAll;

  /// No description provided for @homeStopAll.
  ///
  /// In zh, this message translates to:
  /// **'一键停止'**
  String get homeStopAll;

  /// No description provided for @homeSearchTorrents.
  ///
  /// In zh, this message translates to:
  /// **'搜索种子'**
  String get homeSearchTorrents;

  /// No description provided for @homeLogs.
  ///
  /// In zh, this message translates to:
  /// **'日志'**
  String get homeLogs;

  /// No description provided for @homeSettings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get homeSettings;

  /// No description provided for @homeAddTorrent.
  ///
  /// In zh, this message translates to:
  /// **'添加种子'**
  String get homeAddTorrent;

  /// No description provided for @homeNoActiveServer.
  ///
  /// In zh, this message translates to:
  /// **'还没有活跃的服务器'**
  String get homeNoActiveServer;

  /// No description provided for @homeNoActiveServerHint.
  ///
  /// In zh, this message translates to:
  /// **'去服务器列表添加或点选一台'**
  String get homeNoActiveServerHint;

  /// No description provided for @homeChooseServer.
  ///
  /// In zh, this message translates to:
  /// **'去选择服务器'**
  String get homeChooseServer;

  /// No description provided for @homeNoMatchingTorrents.
  ///
  /// In zh, this message translates to:
  /// **'没有符合条件的种子'**
  String get homeNoMatchingTorrents;

  /// No description provided for @homeClearFilters.
  ///
  /// In zh, this message translates to:
  /// **'清除筛选'**
  String get homeClearFilters;

  /// No description provided for @homeNoTorrents.
  ///
  /// In zh, this message translates to:
  /// **'暂无种子'**
  String get homeNoTorrents;

  /// No description provided for @homeNoTorrentsInList.
  ///
  /// In zh, this message translates to:
  /// **'当前列表没有种子'**
  String get homeNoTorrentsInList;

  /// No description provided for @homeConfirmBatch.
  ///
  /// In zh, this message translates to:
  /// **'确定{action}当前列表中的 {count} 个种子？'**
  String homeConfirmBatch(String action, int count);

  /// No description provided for @homeBatchStarted.
  ///
  /// In zh, this message translates to:
  /// **'已开始 {count} 个种子'**
  String homeBatchStarted(int count);

  /// No description provided for @homeBatchStopped.
  ///
  /// In zh, this message translates to:
  /// **'已停止 {count} 个种子'**
  String homeBatchStopped(int count);

  /// No description provided for @homeBatchFailed.
  ///
  /// In zh, this message translates to:
  /// **'{label}：{error}'**
  String homeBatchFailed(String label, String error);

  /// No description provided for @homeStartAllFailed.
  ///
  /// In zh, this message translates to:
  /// **'一键开始失败'**
  String get homeStartAllFailed;

  /// No description provided for @homeStopAllFailed.
  ///
  /// In zh, this message translates to:
  /// **'一键停止失败'**
  String get homeStopAllFailed;

  /// No description provided for @homeStarting.
  ///
  /// In zh, this message translates to:
  /// **'开始中…'**
  String get homeStarting;

  /// No description provided for @homeStopping.
  ///
  /// In zh, this message translates to:
  /// **'停止中…'**
  String get homeStopping;

  /// No description provided for @homeStart.
  ///
  /// In zh, this message translates to:
  /// **'开始'**
  String get homeStart;

  /// No description provided for @homeStop.
  ///
  /// In zh, this message translates to:
  /// **'停止'**
  String get homeStop;

  /// No description provided for @homeSavedAltSpeed.
  ///
  /// In zh, this message translates to:
  /// **'已保存备用限速'**
  String get homeSavedAltSpeed;

  /// No description provided for @homeSavedGlobalSpeed.
  ///
  /// In zh, this message translates to:
  /// **'已保存全局限速'**
  String get homeSavedGlobalSpeed;

  /// No description provided for @homeAltSpeedToggleFailed.
  ///
  /// In zh, this message translates to:
  /// **'切换备用速度限制失败：{error}'**
  String homeAltSpeedToggleFailed(String error);

  /// No description provided for @homeAltSpeedOn.
  ///
  /// In zh, this message translates to:
  /// **'已开启备用速度限制'**
  String get homeAltSpeedOn;

  /// No description provided for @homeAltSpeedOff.
  ///
  /// In zh, this message translates to:
  /// **'已关闭备用速度限制'**
  String get homeAltSpeedOff;

  /// No description provided for @homeServerStatus.
  ///
  /// In zh, this message translates to:
  /// **'服务器状态'**
  String get homeServerStatus;

  /// No description provided for @renameTitle.
  ///
  /// In zh, this message translates to:
  /// **'重命名'**
  String get renameTitle;

  /// No description provided for @copiedWithLabel.
  ///
  /// In zh, this message translates to:
  /// **'已复制 {label}'**
  String copiedWithLabel(String label);

  /// No description provided for @actionBack.
  ///
  /// In zh, this message translates to:
  /// **'返回'**
  String get actionBack;

  /// No description provided for @actionAdd.
  ///
  /// In zh, this message translates to:
  /// **'添加'**
  String get actionAdd;

  /// No description provided for @actionEnable.
  ///
  /// In zh, this message translates to:
  /// **'开启'**
  String get actionEnable;

  /// No description provided for @actionDisable.
  ///
  /// In zh, this message translates to:
  /// **'关闭'**
  String get actionDisable;

  /// No description provided for @actionGotIt.
  ///
  /// In zh, this message translates to:
  /// **'知道了'**
  String get actionGotIt;

  /// No description provided for @enabling.
  ///
  /// In zh, this message translates to:
  /// **'开启中…'**
  String get enabling;

  /// No description provided for @disabling.
  ///
  /// In zh, this message translates to:
  /// **'关闭中…'**
  String get disabling;

  /// No description provided for @deleting.
  ///
  /// In zh, this message translates to:
  /// **'删除中…'**
  String get deleting;

  /// No description provided for @settingInProgress.
  ///
  /// In zh, this message translates to:
  /// **'设置中…'**
  String get settingInProgress;

  /// No description provided for @deleteFailed.
  ///
  /// In zh, this message translates to:
  /// **'删除失败：{error}'**
  String deleteFailed(String error);

  /// No description provided for @errorWithDetail.
  ///
  /// In zh, this message translates to:
  /// **'{label}：{error}'**
  String errorWithDetail(String label, String error);

  /// No description provided for @onLabel.
  ///
  /// In zh, this message translates to:
  /// **'开'**
  String get onLabel;

  /// No description provided for @offLabel.
  ///
  /// In zh, this message translates to:
  /// **'关'**
  String get offLabel;

  /// No description provided for @unlimited.
  ///
  /// In zh, this message translates to:
  /// **'无限制'**
  String get unlimited;

  /// No description provided for @unlimitedSpeed.
  ///
  /// In zh, this message translates to:
  /// **'不限'**
  String get unlimitedSpeed;

  /// No description provided for @custom.
  ///
  /// In zh, this message translates to:
  /// **'自定义'**
  String get custom;

  /// No description provided for @minutes.
  ///
  /// In zh, this message translates to:
  /// **'分钟'**
  String get minutes;

  /// No description provided for @download.
  ///
  /// In zh, this message translates to:
  /// **'下载'**
  String get download;

  /// No description provided for @upload.
  ///
  /// In zh, this message translates to:
  /// **'上传'**
  String get upload;

  /// No description provided for @status.
  ///
  /// In zh, this message translates to:
  /// **'状态'**
  String get status;

  /// No description provided for @category.
  ///
  /// In zh, this message translates to:
  /// **'分类'**
  String get category;

  /// No description provided for @tags.
  ///
  /// In zh, this message translates to:
  /// **'标签'**
  String get tags;

  /// No description provided for @queue.
  ///
  /// In zh, this message translates to:
  /// **'队列'**
  String get queue;

  /// No description provided for @copy.
  ///
  /// In zh, this message translates to:
  /// **'复制'**
  String get copy;

  /// No description provided for @connection.
  ///
  /// In zh, this message translates to:
  /// **'连接'**
  String get connection;

  /// No description provided for @transfer.
  ///
  /// In zh, this message translates to:
  /// **'传输'**
  String get transfer;

  /// No description provided for @info.
  ///
  /// In zh, this message translates to:
  /// **'信息'**
  String get info;

  /// No description provided for @application.
  ///
  /// In zh, this message translates to:
  /// **'应用'**
  String get application;

  /// No description provided for @never.
  ///
  /// In zh, this message translates to:
  /// **'从未'**
  String get never;

  /// No description provided for @unknown.
  ///
  /// In zh, this message translates to:
  /// **'未知'**
  String get unknown;

  /// No description provided for @enterName.
  ///
  /// In zh, this message translates to:
  /// **'请输入名称'**
  String get enterName;

  /// No description provided for @nameInvalid.
  ///
  /// In zh, this message translates to:
  /// **'名称无效'**
  String get nameInvalid;

  /// No description provided for @invalidTorrent.
  ///
  /// In zh, this message translates to:
  /// **'无效的种子'**
  String get invalidTorrent;

  /// No description provided for @invalidParam.
  ///
  /// In zh, this message translates to:
  /// **'参数无效'**
  String get invalidParam;

  /// No description provided for @torrentNotFound.
  ///
  /// In zh, this message translates to:
  /// **'种子不存在'**
  String get torrentNotFound;

  /// No description provided for @actionForceStart.
  ///
  /// In zh, this message translates to:
  /// **'强制启动'**
  String get actionForceStart;

  /// No description provided for @actionStartFailed.
  ///
  /// In zh, this message translates to:
  /// **'开始失败'**
  String get actionStartFailed;

  /// No description provided for @actionStopFailed.
  ///
  /// In zh, this message translates to:
  /// **'停止失败'**
  String get actionStopFailed;

  /// No description provided for @actionForceStartFailed.
  ///
  /// In zh, this message translates to:
  /// **'强制启动失败'**
  String get actionForceStartFailed;

  /// No description provided for @setSaveLocation.
  ///
  /// In zh, this message translates to:
  /// **'设置保存位置'**
  String get setSaveLocation;

  /// No description provided for @autoTmm.
  ///
  /// In zh, this message translates to:
  /// **'自动种子管理'**
  String get autoTmm;

  /// No description provided for @uploadLimit.
  ///
  /// In zh, this message translates to:
  /// **'上传限速'**
  String get uploadLimit;

  /// No description provided for @uploadDownloadLimit.
  ///
  /// In zh, this message translates to:
  /// **'上传/下载限速'**
  String get uploadDownloadLimit;

  /// No description provided for @shareLimit.
  ///
  /// In zh, this message translates to:
  /// **'分享率限制'**
  String get shareLimit;

  /// No description provided for @superSeeding.
  ///
  /// In zh, this message translates to:
  /// **'超级做种模式'**
  String get superSeeding;

  /// No description provided for @sequentialDownload.
  ///
  /// In zh, this message translates to:
  /// **'顺序下载'**
  String get sequentialDownload;

  /// No description provided for @firstLastPiece.
  ///
  /// In zh, this message translates to:
  /// **'先下首尾块'**
  String get firstLastPiece;

  /// No description provided for @forceRecheck.
  ///
  /// In zh, this message translates to:
  /// **'强制重新校验'**
  String get forceRecheck;

  /// No description provided for @forceReannounce.
  ///
  /// In zh, this message translates to:
  /// **'强制重新汇报'**
  String get forceReannounce;

  /// No description provided for @shareTorrent.
  ///
  /// In zh, this message translates to:
  /// **'分享种子'**
  String get shareTorrent;

  /// No description provided for @queueTop.
  ///
  /// In zh, this message translates to:
  /// **'置顶'**
  String get queueTop;

  /// No description provided for @queueUp.
  ///
  /// In zh, this message translates to:
  /// **'上移'**
  String get queueUp;

  /// No description provided for @queueDown.
  ///
  /// In zh, this message translates to:
  /// **'下移'**
  String get queueDown;

  /// No description provided for @queueBottom.
  ///
  /// In zh, this message translates to:
  /// **'置底'**
  String get queueBottom;

  /// No description provided for @queueTopFailed.
  ///
  /// In zh, this message translates to:
  /// **'置顶失败'**
  String get queueTopFailed;

  /// No description provided for @queueUpFailed.
  ///
  /// In zh, this message translates to:
  /// **'上移失败'**
  String get queueUpFailed;

  /// No description provided for @queueDownFailed.
  ///
  /// In zh, this message translates to:
  /// **'下移失败'**
  String get queueDownFailed;

  /// No description provided for @queueBottomFailed.
  ///
  /// In zh, this message translates to:
  /// **'置底失败'**
  String get queueBottomFailed;

  /// No description provided for @sequentialFailed.
  ///
  /// In zh, this message translates to:
  /// **'设置顺序下载失败'**
  String get sequentialFailed;

  /// No description provided for @firstLastFailed.
  ///
  /// In zh, this message translates to:
  /// **'设置先下首尾块失败'**
  String get firstLastFailed;

  /// No description provided for @recheckFailed.
  ///
  /// In zh, this message translates to:
  /// **'重新校验失败'**
  String get recheckFailed;

  /// No description provided for @reannounceFailed.
  ///
  /// In zh, this message translates to:
  /// **'重新汇报失败'**
  String get reannounceFailed;

  /// No description provided for @preparingShare.
  ///
  /// In zh, this message translates to:
  /// **'准备分享…'**
  String get preparingShare;

  /// No description provided for @shareFailed.
  ///
  /// In zh, this message translates to:
  /// **'分享失败：{error}'**
  String shareFailed(String error);

  /// No description provided for @renameTorrentHint.
  ///
  /// In zh, this message translates to:
  /// **'修改的是种子在列表中的显示名称，不会改动服务器上的文件或文件夹。'**
  String get renameTorrentHint;

  /// No description provided for @setLocationFailed.
  ///
  /// In zh, this message translates to:
  /// **'设置保存位置失败：{error}'**
  String setLocationFailed(String error);

  /// No description provided for @enableAutoTmmTitle.
  ///
  /// In zh, this message translates to:
  /// **'开启自动种子管理'**
  String get enableAutoTmmTitle;

  /// No description provided for @enableAutoTmmMessage.
  ///
  /// In zh, this message translates to:
  /// **'确定开启自动种子管理？种子可能会按分类的保存路径被移动。'**
  String get enableAutoTmmMessage;

  /// No description provided for @autoTmmFailed.
  ///
  /// In zh, this message translates to:
  /// **'{action}自动管理失败：{error}'**
  String autoTmmFailed(String action, String error);

  /// No description provided for @superSeedingFailed.
  ///
  /// In zh, this message translates to:
  /// **'{action}超级做种失败：{error}'**
  String superSeedingFailed(String action, String error);

  /// No description provided for @deleteTorrentTitle.
  ///
  /// In zh, this message translates to:
  /// **'删除种子'**
  String get deleteTorrentTitle;

  /// No description provided for @confirmDeleteTorrent.
  ///
  /// In zh, this message translates to:
  /// **'确定删除该种子？'**
  String get confirmDeleteTorrent;

  /// No description provided for @confirmDeleteTorrentNamed.
  ///
  /// In zh, this message translates to:
  /// **'确定删除「{name}」？'**
  String confirmDeleteTorrentNamed(String name);

  /// No description provided for @deleteFilesToo.
  ///
  /// In zh, this message translates to:
  /// **'同时删除文件'**
  String get deleteFilesToo;

  /// No description provided for @noTorrentsToOperate.
  ///
  /// In zh, this message translates to:
  /// **'当前没有可操作的种子'**
  String get noTorrentsToOperate;

  /// No description provided for @invalidTorrentFile.
  ///
  /// In zh, this message translates to:
  /// **'无效的种子文件'**
  String get invalidTorrentFile;

  /// No description provided for @torrentFileNotReady.
  ///
  /// In zh, this message translates to:
  /// **'种子文件尚未就绪'**
  String get torrentFileNotReady;

  /// No description provided for @shareContentEmpty.
  ///
  /// In zh, this message translates to:
  /// **'分享内容为空'**
  String get shareContentEmpty;

  /// No description provided for @prepareShareFailed.
  ///
  /// In zh, this message translates to:
  /// **'准备分享文件失败'**
  String get prepareShareFailed;

  /// No description provided for @savePathRequired.
  ///
  /// In zh, this message translates to:
  /// **'保存路径不能为空'**
  String get savePathRequired;

  /// No description provided for @savePathNoPermission.
  ///
  /// In zh, this message translates to:
  /// **'没有该目录的写入权限'**
  String get savePathNoPermission;

  /// No description provided for @savePathCreateFailed.
  ///
  /// In zh, this message translates to:
  /// **'无法创建保存路径'**
  String get savePathCreateFailed;

  /// No description provided for @queueingDisabled.
  ///
  /// In zh, this message translates to:
  /// **'未开启种子排队'**
  String get queueingDisabled;

  /// No description provided for @categoryNotFound.
  ///
  /// In zh, this message translates to:
  /// **'分类不存在'**
  String get categoryNotFound;

  /// No description provided for @magnetLink.
  ///
  /// In zh, this message translates to:
  /// **'磁力链接'**
  String get magnetLink;

  /// No description provided for @contentPath.
  ///
  /// In zh, this message translates to:
  /// **'内容路径'**
  String get contentPath;

  /// No description provided for @remaining.
  ///
  /// In zh, this message translates to:
  /// **'剩余'**
  String get remaining;

  /// No description provided for @addCategory.
  ///
  /// In zh, this message translates to:
  /// **'添加分类'**
  String get addCategory;

  /// No description provided for @addSubcategory.
  ///
  /// In zh, this message translates to:
  /// **'添加子分类'**
  String get addSubcategory;

  /// No description provided for @editCategory.
  ///
  /// In zh, this message translates to:
  /// **'编辑分类'**
  String get editCategory;

  /// No description provided for @deleteCategory.
  ///
  /// In zh, this message translates to:
  /// **'删除分类'**
  String get deleteCategory;

  /// No description provided for @deleteUnusedCategories.
  ///
  /// In zh, this message translates to:
  /// **'删除未使用的分类'**
  String get deleteUnusedCategories;

  /// No description provided for @addTag.
  ///
  /// In zh, this message translates to:
  /// **'添加标签'**
  String get addTag;

  /// No description provided for @deleteTag.
  ///
  /// In zh, this message translates to:
  /// **'删除标签'**
  String get deleteTag;

  /// No description provided for @deleteUnusedTags.
  ///
  /// In zh, this message translates to:
  /// **'删除未使用的标签'**
  String get deleteUnusedTags;

  /// No description provided for @confirmDeleteTag.
  ///
  /// In zh, this message translates to:
  /// **'确定删除标签「{tag}」？种子不会被删除。'**
  String confirmDeleteTag(String tag);

  /// No description provided for @confirmDeleteUnusedTags.
  ///
  /// In zh, this message translates to:
  /// **'确定删除 {count} 个未使用的标签？种子不会被删除。'**
  String confirmDeleteUnusedTags(int count);

  /// No description provided for @confirmDeleteCategory.
  ///
  /// In zh, this message translates to:
  /// **'确定删除分类「{name}」？种子不会被删除。'**
  String confirmDeleteCategory(String name);

  /// No description provided for @confirmDeleteCategoryWithChildren.
  ///
  /// In zh, this message translates to:
  /// **'确定删除分类「{name}」？其子分类也会一并删除。种子不会被删除。'**
  String confirmDeleteCategoryWithChildren(String name);

  /// No description provided for @confirmDeleteUnusedCategories.
  ///
  /// In zh, this message translates to:
  /// **'确定删除 {count} 个未使用的分类？种子不会被删除。'**
  String confirmDeleteUnusedCategories(int count);

  /// No description provided for @noUnusedTags.
  ///
  /// In zh, this message translates to:
  /// **'没有未使用的标签'**
  String get noUnusedTags;

  /// No description provided for @noUnusedCategories.
  ///
  /// In zh, this message translates to:
  /// **'没有未使用的分类'**
  String get noUnusedCategories;

  /// No description provided for @noTagsHint.
  ///
  /// In zh, this message translates to:
  /// **'暂无标签，点右上角新建'**
  String get noTagsHint;

  /// No description provided for @removeTags.
  ///
  /// In zh, this message translates to:
  /// **'取消标签'**
  String get removeTags;

  /// No description provided for @tagsRemoved.
  ///
  /// In zh, this message translates to:
  /// **'已取消标签'**
  String get tagsRemoved;

  /// No description provided for @switchServer.
  ///
  /// In zh, this message translates to:
  /// **'切换服务器'**
  String get switchServer;

  /// No description provided for @noServers.
  ///
  /// In zh, this message translates to:
  /// **'暂无服务器'**
  String get noServers;

  /// No description provided for @enterSavePath.
  ///
  /// In zh, this message translates to:
  /// **'请输入保存路径'**
  String get enterSavePath;

  /// No description provided for @savePath.
  ///
  /// In zh, this message translates to:
  /// **'保存路径'**
  String get savePath;

  /// No description provided for @autoTmmLocationHint.
  ///
  /// In zh, this message translates to:
  /// **'已开启自动种子管理。确定后将关闭自动管理，并改用上面的手动路径。'**
  String get autoTmmLocationHint;

  /// No description provided for @enterTagName.
  ///
  /// In zh, this message translates to:
  /// **'请输入标签名称'**
  String get enterTagName;

  /// No description provided for @tagNameNoComma.
  ///
  /// In zh, this message translates to:
  /// **'标签名称不能包含逗号'**
  String get tagNameNoComma;

  /// No description provided for @tagName.
  ///
  /// In zh, this message translates to:
  /// **'标签名称'**
  String get tagName;

  /// No description provided for @enterCategoryName.
  ///
  /// In zh, this message translates to:
  /// **'请输入分类名称'**
  String get enterCategoryName;

  /// No description provided for @categoryNameInvalid.
  ///
  /// In zh, this message translates to:
  /// **'分类名称无效'**
  String get categoryNameInvalid;

  /// No description provided for @parentCategory.
  ///
  /// In zh, this message translates to:
  /// **'父分类'**
  String get parentCategory;

  /// No description provided for @categoryName.
  ///
  /// In zh, this message translates to:
  /// **'分类名称'**
  String get categoryName;

  /// No description provided for @incompleteUseAnotherPath.
  ///
  /// In zh, this message translates to:
  /// **'对不完整的 Torrent 使用另一个路径'**
  String get incompleteUseAnotherPath;

  /// No description provided for @defaultOption.
  ///
  /// In zh, this message translates to:
  /// **'默认'**
  String get defaultOption;

  /// No description provided for @path.
  ///
  /// In zh, this message translates to:
  /// **'路径'**
  String get path;

  /// No description provided for @queuePosition.
  ///
  /// In zh, this message translates to:
  /// **'第 {position} 位'**
  String queuePosition(int position);

  /// No description provided for @notInQueue.
  ///
  /// In zh, this message translates to:
  /// **'不在队列中'**
  String get notInQueue;

  /// No description provided for @seedingTime.
  ///
  /// In zh, this message translates to:
  /// **'做种时间'**
  String get seedingTime;

  /// No description provided for @inactive.
  ///
  /// In zh, this message translates to:
  /// **'不活跃'**
  String get inactive;

  /// No description provided for @afterLimitReached.
  ///
  /// In zh, this message translates to:
  /// **'达到上限后'**
  String get afterLimitReached;

  /// No description provided for @enterValidLimit.
  ///
  /// In zh, this message translates to:
  /// **'请输入有效的限制'**
  String get enterValidLimit;

  /// No description provided for @shareLimitSaved.
  ///
  /// In zh, this message translates to:
  /// **'已保存分享率限制'**
  String get shareLimitSaved;

  /// No description provided for @enterValidSpeed.
  ///
  /// In zh, this message translates to:
  /// **'请输入有效的速度'**
  String get enterValidSpeed;

  /// No description provided for @altSpeedLimit.
  ///
  /// In zh, this message translates to:
  /// **'备用速度限制'**
  String get altSpeedLimit;

  /// No description provided for @globalSpeedLimit.
  ///
  /// In zh, this message translates to:
  /// **'全局速度限制'**
  String get globalSpeedLimit;

  /// No description provided for @altSpeedLimitHint.
  ///
  /// In zh, this message translates to:
  /// **'当前已开启备用限速，修改将作用于备用值'**
  String get altSpeedLimitHint;

  /// No description provided for @speedLimitSaved.
  ///
  /// In zh, this message translates to:
  /// **'已保存限速'**
  String get speedLimitSaved;

  /// No description provided for @altSpeedOffTooltip.
  ///
  /// In zh, this message translates to:
  /// **'关闭备用速度限制'**
  String get altSpeedOffTooltip;

  /// No description provided for @altSpeedOnTooltip.
  ///
  /// In zh, this message translates to:
  /// **'开启备用速度限制'**
  String get altSpeedOnTooltip;

  /// No description provided for @ssConnectionStatus.
  ///
  /// In zh, this message translates to:
  /// **'连接状态'**
  String get ssConnectionStatus;

  /// No description provided for @ssDhtNodes.
  ///
  /// In zh, this message translates to:
  /// **'DHT 节点'**
  String get ssDhtNodes;

  /// No description provided for @ssPeerConnections.
  ///
  /// In zh, this message translates to:
  /// **'Peer 连接'**
  String get ssPeerConnections;

  /// No description provided for @ssExternalIpv4.
  ///
  /// In zh, this message translates to:
  /// **'外网 IPv4'**
  String get ssExternalIpv4;

  /// No description provided for @ssExternalIpv6.
  ///
  /// In zh, this message translates to:
  /// **'外网 IPv6'**
  String get ssExternalIpv6;

  /// No description provided for @ssSessionDownload.
  ///
  /// In zh, this message translates to:
  /// **'本次下载'**
  String get ssSessionDownload;

  /// No description provided for @ssSessionUpload.
  ///
  /// In zh, this message translates to:
  /// **'本次上传'**
  String get ssSessionUpload;

  /// No description provided for @ssAllTimeDownload.
  ///
  /// In zh, this message translates to:
  /// **'累计下载'**
  String get ssAllTimeDownload;

  /// No description provided for @ssAllTimeUpload.
  ///
  /// In zh, this message translates to:
  /// **'累计上传'**
  String get ssAllTimeUpload;

  /// No description provided for @ssSessionWasted.
  ///
  /// In zh, this message translates to:
  /// **'本次丢弃'**
  String get ssSessionWasted;

  /// No description provided for @ssDlRateLimit.
  ///
  /// In zh, this message translates to:
  /// **'下载限速'**
  String get ssDlRateLimit;

  /// No description provided for @ssUpRateLimit.
  ///
  /// In zh, this message translates to:
  /// **'上传限速'**
  String get ssUpRateLimit;

  /// No description provided for @ssAltSpeed.
  ///
  /// In zh, this message translates to:
  /// **'备用限速'**
  String get ssAltSpeed;

  /// No description provided for @ssDiskAndQueue.
  ///
  /// In zh, this message translates to:
  /// **'磁盘与队列'**
  String get ssDiskAndQueue;

  /// No description provided for @ssFreeSpace.
  ///
  /// In zh, this message translates to:
  /// **'磁盘剩余'**
  String get ssFreeSpace;

  /// No description provided for @ssTorrentQueueing.
  ///
  /// In zh, this message translates to:
  /// **'种子排队'**
  String get ssTorrentQueueing;

  /// No description provided for @ssDiskQueue.
  ///
  /// In zh, this message translates to:
  /// **'磁盘队列'**
  String get ssDiskQueue;

  /// No description provided for @ssTrackerQueue.
  ///
  /// In zh, this message translates to:
  /// **'Tracker 排队'**
  String get ssTrackerQueue;

  /// No description provided for @ssWritePending.
  ///
  /// In zh, this message translates to:
  /// **'待写入'**
  String get ssWritePending;

  /// No description provided for @ssQueued.
  ///
  /// In zh, this message translates to:
  /// **'队列等待'**
  String get ssQueued;

  /// No description provided for @ssCache.
  ///
  /// In zh, this message translates to:
  /// **'缓存'**
  String get ssCache;

  /// No description provided for @ssCacheUsed.
  ///
  /// In zh, this message translates to:
  /// **'缓存占用'**
  String get ssCacheUsed;

  /// No description provided for @ssReadCacheHits.
  ///
  /// In zh, this message translates to:
  /// **'读缓存命中'**
  String get ssReadCacheHits;

  /// No description provided for @ssReadCacheOverload.
  ///
  /// In zh, this message translates to:
  /// **'读缓存过载'**
  String get ssReadCacheOverload;

  /// No description provided for @ssWriteCacheOverload.
  ///
  /// In zh, this message translates to:
  /// **'写缓存过载'**
  String get ssWriteCacheOverload;

  /// No description provided for @ssAppVersion.
  ///
  /// In zh, this message translates to:
  /// **'应用版本'**
  String get ssAppVersion;

  /// No description provided for @ssApiVersion.
  ///
  /// In zh, this message translates to:
  /// **'API 版本'**
  String get ssApiVersion;

  /// No description provided for @ssBitness.
  ///
  /// In zh, this message translates to:
  /// **'位数'**
  String get ssBitness;

  /// No description provided for @ssPlatform.
  ///
  /// In zh, this message translates to:
  /// **'平台'**
  String get ssPlatform;

  /// No description provided for @milliseconds.
  ///
  /// In zh, this message translates to:
  /// **'{count} 毫秒'**
  String milliseconds(int count);

  /// No description provided for @bitnessValue.
  ///
  /// In zh, this message translates to:
  /// **'{bitness} 位'**
  String bitnessValue(int bitness);

  /// No description provided for @torrentDetail.
  ///
  /// In zh, this message translates to:
  /// **'种子详情'**
  String get torrentDetail;

  /// No description provided for @tabGeneral.
  ///
  /// In zh, this message translates to:
  /// **'普通'**
  String get tabGeneral;

  /// No description provided for @tabPeers.
  ///
  /// In zh, this message translates to:
  /// **'用户'**
  String get tabPeers;

  /// No description provided for @tabContent.
  ///
  /// In zh, this message translates to:
  /// **'内容'**
  String get tabContent;

  /// No description provided for @tabTrackers.
  ///
  /// In zh, this message translates to:
  /// **'Tracker'**
  String get tabTrackers;

  /// No description provided for @tabHttpSeeds.
  ///
  /// In zh, this message translates to:
  /// **'HTTP 源'**
  String get tabHttpSeeds;

  /// No description provided for @sortPeersTitle.
  ///
  /// In zh, this message translates to:
  /// **'用户排序'**
  String get sortPeersTitle;

  /// No description provided for @sortContent.
  ///
  /// In zh, this message translates to:
  /// **'内容排序'**
  String get sortContent;

  /// No description provided for @sortTrackers.
  ///
  /// In zh, this message translates to:
  /// **'Tracker 排序'**
  String get sortTrackers;

  /// No description provided for @progress.
  ///
  /// In zh, this message translates to:
  /// **'进度'**
  String get progress;

  /// No description provided for @availability.
  ///
  /// In zh, this message translates to:
  /// **'可用性'**
  String get availability;

  /// No description provided for @timeActive.
  ///
  /// In zh, this message translates to:
  /// **'活动时间'**
  String get timeActive;

  /// No description provided for @eta.
  ///
  /// In zh, this message translates to:
  /// **'剩余时间'**
  String get eta;

  /// No description provided for @connections.
  ///
  /// In zh, this message translates to:
  /// **'连接'**
  String get connections;

  /// No description provided for @seeds.
  ///
  /// In zh, this message translates to:
  /// **'种子'**
  String get seeds;

  /// No description provided for @peers.
  ///
  /// In zh, this message translates to:
  /// **'用户'**
  String get peers;

  /// No description provided for @dlLimit.
  ///
  /// In zh, this message translates to:
  /// **'下载限制'**
  String get dlLimit;

  /// No description provided for @upLimit.
  ///
  /// In zh, this message translates to:
  /// **'上传限制'**
  String get upLimit;

  /// No description provided for @wasted.
  ///
  /// In zh, this message translates to:
  /// **'已丢弃'**
  String get wasted;

  /// No description provided for @nextAnnounce.
  ///
  /// In zh, this message translates to:
  /// **'下次汇报'**
  String get nextAnnounce;

  /// No description provided for @lastSeen.
  ///
  /// In zh, this message translates to:
  /// **'最后完整可见'**
  String get lastSeen;

  /// No description provided for @popularity.
  ///
  /// In zh, this message translates to:
  /// **'流行度'**
  String get popularity;

  /// No description provided for @totalSize.
  ///
  /// In zh, this message translates to:
  /// **'总大小'**
  String get totalSize;

  /// No description provided for @pieces.
  ///
  /// In zh, this message translates to:
  /// **'区块'**
  String get pieces;

  /// No description provided for @createdBy.
  ///
  /// In zh, this message translates to:
  /// **'创建'**
  String get createdBy;

  /// No description provided for @addedOn.
  ///
  /// In zh, this message translates to:
  /// **'添加于'**
  String get addedOn;

  /// No description provided for @completedOn.
  ///
  /// In zh, this message translates to:
  /// **'完成于'**
  String get completedOn;

  /// No description provided for @createdOn.
  ///
  /// In zh, this message translates to:
  /// **'创建于'**
  String get createdOn;

  /// No description provided for @privateTorrent.
  ///
  /// In zh, this message translates to:
  /// **'私有'**
  String get privateTorrent;

  /// No description provided for @infohashV1.
  ///
  /// In zh, this message translates to:
  /// **'信息哈希值 v1'**
  String get infohashV1;

  /// No description provided for @infohashV2.
  ///
  /// In zh, this message translates to:
  /// **'信息哈希值 v2'**
  String get infohashV2;

  /// No description provided for @comment.
  ///
  /// In zh, this message translates to:
  /// **'注释'**
  String get comment;

  /// No description provided for @speed.
  ///
  /// In zh, this message translates to:
  /// **'速度'**
  String get speed;

  /// No description provided for @downloadAvg.
  ///
  /// In zh, this message translates to:
  /// **'下载平均'**
  String get downloadAvg;

  /// No description provided for @uploadAvg.
  ///
  /// In zh, this message translates to:
  /// **'上传平均'**
  String get uploadAvg;

  /// No description provided for @sampling.
  ///
  /// In zh, this message translates to:
  /// **'采样中…'**
  String get sampling;

  /// No description provided for @tier.
  ///
  /// In zh, this message translates to:
  /// **'层级'**
  String get tier;

  /// No description provided for @leeches.
  ///
  /// In zh, this message translates to:
  /// **'下载者'**
  String get leeches;

  /// No description provided for @timesCompleted.
  ///
  /// In zh, this message translates to:
  /// **'完成次数'**
  String get timesCompleted;

  /// No description provided for @message.
  ///
  /// In zh, this message translates to:
  /// **'消息'**
  String get message;

  /// No description provided for @minAnnounce.
  ///
  /// In zh, this message translates to:
  /// **'最短宣告间隔'**
  String get minAnnounce;

  /// No description provided for @btProtocol.
  ///
  /// In zh, this message translates to:
  /// **'BT 协议'**
  String get btProtocol;

  /// No description provided for @relevance.
  ///
  /// In zh, this message translates to:
  /// **'关联度'**
  String get relevance;

  /// No description provided for @contribution.
  ///
  /// In zh, this message translates to:
  /// **'贡献'**
  String get contribution;

  /// No description provided for @flags.
  ///
  /// In zh, this message translates to:
  /// **'标志'**
  String get flags;

  /// No description provided for @downloadingFile.
  ///
  /// In zh, this message translates to:
  /// **'正在下载'**
  String get downloadingFile;

  /// No description provided for @downloadingFiles.
  ///
  /// In zh, this message translates to:
  /// **'正在下载 {count} 个文件'**
  String downloadingFiles(int count);

  /// No description provided for @noHttpSeeds.
  ///
  /// In zh, this message translates to:
  /// **'暂无 HTTP 源'**
  String get noHttpSeeds;

  /// No description provided for @noHttpSeedsHint.
  ///
  /// In zh, this message translates to:
  /// **'当前种子还没有 HTTP 源'**
  String get noHttpSeedsHint;

  /// No description provided for @addHttpSeed.
  ///
  /// In zh, this message translates to:
  /// **'添加 HTTP 源'**
  String get addHttpSeed;

  /// No description provided for @editHttpSeed.
  ///
  /// In zh, this message translates to:
  /// **'编辑 HTTP 源 URL'**
  String get editHttpSeed;

  /// No description provided for @deleteHttpSeed.
  ///
  /// In zh, this message translates to:
  /// **'删除 HTTP 源'**
  String get deleteHttpSeed;

  /// No description provided for @copyHttpSeed.
  ///
  /// In zh, this message translates to:
  /// **'复制 HTTP 源 URL'**
  String get copyHttpSeed;

  /// No description provided for @copiedHttpSeed.
  ///
  /// In zh, this message translates to:
  /// **'已复制 HTTP 源 URL'**
  String get copiedHttpSeed;

  /// No description provided for @confirmDeleteHttpSeed.
  ///
  /// In zh, this message translates to:
  /// **'确定删除 {url}？'**
  String confirmDeleteHttpSeed(String url);

  /// No description provided for @addedHttpSeed.
  ///
  /// In zh, this message translates to:
  /// **'已添加 HTTP 源'**
  String get addedHttpSeed;

  /// No description provided for @enterHttpSeeds.
  ///
  /// In zh, this message translates to:
  /// **'请输入至少一个 HTTP 源'**
  String get enterHttpSeeds;

  /// No description provided for @enterHttpSeedUrl.
  ///
  /// In zh, this message translates to:
  /// **'请输入 HTTP 源 URL'**
  String get enterHttpSeedUrl;

  /// No description provided for @invalidUrl.
  ///
  /// In zh, this message translates to:
  /// **'URL 无效'**
  String get invalidUrl;

  /// No description provided for @httpSeedNotFound.
  ///
  /// In zh, this message translates to:
  /// **'HTTP 源不存在'**
  String get httpSeedNotFound;

  /// No description provided for @invalidHttpSeed.
  ///
  /// In zh, this message translates to:
  /// **'无效的 HTTP 源'**
  String get invalidHttpSeed;

  /// No description provided for @httpSeedUrl.
  ///
  /// In zh, this message translates to:
  /// **'HTTP 源 URL'**
  String get httpSeedUrl;

  /// No description provided for @httpSeedListHint.
  ///
  /// In zh, this message translates to:
  /// **'要添加的 HTTP 源列表（每行一个）'**
  String get httpSeedListHint;

  /// No description provided for @noTrackers.
  ///
  /// In zh, this message translates to:
  /// **'暂无 Tracker'**
  String get noTrackers;

  /// No description provided for @noTrackersHint.
  ///
  /// In zh, this message translates to:
  /// **'当前种子还没有 Tracker'**
  String get noTrackersHint;

  /// No description provided for @addTracker.
  ///
  /// In zh, this message translates to:
  /// **'添加 Tracker'**
  String get addTracker;

  /// No description provided for @editTracker.
  ///
  /// In zh, this message translates to:
  /// **'编辑 Tracker URL'**
  String get editTracker;

  /// No description provided for @deleteTracker.
  ///
  /// In zh, this message translates to:
  /// **'删除 Tracker'**
  String get deleteTracker;

  /// No description provided for @copyTracker.
  ///
  /// In zh, this message translates to:
  /// **'复制 Tracker URL'**
  String get copyTracker;

  /// No description provided for @copiedTracker.
  ///
  /// In zh, this message translates to:
  /// **'已复制 Tracker URL'**
  String get copiedTracker;

  /// No description provided for @confirmDeleteTracker.
  ///
  /// In zh, this message translates to:
  /// **'确定删除 {name}？'**
  String confirmDeleteTracker(String name);

  /// No description provided for @reannounceSelected.
  ///
  /// In zh, this message translates to:
  /// **'强制重新宣告选中的 Tracker'**
  String get reannounceSelected;

  /// No description provided for @reannounceAll.
  ///
  /// In zh, this message translates to:
  /// **'强制重新宣告全部 Tracker'**
  String get reannounceAll;

  /// No description provided for @reannouncedAll.
  ///
  /// In zh, this message translates to:
  /// **'已重新宣告全部 Tracker'**
  String get reannouncedAll;

  /// No description provided for @reannouncedOne.
  ///
  /// In zh, this message translates to:
  /// **'已重新宣告该 Tracker'**
  String get reannouncedOne;

  /// No description provided for @reannounceFailedOne.
  ///
  /// In zh, this message translates to:
  /// **'重新宣告失败：{error}'**
  String reannounceFailedOne(String error);

  /// No description provided for @addedTracker.
  ///
  /// In zh, this message translates to:
  /// **'已添加 Tracker'**
  String get addedTracker;

  /// No description provided for @enterTrackers.
  ///
  /// In zh, this message translates to:
  /// **'请输入至少一个 Tracker'**
  String get enterTrackers;

  /// No description provided for @enterTrackerUrl.
  ///
  /// In zh, this message translates to:
  /// **'请输入 Tracker URL'**
  String get enterTrackerUrl;

  /// No description provided for @trackerUrl.
  ///
  /// In zh, this message translates to:
  /// **'Tracker URL'**
  String get trackerUrl;

  /// No description provided for @tierRange.
  ///
  /// In zh, this message translates to:
  /// **'层级必须是 0–255'**
  String get tierRange;

  /// No description provided for @enterTier.
  ///
  /// In zh, this message translates to:
  /// **'请输入层级'**
  String get enterTier;

  /// No description provided for @trackerNotFound.
  ///
  /// In zh, this message translates to:
  /// **'Tracker 不存在'**
  String get trackerNotFound;

  /// No description provided for @trackerUrlTaken.
  ///
  /// In zh, this message translates to:
  /// **'Tracker 不存在或新 URL 已被占用'**
  String get trackerUrlTaken;

  /// No description provided for @invalidTracker.
  ///
  /// In zh, this message translates to:
  /// **'无效的 Tracker'**
  String get invalidTracker;

  /// No description provided for @trackerListHint.
  ///
  /// In zh, this message translates to:
  /// **'要添加的 Tracker 列表（每行一个）'**
  String get trackerListHint;

  /// No description provided for @noPeers.
  ///
  /// In zh, this message translates to:
  /// **'暂无用户'**
  String get noPeers;

  /// No description provided for @noPeersHint.
  ///
  /// In zh, this message translates to:
  /// **'当前没有连上的 Peer'**
  String get noPeersHint;

  /// No description provided for @startRefresh.
  ///
  /// In zh, this message translates to:
  /// **'开始刷新'**
  String get startRefresh;

  /// No description provided for @pauseRefresh.
  ///
  /// In zh, this message translates to:
  /// **'暂停刷新'**
  String get pauseRefresh;

  /// No description provided for @flagsHelp.
  ///
  /// In zh, this message translates to:
  /// **'标志说明'**
  String get flagsHelp;

  /// No description provided for @copiedEndpoint.
  ///
  /// In zh, this message translates to:
  /// **'已复制 IP 端口'**
  String get copiedEndpoint;

  /// No description provided for @banPeerTitle.
  ///
  /// In zh, this message translates to:
  /// **'永久禁止用户'**
  String get banPeerTitle;

  /// No description provided for @banPeerMessage.
  ///
  /// In zh, this message translates to:
  /// **'确定永久禁止 {endpoint}？该用户将无法再连接。'**
  String banPeerMessage(String endpoint);

  /// No description provided for @ban.
  ///
  /// In zh, this message translates to:
  /// **'禁止'**
  String get ban;

  /// No description provided for @peerBanned.
  ///
  /// In zh, this message translates to:
  /// **'已禁止该用户'**
  String get peerBanned;

  /// No description provided for @banFailed.
  ///
  /// In zh, this message translates to:
  /// **'禁止失败：{error}'**
  String banFailed(String error);

  /// No description provided for @addPeers.
  ///
  /// In zh, this message translates to:
  /// **'添加对等节点'**
  String get addPeers;

  /// No description provided for @copyEndpoint.
  ///
  /// In zh, this message translates to:
  /// **'复制IP端口'**
  String get copyEndpoint;

  /// No description provided for @banPeer.
  ///
  /// In zh, this message translates to:
  /// **'永久禁止用户'**
  String get banPeer;

  /// No description provided for @addedPeers.
  ///
  /// In zh, this message translates to:
  /// **'已添加对等节点'**
  String get addedPeers;

  /// No description provided for @peerListHint.
  ///
  /// In zh, this message translates to:
  /// **'要添加的用户列表（每行一个 IP）'**
  String get peerListHint;

  /// No description provided for @peerFormatHint.
  ///
  /// In zh, this message translates to:
  /// **'格式：IPV4:端口/IPV6:端口'**
  String get peerFormatHint;

  /// No description provided for @enterPeers.
  ///
  /// In zh, this message translates to:
  /// **'请输入至少一个对等节点'**
  String get enterPeers;

  /// No description provided for @noValidPeers.
  ///
  /// In zh, this message translates to:
  /// **'没有有效的对等节点'**
  String get noValidPeers;

  /// No description provided for @invalidPeer.
  ///
  /// In zh, this message translates to:
  /// **'无效的对等节点'**
  String get invalidPeer;

  /// No description provided for @noFiles.
  ///
  /// In zh, this message translates to:
  /// **'暂无文件'**
  String get noFiles;

  /// No description provided for @noFilesHint.
  ///
  /// In zh, this message translates to:
  /// **'还没有元数据，或种子里没有文件'**
  String get noFilesHint;

  /// No description provided for @priorityFailed.
  ///
  /// In zh, this message translates to:
  /// **'设置优先级失败：{error}'**
  String priorityFailed(String error);

  /// No description provided for @priorityInvalid.
  ///
  /// In zh, this message translates to:
  /// **'优先级无效'**
  String get priorityInvalid;

  /// No description provided for @metadataNotReady.
  ///
  /// In zh, this message translates to:
  /// **'元数据未就绪，或文件不存在'**
  String get metadataNotReady;

  /// No description provided for @enterNewName.
  ///
  /// In zh, this message translates to:
  /// **'请输入新名称'**
  String get enterNewName;

  /// No description provided for @nameTaken.
  ///
  /// In zh, this message translates to:
  /// **'名称无效或已被占用'**
  String get nameTaken;

  /// No description provided for @nameNoPathSeparator.
  ///
  /// In zh, this message translates to:
  /// **'名称不能包含路径分隔符'**
  String get nameNoPathSeparator;

  /// No description provided for @folderName.
  ///
  /// In zh, this message translates to:
  /// **'文件夹名称'**
  String get folderName;

  /// No description provided for @fileName.
  ///
  /// In zh, this message translates to:
  /// **'文件名称'**
  String get fileName;

  /// No description provided for @renameFolderHint.
  ///
  /// In zh, this message translates to:
  /// **'修改的是服务器上这个文件夹的名称，其中的文件路径会一起变更。'**
  String get renameFolderHint;

  /// No description provided for @renameFileHint.
  ///
  /// In zh, this message translates to:
  /// **'修改的是服务器上这个文件的名称，磁盘路径会一起变更。'**
  String get renameFileHint;

  /// No description provided for @priorityDoNotDownload.
  ///
  /// In zh, this message translates to:
  /// **'不下载'**
  String get priorityDoNotDownload;

  /// No description provided for @priorityHigh.
  ///
  /// In zh, this message translates to:
  /// **'较高'**
  String get priorityHigh;

  /// No description provided for @priorityMaximum.
  ///
  /// In zh, this message translates to:
  /// **'最高'**
  String get priorityMaximum;

  /// No description provided for @priorityMixed.
  ///
  /// In zh, this message translates to:
  /// **'混合'**
  String get priorityMixed;

  /// No description provided for @priorityNormal.
  ///
  /// In zh, this message translates to:
  /// **'正常'**
  String get priorityNormal;

  /// No description provided for @trackerUpdating.
  ///
  /// In zh, this message translates to:
  /// **'正在更新...'**
  String get trackerUpdating;

  /// No description provided for @trackerDisabled.
  ///
  /// In zh, this message translates to:
  /// **'已禁用'**
  String get trackerDisabled;

  /// No description provided for @trackerNotContacted.
  ///
  /// In zh, this message translates to:
  /// **'尚未联系'**
  String get trackerNotContacted;

  /// No description provided for @trackerWorking.
  ///
  /// In zh, this message translates to:
  /// **'工作'**
  String get trackerWorking;

  /// No description provided for @trackerNotWorking.
  ///
  /// In zh, this message translates to:
  /// **'未工作'**
  String get trackerNotWorking;

  /// No description provided for @trackerError.
  ///
  /// In zh, this message translates to:
  /// **'Tracker 错误'**
  String get trackerError;

  /// No description provided for @trackerUnreachable.
  ///
  /// In zh, this message translates to:
  /// **'无法访问'**
  String get trackerUnreachable;

  /// No description provided for @peerFlagD.
  ///
  /// In zh, this message translates to:
  /// **'本端想下且未被阻塞'**
  String get peerFlagD;

  /// No description provided for @peerFlagd.
  ///
  /// In zh, this message translates to:
  /// **'本端想下但对端阻塞'**
  String get peerFlagd;

  /// No description provided for @peerFlagU.
  ///
  /// In zh, this message translates to:
  /// **'对端想下且未被阻塞'**
  String get peerFlagU;

  /// No description provided for @peerFlagu.
  ///
  /// In zh, this message translates to:
  /// **'对端想下但本端阻塞'**
  String get peerFlagu;

  /// No description provided for @peerFlagK.
  ///
  /// In zh, this message translates to:
  /// **'本端不想下，对端未阻塞'**
  String get peerFlagK;

  /// No description provided for @peerFlagQuestion.
  ///
  /// In zh, this message translates to:
  /// **'对端不想下，本端未阻塞'**
  String get peerFlagQuestion;

  /// No description provided for @peerFlagO.
  ///
  /// In zh, this message translates to:
  /// **'乐观解除阻塞'**
  String get peerFlagO;

  /// No description provided for @peerFlagS.
  ///
  /// In zh, this message translates to:
  /// **'对方被冷落'**
  String get peerFlagS;

  /// No description provided for @peerFlagI.
  ///
  /// In zh, this message translates to:
  /// **'传入连接'**
  String get peerFlagI;

  /// No description provided for @peerFlagH.
  ///
  /// In zh, this message translates to:
  /// **'来自 DHT'**
  String get peerFlagH;

  /// No description provided for @peerFlagX.
  ///
  /// In zh, this message translates to:
  /// **'来自 PEX'**
  String get peerFlagX;

  /// No description provided for @peerFlagL.
  ///
  /// In zh, this message translates to:
  /// **'来自 LSD'**
  String get peerFlagL;

  /// No description provided for @peerFlagE.
  ///
  /// In zh, this message translates to:
  /// **'加密传输'**
  String get peerFlagE;

  /// No description provided for @peerFlage.
  ///
  /// In zh, this message translates to:
  /// **'加密握手'**
  String get peerFlage;

  /// No description provided for @peerFlagP.
  ///
  /// In zh, this message translates to:
  /// **'μTP'**
  String get peerFlagP;

  /// No description provided for @peerFlagh.
  ///
  /// In zh, this message translates to:
  /// **'NAT 打洞'**
  String get peerFlagh;

  /// No description provided for @optional.
  ///
  /// In zh, this message translates to:
  /// **'可选'**
  String get optional;

  /// No description provided for @unavailable.
  ///
  /// In zh, this message translates to:
  /// **'暂不可用'**
  String get unavailable;

  /// No description provided for @notEnabled.
  ///
  /// In zh, this message translates to:
  /// **'未启用'**
  String get notEnabled;

  /// No description provided for @adding.
  ///
  /// In zh, this message translates to:
  /// **'添加中…'**
  String get adding;

  /// No description provided for @saved.
  ///
  /// In zh, this message translates to:
  /// **'已保存'**
  String get saved;

  /// No description provided for @saving.
  ///
  /// In zh, this message translates to:
  /// **'保存中…'**
  String get saving;

  /// No description provided for @saveFailed.
  ///
  /// In zh, this message translates to:
  /// **'保存失败：{error}'**
  String saveFailed(String error);

  /// No description provided for @addFailed.
  ///
  /// In zh, this message translates to:
  /// **'添加失败：{error}'**
  String addFailed(String error);

  /// No description provided for @loadSettingsFailed.
  ///
  /// In zh, this message translates to:
  /// **'加载设置失败'**
  String get loadSettingsFailed;

  /// No description provided for @actionClear.
  ///
  /// In zh, this message translates to:
  /// **'清除'**
  String get actionClear;

  /// No description provided for @actionImport.
  ///
  /// In zh, this message translates to:
  /// **'导入'**
  String get actionImport;

  /// No description provided for @actionInstall.
  ///
  /// In zh, this message translates to:
  /// **'安装'**
  String get actionInstall;

  /// No description provided for @actionSearch.
  ///
  /// In zh, this message translates to:
  /// **'搜索'**
  String get actionSearch;

  /// No description provided for @addTorrentSettings.
  ///
  /// In zh, this message translates to:
  /// **'种子设置'**
  String get addTorrentSettings;

  /// No description provided for @noTags.
  ///
  /// In zh, this message translates to:
  /// **'暂无标签'**
  String get noTags;

  /// No description provided for @contentLayout.
  ///
  /// In zh, this message translates to:
  /// **'内容布局'**
  String get contentLayout;

  /// No description provided for @stopCondition.
  ///
  /// In zh, this message translates to:
  /// **'停止条件'**
  String get stopCondition;

  /// No description provided for @startTorrent.
  ///
  /// In zh, this message translates to:
  /// **'开始 Torrent'**
  String get startTorrent;

  /// No description provided for @addToTopOfQueue.
  ///
  /// In zh, this message translates to:
  /// **'添加到队列顶部'**
  String get addToTopOfQueue;

  /// No description provided for @skipHashCheck.
  ///
  /// In zh, this message translates to:
  /// **'跳过哈希校验'**
  String get skipHashCheck;

  /// No description provided for @limitDownloadRate.
  ///
  /// In zh, this message translates to:
  /// **'限制下载速率'**
  String get limitDownloadRate;

  /// No description provided for @limitUploadRate.
  ///
  /// In zh, this message translates to:
  /// **'限制上传速率'**
  String get limitUploadRate;

  /// No description provided for @saveTo.
  ///
  /// In zh, this message translates to:
  /// **'保存在'**
  String get saveTo;

  /// No description provided for @torrentManagementMode.
  ///
  /// In zh, this message translates to:
  /// **'种子管理模式'**
  String get torrentManagementMode;

  /// No description provided for @saveFilesTo.
  ///
  /// In zh, this message translates to:
  /// **'保存文件到'**
  String get saveFilesTo;

  /// No description provided for @autoTmmDecides.
  ///
  /// In zh, this message translates to:
  /// **'由自动管理决定'**
  String get autoTmmDecides;

  /// No description provided for @incompleteTorrentPath.
  ///
  /// In zh, this message translates to:
  /// **'对不完整的种子使用另一个路径'**
  String get incompleteTorrentPath;

  /// No description provided for @incompleteSavePath.
  ///
  /// In zh, this message translates to:
  /// **'不完整种子保存路径'**
  String get incompleteSavePath;

  /// No description provided for @importMagnet.
  ///
  /// In zh, this message translates to:
  /// **'从磁力链接导入'**
  String get importMagnet;

  /// No description provided for @importFile.
  ///
  /// In zh, this message translates to:
  /// **'从文件导入'**
  String get importFile;

  /// No description provided for @tapToChangeLink.
  ///
  /// In zh, this message translates to:
  /// **'点击更换链接'**
  String get tapToChangeLink;

  /// No description provided for @enterMagnetOrHttp.
  ///
  /// In zh, this message translates to:
  /// **'输入磁力链接或 HTTP(S) 地址'**
  String get enterMagnetOrHttp;

  /// No description provided for @tapToChangeFile.
  ///
  /// In zh, this message translates to:
  /// **'点击更换文件'**
  String get tapToChangeFile;

  /// No description provided for @selectTorrentFile.
  ///
  /// In zh, this message translates to:
  /// **'选择 .torrent 文件'**
  String get selectTorrentFile;

  /// No description provided for @magnetOrUrl.
  ///
  /// In zh, this message translates to:
  /// **'磁力链接或 URL'**
  String get magnetOrUrl;

  /// No description provided for @enterMagnetOrUrl.
  ///
  /// In zh, this message translates to:
  /// **'请输入磁力链接或 HTTP(S) 地址'**
  String get enterMagnetOrUrl;

  /// No description provided for @importOneTorrentOnly.
  ///
  /// In zh, this message translates to:
  /// **'一次只能导入一个种子'**
  String get importOneTorrentOnly;

  /// No description provided for @torrentInfo.
  ///
  /// In zh, this message translates to:
  /// **'种子信息'**
  String get torrentInfo;

  /// No description provided for @date.
  ///
  /// In zh, this message translates to:
  /// **'日期'**
  String get date;

  /// No description provided for @fetchingMetadata.
  ///
  /// In zh, this message translates to:
  /// **'正在获取元数据…'**
  String get fetchingMetadata;

  /// No description provided for @metadataFailed.
  ///
  /// In zh, this message translates to:
  /// **'获取元数据失败'**
  String get metadataFailed;

  /// No description provided for @metadataFailedWithError.
  ///
  /// In zh, this message translates to:
  /// **'获取元数据失败：{error}'**
  String metadataFailedWithError(String error);

  /// No description provided for @filesAfterImport.
  ///
  /// In zh, this message translates to:
  /// **'导入种子后显示文件列表'**
  String get filesAfterImport;

  /// No description provided for @cannotReadTorrentFile.
  ///
  /// In zh, this message translates to:
  /// **'无法读取种子文件'**
  String get cannotReadTorrentFile;

  /// No description provided for @cannotReadSelectedFile.
  ///
  /// In zh, this message translates to:
  /// **'无法读取所选文件'**
  String get cannotReadSelectedFile;

  /// No description provided for @importTorrentFirst.
  ///
  /// In zh, this message translates to:
  /// **'请先导入种子'**
  String get importTorrentFirst;

  /// No description provided for @fetchingMetadataWait.
  ///
  /// In zh, this message translates to:
  /// **'正在获取元数据，请稍候'**
  String get fetchingMetadataWait;

  /// No description provided for @cannotAdd.
  ///
  /// In zh, this message translates to:
  /// **'无法添加'**
  String get cannotAdd;

  /// No description provided for @searchTorrents.
  ///
  /// In zh, this message translates to:
  /// **'搜索种子'**
  String get searchTorrents;

  /// No description provided for @searchPlugins.
  ///
  /// In zh, this message translates to:
  /// **'搜索插件'**
  String get searchPlugins;

  /// No description provided for @filterResults.
  ///
  /// In zh, this message translates to:
  /// **'筛选结果'**
  String get filterResults;

  /// No description provided for @stopSearch.
  ///
  /// In zh, this message translates to:
  /// **'停止搜索'**
  String get stopSearch;

  /// No description provided for @searchKeyword.
  ///
  /// In zh, this message translates to:
  /// **'搜索关键词'**
  String get searchKeyword;

  /// No description provided for @searchStarting.
  ///
  /// In zh, this message translates to:
  /// **'启动中…'**
  String get searchStarting;

  /// No description provided for @collapse.
  ///
  /// In zh, this message translates to:
  /// **'收起'**
  String get collapse;

  /// No description provided for @expandSearchForm.
  ///
  /// In zh, this message translates to:
  /// **'展开搜索条件'**
  String get expandSearchForm;

  /// No description provided for @searchCriteria.
  ///
  /// In zh, this message translates to:
  /// **'搜索条件'**
  String get searchCriteria;

  /// No description provided for @filterResultName.
  ///
  /// In zh, this message translates to:
  /// **'筛选结果名称…'**
  String get filterResultName;

  /// No description provided for @enabledPlugins.
  ///
  /// In zh, this message translates to:
  /// **'已启用插件'**
  String get enabledPlugins;

  /// No description provided for @allPlugins.
  ///
  /// In zh, this message translates to:
  /// **'全部插件'**
  String get allPlugins;

  /// No description provided for @plugin.
  ///
  /// In zh, this message translates to:
  /// **'插件'**
  String get plugin;

  /// No description provided for @searchingFound.
  ///
  /// In zh, this message translates to:
  /// **'搜索中 · 已找到 {total} 条'**
  String searchingFound(int total);

  /// No description provided for @searchingFoundVisible.
  ///
  /// In zh, this message translates to:
  /// **'搜索中 · 已找到 {total} 条（显示 {visible} 条）'**
  String searchingFoundVisible(int total, int visible);

  /// No description provided for @pythonRequired.
  ///
  /// In zh, this message translates to:
  /// **'服务器未安装 Python，无法使用搜索功能'**
  String get pythonRequired;

  /// No description provided for @searchLimitReached.
  ///
  /// In zh, this message translates to:
  /// **'进行中的搜索已达上限（最多 5 个）'**
  String get searchLimitReached;

  /// No description provided for @startSearchFailed.
  ///
  /// In zh, this message translates to:
  /// **'开始搜索失败'**
  String get startSearchFailed;

  /// No description provided for @loadPluginsFailed.
  ///
  /// In zh, this message translates to:
  /// **'加载搜索插件失败'**
  String get loadPluginsFailed;

  /// No description provided for @noSearchPlugins.
  ///
  /// In zh, this message translates to:
  /// **'未安装搜索插件'**
  String get noSearchPlugins;

  /// No description provided for @noSearchPluginsHint.
  ///
  /// In zh, this message translates to:
  /// **'请在 qBittorrent Web 端安装并启用搜索插件'**
  String get noSearchPluginsHint;

  /// No description provided for @searchIdleHint.
  ///
  /// In zh, this message translates to:
  /// **'输入关键词并选择分类 / 插件后开始搜索'**
  String get searchIdleHint;

  /// No description provided for @searching.
  ///
  /// In zh, this message translates to:
  /// **'搜索中'**
  String get searching;

  /// No description provided for @searchingHint.
  ///
  /// In zh, this message translates to:
  /// **'正在从插件获取结果…'**
  String get searchingHint;

  /// No description provided for @noMatchingResults.
  ///
  /// In zh, this message translates to:
  /// **'无匹配结果'**
  String get noMatchingResults;

  /// No description provided for @noResults.
  ///
  /// In zh, this message translates to:
  /// **'未找到结果'**
  String get noResults;

  /// No description provided for @adjustFiltersHint.
  ///
  /// In zh, this message translates to:
  /// **'试试调整筛选条件'**
  String get adjustFiltersHint;

  /// No description provided for @retrySearchHint.
  ///
  /// In zh, this message translates to:
  /// **'可更换关键词或插件重试'**
  String get retrySearchHint;

  /// No description provided for @allCategories.
  ///
  /// In zh, this message translates to:
  /// **'全部分类'**
  String get allCategories;

  /// No description provided for @searchCategoryAnime.
  ///
  /// In zh, this message translates to:
  /// **'动画'**
  String get searchCategoryAnime;

  /// No description provided for @searchCategoryBooks.
  ///
  /// In zh, this message translates to:
  /// **'书籍'**
  String get searchCategoryBooks;

  /// No description provided for @searchCategoryGames.
  ///
  /// In zh, this message translates to:
  /// **'游戏'**
  String get searchCategoryGames;

  /// No description provided for @searchCategoryMovies.
  ///
  /// In zh, this message translates to:
  /// **'电影'**
  String get searchCategoryMovies;

  /// No description provided for @searchCategoryMusic.
  ///
  /// In zh, this message translates to:
  /// **'音乐'**
  String get searchCategoryMusic;

  /// No description provided for @searchCategoryPictures.
  ///
  /// In zh, this message translates to:
  /// **'图片'**
  String get searchCategoryPictures;

  /// No description provided for @searchCategorySoftware.
  ///
  /// In zh, this message translates to:
  /// **'软件'**
  String get searchCategorySoftware;

  /// No description provided for @searchCategoryTv.
  ///
  /// In zh, this message translates to:
  /// **'电视节目'**
  String get searchCategoryTv;

  /// No description provided for @searchJobNotFound.
  ///
  /// In zh, this message translates to:
  /// **'搜索任务不存在'**
  String get searchJobNotFound;

  /// No description provided for @searchResultsUnavailable.
  ///
  /// In zh, this message translates to:
  /// **'搜索结果已不可用'**
  String get searchResultsUnavailable;

  /// No description provided for @seedingCount.
  ///
  /// In zh, this message translates to:
  /// **'做种 {count}'**
  String seedingCount(String count);

  /// No description provided for @leechingCount.
  ///
  /// In zh, this message translates to:
  /// **'下载 {count}'**
  String leechingCount(String count);

  /// No description provided for @unknownSize.
  ///
  /// In zh, this message translates to:
  /// **'未知大小'**
  String get unknownSize;

  /// No description provided for @cannotOpenDescription.
  ///
  /// In zh, this message translates to:
  /// **'无法打开描述页'**
  String get cannotOpenDescription;

  /// No description provided for @copiedName.
  ///
  /// In zh, this message translates to:
  /// **'已复制名称'**
  String get copiedName;

  /// No description provided for @copiedDownloadLink.
  ///
  /// In zh, this message translates to:
  /// **'已复制下载链接'**
  String get copiedDownloadLink;

  /// No description provided for @copiedDescriptionUrl.
  ///
  /// In zh, this message translates to:
  /// **'已复制描述页 URL'**
  String get copiedDescriptionUrl;

  /// No description provided for @openDescription.
  ///
  /// In zh, this message translates to:
  /// **'打开描述页'**
  String get openDescription;

  /// No description provided for @copyName.
  ///
  /// In zh, this message translates to:
  /// **'复制名称'**
  String get copyName;

  /// No description provided for @copyDownloadLink.
  ///
  /// In zh, this message translates to:
  /// **'复制下载链接'**
  String get copyDownloadLink;

  /// No description provided for @copyDescriptionUrl.
  ///
  /// In zh, this message translates to:
  /// **'复制描述页 URL'**
  String get copyDescriptionUrl;

  /// No description provided for @resultFilter.
  ///
  /// In zh, this message translates to:
  /// **'结果筛选'**
  String get resultFilter;

  /// No description provided for @resultFilterHint.
  ///
  /// In zh, this message translates to:
  /// **'对齐 Web 端：0 表示不限制。大小单位按 1024 进制换算。'**
  String get resultFilterHint;

  /// No description provided for @seeders.
  ///
  /// In zh, this message translates to:
  /// **'做种数'**
  String get seeders;

  /// No description provided for @minValue.
  ///
  /// In zh, this message translates to:
  /// **'最小'**
  String get minValue;

  /// No description provided for @maxValue.
  ///
  /// In zh, this message translates to:
  /// **'最大'**
  String get maxValue;

  /// No description provided for @rangeTo.
  ///
  /// In zh, this message translates to:
  /// **'至'**
  String get rangeTo;

  /// No description provided for @pluginVersion.
  ///
  /// In zh, this message translates to:
  /// **'版本 {version}'**
  String pluginVersion(String version);

  /// No description provided for @deletePlugin.
  ///
  /// In zh, this message translates to:
  /// **'删除插件'**
  String get deletePlugin;

  /// No description provided for @installPlugin.
  ///
  /// In zh, this message translates to:
  /// **'安装插件'**
  String get installPlugin;

  /// No description provided for @checkingUpdates.
  ///
  /// In zh, this message translates to:
  /// **'检查中…'**
  String get checkingUpdates;

  /// No description provided for @checkUpdates.
  ///
  /// In zh, this message translates to:
  /// **'检查更新'**
  String get checkUpdates;

  /// No description provided for @searchPluginCopyrightWarning.
  ///
  /// In zh, this message translates to:
  /// **'警告：在下载来自这些搜索引擎的 torrent 时，请确认它符合您所在国家的版权法。'**
  String get searchPluginCopyrightWarning;

  /// No description provided for @searchPluginGetMore.
  ///
  /// In zh, this message translates to:
  /// **'你可以在这里获取新的搜索引擎插件：'**
  String get searchPluginGetMore;

  /// No description provided for @noSearchPluginsList.
  ///
  /// In zh, this message translates to:
  /// **'暂无搜索插件'**
  String get noSearchPluginsList;

  /// No description provided for @noSearchPluginsListHint.
  ///
  /// In zh, this message translates to:
  /// **'点击「安装插件」或「检查更新」获取官方插件'**
  String get noSearchPluginsListHint;

  /// No description provided for @cannotOpenLink.
  ///
  /// In zh, this message translates to:
  /// **'无法打开链接'**
  String get cannotOpenLink;

  /// No description provided for @installing.
  ///
  /// In zh, this message translates to:
  /// **'安装中…'**
  String get installing;

  /// No description provided for @pluginInstalled.
  ///
  /// In zh, this message translates to:
  /// **'插件已安装'**
  String get pluginInstalled;

  /// No description provided for @installFailed.
  ///
  /// In zh, this message translates to:
  /// **'安装失败：{error}'**
  String installFailed(String error);

  /// No description provided for @pluginsUpdated.
  ///
  /// In zh, this message translates to:
  /// **'插件列表已更新'**
  String get pluginsUpdated;

  /// No description provided for @checkUpdatesFailed.
  ///
  /// In zh, this message translates to:
  /// **'检查更新失败：{error}'**
  String checkUpdatesFailed(String error);

  /// No description provided for @operationFailed.
  ///
  /// In zh, this message translates to:
  /// **'操作失败：{error}'**
  String operationFailed(String error);

  /// No description provided for @confirmUninstallPlugin.
  ///
  /// In zh, this message translates to:
  /// **'确定卸载 {name}？'**
  String confirmUninstallPlugin(String name);

  /// No description provided for @pluginDeleted.
  ///
  /// In zh, this message translates to:
  /// **'插件已删除'**
  String get pluginDeleted;

  /// No description provided for @enterPluginSource.
  ///
  /// In zh, this message translates to:
  /// **'请输入插件 URL 或路径'**
  String get enterPluginSource;

  /// No description provided for @installSearchPlugin.
  ///
  /// In zh, this message translates to:
  /// **'安装搜索插件'**
  String get installSearchPlugin;

  /// No description provided for @installPluginHint.
  ///
  /// In zh, this message translates to:
  /// **'输入插件 .py 的 URL，或 qB 服务器上的文件路径。多个来源可用换行分隔。'**
  String get installPluginHint;

  /// No description provided for @pluginSource.
  ///
  /// In zh, this message translates to:
  /// **'插件来源'**
  String get pluginSource;

  /// No description provided for @actionEdit.
  ///
  /// In zh, this message translates to:
  /// **'编辑'**
  String get actionEdit;

  /// No description provided for @actionReset.
  ///
  /// In zh, this message translates to:
  /// **'重置'**
  String get actionReset;

  /// No description provided for @actionGenerate.
  ///
  /// In zh, this message translates to:
  /// **'生成'**
  String get actionGenerate;

  /// No description provided for @actionSend.
  ///
  /// In zh, this message translates to:
  /// **'发送'**
  String get actionSend;

  /// No description provided for @validating.
  ///
  /// In zh, this message translates to:
  /// **'校验中…'**
  String get validating;

  /// No description provided for @listSeparator.
  ///
  /// In zh, this message translates to:
  /// **'、'**
  String get listSeparator;

  /// No description provided for @pleaseFillFields.
  ///
  /// In zh, this message translates to:
  /// **'请填写：{fields}'**
  String pleaseFillFields(String fields);

  /// No description provided for @serverNotFound.
  ///
  /// In zh, this message translates to:
  /// **'服务器不存在或已删除'**
  String get serverNotFound;

  /// No description provided for @cannotGetApiVersion.
  ///
  /// In zh, this message translates to:
  /// **'无法获取 API 版本'**
  String get cannotGetApiVersion;

  /// No description provided for @probeFailed.
  ///
  /// In zh, this message translates to:
  /// **'校验失败：{error}'**
  String probeFailed(String error);

  /// No description provided for @saveFailedServerGone.
  ///
  /// In zh, this message translates to:
  /// **'保存失败：服务器不存在或已删除'**
  String get saveFailedServerGone;

  /// No description provided for @unitSeconds.
  ///
  /// In zh, this message translates to:
  /// **'秒'**
  String get unitSeconds;

  /// No description provided for @unitMilliseconds.
  ///
  /// In zh, this message translates to:
  /// **'毫秒'**
  String get unitMilliseconds;

  /// No description provided for @unlimitedHint.
  ///
  /// In zh, this message translates to:
  /// **'0 为无限制'**
  String get unlimitedHint;

  /// No description provided for @qbSetBehavior.
  ///
  /// In zh, this message translates to:
  /// **'行为'**
  String get qbSetBehavior;

  /// No description provided for @qbSetDownloads.
  ///
  /// In zh, this message translates to:
  /// **'下载'**
  String get qbSetDownloads;

  /// No description provided for @qbSetConnection.
  ///
  /// In zh, this message translates to:
  /// **'连接'**
  String get qbSetConnection;

  /// No description provided for @qbSetSpeed.
  ///
  /// In zh, this message translates to:
  /// **'速度'**
  String get qbSetSpeed;

  /// No description provided for @qbSetAdvanced.
  ///
  /// In zh, this message translates to:
  /// **'高级'**
  String get qbSetAdvanced;

  /// No description provided for @qbSetDisclaimer.
  ///
  /// In zh, this message translates to:
  /// **'此处修改的是当前 qBittorrent 服务器的选项。部分设置仅作用于服务器或 WebUI，不会影响本 App 的界面与行为。'**
  String get qbSetDisclaimer;

  /// No description provided for @currentServerSettings.
  ///
  /// In zh, this message translates to:
  /// **'当前服务器设置'**
  String get currentServerSettings;

  /// No description provided for @addServer.
  ///
  /// In zh, this message translates to:
  /// **'添加服务器'**
  String get addServer;

  /// No description provided for @editServer.
  ///
  /// In zh, this message translates to:
  /// **'编辑服务器'**
  String get editServer;

  /// No description provided for @serverListHint.
  ///
  /// In zh, this message translates to:
  /// **'点击切换服务器，点击右上角可以修改服务器设置'**
  String get serverListHint;

  /// No description provided for @noServersHint.
  ///
  /// In zh, this message translates to:
  /// **'点击右下角添加一台 qBittorrent 服务器'**
  String get noServersHint;

  /// No description provided for @deleteServer.
  ///
  /// In zh, this message translates to:
  /// **'删除服务器'**
  String get deleteServer;

  /// No description provided for @confirmDeleteServer.
  ///
  /// In zh, this message translates to:
  /// **'确定删除「{name}」吗？此操作不可恢复。'**
  String confirmDeleteServer(String name);

  /// No description provided for @serverName.
  ///
  /// In zh, this message translates to:
  /// **'服务器名称'**
  String get serverName;

  /// No description provided for @serverNameHint.
  ///
  /// In zh, this message translates to:
  /// **'服务器名称，例如：我的NAS'**
  String get serverNameHint;

  /// No description provided for @host.
  ///
  /// In zh, this message translates to:
  /// **'域名或IP'**
  String get host;

  /// No description provided for @hostHint.
  ///
  /// In zh, this message translates to:
  /// **'域名或IP，例如：my.nas.com, 192.168.1.1'**
  String get hostHint;

  /// No description provided for @port.
  ///
  /// In zh, this message translates to:
  /// **'端口'**
  String get port;

  /// No description provided for @portHint.
  ///
  /// In zh, this message translates to:
  /// **'端口，例如：8888'**
  String get portHint;

  /// No description provided for @pathHint.
  ///
  /// In zh, this message translates to:
  /// **'路径，不包含“/”符号，例如：nas/qb'**
  String get pathHint;

  /// No description provided for @apiKey.
  ///
  /// In zh, this message translates to:
  /// **'API密钥'**
  String get apiKey;

  /// No description provided for @apiKeyHint.
  ///
  /// In zh, this message translates to:
  /// **'API密钥，请在WebUI上生成密钥'**
  String get apiKeyHint;

  /// No description provided for @useHttps.
  ///
  /// In zh, this message translates to:
  /// **'使用HTTPS'**
  String get useHttps;

  /// No description provided for @schedulerEveryDay.
  ///
  /// In zh, this message translates to:
  /// **'每天'**
  String get schedulerEveryDay;

  /// No description provided for @schedulerWeekdays.
  ///
  /// In zh, this message translates to:
  /// **'工作日'**
  String get schedulerWeekdays;

  /// No description provided for @schedulerWeekends.
  ///
  /// In zh, this message translates to:
  /// **'周末'**
  String get schedulerWeekends;

  /// No description provided for @schedulerMonday.
  ///
  /// In zh, this message translates to:
  /// **'周一'**
  String get schedulerMonday;

  /// No description provided for @schedulerTuesday.
  ///
  /// In zh, this message translates to:
  /// **'周二'**
  String get schedulerTuesday;

  /// No description provided for @schedulerWednesday.
  ///
  /// In zh, this message translates to:
  /// **'周三'**
  String get schedulerWednesday;

  /// No description provided for @schedulerThursday.
  ///
  /// In zh, this message translates to:
  /// **'周四'**
  String get schedulerThursday;

  /// No description provided for @schedulerFriday.
  ///
  /// In zh, this message translates to:
  /// **'周五'**
  String get schedulerFriday;

  /// No description provided for @schedulerSaturday.
  ///
  /// In zh, this message translates to:
  /// **'周六'**
  String get schedulerSaturday;

  /// No description provided for @schedulerSunday.
  ///
  /// In zh, this message translates to:
  /// **'周日'**
  String get schedulerSunday;

  /// No description provided for @peerProtocolTcpAndUtp.
  ///
  /// In zh, this message translates to:
  /// **'TCP 和 μTP'**
  String get peerProtocolTcpAndUtp;

  /// No description provided for @proxyTypeNone.
  ///
  /// In zh, this message translates to:
  /// **'(无)'**
  String get proxyTypeNone;

  /// No description provided for @btEncryptAllow.
  ///
  /// In zh, this message translates to:
  /// **'允许加密'**
  String get btEncryptAllow;

  /// No description provided for @btEncryptRequire.
  ///
  /// In zh, this message translates to:
  /// **'强制加密'**
  String get btEncryptRequire;

  /// No description provided for @btEncryptDisable.
  ///
  /// In zh, this message translates to:
  /// **'禁用加密'**
  String get btEncryptDisable;

  /// No description provided for @btRatioStop.
  ///
  /// In zh, this message translates to:
  /// **'停止 torrent'**
  String get btRatioStop;

  /// No description provided for @btRatioRemove.
  ///
  /// In zh, this message translates to:
  /// **'删除 torrent'**
  String get btRatioRemove;

  /// No description provided for @btRatioRemoveAndFiles.
  ///
  /// In zh, this message translates to:
  /// **'删除 torrent 及所属文件'**
  String get btRatioRemoveAndFiles;

  /// No description provided for @btRatioSuperSeeding.
  ///
  /// In zh, this message translates to:
  /// **'为 torrent 启用超级做种'**
  String get btRatioSuperSeeding;

  /// No description provided for @logAgeDays.
  ///
  /// In zh, this message translates to:
  /// **'天'**
  String get logAgeDays;

  /// No description provided for @logAgeMonths.
  ///
  /// In zh, this message translates to:
  /// **'月'**
  String get logAgeMonths;

  /// No description provided for @logAgeYears.
  ///
  /// In zh, this message translates to:
  /// **'年'**
  String get logAgeYears;

  /// No description provided for @tmmRelocateTorrent.
  ///
  /// In zh, this message translates to:
  /// **'重新定位 Torrent'**
  String get tmmRelocateTorrent;

  /// No description provided for @tmmRelocateAffected.
  ///
  /// In zh, this message translates to:
  /// **'重新定位受影响的 Torrent'**
  String get tmmRelocateAffected;

  /// No description provided for @tmmSwitchTorrentManual.
  ///
  /// In zh, this message translates to:
  /// **'切换 Torrent 到手动模式'**
  String get tmmSwitchTorrentManual;

  /// No description provided for @tmmSwitchAffectedManual.
  ///
  /// In zh, this message translates to:
  /// **'切换受影响的 torrent 至手动模式'**
  String get tmmSwitchAffectedManual;

  /// No description provided for @resumeFastresume.
  ///
  /// In zh, this message translates to:
  /// **'Fastresume 文件'**
  String get resumeFastresume;

  /// No description provided for @resumeSqlite.
  ///
  /// In zh, this message translates to:
  /// **'SQLite 数据库（实验性）'**
  String get resumeSqlite;

  /// No description provided for @removeDeleteFiles.
  ///
  /// In zh, this message translates to:
  /// **'永久删除文件'**
  String get removeDeleteFiles;

  /// No description provided for @removeMoveToTrash.
  ///
  /// In zh, this message translates to:
  /// **'移到回收站（如可能）'**
  String get removeMoveToTrash;

  /// No description provided for @diskIoMemoryMapped.
  ///
  /// In zh, this message translates to:
  /// **'内存映射文件'**
  String get diskIoMemoryMapped;

  /// No description provided for @diskIoPosix.
  ///
  /// In zh, this message translates to:
  /// **'POSIX 兼容'**
  String get diskIoPosix;

  /// No description provided for @diskIoSimplePread.
  ///
  /// In zh, this message translates to:
  /// **'简单 pread/pwrite'**
  String get diskIoSimplePread;

  /// No description provided for @osCacheDisable.
  ///
  /// In zh, this message translates to:
  /// **'禁用 OS 缓存'**
  String get osCacheDisable;

  /// No description provided for @osCacheEnable.
  ///
  /// In zh, this message translates to:
  /// **'启用 OS 缓存'**
  String get osCacheEnable;

  /// No description provided for @osCacheWriteThrough.
  ///
  /// In zh, this message translates to:
  /// **'直写'**
  String get osCacheWriteThrough;

  /// No description provided for @utpPreferTcp.
  ///
  /// In zh, this message translates to:
  /// **'首选 TCP'**
  String get utpPreferTcp;

  /// No description provided for @utpPeerProportional.
  ///
  /// In zh, this message translates to:
  /// **'与 peer 成比例（限制 TCP）'**
  String get utpPeerProportional;

  /// No description provided for @uploadSlotsFixed.
  ///
  /// In zh, this message translates to:
  /// **'固定槽位'**
  String get uploadSlotsFixed;

  /// No description provided for @uploadSlotsRateBased.
  ///
  /// In zh, this message translates to:
  /// **'基于上传速率'**
  String get uploadSlotsRateBased;

  /// No description provided for @chokeRoundRobin.
  ///
  /// In zh, this message translates to:
  /// **'轮询'**
  String get chokeRoundRobin;

  /// No description provided for @chokeFastestUpload.
  ///
  /// In zh, this message translates to:
  /// **'最快上传'**
  String get chokeFastestUpload;

  /// No description provided for @chokeAntiLeech.
  ///
  /// In zh, this message translates to:
  /// **'反吸血'**
  String get chokeAntiLeech;

  /// No description provided for @bindAllAddresses.
  ///
  /// In zh, this message translates to:
  /// **'所有地址'**
  String get bindAllAddresses;

  /// No description provided for @bindAllIpv4.
  ///
  /// In zh, this message translates to:
  /// **'所有 IPv4 地址'**
  String get bindAllIpv4;

  /// No description provided for @bindAllIpv6.
  ///
  /// In zh, this message translates to:
  /// **'所有 IPv6 地址'**
  String get bindAllIpv6;

  /// No description provided for @anyInterface.
  ///
  /// In zh, this message translates to:
  /// **'任意接口'**
  String get anyInterface;

  /// No description provided for @qbWebUiLanguage.
  ///
  /// In zh, this message translates to:
  /// **'用户界面语言'**
  String get qbWebUiLanguage;

  /// No description provided for @transferList.
  ///
  /// In zh, this message translates to:
  /// **'传输列表'**
  String get transferList;

  /// No description provided for @confirmTorrentDeletion.
  ///
  /// In zh, this message translates to:
  /// **'删除 Torrent 时提示确认'**
  String get confirmTorrentDeletion;

  /// No description provided for @showExternalIp.
  ///
  /// In zh, this message translates to:
  /// **'在状态栏展示外部 IP'**
  String get showExternalIp;

  /// No description provided for @logFile.
  ///
  /// In zh, this message translates to:
  /// **'日志文件'**
  String get logFile;

  /// No description provided for @enableLogFile.
  ///
  /// In zh, this message translates to:
  /// **'启用日志文件'**
  String get enableLogFile;

  /// No description provided for @backupLogWhenLarger.
  ///
  /// In zh, this message translates to:
  /// **'当大于指定大小时备份日志文件'**
  String get backupLogWhenLarger;

  /// No description provided for @deleteOldBackupLogs.
  ///
  /// In zh, this message translates to:
  /// **'删除早于指定时间的备份日志文件'**
  String get deleteOldBackupLogs;

  /// No description provided for @logAge.
  ///
  /// In zh, this message translates to:
  /// **'时间'**
  String get logAge;

  /// No description provided for @logPerformanceWarning.
  ///
  /// In zh, this message translates to:
  /// **'记录性能警报'**
  String get logPerformanceWarning;

  /// No description provided for @invalidLogBackupSize.
  ///
  /// In zh, this message translates to:
  /// **'请填写有效的日志备份大小'**
  String get invalidLogBackupSize;

  /// No description provided for @invalidLogRetention.
  ///
  /// In zh, this message translates to:
  /// **'请填写有效的日志保留时间'**
  String get invalidLogRetention;

  /// No description provided for @scheduleAltSpeed.
  ///
  /// In zh, this message translates to:
  /// **'计划备用速度限制的启用时间'**
  String get scheduleAltSpeed;

  /// No description provided for @scheduleFrom.
  ///
  /// In zh, this message translates to:
  /// **'从'**
  String get scheduleFrom;

  /// No description provided for @scheduleTo.
  ///
  /// In zh, this message translates to:
  /// **'到'**
  String get scheduleTo;

  /// No description provided for @scheduleWhen.
  ///
  /// In zh, this message translates to:
  /// **'时间'**
  String get scheduleWhen;

  /// No description provided for @rateLimitOptions.
  ///
  /// In zh, this message translates to:
  /// **'设置速度限制'**
  String get rateLimitOptions;

  /// No description provided for @limitUtpRate.
  ///
  /// In zh, this message translates to:
  /// **'对 µTP 协议进行速度限制'**
  String get limitUtpRate;

  /// No description provided for @limitOverhead.
  ///
  /// In zh, this message translates to:
  /// **'对传送总开销进行速度限制'**
  String get limitOverhead;

  /// No description provided for @limitLanPeers.
  ///
  /// In zh, this message translates to:
  /// **'对本地网络用户进行速度限制'**
  String get limitLanPeers;

  /// No description provided for @invalidSpeedLimit.
  ///
  /// In zh, this message translates to:
  /// **'速度限制必须大于等于 0（0 为无限制）'**
  String get invalidSpeedLimit;

  /// No description provided for @peerConnectionProtocol.
  ///
  /// In zh, this message translates to:
  /// **'对等节点连接协议'**
  String get peerConnectionProtocol;

  /// No description provided for @listeningPort.
  ///
  /// In zh, this message translates to:
  /// **'监听端口'**
  String get listeningPort;

  /// No description provided for @incomingConnectionsPort.
  ///
  /// In zh, this message translates to:
  /// **'用于传入连接的端口'**
  String get incomingConnectionsPort;

  /// No description provided for @actionRandom.
  ///
  /// In zh, this message translates to:
  /// **'随机'**
  String get actionRandom;

  /// No description provided for @upnpPortForward.
  ///
  /// In zh, this message translates to:
  /// **'使用我的路由器的 UPnP / NAT-PMP 端口转发'**
  String get upnpPortForward;

  /// No description provided for @connectionLimits.
  ///
  /// In zh, this message translates to:
  /// **'连接限制'**
  String get connectionLimits;

  /// No description provided for @maxConnectionsGlobal.
  ///
  /// In zh, this message translates to:
  /// **'全局最大连接数'**
  String get maxConnectionsGlobal;

  /// No description provided for @maxConnectionsPerTorrent.
  ///
  /// In zh, this message translates to:
  /// **'每 torrent 最大连接数'**
  String get maxConnectionsPerTorrent;

  /// No description provided for @maxUploadsGlobal.
  ///
  /// In zh, this message translates to:
  /// **'全局上传窗口数上限'**
  String get maxUploadsGlobal;

  /// No description provided for @maxUploadsPerTorrent.
  ///
  /// In zh, this message translates to:
  /// **'每个 torrent 上传窗口数上限'**
  String get maxUploadsPerTorrent;

  /// No description provided for @i2pExperimental.
  ///
  /// In zh, this message translates to:
  /// **'I2P（实验性）'**
  String get i2pExperimental;

  /// No description provided for @mixedMode.
  ///
  /// In zh, this message translates to:
  /// **'混合模式'**
  String get mixedMode;

  /// No description provided for @proxyServer.
  ///
  /// In zh, this message translates to:
  /// **'代理服务器'**
  String get proxyServer;

  /// No description provided for @proxyType.
  ///
  /// In zh, this message translates to:
  /// **'类型'**
  String get proxyType;

  /// No description provided for @proxyHostnameLookup.
  ///
  /// In zh, this message translates to:
  /// **'通过代理查找主机名'**
  String get proxyHostnameLookup;

  /// No description provided for @authentication.
  ///
  /// In zh, this message translates to:
  /// **'验证'**
  String get authentication;

  /// No description provided for @username.
  ///
  /// In zh, this message translates to:
  /// **'用户名'**
  String get username;

  /// No description provided for @password.
  ///
  /// In zh, this message translates to:
  /// **'密码'**
  String get password;

  /// No description provided for @passwordStoredUnencrypted.
  ///
  /// In zh, this message translates to:
  /// **'注意：密码以非加密形式保存'**
  String get passwordStoredUnencrypted;

  /// No description provided for @proxyForBittorrent.
  ///
  /// In zh, this message translates to:
  /// **'对 BitTorrent 目的使用代理'**
  String get proxyForBittorrent;

  /// No description provided for @proxyForPeerConnections.
  ///
  /// In zh, this message translates to:
  /// **'使用代理服务器进行用户连接'**
  String get proxyForPeerConnections;

  /// No description provided for @proxyForRss.
  ///
  /// In zh, this message translates to:
  /// **'对 RSS 目的使用代理'**
  String get proxyForRss;

  /// No description provided for @proxyForGeneral.
  ///
  /// In zh, this message translates to:
  /// **'对常规目的使用代理'**
  String get proxyForGeneral;

  /// No description provided for @ipFiltering.
  ///
  /// In zh, this message translates to:
  /// **'IP 过滤'**
  String get ipFiltering;

  /// No description provided for @ipFilterPath.
  ///
  /// In zh, this message translates to:
  /// **'过滤规则路径 (.dat, .p2p, .p2b)'**
  String get ipFilterPath;

  /// No description provided for @filterTrackers.
  ///
  /// In zh, this message translates to:
  /// **'匹配 tracker'**
  String get filterTrackers;

  /// No description provided for @manuallyBannedIps.
  ///
  /// In zh, this message translates to:
  /// **'手动屏蔽 IP 地址'**
  String get manuallyBannedIps;

  /// No description provided for @oneIpPerLine.
  ///
  /// In zh, this message translates to:
  /// **'每行一个 IP'**
  String get oneIpPerLine;

  /// No description provided for @invalidListenPort.
  ///
  /// In zh, this message translates to:
  /// **'用于传入连接的端口必须在 0 到 65535 之间'**
  String get invalidListenPort;

  /// No description provided for @invalidMaxConnections.
  ///
  /// In zh, this message translates to:
  /// **'全局最大连接数必须大于 0 或关闭'**
  String get invalidMaxConnections;

  /// No description provided for @invalidMaxConnectionsPerTorrent.
  ///
  /// In zh, this message translates to:
  /// **'每 torrent 最大连接数必须大于 0 或关闭'**
  String get invalidMaxConnectionsPerTorrent;

  /// No description provided for @invalidMaxUploads.
  ///
  /// In zh, this message translates to:
  /// **'全局上传窗口数上限必须大于 0 或关闭'**
  String get invalidMaxUploads;

  /// No description provided for @invalidMaxUploadsPerTorrent.
  ///
  /// In zh, this message translates to:
  /// **'每个 torrent 上传窗口数上限必须大于 0 或关闭'**
  String get invalidMaxUploadsPerTorrent;

  /// No description provided for @invalidProxyPort.
  ///
  /// In zh, this message translates to:
  /// **'代理端口必须在 0 到 65535 之间'**
  String get invalidProxyPort;

  /// No description provided for @invalidI2pPort.
  ///
  /// In zh, this message translates to:
  /// **'I2P 端口必须在 0 到 65535 之间'**
  String get invalidI2pPort;

  /// No description provided for @privacy.
  ///
  /// In zh, this message translates to:
  /// **'隐私'**
  String get privacy;

  /// No description provided for @enableDht.
  ///
  /// In zh, this message translates to:
  /// **'启用 DHT (去中心化网络) 以找到更多用户'**
  String get enableDht;

  /// No description provided for @enablePex.
  ///
  /// In zh, this message translates to:
  /// **'启用用户交换 (PeX) 以找到更多用户'**
  String get enablePex;

  /// No description provided for @enableLsd.
  ///
  /// In zh, this message translates to:
  /// **'启用本地用户发现以找到更多用户'**
  String get enableLsd;

  /// No description provided for @encryptionMode.
  ///
  /// In zh, this message translates to:
  /// **'加密模式'**
  String get encryptionMode;

  /// No description provided for @anonymousMode.
  ///
  /// In zh, this message translates to:
  /// **'启用匿名模式'**
  String get anonymousMode;

  /// No description provided for @maxActiveCheckingTorrents.
  ///
  /// In zh, this message translates to:
  /// **'最大活跃检查 Torrent 数'**
  String get maxActiveCheckingTorrents;

  /// No description provided for @maxActiveDownloads.
  ///
  /// In zh, this message translates to:
  /// **'最大活动的下载数'**
  String get maxActiveDownloads;

  /// No description provided for @maxActiveUploads.
  ///
  /// In zh, this message translates to:
  /// **'最大活动的上传数'**
  String get maxActiveUploads;

  /// No description provided for @maxActiveTorrents.
  ///
  /// In zh, this message translates to:
  /// **'最大活动的 torrent 数'**
  String get maxActiveTorrents;

  /// No description provided for @ignoreSlowTorrents.
  ///
  /// In zh, this message translates to:
  /// **'慢速 torrent 不计入限制内'**
  String get ignoreSlowTorrents;

  /// No description provided for @downloadRateThreshold.
  ///
  /// In zh, this message translates to:
  /// **'下载速度阈值'**
  String get downloadRateThreshold;

  /// No description provided for @uploadRateThreshold.
  ///
  /// In zh, this message translates to:
  /// **'上传速度阈值'**
  String get uploadRateThreshold;

  /// No description provided for @torrentInactivityTimer.
  ///
  /// In zh, this message translates to:
  /// **'Torrent 非活动计时器'**
  String get torrentInactivityTimer;

  /// No description provided for @seedingLimits.
  ///
  /// In zh, this message translates to:
  /// **'做种限制'**
  String get seedingLimits;

  /// No description provided for @whenRatioReaches.
  ///
  /// In zh, this message translates to:
  /// **'当分享率达到'**
  String get whenRatioReaches;

  /// No description provided for @whenSeedingTimeReaches.
  ///
  /// In zh, this message translates to:
  /// **'达到总做种时间时'**
  String get whenSeedingTimeReaches;

  /// No description provided for @whenInactiveSeedingTimeReaches.
  ///
  /// In zh, this message translates to:
  /// **'达到不活跃做种时间时'**
  String get whenInactiveSeedingTimeReaches;

  /// No description provided for @then.
  ///
  /// In zh, this message translates to:
  /// **'然后'**
  String get then;

  /// No description provided for @autoAddTrackers.
  ///
  /// In zh, this message translates to:
  /// **'自动附加这些 tracker 到新下载'**
  String get autoAddTrackers;

  /// No description provided for @oneTrackerPerLine.
  ///
  /// In zh, this message translates to:
  /// **'每行一个 tracker'**
  String get oneTrackerPerLine;

  /// No description provided for @autoAddTrackersFromUrl.
  ///
  /// In zh, this message translates to:
  /// **'自动添加 URL 中的 trackers 到新的下载'**
  String get autoAddTrackersFromUrl;

  /// No description provided for @url.
  ///
  /// In zh, this message translates to:
  /// **'网址'**
  String get url;

  /// No description provided for @fetchedTrackers.
  ///
  /// In zh, this message translates to:
  /// **'获取 tracker'**
  String get fetchedTrackers;

  /// No description provided for @invalidMaxActiveChecking.
  ///
  /// In zh, this message translates to:
  /// **'最大活跃检查 Torrent 数必须大于 -1'**
  String get invalidMaxActiveChecking;

  /// No description provided for @invalidMaxActiveDownloads.
  ///
  /// In zh, this message translates to:
  /// **'最大活动的下载数必须大于 -1'**
  String get invalidMaxActiveDownloads;

  /// No description provided for @invalidMaxActiveUploads.
  ///
  /// In zh, this message translates to:
  /// **'最大活动的上传数必须大于 -1'**
  String get invalidMaxActiveUploads;

  /// No description provided for @invalidMaxActiveTorrents.
  ///
  /// In zh, this message translates to:
  /// **'最大活动的 torrent 数必须大于 -1'**
  String get invalidMaxActiveTorrents;

  /// No description provided for @invalidDownloadRateThreshold.
  ///
  /// In zh, this message translates to:
  /// **'下载速度阈值必须大于 0'**
  String get invalidDownloadRateThreshold;

  /// No description provided for @invalidUploadRateThreshold.
  ///
  /// In zh, this message translates to:
  /// **'上传速度阈值必须大于 0'**
  String get invalidUploadRateThreshold;

  /// No description provided for @invalidTorrentInactivityTimer.
  ///
  /// In zh, this message translates to:
  /// **'Torrent 非活动计时器必须大于 0'**
  String get invalidTorrentInactivityTimer;

  /// No description provided for @invalidShareRatio.
  ///
  /// In zh, this message translates to:
  /// **'分享率限制不能为负数'**
  String get invalidShareRatio;

  /// No description provided for @invalidSeedingTime.
  ///
  /// In zh, this message translates to:
  /// **'做种时间限制不能为负数'**
  String get invalidSeedingTime;

  /// No description provided for @invalidInactiveSeedingTime.
  ///
  /// In zh, this message translates to:
  /// **'不活跃做种时间限制不能为负数'**
  String get invalidInactiveSeedingTime;

  /// No description provided for @whenAddingTorrent.
  ///
  /// In zh, this message translates to:
  /// **'添加 torrent 时'**
  String get whenAddingTorrent;

  /// No description provided for @doNotStartDownload.
  ///
  /// In zh, this message translates to:
  /// **'不要自动开始下载'**
  String get doNotStartDownload;

  /// No description provided for @whenDuplicateTorrent.
  ///
  /// In zh, this message translates to:
  /// **'添加重复种子时'**
  String get whenDuplicateTorrent;

  /// No description provided for @mergeTrackers.
  ///
  /// In zh, this message translates to:
  /// **'合并 tracker 到现有 torrent'**
  String get mergeTrackers;

  /// No description provided for @deleteTorrentFileWhenDone.
  ///
  /// In zh, this message translates to:
  /// **'完成后删除 .torrent 文件'**
  String get deleteTorrentFileWhenDone;

  /// No description provided for @preallocateAll.
  ///
  /// In zh, this message translates to:
  /// **'为所有文件预分配磁盘空间'**
  String get preallocateAll;

  /// No description provided for @appendIncompleteExt.
  ///
  /// In zh, this message translates to:
  /// **'为不完整的文件添加扩展名 .!qB'**
  String get appendIncompleteExt;

  /// No description provided for @keepUnwantedInFolder.
  ///
  /// In zh, this message translates to:
  /// **'将未选中的文件保留在 \".unwanted\" 文件夹中'**
  String get keepUnwantedInFolder;

  /// No description provided for @saveManagement.
  ///
  /// In zh, this message translates to:
  /// **'保存管理'**
  String get saveManagement;

  /// No description provided for @defaultTmmMode.
  ///
  /// In zh, this message translates to:
  /// **'默认 Torrent 管理模式'**
  String get defaultTmmMode;

  /// No description provided for @whenTorrentCategoryChanged.
  ///
  /// In zh, this message translates to:
  /// **'当 Torrent 分类修改时'**
  String get whenTorrentCategoryChanged;

  /// No description provided for @whenDefaultSavePathChanged.
  ///
  /// In zh, this message translates to:
  /// **'当默认保存路径修改时'**
  String get whenDefaultSavePathChanged;

  /// No description provided for @whenCategorySavePathChanged.
  ///
  /// In zh, this message translates to:
  /// **'当分类保存路径修改时'**
  String get whenCategorySavePathChanged;

  /// No description provided for @useCategoryPathsInManualMode.
  ///
  /// In zh, this message translates to:
  /// **'在手动模式下使用分类路径'**
  String get useCategoryPathsInManualMode;

  /// No description provided for @defaultSavePath.
  ///
  /// In zh, this message translates to:
  /// **'默认保存路径'**
  String get defaultSavePath;

  /// No description provided for @saveIncompleteTorrentsTo.
  ///
  /// In zh, this message translates to:
  /// **'保存未完成的 torrent 到'**
  String get saveIncompleteTorrentsTo;

  /// No description provided for @copyTorrentFilesTo.
  ///
  /// In zh, this message translates to:
  /// **'复制 .torrent 文件到'**
  String get copyTorrentFilesTo;

  /// No description provided for @copyFinishedTorrentFilesTo.
  ///
  /// In zh, this message translates to:
  /// **'复制下载完成的 .torrent 文件到'**
  String get copyFinishedTorrentFilesTo;

  /// No description provided for @excludedFileNames.
  ///
  /// In zh, this message translates to:
  /// **'排除的文件名'**
  String get excludedFileNames;

  /// No description provided for @oneRulePerLine.
  ///
  /// In zh, this message translates to:
  /// **'每行一个规则'**
  String get oneRulePerLine;

  /// No description provided for @emailOnTorrentCompletion.
  ///
  /// In zh, this message translates to:
  /// **'下载完成时发送电子邮件通知'**
  String get emailOnTorrentCompletion;

  /// No description provided for @mailSender.
  ///
  /// In zh, this message translates to:
  /// **'发件人'**
  String get mailSender;

  /// No description provided for @mailRecipient.
  ///
  /// In zh, this message translates to:
  /// **'收件人'**
  String get mailRecipient;

  /// No description provided for @smtpServer.
  ///
  /// In zh, this message translates to:
  /// **'SMTP 服务器'**
  String get smtpServer;

  /// No description provided for @smtpRequiresSsl.
  ///
  /// In zh, this message translates to:
  /// **'该服务器需要安全链接（SSL）'**
  String get smtpRequiresSsl;

  /// No description provided for @sendTestEmail.
  ///
  /// In zh, this message translates to:
  /// **'发送测试邮件'**
  String get sendTestEmail;

  /// No description provided for @sending.
  ///
  /// In zh, this message translates to:
  /// **'发送中…'**
  String get sending;

  /// No description provided for @sendFailed.
  ///
  /// In zh, this message translates to:
  /// **'发送失败：{error}'**
  String sendFailed(String error);

  /// No description provided for @testEmailSent.
  ///
  /// In zh, this message translates to:
  /// **'测试邮件已发送'**
  String get testEmailSent;

  /// No description provided for @confirmSendTestEmailTitle.
  ///
  /// In zh, this message translates to:
  /// **'发送测试邮件'**
  String get confirmSendTestEmailTitle;

  /// No description provided for @confirmSendTestEmail.
  ///
  /// In zh, this message translates to:
  /// **'测试邮件会使用服务器已保存的邮件设置发送。继续前将先保存当前本页设置（含邮件相关项），确定继续吗？'**
  String get confirmSendTestEmail;

  /// No description provided for @runExternalProgram.
  ///
  /// In zh, this message translates to:
  /// **'运行外部程序'**
  String get runExternalProgram;

  /// No description provided for @runOnTorrentAdded.
  ///
  /// In zh, this message translates to:
  /// **'新增 Torrent 时运行'**
  String get runOnTorrentAdded;

  /// No description provided for @runOnTorrentFinished.
  ///
  /// In zh, this message translates to:
  /// **'torrent 完成时运行'**
  String get runOnTorrentFinished;

  /// No description provided for @autorunExampleHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：\"%N\"'**
  String get autorunExampleHint;

  /// No description provided for @autorunParametersHint.
  ///
  /// In zh, this message translates to:
  /// **'支持的参数（区分大小写）：\n%N：Torrent 名称，%L：分类，%G：标签（以逗号分隔），%F：内容路径，%R：根目录，%D：保存路径，%C：文件数，%Z：Torrent 大小（字节），%T：Tracker，%I/%J：Info hash，%K：ID，%M：备注\n提示：使用引号将参数扩起以防止文本被空白符分割（例如：\"%N\"）'**
  String get autorunParametersHint;

  /// No description provided for @torrentContentLayout.
  ///
  /// In zh, this message translates to:
  /// **'Torrent 内容布局'**
  String get torrentContentLayout;

  /// No description provided for @torrentStopCondition.
  ///
  /// In zh, this message translates to:
  /// **'Torrent 停止条件'**
  String get torrentStopCondition;

  /// No description provided for @enableMailNotificationFirst.
  ///
  /// In zh, this message translates to:
  /// **'请先启用邮件通知'**
  String get enableMailNotificationFirst;

  /// No description provided for @enterDefaultSavePath.
  ///
  /// In zh, this message translates to:
  /// **'请填写默认保存路径'**
  String get enterDefaultSavePath;

  /// No description provided for @webUiRemoteControl.
  ///
  /// In zh, this message translates to:
  /// **'Web 用户界面（远程控制）'**
  String get webUiRemoteControl;

  /// No description provided for @ipAddress.
  ///
  /// In zh, this message translates to:
  /// **'IP 地址'**
  String get ipAddress;

  /// No description provided for @useHttpsInsteadOfHttp.
  ///
  /// In zh, this message translates to:
  /// **'使用 HTTPS 而不是 HTTP'**
  String get useHttpsInsteadOfHttp;

  /// No description provided for @certificate.
  ///
  /// In zh, this message translates to:
  /// **'证书'**
  String get certificate;

  /// No description provided for @privateKey.
  ///
  /// In zh, this message translates to:
  /// **'密钥'**
  String get privateKey;

  /// No description provided for @bypassAuthLocalhost.
  ///
  /// In zh, this message translates to:
  /// **'对本地主机上的客户端跳过身份验证'**
  String get bypassAuthLocalhost;

  /// No description provided for @bypassAuthWhitelist.
  ///
  /// In zh, this message translates to:
  /// **'对 IP 子网白名单中的客户端跳过身份验证'**
  String get bypassAuthWhitelist;

  /// No description provided for @subnetWhitelistHint.
  ///
  /// In zh, this message translates to:
  /// **'例如 192.168.1.0/24'**
  String get subnetWhitelistHint;

  /// No description provided for @banAfterFailedAttempts.
  ///
  /// In zh, this message translates to:
  /// **'连续失败后禁止客户端'**
  String get banAfterFailedAttempts;

  /// No description provided for @banFor.
  ///
  /// In zh, this message translates to:
  /// **'禁止'**
  String get banFor;

  /// No description provided for @sessionTimeout.
  ///
  /// In zh, this message translates to:
  /// **'会话超时'**
  String get sessionTimeout;

  /// No description provided for @passwordLeaveBlank.
  ///
  /// In zh, this message translates to:
  /// **'留空表示不修改'**
  String get passwordLeaveBlank;

  /// No description provided for @copiedApiKey.
  ///
  /// In zh, this message translates to:
  /// **'已复制 API 密钥'**
  String get copiedApiKey;

  /// No description provided for @resetApiKey.
  ///
  /// In zh, this message translates to:
  /// **'重置 API key'**
  String get resetApiKey;

  /// No description provided for @generateApiKey.
  ///
  /// In zh, this message translates to:
  /// **'生成 API 密钥'**
  String get generateApiKey;

  /// No description provided for @confirmResetApiKey.
  ///
  /// In zh, this message translates to:
  /// **'重置该 API key 吗？当前 key 会立即停止工作，会生成新 key。本 App 会自动更新本地保存的密钥。'**
  String get confirmResetApiKey;

  /// No description provided for @confirmGenerateApiKey.
  ///
  /// In zh, this message translates to:
  /// **'生成 API key 吗？这枚 key 可用于和 qBittorrent 的 API 互动。本 App 会自动保存到本地服务器配置。'**
  String get confirmGenerateApiKey;

  /// No description provided for @resetting.
  ///
  /// In zh, this message translates to:
  /// **'重置中…'**
  String get resetting;

  /// No description provided for @generating.
  ///
  /// In zh, this message translates to:
  /// **'生成中…'**
  String get generating;

  /// No description provided for @apiKeyReset.
  ///
  /// In zh, this message translates to:
  /// **'已重置 API key'**
  String get apiKeyReset;

  /// No description provided for @apiKeyGenerated.
  ///
  /// In zh, this message translates to:
  /// **'已生成 API 密钥'**
  String get apiKeyGenerated;

  /// No description provided for @deleteApiKey.
  ///
  /// In zh, this message translates to:
  /// **'删除 API 密钥'**
  String get deleteApiKey;

  /// No description provided for @confirmDeleteApiKey.
  ///
  /// In zh, this message translates to:
  /// **'删除此 API key 吗？当前 key 会立即停止工作。本 App 将无法继续连接，请随后在服务器设置中重新配置密钥。'**
  String get confirmDeleteApiKey;

  /// No description provided for @apiKeyDeleted.
  ///
  /// In zh, this message translates to:
  /// **'已删除 API 密钥'**
  String get apiKeyDeleted;

  /// No description provided for @useAlternativeWebUi.
  ///
  /// In zh, this message translates to:
  /// **'使用备选 WebUI'**
  String get useAlternativeWebUi;

  /// No description provided for @filePath.
  ///
  /// In zh, this message translates to:
  /// **'文件路径'**
  String get filePath;

  /// No description provided for @security.
  ///
  /// In zh, this message translates to:
  /// **'安全'**
  String get security;

  /// No description provided for @clickjackingProtection.
  ///
  /// In zh, this message translates to:
  /// **'启用“点击劫持”保护'**
  String get clickjackingProtection;

  /// No description provided for @csrfProtection.
  ///
  /// In zh, this message translates to:
  /// **'启用跨站请求伪造 (CSRF) 保护'**
  String get csrfProtection;

  /// No description provided for @secureCookie.
  ///
  /// In zh, this message translates to:
  /// **'启用 cookie Secure 标志（需要 HTTPS 或本机连接）'**
  String get secureCookie;

  /// No description provided for @hostHeaderValidation.
  ///
  /// In zh, this message translates to:
  /// **'启用 Host 标头验证'**
  String get hostHeaderValidation;

  /// No description provided for @serverDomains.
  ///
  /// In zh, this message translates to:
  /// **'服务器域名'**
  String get serverDomains;

  /// No description provided for @customHttpHeaders.
  ///
  /// In zh, this message translates to:
  /// **'启用自定义 HTTP 头'**
  String get customHttpHeaders;

  /// No description provided for @oneHeaderPerLine.
  ///
  /// In zh, this message translates to:
  /// **'每行一个 Header'**
  String get oneHeaderPerLine;

  /// No description provided for @reverseProxySupport.
  ///
  /// In zh, this message translates to:
  /// **'启用反向代理支持'**
  String get reverseProxySupport;

  /// No description provided for @trustedProxiesList.
  ///
  /// In zh, this message translates to:
  /// **'受信任的代理列表'**
  String get trustedProxiesList;

  /// No description provided for @onePerLine.
  ///
  /// In zh, this message translates to:
  /// **'每行一个'**
  String get onePerLine;

  /// No description provided for @updateDynDns.
  ///
  /// In zh, this message translates to:
  /// **'更新我的动态域名'**
  String get updateDynDns;

  /// No description provided for @dynDnsService.
  ///
  /// In zh, this message translates to:
  /// **'服务'**
  String get dynDnsService;

  /// No description provided for @domain.
  ///
  /// In zh, this message translates to:
  /// **'域名'**
  String get domain;

  /// No description provided for @webUiWarning.
  ///
  /// In zh, this message translates to:
  /// **'此处修改的是服务器 WebUI 自身配置。错误地更改地址、端口、HTTPS、认证或安全选项可能导致本 App 无法再连接该服务器，请谨慎操作并确保仍有其他方式访问 qBittorrent。'**
  String get webUiWarning;

  /// No description provided for @confirmSaveWebUiTitle.
  ///
  /// In zh, this message translates to:
  /// **'确认保存 WebUI 设置'**
  String get confirmSaveWebUiTitle;

  /// No description provided for @confirmSaveWebUi.
  ///
  /// In zh, this message translates to:
  /// **'修改地址、端口、HTTPS、用户名密码或安全选项后，本 App 可能暂时无法连接服务器。请确认你仍能通过其他方式访问 qBittorrent。确定继续保存吗？'**
  String get confirmSaveWebUi;

  /// No description provided for @cannotResetApiKey.
  ///
  /// In zh, this message translates to:
  /// **'无法重置 API key'**
  String get cannotResetApiKey;

  /// No description provided for @cannotDeleteApiKey.
  ///
  /// In zh, this message translates to:
  /// **'无法删除 API 密钥。'**
  String get cannotDeleteApiKey;

  /// No description provided for @httpsCertPathRequired.
  ///
  /// In zh, this message translates to:
  /// **'HTTPS 证书路径不能为空'**
  String get httpsCertPathRequired;

  /// No description provided for @httpsKeyPathRequired.
  ///
  /// In zh, this message translates to:
  /// **'HTTPS 密钥路径不能为空'**
  String get httpsKeyPathRequired;

  /// No description provided for @webUiUsernameMinLength.
  ///
  /// In zh, this message translates to:
  /// **'WebUI 用户名至少需要 3 个字符'**
  String get webUiUsernameMinLength;

  /// No description provided for @webUiUsernameNoColon.
  ///
  /// In zh, this message translates to:
  /// **'WebUI 用户名不能包含冒号'**
  String get webUiUsernameNoColon;

  /// No description provided for @webUiPasswordMinLength.
  ///
  /// In zh, this message translates to:
  /// **'WebUI 密码至少需要 6 个字符'**
  String get webUiPasswordMinLength;

  /// No description provided for @altWebUiPathRequired.
  ///
  /// In zh, this message translates to:
  /// **'备选 WebUI 文件路径不能为空'**
  String get altWebUiPathRequired;

  /// No description provided for @webUiPortRange.
  ///
  /// In zh, this message translates to:
  /// **'WebUI 端口必须在 1 到 65535 之间'**
  String get webUiPortRange;

  /// No description provided for @resumeDataStorage.
  ///
  /// In zh, this message translates to:
  /// **'恢复数据存储类型（需重启）'**
  String get resumeDataStorage;

  /// No description provided for @torrentContentRemoveOption.
  ///
  /// In zh, this message translates to:
  /// **'删除种子内容方式'**
  String get torrentContentRemoveOption;

  /// No description provided for @physicalMemoryLimit.
  ///
  /// In zh, this message translates to:
  /// **'物理内存 (RAM) 使用上限'**
  String get physicalMemoryLimit;

  /// No description provided for @networkInterface.
  ///
  /// In zh, this message translates to:
  /// **'网络接口'**
  String get networkInterface;

  /// No description provided for @optionalBindAddress.
  ///
  /// In zh, this message translates to:
  /// **'可选绑定 IP 地址'**
  String get optionalBindAddress;

  /// No description provided for @saveResumeDataInterval.
  ///
  /// In zh, this message translates to:
  /// **'保存恢复数据间隔'**
  String get saveResumeDataInterval;

  /// No description provided for @saveStatisticsInterval.
  ///
  /// In zh, this message translates to:
  /// **'保存统计信息间隔'**
  String get saveStatisticsInterval;

  /// No description provided for @torrentFileSizeLimit.
  ///
  /// In zh, this message translates to:
  /// **'.torrent 文件大小限制'**
  String get torrentFileSizeLimit;

  /// No description provided for @confirmTorrentRecheck.
  ///
  /// In zh, this message translates to:
  /// **'确认重新检查种子'**
  String get confirmTorrentRecheck;

  /// No description provided for @recheckCompletedTorrents.
  ///
  /// In zh, this message translates to:
  /// **'完成时重新检查种子'**
  String get recheckCompletedTorrents;

  /// No description provided for @appInstanceName.
  ///
  /// In zh, this message translates to:
  /// **'自定义应用程序实例名称'**
  String get appInstanceName;

  /// No description provided for @refreshInterval.
  ///
  /// In zh, this message translates to:
  /// **'刷新间隔'**
  String get refreshInterval;

  /// No description provided for @resolvePeerHostnames.
  ///
  /// In zh, this message translates to:
  /// **'解析 peer 主机名'**
  String get resolvePeerHostnames;

  /// No description provided for @resolvePeerCountries.
  ///
  /// In zh, this message translates to:
  /// **'解析 peer 国家/地区'**
  String get resolvePeerCountries;

  /// No description provided for @enableEmbeddedTracker.
  ///
  /// In zh, this message translates to:
  /// **'启用嵌入式 tracker'**
  String get enableEmbeddedTracker;

  /// No description provided for @embeddedTrackerPort.
  ///
  /// In zh, this message translates to:
  /// **'嵌入式 tracker 端口'**
  String get embeddedTrackerPort;

  /// No description provided for @embeddedTrackerPortForwarding.
  ///
  /// In zh, this message translates to:
  /// **'为嵌入式 tracker 启用端口转发'**
  String get embeddedTrackerPortForwarding;

  /// No description provided for @enableMotw.
  ///
  /// In zh, this message translates to:
  /// **'为下载的文件启用 Mark-of-the-Web（需 macOS 或 Windows）'**
  String get enableMotw;

  /// No description provided for @ignoreSslErrors.
  ///
  /// In zh, this message translates to:
  /// **'忽略 SSL 错误'**
  String get ignoreSslErrors;

  /// No description provided for @asyncIoThreads.
  ///
  /// In zh, this message translates to:
  /// **'异步 I/O 线程数'**
  String get asyncIoThreads;

  /// No description provided for @hashingThreads.
  ///
  /// In zh, this message translates to:
  /// **'哈希线程数'**
  String get hashingThreads;

  /// No description provided for @filePoolSize.
  ///
  /// In zh, this message translates to:
  /// **'文件池大小'**
  String get filePoolSize;

  /// No description provided for @outstandingMemoryWhenChecking.
  ///
  /// In zh, this message translates to:
  /// **'检查种子时的未决内存'**
  String get outstandingMemoryWhenChecking;

  /// No description provided for @diskCache.
  ///
  /// In zh, this message translates to:
  /// **'磁盘缓存'**
  String get diskCache;

  /// No description provided for @diskCacheTtl.
  ///
  /// In zh, this message translates to:
  /// **'磁盘缓存过期间隔'**
  String get diskCacheTtl;

  /// No description provided for @diskQueueSize.
  ///
  /// In zh, this message translates to:
  /// **'磁盘队列大小'**
  String get diskQueueSize;

  /// No description provided for @diskIoType.
  ///
  /// In zh, this message translates to:
  /// **'磁盘 IO 类型（需重启）'**
  String get diskIoType;

  /// No description provided for @diskIoReadMode.
  ///
  /// In zh, this message translates to:
  /// **'磁盘 IO 读取模式'**
  String get diskIoReadMode;

  /// No description provided for @diskIoWriteMode.
  ///
  /// In zh, this message translates to:
  /// **'磁盘 IO 写入模式'**
  String get diskIoWriteMode;

  /// No description provided for @coalesceReadsWrites.
  ///
  /// In zh, this message translates to:
  /// **'合并读写'**
  String get coalesceReadsWrites;

  /// No description provided for @pieceExtentAffinity.
  ///
  /// In zh, this message translates to:
  /// **'使用分块范围亲和性'**
  String get pieceExtentAffinity;

  /// No description provided for @sendUploadPieceSuggestions.
  ///
  /// In zh, this message translates to:
  /// **'发送上传分块建议'**
  String get sendUploadPieceSuggestions;

  /// No description provided for @sendBufferWatermark.
  ///
  /// In zh, this message translates to:
  /// **'发送缓冲区水位线'**
  String get sendBufferWatermark;

  /// No description provided for @sendBufferLowWatermark.
  ///
  /// In zh, this message translates to:
  /// **'发送缓冲区低水位线'**
  String get sendBufferLowWatermark;

  /// No description provided for @sendBufferWatermarkFactor.
  ///
  /// In zh, this message translates to:
  /// **'发送缓冲区水位线系数'**
  String get sendBufferWatermarkFactor;

  /// No description provided for @outgoingConnectionsPerSecond.
  ///
  /// In zh, this message translates to:
  /// **'每秒传出连接数'**
  String get outgoingConnectionsPerSecond;

  /// No description provided for @allowOutgoingWhenSeeding.
  ///
  /// In zh, this message translates to:
  /// **'做种时允许传出连接'**
  String get allowOutgoingWhenSeeding;

  /// No description provided for @socketSendBufferSize.
  ///
  /// In zh, this message translates to:
  /// **'套接字发送缓冲区大小（0：系统默认）'**
  String get socketSendBufferSize;

  /// No description provided for @socketReceiveBufferSize.
  ///
  /// In zh, this message translates to:
  /// **'套接字接收缓冲区大小（0：系统默认）'**
  String get socketReceiveBufferSize;

  /// No description provided for @socketBacklogSize.
  ///
  /// In zh, this message translates to:
  /// **'套接字 backlog 大小'**
  String get socketBacklogSize;

  /// No description provided for @outgoingPortsMin.
  ///
  /// In zh, this message translates to:
  /// **'传出端口（最小，0：禁用）'**
  String get outgoingPortsMin;

  /// No description provided for @outgoingPortsMax.
  ///
  /// In zh, this message translates to:
  /// **'传出端口（最大，0：禁用）'**
  String get outgoingPortsMax;

  /// No description provided for @peerTos.
  ///
  /// In zh, this message translates to:
  /// **'连接 peer 的 DSCP'**
  String get peerTos;

  /// No description provided for @resolverCacheTtl.
  ///
  /// In zh, this message translates to:
  /// **'内部主机名解析器缓存过期间隔'**
  String get resolverCacheTtl;

  /// No description provided for @idnSupport.
  ///
  /// In zh, this message translates to:
  /// **'支持国际化域名 (IDN)'**
  String get idnSupport;

  /// No description provided for @allowMultipleConnectionsFromSameIp.
  ///
  /// In zh, this message translates to:
  /// **'允许来自同一 IP 地址的多个连接'**
  String get allowMultipleConnectionsFromSameIp;

  /// No description provided for @validateHttpsTrackerCert.
  ///
  /// In zh, this message translates to:
  /// **'验证 HTTPS tracker 证书'**
  String get validateHttpsTrackerCert;

  /// No description provided for @ssrfMitigation.
  ///
  /// In zh, this message translates to:
  /// **'服务端请求伪造 (SSRF) 缓解'**
  String get ssrfMitigation;

  /// No description provided for @blockPeersOnPrivilegedPorts.
  ///
  /// In zh, this message translates to:
  /// **'禁止连接到特权端口上的 peer'**
  String get blockPeersOnPrivilegedPorts;

  /// No description provided for @uploadSlotsBehavior.
  ///
  /// In zh, this message translates to:
  /// **'上传槽行为'**
  String get uploadSlotsBehavior;

  /// No description provided for @uploadChokingAlgorithm.
  ///
  /// In zh, this message translates to:
  /// **'上传阻塞算法'**
  String get uploadChokingAlgorithm;

  /// No description provided for @announceToAllTrackers.
  ///
  /// In zh, this message translates to:
  /// **'始终向层级内所有 tracker 宣布'**
  String get announceToAllTrackers;

  /// No description provided for @announceToAllTiers.
  ///
  /// In zh, this message translates to:
  /// **'始终向 tier 内所有 tracker 宣布'**
  String get announceToAllTiers;

  /// No description provided for @announceIp.
  ///
  /// In zh, this message translates to:
  /// **'向 tracker 报告的 IP（需重启）'**
  String get announceIp;

  /// No description provided for @announcePort.
  ///
  /// In zh, this message translates to:
  /// **'向 tracker 报告的端口（需重启，0：监听端口）'**
  String get announcePort;

  /// No description provided for @maxConcurrentHttpAnnounces.
  ///
  /// In zh, this message translates to:
  /// **'最大并发 HTTP announce 数'**
  String get maxConcurrentHttpAnnounces;

  /// No description provided for @stopTrackerTimeout.
  ///
  /// In zh, this message translates to:
  /// **'停止 tracker 超时（0：禁用）'**
  String get stopTrackerTimeout;

  /// No description provided for @peerTurnover.
  ///
  /// In zh, this message translates to:
  /// **'Peer 轮换断开百分比'**
  String get peerTurnover;

  /// No description provided for @peerTurnoverCutoff.
  ///
  /// In zh, this message translates to:
  /// **'Peer 轮换阈值百分比'**
  String get peerTurnoverCutoff;

  /// No description provided for @peerTurnoverInterval.
  ///
  /// In zh, this message translates to:
  /// **'Peer 轮换断开间隔'**
  String get peerTurnoverInterval;

  /// No description provided for @requestQueueSize.
  ///
  /// In zh, this message translates to:
  /// **'对单个 peer 的最大未完成请求数'**
  String get requestQueueSize;

  /// No description provided for @maxOutstandingPieceRequests.
  ///
  /// In zh, this message translates to:
  /// **'来自 peer 的最大未完成块请求数'**
  String get maxOutstandingPieceRequests;

  /// No description provided for @dhtBootstrapNodes.
  ///
  /// In zh, this message translates to:
  /// **'DHT 引导节点'**
  String get dhtBootstrapNodes;

  /// No description provided for @i2pInboundQuantity.
  ///
  /// In zh, this message translates to:
  /// **'I2P 入站数量'**
  String get i2pInboundQuantity;

  /// No description provided for @i2pOutboundQuantity.
  ///
  /// In zh, this message translates to:
  /// **'I2P 出站数量'**
  String get i2pOutboundQuantity;

  /// No description provided for @i2pInboundLength.
  ///
  /// In zh, this message translates to:
  /// **'I2P 入站长度'**
  String get i2pInboundLength;

  /// No description provided for @i2pOutboundLength.
  ///
  /// In zh, this message translates to:
  /// **'I2P 出站长度'**
  String get i2pOutboundLength;

  /// No description provided for @i2pTunnel.
  ///
  /// In zh, this message translates to:
  /// **'I2P 隧道'**
  String get i2pTunnel;

  /// No description provided for @upnpLeaseDuration.
  ///
  /// In zh, this message translates to:
  /// **'UPnP 租约时长（0：永久）'**
  String get upnpLeaseDuration;

  /// No description provided for @reannounceWhenAddressChanges.
  ///
  /// In zh, this message translates to:
  /// **'IP 或端口变化时向所有 tracker 重新 announce'**
  String get reannounceWhenAddressChanges;

  /// No description provided for @pythonExecutablePath.
  ///
  /// In zh, this message translates to:
  /// **'Python 可执行文件路径（可能需要重启）'**
  String get pythonExecutablePath;

  /// No description provided for @bdecodeTokenLimit.
  ///
  /// In zh, this message translates to:
  /// **'Bdecode 令牌限制'**
  String get bdecodeTokenLimit;

  /// No description provided for @bdecodeDepthLimit.
  ///
  /// In zh, this message translates to:
  /// **'Bdecode 深度限制'**
  String get bdecodeDepthLimit;

  /// No description provided for @utpTcpMixedMode.
  ///
  /// In zh, this message translates to:
  /// **'μTP-TCP 混合模式算法'**
  String get utpTcpMixedMode;

  /// No description provided for @allowMultipleConnectionsFromSamePeerId.
  ///
  /// In zh, this message translates to:
  /// **'允许来自同一 Peer ID 的多个连接'**
  String get allowMultipleConnectionsFromSamePeerId;

  /// No description provided for @invalidCheckingMemory.
  ///
  /// In zh, this message translates to:
  /// **'检查种子时的未决内存必须大于 0 且小于 1024 MiB'**
  String get invalidCheckingMemory;

  /// No description provided for @invalidPeerDscp.
  ///
  /// In zh, this message translates to:
  /// **'Peer DSCP 必须在 0 到 255 之间'**
  String get invalidPeerDscp;

  /// No description provided for @invalidAnnouncePort.
  ///
  /// In zh, this message translates to:
  /// **'向 tracker 报告的端口必须在 0 到 65535 之间'**
  String get invalidAnnouncePort;

  /// No description provided for @invalidPeerTurnover.
  ///
  /// In zh, this message translates to:
  /// **'Peer 轮换断开百分比必须在 0 到 100 之间'**
  String get invalidPeerTurnover;

  /// No description provided for @invalidPeerTurnoverCutoff.
  ///
  /// In zh, this message translates to:
  /// **'Peer 轮换阈值百分比必须在 0 到 100 之间'**
  String get invalidPeerTurnoverCutoff;

  /// No description provided for @invalidPeerTurnoverInterval.
  ///
  /// In zh, this message translates to:
  /// **'Peer 轮换断开间隔必须大于等于 0'**
  String get invalidPeerTurnoverInterval;

  /// No description provided for @pythonPathNoQuotes.
  ///
  /// In zh, this message translates to:
  /// **'Python 可执行文件路径首尾不能包含引号'**
  String get pythonPathNoQuotes;

  /// No description provided for @searchLogsHint.
  ///
  /// In zh, this message translates to:
  /// **'搜索日志…'**
  String get searchLogsHint;

  /// No description provided for @closeSearch.
  ///
  /// In zh, this message translates to:
  /// **'关闭搜索'**
  String get closeSearch;

  /// No description provided for @logTabBannedIp.
  ///
  /// In zh, this message translates to:
  /// **'封禁 IP'**
  String get logTabBannedIp;

  /// No description provided for @noLogs.
  ///
  /// In zh, this message translates to:
  /// **'暂无日志'**
  String get noLogs;

  /// No description provided for @noLogsHint.
  ///
  /// In zh, this message translates to:
  /// **'服务器尚未产生日志记录'**
  String get noLogsHint;

  /// No description provided for @noMatchingLogs.
  ///
  /// In zh, this message translates to:
  /// **'无匹配日志'**
  String get noMatchingLogs;

  /// No description provided for @adjustFiltersOrSearchHint.
  ///
  /// In zh, this message translates to:
  /// **'试试调整筛选或搜索关键词'**
  String get adjustFiltersOrSearchHint;

  /// No description provided for @noBanRecords.
  ///
  /// In zh, this message translates to:
  /// **'暂无封禁记录'**
  String get noBanRecords;

  /// No description provided for @noBanRecordsHint.
  ///
  /// In zh, this message translates to:
  /// **'尚未有 Peer 被屏蔽或封禁'**
  String get noBanRecordsHint;

  /// No description provided for @noMatchingRecords.
  ///
  /// In zh, this message translates to:
  /// **'无匹配记录'**
  String get noMatchingRecords;

  /// No description provided for @adjustSearchHint.
  ///
  /// In zh, this message translates to:
  /// **'试试调整搜索关键词'**
  String get adjustSearchHint;

  /// No description provided for @logPeerBlocked.
  ///
  /// In zh, this message translates to:
  /// **'已屏蔽'**
  String get logPeerBlocked;

  /// No description provided for @logPeerBanned.
  ///
  /// In zh, this message translates to:
  /// **'已封禁'**
  String get logPeerBanned;

  /// No description provided for @pageNotFound.
  ///
  /// In zh, this message translates to:
  /// **'页面不存在'**
  String get pageNotFound;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
