import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qbpanel/api/entity/response/torrent_webseed_response.dart';
import 'package:qbpanel/detail/webseeds/edit_webseed_dialog.dart';
import 'package:qbpanel/detail/webseeds/torrent_webseeds_view_model.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';
import 'package:qbpanel/widget/dialog/confirm_dialog.dart';

abstract final class WebSeedActionDialog {
  WebSeedActionDialog._();

  static Future<void> show({
    required BuildContext context,
    required TorrentWebSeedResponse webSeed,
    required TorrentWebSeedsViewModel viewModel,
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
          child: _WebSeedActionContent(
            url: webSeed.url,
            onEdit: () {
              Navigator.of(ctx).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!context.mounted) return;
                EditWebSeedDialog.show(
                  context: context,
                  viewModel: viewModel,
                  webSeed: webSeed,
                );
              });
            },
            onRemove: () {
              Navigator.of(ctx).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  _removeWebSeed(context, webSeed, viewModel);
                }
              });
            },
            onCopy: () async {
              Navigator.of(ctx).pop();
              await Clipboard.setData(ClipboardData(text: webSeed.url));
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(context.l10n.copiedHttpSeed)));
            },
          ),
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
    );
  }
}

Future<void> _removeWebSeed(
  BuildContext context,
  TorrentWebSeedResponse webSeed,
  TorrentWebSeedsViewModel viewModel,
) async {
  final l10n = context.l10n;
  final confirmed = await ConfirmDialog.show(
    context,
    title: l10n.deleteHttpSeed,
    message: l10n.confirmDeleteHttpSeed(webSeed.url),
    confirmText: l10n.actionDelete,
    destructive: true,
  );
  if (confirmed != true || !context.mounted) return;
  final error = await viewModel.removeWebSeed(webSeed.url);
  if (!context.mounted) return;
  if (error == null) return;
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(l10n.deleteFailed(error))));
}

class _WebSeedActionContent extends StatelessWidget {
  const _WebSeedActionContent({
    required this.url,
    required this.onEdit,
    required this.onRemove,
    required this.onCopy,
  });

  final String url;
  final VoidCallback onEdit;
  final VoidCallback onRemove;
  final VoidCallback onCopy;

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
            url,
            style: textTheme.titleMedium?.copyWith(color: scheme.onSurface),
          ),
        ),
        _ActionTile(
          icon: Icons.edit_outlined,
          label: context.l10n.editHttpSeed,
          onTap: onEdit,
        ),
        _ActionTile(
          icon: Icons.delete_outline,
          label: context.l10n.deleteHttpSeed,
          foreground: scheme.error,
          onTap: onRemove,
        ),
        _ActionTile(
          icon: Icons.copy_outlined,
          label: context.l10n.copyHttpSeed,
          onTap: onCopy,
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
