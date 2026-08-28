import 'package:qbpanel/add/add_torrent_ui_state.dart';
import 'package:qbpanel/l10n/app_localizations.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

/// WebUI「下载」页状态。
class DownloadsSettingsUiState {
  const DownloadsSettingsUiState({
    this.emptyState = const EmptyState.content(),
    this.saving = false,
    this.testingEmail = false,
    this.contentLayout = TorrentContentLayout.original,
    this.addToTopOfQueue = false,
    this.addStoppedEnabled = false,
    this.stopCondition = TorrentStopCondition.none,
    this.mergeTrackers = false,
    this.autoDeleteTorrentFile = false,
    this.preallocateAll = false,
    this.incompleteFilesExt = false,
    this.useUnwantedFolder = false,
    this.autoTmmEnabled = false,
    this.torrentChangedTmmEnabled = true,
    this.savePathChangedTmmEnabled = false,
    this.categoryChangedTmmEnabled = false,
    this.useCategoryPathsInManualMode = false,
    this.savePath = '',
    this.tempPathEnabled = false,
    this.tempPath = '',
    this.exportDirEnabled = false,
    this.exportDir = '',
    this.exportDirFinEnabled = false,
    this.exportDirFin = '',
    this.excludedFileNamesEnabled = false,
    this.excludedFileNames = '',
    this.mailNotificationEnabled = false,
    this.mailNotificationSender = '',
    this.mailNotificationEmail = '',
    this.mailNotificationSmtp = '',
    this.mailNotificationSslEnabled = false,
    this.mailNotificationAuthEnabled = false,
    this.mailNotificationUsername = '',
    this.mailNotificationPassword = '',
    this.autorunOnTorrentAddedEnabled = false,
    this.autorunOnTorrentAddedProgram = '',
    this.autorunEnabled = false,
    this.autorunProgram = '',
  });

  final EmptyState emptyState;
  final bool saving;
  final bool testingEmail;

  final TorrentContentLayout contentLayout;
  final bool addToTopOfQueue;
  final bool addStoppedEnabled;
  final TorrentStopCondition stopCondition;
  final bool mergeTrackers;
  final bool autoDeleteTorrentFile;
  final bool preallocateAll;
  final bool incompleteFilesExt;
  final bool useUnwantedFolder;

  final bool autoTmmEnabled;
  final bool torrentChangedTmmEnabled;
  final bool savePathChangedTmmEnabled;
  final bool categoryChangedTmmEnabled;
  final bool useCategoryPathsInManualMode;
  final String savePath;
  final bool tempPathEnabled;
  final String tempPath;
  final bool exportDirEnabled;
  final String exportDir;
  final bool exportDirFinEnabled;
  final String exportDirFin;

  final bool excludedFileNamesEnabled;
  final String excludedFileNames;

  final bool mailNotificationEnabled;
  final String mailNotificationSender;
  final String mailNotificationEmail;
  final String mailNotificationSmtp;
  final bool mailNotificationSslEnabled;
  final bool mailNotificationAuthEnabled;
  final String mailNotificationUsername;
  final String mailNotificationPassword;

  final bool autorunOnTorrentAddedEnabled;
  final String autorunOnTorrentAddedProgram;
  final bool autorunEnabled;
  final String autorunProgram;

  bool get ready => emptyState.ready;

