import 'package:qbpanel/l10n/app_localizations.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

/// WebUI「行为」页状态。
class BehaviorSettingsUiState {
  const BehaviorSettingsUiState({
    this.emptyState = const EmptyState.content(),
    this.saving = false,
    this.locale = 'zh_CN',
    this.confirmTorrentDeletion = true,
    this.statusBarExternalIp = true,
    this.fileLogEnabled = true,
    this.fileLogPath = '',
    this.fileLogBackupEnabled = true,
    this.fileLogMaxSize = 65,
    this.fileLogDeleteOld = true,
    this.fileLogAge = 1,
    this.fileLogAgeType = BehaviorLogAgeType.months,
    this.performanceWarning = false,
  });

  final EmptyState emptyState;
  final bool saving;

  /// `locale`
  final String locale;

  /// `confirm_torrent_deletion`
  final bool confirmTorrentDeletion;

  /// `status_bar_external_ip`
  final bool statusBarExternalIp;

  /// `file_log_enabled`
  final bool fileLogEnabled;

  /// `file_log_path`
  final String fileLogPath;

  /// `file_log_backup_enabled`
  final bool fileLogBackupEnabled;

  /// `file_log_max_size`（KiB）
  final int fileLogMaxSize;

  /// `file_log_delete_old`
  final bool fileLogDeleteOld;

  /// `file_log_age`
  final int fileLogAge;

  /// `file_log_age_type`：0 天 / 1 月 / 2 年
  final BehaviorLogAgeType fileLogAgeType;

  /// `performance_warning`
  final bool performanceWarning;

  bool get ready => emptyState.ready;

  BehaviorSettingsUiState copyWith({
    EmptyState? emptyState,
    bool? saving,
    String? locale,
    bool? confirmTorrentDeletion,
    bool? statusBarExternalIp,
    bool? fileLogEnabled,
    String? fileLogPath,
    bool? fileLogBackupEnabled,
    int? fileLogMaxSize,
    bool? fileLogDeleteOld,
    int? fileLogAge,
    BehaviorLogAgeType? fileLogAgeType,
    bool? performanceWarning,
  }) {
    return BehaviorSettingsUiState(
      emptyState: emptyState ?? this.emptyState,
      saving: saving ?? this.saving,
      locale: locale ?? this.locale,
      confirmTorrentDeletion:
          confirmTorrentDeletion ?? this.confirmTorrentDeletion,
      statusBarExternalIp: statusBarExternalIp ?? this.statusBarExternalIp,
      fileLogEnabled: fileLogEnabled ?? this.fileLogEnabled,
      fileLogPath: fileLogPath ?? this.fileLogPath,
      fileLogBackupEnabled: fileLogBackupEnabled ?? this.fileLogBackupEnabled,
      fileLogMaxSize: fileLogMaxSize ?? this.fileLogMaxSize,
      fileLogDeleteOld: fileLogDeleteOld ?? this.fileLogDeleteOld,
      fileLogAge: fileLogAge ?? this.fileLogAge,
      fileLogAgeType: fileLogAgeType ?? this.fileLogAgeType,
      performanceWarning: performanceWarning ?? this.performanceWarning,
    );
  }
}

class BehaviorLocaleOption {
  const BehaviorLocaleOption(this.code, this.label);

  final String code;
  final String label;

  static const options = <BehaviorLocaleOption>[
    BehaviorLocaleOption('en', 'English'),
    BehaviorLocaleOption('en_GB', 'English (United Kingdom)'),
    BehaviorLocaleOption('en_AU', 'English (Australia)'),
    BehaviorLocaleOption('zh_CN', '简体中文'),
    BehaviorLocaleOption('zh_TW', '繁體中文'),
    BehaviorLocaleOption('zh_HK', '繁體中文（香港）'),
    BehaviorLocaleOption('ja', '日本語'),
    BehaviorLocaleOption('ko', '한국어'),
    BehaviorLocaleOption('de', 'Deutsch'),
    BehaviorLocaleOption('fr', 'Français'),
    BehaviorLocaleOption('es', 'Español'),
    BehaviorLocaleOption('ru', 'Русский'),
    BehaviorLocaleOption('pt_BR', 'Português (Brasil)'),
    BehaviorLocaleOption('pt_PT', 'Português (Portugal)'),
    BehaviorLocaleOption('it', 'Italiano'),
    BehaviorLocaleOption('nl', 'Nederlands'),
    BehaviorLocaleOption('pl', 'Polski'),
    BehaviorLocaleOption('tr', 'Türkçe'),
    BehaviorLocaleOption('uk', 'Українська'),
    BehaviorLocaleOption('vi', 'Tiếng Việt'),
    BehaviorLocaleOption('th', 'ไทย'),
    BehaviorLocaleOption('ar', 'العربية'),
    BehaviorLocaleOption('cs', 'Čeština'),
    BehaviorLocaleOption('da', 'Dansk'),
    BehaviorLocaleOption('fi', 'Suomi'),
    BehaviorLocaleOption('hu', 'Magyar'),
    BehaviorLocaleOption('id', 'Bahasa Indonesia'),
    BehaviorLocaleOption('nb', 'Norsk bokmål'),
    BehaviorLocaleOption('ro', 'Română'),
    BehaviorLocaleOption('sk', 'Slovenčina'),
    BehaviorLocaleOption('sv', 'Svenska'),
    BehaviorLocaleOption('el', 'Ελληνικά'),
    BehaviorLocaleOption('he', 'עברית'),
    BehaviorLocaleOption('hi', 'हिन्दी'),
    BehaviorLocaleOption('hr', 'Hrvatski'),
    BehaviorLocaleOption('bg', 'Български'),
    BehaviorLocaleOption('ca', 'Català'),
    BehaviorLocaleOption('eu', 'Euskara'),
    BehaviorLocaleOption('fa', 'فارسی'),
    BehaviorLocaleOption('lt', 'Lietuvių'),
    BehaviorLocaleOption('lv', 'Latviešu'),
    BehaviorLocaleOption('sl', 'Slovenščina'),
    BehaviorLocaleOption('sr', 'Српски'),
    BehaviorLocaleOption('ms_MY', 'Bahasa Melayu'),
  ];

  static bool contains(String code) =>
      options.any((item) => item.code == code);
}

enum BehaviorLogAgeType {
  days(0),
  months(1),
  years(2);

  const BehaviorLogAgeType(this.apiValue);
  final int apiValue;

  String label(AppLocalizations l10n) => switch (this) {
        BehaviorLogAgeType.days => l10n.logAgeDays,
        BehaviorLogAgeType.months => l10n.logAgeMonths,
        BehaviorLogAgeType.years => l10n.logAgeYears,
      };

  static BehaviorLogAgeType fromApi(int? value) {
    for (final item in values) {
      if (item.apiValue == value) return item;
    }
    return BehaviorLogAgeType.months;
  }
}
