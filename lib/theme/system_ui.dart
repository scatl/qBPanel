import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamic_color/dynamic_color.dart';

SystemUiOverlayStyle systemUiOverlayStyle(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  return SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    systemStatusBarContrastEnforced: false,

    systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    // Android 10+：关掉系统给导航栏加的半透明黑底，否则底部仍像一块黑条
    systemNavigationBarContrastEnforced: false,
  );
}

/// 进程启动时打开 edge-to-edge（与 Android 15 默认行为对齐）
void enableEdgeToEdge() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  // 先给一版默认（亮色）；真正亮暗以 MaterialApp builder 里的 AnnotatedRegion 为准
  SystemChrome.setSystemUIOverlayStyle(
    systemUiOverlayStyle(Brightness.light),
  );
}

final dynamicColorSupportedProvider = FutureProvider<bool>((ref) async {
  final palette = await DynamicColorPlugin.getCorePalette();
  return palette != null;
});