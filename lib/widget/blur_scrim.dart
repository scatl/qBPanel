import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dialog/blur_dialog_scaffold.dart';

/// 全屏高斯模糊 + 压暗，供 Dialog / Sheet 遮罩复用。
class BlurScrim extends StatelessWidget {
  const BlurScrim({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: BlurDialogMotion.blurSigma,
          sigmaY: BlurDialogMotion.blurSigma,
        ),
        child: ColoredBox(
          color: scheme.scrim.withValues(alpha: BlurDialogMotion.scrimAlpha),
        ),
      ),
    );
  }
}