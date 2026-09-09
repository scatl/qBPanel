import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/http/poll_settings.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/settings/widget/setting_subtitle.dart';
import 'package:qbpanel/widget/dropdown_field.dart';
import 'package:qbpanel/widget/page_insets.dart';

/// 设置页「刷新」区块：轮询间隔。
class SettingRefresh extends ConsumerWidget {
  const SettingRefresh({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final interval = ref.watch(pollIntervalProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: PageInsets.content,
          child: SettingSectionTitle(l10n.settingsRefresh),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: PageInsets.content,
          child: DropdownField<PollInterval>(
            label: l10n.settingsPollInterval,
            value: interval,
            items: [
              for (final item in PollInterval.values)
                DropdownMenuItem(value: item, child: Text(item.label(l10n))),
            ],
            onChanged: (value) {
              ref.read(pollIntervalProvider.notifier).setInterval(value);
            },
          ),
        ),
      ],
    );
  }
}
