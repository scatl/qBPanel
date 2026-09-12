import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/settings/widget/setting_subtitle.dart';
import 'package:qbpanel/widget/page_insets.dart';
import 'package:url_launcher/url_launcher.dart';

const _sourceUrl = 'https://github.com/scatl/qBPanel';
const _privacyUrl = 'https://scatl.github.io/qBPanel/privacy-policy.html';

final appPackageInfoProvider = FutureProvider<PackageInfo>((ref) {
  return PackageInfo.fromPlatform();
});

/// 设置页「关于」：版本、开源许可、源码与隐私链接。
class SettingAbout extends ConsumerWidget {
  const SettingAbout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final versionLabel = ref
        .watch(appPackageInfoProvider)
        .maybeWhen(data: _formatVersion, orElse: () => l10n.emDash);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: PageInsets.content,
          child: SettingSectionTitle(l10n.settingsAbout),
        ),
        const SizedBox(height: 4),
        ListTile(
          contentPadding: PageInsets.content,
          title: Text(l10n.settingsAboutVersion, style: textTheme.bodyLarge),
          subtitle: Text(
            versionLabel,
            style: textTheme.bodySmall?.copyWith(color: scheme.outline),
          ),
        ),
        ListTile(
          contentPadding: PageInsets.content,
          title: Text(l10n.settingsAboutLicenses, style: textTheme.bodyLarge),
          subtitle: Text(
            l10n.settingsAboutLicensesSubtitle,
            style: textTheme.bodySmall?.copyWith(color: scheme.outline),
          ),
          onTap: () {
            final info = ref.read(appPackageInfoProvider).asData?.value;
            showLicensePage(
              context: context,
              applicationName: l10n.appTitle,
              applicationVersion: info == null ? null : _formatVersion(info),
            );
          },
        ),
        ListTile(
          contentPadding: PageInsets.content,
          title: Text(l10n.settingsAboutSource, style: textTheme.bodyLarge),
          subtitle: Text(
            l10n.settingsAboutSourceSubtitle,
            style: textTheme.bodySmall?.copyWith(color: scheme.outline),
          ),
          onTap: () => _openUrl(context, _sourceUrl),
        ),
        ListTile(
          contentPadding: PageInsets.content,
          title: Text(l10n.settingsAboutPrivacy, style: textTheme.bodyLarge),
          subtitle: Text(
            l10n.settingsAboutPrivacySubtitle,
            style: textTheme.bodySmall?.copyWith(color: scheme.outline),
          ),
          onTap: () => _openUrl(context, _privacyUrl),
        ),
      ],
    );
  }

  static String _formatVersion(PackageInfo info) {
    if (info.buildNumber.isEmpty) return info.version;
    return '${info.version} (${info.buildNumber})';
  }

  static Future<void> _openUrl(BuildContext context, String url) async {
    final ok = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!context.mounted || ok) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.cannotOpenLink)));
  }
}
