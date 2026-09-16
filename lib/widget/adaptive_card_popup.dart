import 'package:flutter/material.dart';
import 'package:qbpanel/util/platform_info.dart';
import 'package:qbpanel/widget/adaptive_card_grid.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';
import 'package:qbpanel/widget/sheet/blur_modal_bottom_sheet.dart';

/// 桌面或 Pad，且当前宽度为多列时用 Dialog；手机 / 窄窗口一律 sheet。
bool useWideCardPopup(BuildContext context) =>
    isDesktopOrTablet(context) &&
    useAdaptiveGrid(MediaQuery.sizeOf(context).width);

/// 卡片点击 / 上下文菜单：手机或窄窗口 sheet，桌面 / Pad 多列 Dialog（有 [anchor] 则贴在坐标旁）。
///
/// [useDialog] 为 null 时：桌面或 Pad 且宽度 ≥ 600 用 Dialog，否则 sheet；
/// 始终单列的列表（如 HTTP 种子）应传 `false`。
Future<T?> showAdaptiveCardPopup<T>({
  required BuildContext context,
  required Widget Function(BuildContext popupContext) builder,
  Offset? anchor,
  bool? useDialog,
  BoxConstraints dialogConstraints = const BoxConstraints(
    minWidth: 240,
    maxWidth: 320,
  ),
  EdgeInsetsGeometry dialogPadding = const EdgeInsets.fromLTRB(8, 14, 8, 8),
  EdgeInsetsGeometry sheetPadding = EdgeInsets.zero,
}) {
  if (useDialog ?? useWideCardPopup(context)) {
    return showGeneralDialog<T>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: BlurDialogMotion.duration,
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return BlurDialogScaffold(
          animation: animation,
          anchor: anchor,
          onBarrierTap: () => Navigator.of(ctx).pop(),
          panelConstraints: dialogConstraints,
          panelPadding: dialogPadding,
          child: builder(ctx),
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
    );
  }

  return showBlurModalBottomSheet<T>(
    context: context,
    builder: (ctx) => Padding(padding: sheetPadding, child: builder(ctx)),
  );
}
