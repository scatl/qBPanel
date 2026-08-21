import 'package:flutter/material.dart';

/// 页面水平内容边距。
///
/// ListView 本身左右不 padding，让 [ListTile] / [SwitchListTile] 可以全宽水波纹；
/// 文字与控件通过本边距内缩。
abstract final class PageInsets {
  static const horizontal = 16.0;

  static const content = EdgeInsets.symmetric(horizontal: horizontal);
}
