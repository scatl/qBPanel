import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:qbpanel/api/entity/response/search_result_response.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/router/router_path.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

abstract final class SearchResultActionDialog {
  SearchResultActionDialog._();

  static Future<void> show({
    required BuildContext context,
    required SearchResultResponse result,
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
          panelConstraints: const BoxConstraints(minWidth: 220, maxWidth: 280),
          panelPadding: const EdgeInsets.fromLTRB(8, 14, 8, 8),
          child: _SearchResultActionContent(
            result: result,
            onDownload: () {
              Navigator.of(ctx).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!context.mounted) return;
                context.push(
                  RouterPath.addTorrentWithParams(url: result.fileUrl),
                );
              });
            },
            onOpenDescription: () async {
              Navigator.of(ctx).pop();
              final ok = await _openExternalUrl(result.descrLink!);
              if (!context.mounted) return;
              if (!ok) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l10n.cannotOpenDescription)),
                );
              }
            },
            onCopyName: () => _copyAndClose(
              dialogContext: ctx,
              pageContext: context,
              text: result.fileName,
              message: context.l10n.copiedName,
            ),
            onCopyDownloadLink: () => _copyAndClose(
              dialogContext: ctx,
              pageContext: context,
              text: result.fileUrl,
              message: context.l10n.copiedDownloadLink,
            ),
            onCopyDescriptionUrl: () => _copyAndClose(
              dialogContext: ctx,
              pageContext: context,
              text: result.descrLink!,
              message: context.l10n.copiedDescriptionUrl,
            ),
          ),
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
    );
  }

  static Future<void> _copyAndClose({
    required BuildContext dialogContext,
    required BuildContext pageContext,
    required String text,
    required String message,
  }) async {
    Navigator.of(dialogContext).pop();
    await Clipboard.setData(ClipboardData(text: text));
    if (!pageContext.mounted) return;
    ScaffoldMessenger.of(pageContext).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static Future<bool> _openExternalUrl(String raw) async {
    final url = raw.trim();
    if (url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) return false;
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _SearchResultActionContent extends StatelessWidget {
  const _SearchResultActionContent({
    required this.result,
    required this.onDownload,
    required this.onOpenDescription,
    required this.onCopyName,
    required this.onCopyDownloadLink,
    required this.onCopyDescriptionUrl,
  });

  final SearchResultResponse result;
  final VoidCallback onDownload;
  final VoidCallback onOpenDescription;
  final VoidCallback onCopyName;
  final VoidCallback onCopyDownloadLink;
  final VoidCallback onCopyDescriptionUrl;

  bool get _hasDownloadLink => result.fileUrl.trim().isNotEmpty;

  bool get _hasDescriptionLink => (result.descrLink ?? '').trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: Text(
            result.fileName,
            style: textTheme.titleMedium?.copyWith(color: scheme.onSurface),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _ActionTile(
          icon: Icons.download_outlined,
          label: l10n.download,
          enabled: _hasDownloadLink,
          onTap: onDownload,
        ),
        _ActionTile(
          icon: Icons.open_in_new_outlined,
          label: l10n.openDescription,
          enabled: _hasDescriptionLink,
          onTap: onOpenDescription,
        ),
        _ActionTile(
          icon: Icons.copy_outlined,
          label: l10n.copyName,
          onTap: onCopyName,
        ),
        _ActionTile(
          icon: Icons.link_outlined,
          label: l10n.copyDownloadLink,
          enabled: _hasDownloadLink,
          onTap: onCopyDownloadLink,
        ),
        _ActionTile(
          icon: Icons.description_outlined,
          label: l10n.copyDescriptionUrl,
          enabled: _hasDescriptionLink,
          onTap: onCopyDescriptionUrl,
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
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = enabled
        ? scheme.onSurface
        : scheme.onSurface.withValues(alpha: 0.38);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
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
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: color,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
