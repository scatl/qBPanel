import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// 与网格断点一致：shortestSide ≥ 此值视为平板（不含桌面窗口、不含手机横屏）。
const kTabletShortestSide = 600.0;

/// Windows / macOS / Linux 桌面端（不含 Web）。
bool get isDesktopPlatform {
  if (kIsWeb) return false;
  return switch (defaultTargetPlatform) {
    TargetPlatform.windows ||
    TargetPlatform.linux ||
    TargetPlatform.macOS => true,
    _ => false,
  };
}

/// Android / iOS 平板。用 shortestSide，避免手机横屏被当成 Pad。
bool isTablet(BuildContext context) {
  if (isDesktopPlatform) return false;
  return MediaQuery.sizeOf(context).shortestSide >= kTabletShortestSide;
}

/// 桌面，或 Pad。用于 Dialog / 底栏额外信息等宽屏 chrome（仍不要用来决定列表列数）。
bool isDesktopOrTablet(BuildContext context) =>
    isDesktopPlatform || isTablet(context);

/// 上下文菜单触发：桌面用右键（带全局坐标），手机 / Pad 用长按。
({VoidCallback? onLongPress, GestureTapUpCallback? onSecondaryTapUp})
contextMenuActivators(void Function(Offset? position)? action) {
  if (action == null) {
    return (onLongPress: null, onSecondaryTapUp: null);
  }
  if (isDesktopPlatform) {
    return (
      onLongPress: null,
      onSecondaryTapUp: (details) => action(details.globalPosition),
    );
  }
  return (onLongPress: () => action(null), onSecondaryTapUp: null);
}
