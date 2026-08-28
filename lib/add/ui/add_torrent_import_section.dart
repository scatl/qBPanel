import 'package:flutter/material.dart';
import 'package:qbpanel/add/add_torrent_ui_state.dart';
import 'package:qbpanel/add/ui/add_torrent_card.dart';
import 'package:qbpanel/l10n/context_l10n.dart';

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
    final l10n = context.l10n;
    return AddTorrentCard(
      child: Column(
        children: [
          _ImportTile(
            icon: Icons.link,
            title: l10n.importMagnet,
            subtitle: ui.isFromMagnet
                ? (ui.sourceUrl ?? l10n.tapToChangeLink)
                : l10n.enterMagnetOrHttp,
            onTap: onImportMagnet,
          ),
          const Divider(height: 1),
          _ImportTile(
            icon: Icons.insert_drive_file_outlined,
            title: l10n.importFile,
            subtitle: ui.isFromFile
                ? (ui.sourceFileName ?? l10n.tapToChangeFile)
                : l10n.selectTorrentFile,
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