  DownloadsSettingsUiState copyWith({
    EmptyState? emptyState,
    bool? saving,
    bool? testingEmail,
    TorrentContentLayout? contentLayout,
    bool? addToTopOfQueue,
    bool? addStoppedEnabled,
    TorrentStopCondition? stopCondition,
    bool? mergeTrackers,
    bool? autoDeleteTorrentFile,
    bool? preallocateAll,
    bool? incompleteFilesExt,
    bool? useUnwantedFolder,
    bool? autoTmmEnabled,
    bool? torrentChangedTmmEnabled,
    bool? savePathChangedTmmEnabled,
    bool? categoryChangedTmmEnabled,
    bool? useCategoryPathsInManualMode,
    String? savePath,
    bool? tempPathEnabled,
    String? tempPath,
    bool? exportDirEnabled,
    String? exportDir,
    bool? exportDirFinEnabled,
    String? exportDirFin,
    bool? excludedFileNamesEnabled,
    String? excludedFileNames,
    bool? mailNotificationEnabled,
    String? mailNotificationSender,
    String? mailNotificationEmail,
    String? mailNotificationSmtp,
    bool? mailNotificationSslEnabled,
    bool? mailNotificationAuthEnabled,
    String? mailNotificationUsername,
    String? mailNotificationPassword,
    bool? autorunOnTorrentAddedEnabled,
    String? autorunOnTorrentAddedProgram,
    bool? autorunEnabled,
    String? autorunProgram,
  }) {
    return DownloadsSettingsUiState(
      emptyState: emptyState ?? this.emptyState,
      saving: saving ?? this.saving,
      testingEmail: testingEmail ?? this.testingEmail,
      contentLayout: contentLayout ?? this.contentLayout,
      addToTopOfQueue: addToTopOfQueue ?? this.addToTopOfQueue,
      addStoppedEnabled: addStoppedEnabled ?? this.addStoppedEnabled,
      stopCondition: stopCondition ?? this.stopCondition,
      mergeTrackers: mergeTrackers ?? this.mergeTrackers,
      autoDeleteTorrentFile:
          autoDeleteTorrentFile ?? this.autoDeleteTorrentFile,
      preallocateAll: preallocateAll ?? this.preallocateAll,
      incompleteFilesExt: incompleteFilesExt ?? this.incompleteFilesExt,
      useUnwantedFolder: useUnwantedFolder ?? this.useUnwantedFolder,
      autoTmmEnabled: autoTmmEnabled ?? this.autoTmmEnabled,
      torrentChangedTmmEnabled:
          torrentChangedTmmEnabled ?? this.torrentChangedTmmEnabled,
      savePathChangedTmmEnabled:
          savePathChangedTmmEnabled ?? this.savePathChangedTmmEnabled,
      categoryChangedTmmEnabled:
          categoryChangedTmmEnabled ?? this.categoryChangedTmmEnabled,
      useCategoryPathsInManualMode:
          useCategoryPathsInManualMode ?? this.useCategoryPathsInManualMode,
      savePath: savePath ?? this.savePath,
      tempPathEnabled: tempPathEnabled ?? this.tempPathEnabled,
      tempPath: tempPath ?? this.tempPath,
      exportDirEnabled: exportDirEnabled ?? this.exportDirEnabled,
      exportDir: exportDir ?? this.exportDir,
      exportDirFinEnabled: exportDirFinEnabled ?? this.exportDirFinEnabled,
      exportDirFin: exportDirFin ?? this.exportDirFin,
      excludedFileNamesEnabled:
          excludedFileNamesEnabled ?? this.excludedFileNamesEnabled,
      excludedFileNames: excludedFileNames ?? this.excludedFileNames,
      mailNotificationEnabled:
          mailNotificationEnabled ?? this.mailNotificationEnabled,
      mailNotificationSender:
          mailNotificationSender ?? this.mailNotificationSender,
      mailNotificationEmail:
          mailNotificationEmail ?? this.mailNotificationEmail,
      mailNotificationSmtp: mailNotificationSmtp ?? this.mailNotificationSmtp,
      mailNotificationSslEnabled:
          mailNotificationSslEnabled ?? this.mailNotificationSslEnabled,
      mailNotificationAuthEnabled:
          mailNotificationAuthEnabled ?? this.mailNotificationAuthEnabled,
      mailNotificationUsername:
          mailNotificationUsername ?? this.mailNotificationUsername,
      mailNotificationPassword:
          mailNotificationPassword ?? this.mailNotificationPassword,
      autorunOnTorrentAddedEnabled:
          autorunOnTorrentAddedEnabled ?? this.autorunOnTorrentAddedEnabled,
      autorunOnTorrentAddedProgram:
          autorunOnTorrentAddedProgram ?? this.autorunOnTorrentAddedProgram,
      autorunEnabled: autorunEnabled ?? this.autorunEnabled,
      autorunProgram: autorunProgram ?? this.autorunProgram,
    );
  }
}

/// TMM 变更后动作（分类变更 / 路径变更文案与 WebUI 一致）。
enum DownloadsTmmAction {
  relocate(true),
  switchToManual(false);

  const DownloadsTmmAction(this.apiValue);

  final bool apiValue;

  /// 「当 Torrent 分类修改时」选项文案。
  String torrentLabel(AppLocalizations l10n) => switch (this) {
        DownloadsTmmAction.relocate => l10n.tmmRelocateTorrent,
        DownloadsTmmAction.switchToManual => l10n.tmmSwitchTorrentManual,
      };

  /// 「当默认/分类保存路径修改时」选项文案。
  String affectedLabel(AppLocalizations l10n) => switch (this) {
        DownloadsTmmAction.relocate => l10n.tmmRelocateAffected,
        DownloadsTmmAction.switchToManual => l10n.tmmSwitchAffectedManual,
      };

  static DownloadsTmmAction fromApi(bool? value) {
    return (value ?? false)
        ? DownloadsTmmAction.relocate
        : DownloadsTmmAction.switchToManual;
  }
}
