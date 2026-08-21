import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/settings/widget/setting_subtitle.dart';
import 'package:qbpanel/theme/system_ui.dart';
import 'package:qbpanel/theme/theme_controller.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';
import 'package:qbpanel/widget/page_insets.dart';

/// 设置页「外观」区块
///
/// 层级：
/// - 大标题：外观
/// - 选项标题：显示模式 / 主题色 / 预览（更小、更淡）
/// - 选项正文：按钮、开关、说明文字
class SettingAppearance extends ConsumerWidget {
  const SettingAppearance({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(themeSettingProvider);
    final controller = ref.read(themeSettingProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dynamicSupported = ref.watch(dynamicColorSupportedProvider);

    final showDynamicSwitch = dynamicSupported.maybeWhen(
      data: (supported) => supported,
      orElse: () => false,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 大标题
        Padding(
          padding: PageInsets.content,
          child: Text(
            '外观',
            style: TextStyle(
              fontSize: 20
            ),
          ),
        ),
        const SizedBox(height: 16),
        // 选项：显示模式
        const Padding(
          padding: PageInsets.content,
          child: SettingSubtitle('显示模式'),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: PageInsets.content,
          child: SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.system,
                label: Text('跟随系统'),
                icon: Icon(Icons.brightness_auto),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                label: Text('浅色'),
                icon: Icon(Icons.light_mode_outlined),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text('深色'),
                icon: Icon(Icons.dark_mode_outlined),
              ),
            ],
            selected: {settings.themeMode},
            onSelectionChanged: (value) {
              controller.setThemeMode(value.first);
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: PageInsets.content,
          child: Text(
            '跟随系统时，自动匹配设备的浅色 / 深色模式。',
            style: textTheme.bodySmall?.copyWith(color: scheme.outline),
          ),
        ),
        const SizedBox(height: 20),
        // 选项：主题色
        const Padding(
          padding: PageInsets.content,
          child: SettingSubtitle('主题色'),
        ),
        const SizedBox(height: 4),
        if (showDynamicSwitch) ...[
          SwitchListTile(
            contentPadding: PageInsets.content,
            title: Text('使用系统强调色', style: textTheme.bodyLarge),
            subtitle: Text(
              '使用 Android 12+ 的 Material You 配色。',
              style: textTheme.bodySmall?.copyWith(color: scheme.outline),
            ),
            value: settings.useDynamicColor,
            onChanged: controller.setUseDynamicColor,
          ),
        ],
        ListTile(
          contentPadding: PageInsets.content,
          title: Text('自定义主题色', style: textTheme.bodyLarge),
          subtitle: Text(
            showDynamicSwitch && settings.useDynamicColor
                ? '关闭上方开关后生效；系统色不可用时也会回退到此颜色'
                : '任意选取一个颜色，作为 Material 3 种子色',
            style: textTheme.bodySmall?.copyWith(color: scheme.outline),
          ),
          trailing: _ColorDot(color: settings.seedColor),
          onTap: () => _pickColor(context, ref),
        ),
      ],
    );
  }

  Future<void> _pickColor(BuildContext context, WidgetRef ref) async {
    final current = ref.read(themeSettingProvider).seedColor;
    var temp = current;

    final confirmed = await showGeneralDialog<bool>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: BlurDialogMotion.duration,
      pageBuilder: (ctx, animation, secondaryAnimation) {
        final scheme = Theme.of(ctx).colorScheme;
        final textTheme = Theme.of(ctx).textTheme;
        final dialogWidth = MediaQuery.sizeOf(ctx).width * 0.8;
        return BlurDialogScaffold(
          animation: animation,
          onBarrierTap: () => Navigator.of(ctx).pop(false),
          panelConstraints: BoxConstraints.tightFor(width: dialogWidth),
          panelPadding: const EdgeInsets.fromLTRB(24, 22, 24, 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '选择主题色',
                  style: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
                ),
                const SizedBox(height: 12),
                ColorPicker(
                  color: current,
                  onColorChanged: (color) => temp = color,
                  width: 40,
                  height: 40,
                  borderRadius: 8,
                  heading: Text(
                    '取色',
                    style: textTheme.titleSmall,
                  ),
                  subheading: Text(
                    '选中后点「应用」立即生效',
                    style: textTheme.bodySmall,
                  ),
                  pickersEnabled: const {
                    ColorPickerType.both: false,
                    ColorPickerType.primary: true,
                    ColorPickerType.accent: false,
                    ColorPickerType.wheel: true,
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('取消'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('应用'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
    );

    if (confirmed == true) {
      await ref.read(themeSettingProvider.notifier).setSeedColor(temp);
    }
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
    );
  }
}
