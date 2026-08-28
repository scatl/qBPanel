import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/l10n/app_localizations.dart';
import 'package:qbpanel/storage/sp_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 应用界面语言：跟随系统 / 简体中文 / 繁體中文 / English。
enum AppLocaleMode {
  system,
  zh,
  zhHant,
  en;

  String storageName() => name;

  String label(AppLocalizations l10n) => switch (this) {
        AppLocaleMode.system => l10n.localeFollowSystem,
        AppLocaleMode.zh => l10n.localeChinese,
        AppLocaleMode.zhHant => l10n.localeChineseTraditional,
        AppLocaleMode.en => l10n.localeEnglish,
      };

  static AppLocaleMode parse(String? raw) {
    return AppLocaleMode.values.firstWhere(
      (m) => m.name == raw,
      orElse: () => AppLocaleMode.system,
    );
  }
}

bool isTraditionalChinese(Locale locale) {
  if (locale.languageCode != 'zh') return false;
  final script = locale.scriptCode?.toLowerCase();
  if (script == 'hant') return true;
  if (script == 'hans') return false;
  const regions = {'TW', 'HK', 'MO'};
  return regions.contains(locale.countryCode?.toUpperCase());
}

Locale resolveAppLocale(AppLocaleMode mode, {Locale? deviceLocale}) {
  switch (mode) {
    case AppLocaleMode.zh:
      return const Locale('zh');
    case AppLocaleMode.zhHant:
      return const Locale('zh', 'TW');
    case AppLocaleMode.en:
      return const Locale('en');
    case AppLocaleMode.system:
      final device =
          deviceLocale ?? WidgetsBinding.instance.platformDispatcher.locale;
      if (isTraditionalChinese(device)) return const Locale('zh', 'TW');
      if (device.languageCode == 'zh') return const Locale('zh');
      return const Locale('en');
  }
}

final platformLocaleProvider =
    NotifierProvider<PlatformLocaleController, Locale>(
  PlatformLocaleController.new,
);

class PlatformLocaleController extends Notifier<Locale> {
  @override
  Locale build() => WidgetsBinding.instance.platformDispatcher.locale;

  void setLocale(Locale locale) => state = locale;
}

final appLocaleModeProvider =
    NotifierProvider<AppLocaleController, AppLocaleMode>(
  AppLocaleController.new,
);

final resolvedAppLocaleProvider = Provider<Locale>((ref) {
  final mode = ref.watch(appLocaleModeProvider);
  final device = ref.watch(platformLocaleProvider);
  return resolveAppLocale(mode, deviceLocale: device);
});

final appLocalizationsProvider = Provider<AppLocalizations>((ref) {
  return lookupAppLocalizations(ref.watch(resolvedAppLocaleProvider));
});

class AppLocaleController extends Notifier<AppLocaleMode> {
  @override
  AppLocaleMode build() {
    Future.microtask(_restore);
    return AppLocaleMode.system;
  }

  Future<void> _restore() async {
    final sp = await SharedPreferences.getInstance();
    state = AppLocaleMode.parse(sp.getString(SpKey.locale.keyMode));
  }

  Future<void> setMode(AppLocaleMode mode) async {
    state = mode;
    final sp = await SharedPreferences.getInstance();
    await sp.setString(SpKey.locale.keyMode, mode.storageName());
  }
}
