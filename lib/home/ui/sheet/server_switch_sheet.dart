import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/settings/server/list/server_list_item.dart';
import 'package:qbpanel/settings/server/list/server_list_view_model.dart';
import 'package:qbpanel/storage/db/app_database.dart';
import 'package:qbpanel/widget/sheet/blur_modal_bottom_sheet.dart';

class ServerSwitchSheet extends ConsumerStatefulWidget {
  const ServerSwitchSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showBlurModalBottomSheet<void>(
      context: context,
      builder: (_) => const ServerSwitchSheet(),
    );
  }

  @override
  ConsumerState<ServerSwitchSheet> createState() => _ServerSwitchSheetState();
}

class _ServerSwitchSheetState extends ConsumerState<ServerSwitchSheet> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(serverListProvider.notifier).refresh());
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(serverListProvider);
    final textTheme = Theme.of(context).textTheme;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.7;
    final list = ui.list;

    Widget body;
    if (list.showInitLoading) {
      body = const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (list.showEmptyOrError) {
      body = Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Text(
          list.error ? (list.errorMessage ?? '加载失败') : '暂无服务器',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      );
    } else {
      body = ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: list.items.length,
        itemBuilder: (context, index) {
          final server = list.items[index];
          return ServerListItem(
            server: server,
            showEdit: false,
            onTap: () => _onSelect(server),
          );
        },
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text('切换服务器', style: textTheme.titleMedium),
          ),
          Flexible(child: body),
        ],
      ),
    );
  }

  Future<void> _onSelect(QbServer server) async {
    if (!server.isActive) {
      await ref.read(serverListProvider.notifier).setActive(server.id);
    }
    if (!mounted) return;
    Navigator.pop(context);
  }
}
