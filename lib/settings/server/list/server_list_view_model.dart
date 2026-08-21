import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/settings/server/list/server_list_ui_state.dart';
import 'package:qbpanel/storage/db/app_database.dart';
import 'package:qbpanel/storage/db/app_database_provider.dart';

final serverListProvider = NotifierProvider<ServerListViewModel, ServerListUiState>(
    ServerListViewModel.new
);

class ServerListViewModel extends Notifier<ServerListUiState> {
  @override
  ServerListUiState build() {
    final ui = ServerListUiState();
    ui.list.beginInit();
    Future.microtask(refresh);
    return ui;
  }

  /// 拉取本地全部服务器（无分页）
  Future<void> refresh() async {
    final list = state.list;
    if (!list.initLoading) {
      list.beginRefresh();
      state = state.copyWith(list: list);
    }

    try {
      final db = ref.read(appDatabaseProvider);
      final rows = await (db.select(db.qbServers)
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();
      final activeServer = rows.where((s) => s.isActive).firstOrNull;
      list.setSuccess(data: rows, append: false, hasMore: false);
      state = state.copyWith(list: list, activeServer: activeServer);
    } catch (e) {
      list.setError(
        e.toString(),
        keepItems: list.items.isNotEmpty,
      );
      state = state.copyWith(list: list);
    }
  }

  Future<void> setActive(int id) async {
    final db = ref.read(appDatabaseProvider);
    await db.transaction(() async {
      await db.update(db.qbServers).write(
        const QbServersCompanion(isActive: Value(false))
      );
      await (db.update(db.qbServers)..where((t) => t.id.equals(id))).write(
          const QbServersCompanion(isActive: Value(true))
      );
    });
    await refresh();
  }

  /// 删除本地服务器配置，并刷新列表。
  Future<void> delete(int id) async {
    final db = ref.read(appDatabaseProvider);
    await (db.delete(db.qbServers)..where((t) => t.id.equals(id))).go();
    await refresh();
  }
}
