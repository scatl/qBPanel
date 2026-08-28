import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
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
    final l10n = context.l10n;
    final ui = ref.watch(serverListProvider);
    final vm = ref.read(serverListProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsServer),
        actions: [
          if (ui.activeServer != null)...[
            IconButton(
              tooltip: l10n.currentServerSettings,
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push(RouterPath.serverSettingsWithParams(ui.activeServer?.id))
            ),
          ]
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouterPath.serverModifyWithParams()),
        tooltip: l10n.addServer,
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
                l10n.serverListHint,
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
              emptyTitle: l10n.noServers,
              emptySubtitle: l10n.noServersHint,
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
    final l10n = context.l10n;
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.deleteServer,
      message: l10n.confirmDeleteServer(server.name),
      cancelText: l10n.actionCancel,
      confirmText: l10n.actionDelete,
    );
    if (confirmed != true || !mounted) return;
    await ref.read(serverListProvider.notifier).delete(server.id);
  }
}
