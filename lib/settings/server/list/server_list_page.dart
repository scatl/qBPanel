import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:qbpanel/router/router_path.dart';
import 'package:qbpanel/settings/server/list/server_list_item.dart';
import 'package:qbpanel/settings/server/list/server_list_view_model.dart';
import 'package:qbpanel/widget/page_insets.dart';
import 'package:qbpanel/storage/db/app_database.dart';
import 'package:qbpanel/widget/dialog/confirm_dialog.dart';
import 'package:qbpanel/widget/refresh/paged_refresh_list.dart';

class ServerListPage extends ConsumerStatefulWidget {
  const ServerListPage({super.key});

  @override
  ConsumerState<ServerListPage> createState() => _ServerListPageState();
}

class _ServerListPageState extends ConsumerState<ServerListPage> {

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(serverListProvider);
    final vm = ref.read(serverListProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('服务器'),
        actions: [
          if (ui.activeServer != null)...[
            IconButton(
              tooltip: '当前服务器设置',
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push(RouterPath.serverSettingsWithParams(ui.activeServer?.id))
            ),
          ]
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouterPath.serverModifyWithParams()),
        tooltip: '添加服务器',
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (ui.activeServer != null)... [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                PageInsets.horizontal,
                12,
                PageInsets.horizontal,
                4,
              ),
              child: Text(
                '点击切换服务器，点击右上角可以修改服务器设置',
                style: textTheme.titleSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
          Expanded(
            child: SlidableAutoCloseBehavior(
              child: PagedRefreshList<QbServer>(
              state: ui.list,
              enableLoadMore: false,
              emptyTitle: '暂无服务器',
              emptySubtitle: '点击右下角添加一台 qBittorrent 服务器',
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 88),
              onRefresh: vm.refresh,
              itemBuilder: (context, index, server) {
                return ServerListItem(
                  server: server,
                  onTap: server.isActive
                      ? null
                      : () => vm.setActive(server.id),
                  onEdit: () {
                    context.push(
                      RouterPath.serverModifyWithParams(serverId: server.id),
                    );
                  },
                  onDelete: _confirmDelete,
                );
              },
            ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(QbServer server) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: '删除服务器',
      message: '确定删除「${server.name}」吗？此操作不可恢复。',
      cancelText: '取消',
      confirmText: '删除',
    );
    if (confirmed != true || !mounted) return;
    await ref.read(serverListProvider.notifier).delete(server.id);
  }
}
