import 'package:flutter/cupertino.dart';
import 'package:qbpanel/theme/system_ui.dart';
import 'package:qbpanel/theme/theme_settings.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

class ThemeBuilder extends StatelessWidget{
  const ThemeBuilder({
    super.key,
    required this.themeSettings,
    required this.builder
  });

  final ThemeSettings themeSettings;
  final Widget Function(ThemeData light, ThemeData dark) builder;

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: ((lightDynamic, darkDynamic) {
          final useDynamicColor = themeSettings.useDynamicColor
              && lightDynamic != null && darkDynamic != null;
          final lightScheme = useDynamicColor
              ? lightDynamic.harmonized()
              : ColorScheme.fromSeed(seedColor: themeSettings.seedColor, brightness: Brightness.light);
          final darkScheme = useDynamicColor
              ? darkDynamic.harmonized()
              : ColorScheme.fromSeed(seedColor: themeSettings.seedColor, brightness: Brightness.dark);
          return builder(_buildTheme(lightScheme), _buildTheme(darkScheme));
        })
    );
  }
}

ThemeData _buildTheme(ColorScheme scheme) {
  final outlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: scheme.outlineVariant),
  );

  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    // Zoom 默认会对下层做 snapshot，Ink 水波纹会被“冻住”，返回后才继续播完
    // 官方说明：https://github.com/flutter/flutter/issues/119897
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(
          allowEnterRouteSnapshotting: false,
        ),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: ZoomPageTransitionsBuilder(
          allowEnterRouteSnapshotting: false,
        ),
        TargetPlatform.windows: ZoomPageTransitionsBuilder(
          allowEnterRouteSnapshotting: false,
        ),
      },
    ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: systemUiOverlayStyle(scheme.brightness),
    ),
    // 全局让 TextField 变成「带轮廓的输入框」，而不是默认下划线样式
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
      border: outlineBorder,
      enabledBorder: outlineBorder,
      disabledBorder: outlineBorder.copyWith(
        borderSide: BorderSide(
          color: scheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      focusedBorder: outlineBorder.copyWith(
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      errorBorder: outlineBorder.copyWith(
        borderSide: BorderSide(color: scheme.error),
      ),
      focusedErrorBorder: outlineBorder.copyWith(
        borderSide: BorderSide(color: scheme.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}