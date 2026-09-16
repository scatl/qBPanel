import 'package:flutter/material.dart';
import 'package:qbpanel/api/entity/response/torrent_peer_response.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/adaptive_card_popup.dart';

abstract final class PeerFilesDialog {
  PeerFilesDialog._();

  static Future<void> show({
    required BuildContext context,
    required TorrentPeerResponse peer,
  }) {
    return showAdaptiveCardPopup<void>(
      context: context,
      dialogConstraints: const BoxConstraints(minWidth: 280, maxWidth: 420),
      dialogPadding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      sheetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      builder: (ctx) => _PeerFilesContent(peer: peer),
    );
  }
}

class _PeerFilesContent extends StatelessWidget {
  const _PeerFilesContent({required this.peer});

  final TorrentPeerResponse peer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final names = _peerFileNames(peer.files);
    final title = names.length <= 1
        ? l10n.downloadingFile
        : l10n.downloadingFiles(names.length);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          peer.displayName,
          style: textTheme.titleMedium?.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: textTheme.labelLarge?.copyWith(color: scheme.primary),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight:
                MediaQuery.sizeOf(context).height *
                (useWideCardPopup(context) ? 0.55 : 0.7),
          ),
          child: names.isEmpty
              ? Text(
                  l10n.noDownloadingFiles,
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: names.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.insert_drive_file_outlined,
                          size: 16,
                          color: scheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            names[index],
                            style: textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}

List<String> _peerFileNames(String? raw) {
  if (raw == null) return const [];
  return raw
      .split(RegExp(r'[\r\n]+'))
      .map((name) => name.trim())
      .where((name) => name.isNotEmpty)
      .toList();
}
