import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/router/router_path.dart';
import 'package:qbpanel/settings/widget/setting_subtitle.dart';
import 'package:qbpanel/widget/page_insets.dart';

class SettingServer extends ConsumerWidget {
  const SettingServer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: PageInsets.content,
          child: SettingSectionTitle(l10n.settingsServer),
        ),
        const SizedBox(height: 4),
        ListTile(
          contentPadding: PageInsets.content,
          title: Text(l10n.settingsServerSettings, style: textTheme.bodyLarge),
          subtitle: Text(
            l10n.settingsServerSettingsSubtitle,
            style: textTheme.bodySmall?.copyWith(color: scheme.outline),
          ),
          onTap: () => context.push(RouterPath.serverList),
        ),
      ],
    );
  }
}
