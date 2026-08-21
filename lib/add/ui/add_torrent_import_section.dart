import 'package:flutter/material.dart';
import 'package:qbpanel/add/add_torrent_ui_state.dart';
import 'package:qbpanel/add/ui/add_torrent_card.dart';

class AddTorrentImportSection extends StatelessWidget {
  const AddTorrentImportSection({
    super.key,
    required this.ui,
    required this.onImportMagnet,
    required this.onImportFile,
  });

  final AddTorrentUiState ui;
  final VoidCallback onImportMagnet;
  final VoidCallback onImportFile;

  @override
  Widget build(BuildContext context) {
    return AddTorrentCard(
      child: Column(
        children: [
          _ImportTile(
            icon: Icons.link,
            title: '从磁力链接导入',
            subtitle: ui.isFromMagnet
                ? (ui.sourceUrl ?? '点击更换链接')
                : '输入磁力链接或 HTTP(S) 地址',
            onTap: onImportMagnet,
          ),
          const Divider(height: 1),
          _ImportTile(
            icon: Icons.insert_drive_file_outlined,
            title: '从文件导入',
            subtitle: ui.isFromFile
                ? (ui.sourceFileName ?? '点击更换文件')
                : '选择 .torrent 文件',
            onTap: onImportFile,
          ),
        ],
      ),
    );
  }
}

class _ImportTile extends StatelessWidget {
  const _ImportTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: Icon(icon, color: scheme.onSurfaceVariant),
      title: Text(title),
      subtitle: Text(
        subtitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
