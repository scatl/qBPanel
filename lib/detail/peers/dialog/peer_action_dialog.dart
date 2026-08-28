import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qbpanel/api/entity/response/torrent_peer_response.dart';
import 'package:qbpanel/detail/peers/dialog/add_peers_dialog.dart';
import 'package:qbpanel/detail/peers/torrent_peers_view_model.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';
import 'package:qbpanel/widget/dialog/confirm_dialog.dart';

abstract final class PeerActionDialog {
  PeerActionDialog._();

  static Future<void> show({
    required BuildContext context,
    required TorrentPeerResponse peer,
    required TorrentPeersViewModel viewModel,
  }) {
    return showGeneralDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: BlurDialogMotion.duration,
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return BlurDialogScaffold(
          animation: animation,
          onBarrierTap: () => Navigator.of(ctx).pop(),
          panelConstraints: const BoxConstraints(minWidth: 240, maxWidth: 320),
          panelPadding: const EdgeInsets.fromLTRB(8, 14, 8, 8),
          child: _PeerActionContent(
            peer: peer,
            onAddPeers: () {
              Navigator.of(ctx).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!context.mounted) return;
                AddPeersDialog.show(context: context, viewModel: viewModel);
              });
            },
            onCopy: () async {
              Navigator.of(ctx).pop();
              await Clipboard.setData(ClipboardData(text: peer.endpoint));
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(context.l10n.copiedEndpoint)));
            },
            onBan: () {
              Navigator.of(ctx).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) _banPeer(context, peer, viewModel);
              });
            },
          ),
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
    );
  }
}

Future<void> _banPeer(
  BuildContext context,
  TorrentPeerResponse peer,
  TorrentPeersViewModel viewModel,
) async {
  final l10n = context.l10n;
  final confirmed = await ConfirmDialog.show(
    context,
    title: l10n.banPeerTitle,
    message: l10n.banPeerMessage(peer.endpoint),
    confirmText: l10n.ban,
    destructive: true,
  );
  if (confirmed != true || !context.mounted) return;

  final error = await viewModel.banPeer(peer.endpoint);
  if (!context.mounted) return;
  if (error == null) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.peerBanned)));
    return;
  }
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(l10n.banFailed(error))));
}

class _PeerActionContent extends StatelessWidget {
  const _PeerActionContent({
    required this.peer,
    required this.onAddPeers,
    required this.onCopy,
    required this.onBan,
  });

  final TorrentPeerResponse peer;
  final VoidCallback onAddPeers;
  final VoidCallback onCopy;
  final VoidCallback onBan;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: Text(
            peer.displayName,
            style: textTheme.titleMedium?.copyWith(color: scheme.onSurface),
          ),
        ),
        _ActionTile(
          icon: Icons.person_add_outlined,
          label: context.l10n.addPeers,
          onTap: onAddPeers,
        ),
        _ActionTile(icon: Icons.copy_outlined, label: context.l10n.copyEndpoint, onTap: onCopy),
        _ActionTile(
          icon: Icons.block,
          label: context.l10n.banPeer,
          foreground: scheme.error,
          onTap: onBan,
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.foreground,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final color = foreground ?? Theme.of(context).colorScheme.onSurface;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
