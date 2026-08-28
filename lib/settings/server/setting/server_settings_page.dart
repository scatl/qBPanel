import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/router/router_path.dart';
import 'package:qbpanel/settings/widget/settings_group_card.dart';
import 'package:qbpanel/widget/page_insets.dart';

class ServerSettingsPage extends StatefulWidget {
  const ServerSettingsPage({
    super.key,
    required this.serverId,
  });

  final int serverId;

  @override
  State<StatefulWidget> createState() {
    return _ServerSettingsPageState();
  }
}

class _ServerSettingsPageState extends State<ServerSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final groups = [
      _ServerSettingGroup(
        icon: Icons.tune,
        title: l10n.qbSetBehavior,
        onTap: () => context.push(
          RouterPath.serverSettingsBehaviorWithParams(widget.serverId),
        ),
      ),
      _ServerSettingGroup(
        icon: Icons.download_outlined,
        title: l10n.qbSetDownloads,
        onTap: () => context.push(
          RouterPath.serverSettingsDownloadsWithParams(widget.serverId),
        ),
      ),
      _ServerSettingGroup(
        icon: Icons.lan_outlined,
        title: l10n.qbSetConnection,
        onTap: () => context.push(
          RouterPath.serverSettingsConnectionWithParams(widget.serverId),
        ),
      ),
      _ServerSettingGroup(
        icon: Icons.speed,
        title: l10n.qbSetSpeed,
        onTap: () => context.push(
          RouterPath.serverSettingsSpeedWithParams(widget.serverId),
        ),
      ),
      _ServerSettingGroup(
        icon: Icons.hub_outlined,
        title: 'BitTorrent',
        onTap: () => context.push(
          RouterPath.serverSettingsBittorrentWithParams(widget.serverId),
        ),
      ),
      const _ServerSettingGroup(icon: Icons.rss_feed, title: 'RSS'),
      _ServerSettingGroup(
        icon: Icons.web,
        title: 'WebUI',
        onTap: () => context.push(
          RouterPath.serverSettingsWebUiWithParams(widget.serverId),
        ),
      ),
      _ServerSettingGroup(
        icon: Icons.build_outlined,
        title: l10n.qbSetAdvanced,
        onTap: () => context.push(
          RouterPath.serverSettingsAdvancedWithParams(widget.serverId),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsServerSettings),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 24 + bottomSafe),
        children: [
          SettingsGroupCard(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.qbSetDisclaimer,
                    style: textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          for (final group in groups)
            _ServerSettingGroupTile(group: group),
        ],
      ),
    );
  }
}

class _ServerSettingGroup {
  const _ServerSettingGroup({
    required this.icon,
    required this.title,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
}

class _ServerSettingGroupTile extends StatelessWidget {
  const _ServerSettingGroupTile({required this.group});

  final _ServerSettingGroup group;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      contentPadding: PageInsets.content,
      leading: Icon(group.icon, color: scheme.onSurfaceVariant),
      title: Text(group.title, style: textTheme.bodyLarge),
      trailing: group.onTap == null
          ? null
          : Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
      onTap: group.onTap,
    );
  }
}
