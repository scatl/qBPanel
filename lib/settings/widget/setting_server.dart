import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qbpanel/router/router_path.dart';
import 'package:qbpanel/widget/page_insets.dart';

class SettingServer extends ConsumerWidget {
  const SettingServer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 大标题
        Padding(
          padding: PageInsets.content,
          child: Text(
            '服务器',
            style: TextStyle(
                fontSize: 20
            ),
          ),
        ),
        const SizedBox(height: 4),
        ListTile(
          contentPadding: PageInsets.content,
          title: Text('服务器设置', style: textTheme.bodyLarge),
          subtitle: Text(
            '修改或添加服务器',
            style: textTheme.bodySmall?.copyWith(color: scheme.outline),
          ),
          onTap: () => context.push(RouterPath.serverList),
        ),

      ],
    );
  }
}