import 'package:qbpanel/theme/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeSettingProvider = NotifierProvider<ThemeController, ThemeSettings>(ThemeController.new);

class ThemeController extends Notifier<ThemeSettings> {

  @override
  ThemeSettings build() {
    //先默认，再取本地配置
    Future.microtask(_restore);
    return ThemeSettings.defaults;
  }

  Future<void> _restore() async {
    state = await ThemeSettings.load();
  }

  /// 切换：跟随系统 / 浅色 / 深色
  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _persist();
  }

  /// 是否优先使用 Android 12+ 系统强调色
  Future<void> setUseDynamicColor(bool enabled) async {
    state = state.copyWith(useDynamicColor: enabled);
    await _persist();
  }

  /// 自定义任意主题色（种子色）
  Future<void> setSeedColor(Color color) async {
    state = state.copyWith(seedColor: color);
    await _persist();
  }

  Future<void> _persist() async {
    await state.save();
  }

}