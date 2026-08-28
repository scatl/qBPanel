import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/settings/widget/setting_subtitle.dart';
import 'package:qbpanel/theme/system_ui.dart';
import 'package:qbpanel/theme/theme_controller.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';
import 'package:qbpanel/widget/dropdown_field.dart';
import 'package:qbpanel/widget/page_insets.dart';

/// 设置页「显示」区块
///
/// 层级：
/// - 大标题：显示
/// - 选项标题：语言 / 显示模式 / 主题色（更小、更淡）
/// - 选项正文：下拉、按钮、开关、说明文字
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

    final l10n = context.l10n;
    final localeMode = ref.watch(appLocaleModeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: PageInsets.content,
          child: Text(
            l10n.settingsAppearance,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: PageInsets.content,
          child: DropdownField<AppLocaleMode>(
            label: l10n.settingsLanguage,
            value: localeMode,
            items: [
              for (final mode in AppLocaleMode.values)
                DropdownMenuItem(
                  value: mode,
                  child: Text(mode.label(l10n)),
                ),
            ],
            onChanged: (value) {
              ref.read(appLocaleModeProvider.notifier).setMode(value);
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: PageInsets.content,
          child: SettingSubtitle(l10n.settingsDisplayMode),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: PageInsets.content,
          child: SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                value: ThemeMode.system,
                label: Text(l10n.settingsThemeSystem),
                icon: const Icon(Icons.brightness_auto),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                label: Text(l10n.settingsThemeLight),
                icon: const Icon(Icons.light_mode_outlined),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text(l10n.settingsThemeDark),
                icon: const Icon(Icons.dark_mode_outlined),
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
            l10n.settingsThemeHint,
            style: textTheme.bodySmall?.copyWith(color: scheme.outline),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: PageInsets.content,
          child: SettingSubtitle(l10n.settingsThemeColor),
        ),
        const SizedBox(height: 4),
        if (showDynamicSwitch) ...[
          SwitchListTile(
            contentPadding: PageInsets.content,
            title: Text(l10n.settingsUseDynamicColor, style: textTheme.bodyLarge),
            subtitle: Text(
              l10n.settingsUseDynamicColorHint,
              style: textTheme.bodySmall?.copyWith(color: scheme.outline),
            ),
            value: settings.useDynamicColor,
            onChanged: controller.setUseDynamicColor,
          ),
        ],
        ListTile(
          contentPadding: PageInsets.content,
          title: Text(l10n.settingsCustomThemeColor, style: textTheme.bodyLarge),
          subtitle: Text(
            showDynamicSwitch && settings.useDynamicColor
                ? l10n.settingsCustomThemeColorHintDynamic
                : l10n.settingsCustomThemeColorHint,
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
        final l10n = ctx.l10n;
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
                  l10n.settingsPickThemeColor,
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
                    l10n.settingsPickColor,
                    style: textTheme.titleSmall,
                  ),
                  subheading: Text(
                    l10n.settingsPickColorHint,
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
                      child: Text(l10n.actionCancel),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: Text(l10n.actionApply),
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
