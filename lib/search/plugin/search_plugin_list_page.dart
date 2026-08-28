import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/entity/response/search_plugin_response.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/search/plugin/search_plugin_list_view_model.dart';
import 'package:qbpanel/search/plugin/ui/install_search_plugin_dialog.dart';
import 'package:qbpanel/search/plugin/ui/search_plugin_item.dart';
import 'package:qbpanel/widget/dialog/confirm_dialog.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';
import 'package:qbpanel/widget/page_insets.dart';
import 'package:qbpanel/widget/refresh/paged_refresh_list.dart';
import 'package:url_launcher/url_launcher.dart';

const _pluginsSiteUrl = 'https://plugins.qbittorrent.org';

class SearchPluginListPage extends ConsumerWidget {
  const SearchPluginListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final ui = ref.watch(searchPluginListProvider);
    final vm = ref.read(searchPluginListProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.searchPlugins),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              PageInsets.horizontal,
              12,
              PageInsets.horizontal,
              8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _installPlugin(context, vm),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.installPlugin),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: ui.updating
                        ? null
                        : () => _checkForUpdates(context, vm),
                    icon: ui.updating
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: scheme.primary,
                            ),
                          )
                        : const Icon(Icons.system_update_alt_outlined),
                    label: Text(ui.updating ? l10n.checkingUpdates : l10n.checkUpdates),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: PageInsets.content,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.searchPluginCopyrightWarning,
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      l10n.searchPluginGetMore,
                      style: textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    InkWell(
                      onTap: () => _openPluginsSite(context),
                      borderRadius: BorderRadius.circular(4),
                      child: Text(
                        _pluginsSiteUrl,
                        style: textTheme.bodySmall?.copyWith(
                          color: scheme.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: scheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: PagedRefreshList<SearchPluginResponse>(
              state: ui.list,
              enableLoadMore: false,
              emptyTitle: l10n.noSearchPluginsList,
              emptySubtitle: l10n.noSearchPluginsListHint,
              emptyIcon: Icons.extension_off_outlined,
              padding: const EdgeInsets.only(bottom: 24),
              onRefresh: vm.refresh,
              itemBuilder: (context, index, plugin) {
                final busy = ui.busyPluginNames.contains(plugin.name);
                return SearchPluginItem(
                  plugin: plugin,
                  busy: busy,
                  onEnabledChanged: (enabled) =>
                      _setEnabled(context, vm, plugin, enabled),
                  onDelete: () => _confirmDelete(context, vm, plugin),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _openPluginsSite(BuildContext context) async {
    final uri = Uri.parse(_pluginsSiteUrl);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!context.mounted || ok) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.cannotOpenLink)),
    );
  }

  Future<void> _installPlugin(
    BuildContext context,
    SearchPluginListViewModel vm,
  ) async {
    final source = await InstallSearchPluginDialog.show(context);
    if (source == null || !context.mounted) return;

    final l10n = context.l10n;
    LoadingDialog.show(context, message: l10n.installing);
    final error = await vm.installPlugin(source);
    if (context.mounted) LoadingDialog.dismiss(context);
    if (!context.mounted) return;

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pluginInstalled)),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.installFailed(error))),
    );
  }

  Future<void> _checkForUpdates(
    BuildContext context,
    SearchPluginListViewModel vm,
  ) async {
    final error = await vm.checkForUpdates();
    if (!context.mounted) return;
    final l10n = context.l10n;

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pluginsUpdated)),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.checkUpdatesFailed(error))),
    );
  }

  Future<void> _setEnabled(
    BuildContext context,
    SearchPluginListViewModel vm,
    SearchPluginResponse plugin,
    bool enabled,
  ) async {
    final error = await vm.setPluginEnabled(plugin.name, enabled);
    if (!context.mounted || error == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.operationFailed(error))),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    SearchPluginListViewModel vm,
    SearchPluginResponse plugin,
  ) async {
    final title =
        plugin.fullName.isNotEmpty ? plugin.fullName : plugin.name;
    final l10n = context.l10n;
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.deletePlugin,
      message: l10n.confirmUninstallPlugin(title),
      confirmText: l10n.actionDelete,
      destructive: true,
    );
    if (confirmed != true || !context.mounted) return;

    LoadingDialog.show(context, message: l10n.deleting);
    final error = await vm.uninstallPlugin(plugin.name);
    if (context.mounted) LoadingDialog.dismiss(context);
    if (!context.mounted) return;

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pluginDeleted)),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.deleteFailed(error))),
    );
  }
}
