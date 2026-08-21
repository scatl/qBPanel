import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qbpanel/api/entity/response/torrent_peer_response.dart';
import 'package:qbpanel/detail/peers/dialog/add_peers_dialog.dart';
import 'package:qbpanel/detail/peers/torrent_peers_view_model.dart';
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
              ).showSnackBar(const SnackBar(content: Text('已复制 IP 端口')));
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
  final confirmed = await ConfirmDialog.show(
    context,
    title: '永久禁止用户',
    message: '确定永久禁止 ${peer.endpoint}？该用户将无法再连接。',
    confirmText: '禁止',
    destructive: true,
  );
  if (confirmed != true || !context.mounted) return;

  final error = await viewModel.banPeer(peer.endpoint);
  if (!context.mounted) return;
  if (error == null) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已禁止该用户')));
    return;
  }
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('禁止失败：$error')));
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
          label: '添加对等节点',
          onTap: onAddPeers,
        ),
        _ActionTile(icon: Icons.copy_outlined, label: '复制IP端口', onTap: onCopy),
        _ActionTile(
          icon: Icons.block,
          label: '永久禁止用户',
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
