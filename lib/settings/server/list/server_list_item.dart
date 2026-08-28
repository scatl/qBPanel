import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qbpanel/widget/page_insets.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/storage/db/app_database.dart';

class ServerListItem extends StatelessWidget {
  const ServerListItem({
    super.key,
    required this.server,
    this.showEdit = true,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final QbServer server;
  final bool showEdit;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final void Function(QbServer server)? onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final schemeUrl =
        '${server.useHttps ? 'https' : 'http'}://${server.host}:${server.port}';
    final borderColor = server.isActive ? scheme.primary : scheme.outlineVariant;
    final borderWidth = server.isActive ? 2.0 : 1.0;

    final tile = InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 12, showEdit ? 4 : 16, 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    server.name,
                    style: textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    schemeUrl,
                    style: textTheme.bodySmall?.copyWith(
                      color: scheme.outline,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (showEdit)
              IconButton(
                tooltip: context.l10n.actionEdit,
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
          ],
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PageInsets.horizontal,
        vertical: 6,
      ),
      child: Material(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor, width: borderWidth),
        ),
        clipBehavior: Clip.antiAlias,
        child: onDelete == null
            ? tile
            : Slidable(
                key: ValueKey(server.id),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.28,
                  children: [
                    SlidableAction(
                      onPressed: (_) => onDelete!(server),
                      backgroundColor: scheme.error,
                      foregroundColor: scheme.onError,
                      icon: Icons.delete_outline,
                      label: context.l10n.actionDelete,
                    ),
                  ],
                ),
                child: tile,
              ),
      ),
    );
  }
}
