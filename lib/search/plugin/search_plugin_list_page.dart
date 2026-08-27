import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/entity/response/search_plugin_response.dart';
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
    final ui = ref.watch(searchPluginListProvider);
    final vm = ref.read(searchPluginListProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('搜索插件'),
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
                    label: const Text('安装插件'),
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
                    label: Text(ui.updating ? '检查中…' : '检查更新'),
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
                  '警告：在下载来自这些搜索引擎的 torrent 时，请确认它符合您所在国家的版权法。',
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '你可以在这里获取新的搜索引擎插件：',
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
              emptyTitle: '暂无搜索插件',
              emptySubtitle: '点击「安装插件」或「检查更新」获取官方插件',
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
      const SnackBar(content: Text('无法打开链接')),
    );
  }

  Future<void> _installPlugin(
    BuildContext context,
    SearchPluginListViewModel vm,
  ) async {
    final source = await InstallSearchPluginDialog.show(context);
    if (source == null || !context.mounted) return;

    LoadingDialog.show(context, message: '安装中…');
    final error = await vm.installPlugin(source);
    if (context.mounted) LoadingDialog.dismiss(context);
    if (!context.mounted) return;

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('插件已安装')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('安装失败：$error')),
    );
  }

  Future<void> _checkForUpdates(
    BuildContext context,
    SearchPluginListViewModel vm,
  ) async {
    final error = await vm.checkForUpdates();
    if (!context.mounted) return;

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('插件列表已更新')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('检查更新失败：$error')),
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
      SnackBar(content: Text('操作失败：$error')),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    SearchPluginListViewModel vm,
    SearchPluginResponse plugin,
  ) async {
    final title =
        plugin.fullName.isNotEmpty ? plugin.fullName : plugin.name;
    final confirmed = await ConfirmDialog.show(
      context,
      title: '删除插件',
      message: '确定卸载 $title？',
      confirmText: '删除',
      destructive: true,
    );
    if (confirmed != true || !context.mounted) return;

    LoadingDialog.show(context, message: '删除中…');
    final error = await vm.uninstallPlugin(plugin.name);
    if (context.mounted) LoadingDialog.dismiss(context);
    if (!context.mounted) return;

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('插件已删除')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('删除失败：$error')),
    );
  }
}
