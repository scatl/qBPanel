import 'package:qbpanel/storage/sp_key.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSettings {

  const ThemeSettings({
    required this.themeMode,
    required this.useDynamicColor,
    required this.seedColor,
  });

  /// 跟随系统 / 浅色 / 深色
  final ThemeMode themeMode;

  /// true = 尽量使用 Android 12+ 系统强调色（Material You）
  /// 不支持时自动回退到 [seedColor]
  final bool useDynamicColor;

  /// 自定义种子色（任意取色的结果）
  final Color seedColor;

  static const Color defaultSeed = Color(0xFF1B6B5A);

  static const ThemeSettings defaults = ThemeSettings(
    themeMode: ThemeMode.system,
    useDynamicColor: true,
    seedColor: defaultSeed,
  );

  ThemeSettings copyWith({
    ThemeMode? themeMode,
    bool? useDynamicColor,
    Color? seedColor,
  }) {
    return ThemeSettings(
      themeMode: themeMode ?? this.themeMode,
      useDynamicColor: useDynamicColor ?? this.useDynamicColor,
      seedColor: seedColor ?? this.seedColor,
    );
  }

  static Future<ThemeSettings> load() async {
    final sp = await SharedPreferences.getInstance();
    final themeMode = ThemeMode.values.firstWhere(
      (m) => m.name == sp.getString(SpKey.theme.keyMode),
      orElse: () => ThemeMode.system
    );

    return ThemeSettings(
        themeMode: themeMode,
        useDynamicColor: sp.getBool(SpKey.theme.keyDynamic) ?? false,
        seedColor: Color(sp.getInt(SpKey.theme.keySeedColor) ?? defaultSeed.toARGB32())
    );
  }

  Future<void> save() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(SpKey.theme.keyMode, themeMode.name);
    await sp.setBool(SpKey.theme.keyDynamic, useDynamicColor);
    await sp.setInt(SpKey.theme.keySeedColor, seedColor.toARGB32());
  }
}