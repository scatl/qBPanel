import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qbpanel/api/entity/response/rss_items_response.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/rss/rss_view_model.dart';
import 'package:qbpanel/rss/ui/rss_text_input_dialog.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';
import 'package:qbpanel/widget/dialog/confirm_dialog.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';

abstract final class RssFeedActionDialog {
  RssFeedActionDialog._();

  static Future<void> show({
    required BuildContext context,
    required RssTreeNode node,
    required RssViewModel vm,
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
          panelConstraints: const BoxConstraints(minWidth: 240, maxWidth: 300),
          panelPadding: const EdgeInsets.fromLTRB(8, 14, 8, 8),
          child: _RssFeedActionContent(
            node: node,
            parentContext: context,
            dialogContext: ctx,
            vm: vm,
          ),
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
    );
  }
}

class _RssFeedActionContent extends StatelessWidget {
  const _RssFeedActionContent({
    required this.node,
    required this.parentContext,
    required this.dialogContext,
    required this.vm,
  });

  final RssTreeNode node;
  final BuildContext parentContext;
  final BuildContext dialogContext;
  final RssViewModel vm;

  void _closeThen(Future<void> Function() action) {
    Navigator.of(dialogContext).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!parentContext.mounted) return;
      await action();
    });
  }

  Future<void> _runBusy(
    BuildContext context,
    Future<String?> Function() task, {
    String? successMessage,
  }) async {
    LoadingDialog.show(context, message: context.l10n.saving);
    await Future<void>.delayed(Duration.zero);
    final error = await task();
    if (!context.mounted) return;
    LoadingDialog.dismiss(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error ?? successMessage ?? context.l10n.saved,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: Text(
            node.displayName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.refresh),
          title: Text(l10n.rssUpdate),
          onTap: () => _closeThen(() async {
            await _runBusy(
              parentContext,
              () => vm.refreshItem(node.path),
              successMessage: l10n.rssUpdateStarted,
            );
          }),
        ),
        ListTile(
          leading: const Icon(Icons.done_all),
          title: Text(l10n.rssMarkAsRead),
          onTap: () => _closeThen(() async {
            await _runBusy(
              parentContext,
              () => vm.markAsRead(itemPath: node.path),
              successMessage: l10n.rssMarkedAsRead,
            );
          }),
        ),
        ListTile(
          leading: const Icon(Icons.drive_file_rename_outline),
          title: Text(l10n.actionRename),
          onTap: () => _closeThen(() async {
            final name = await RssTextInputDialog.show(
              parentContext,
              title: l10n.actionRename,
              label: l10n.rssName,
              initialValue: RssItemsParser.leafNameOf(node.path),
              emptyError: l10n.rssNameRequired,
            );
            if (name == null || !parentContext.mounted) return;
            await _runBusy(
              parentContext,
              () => vm.renameItem(itemPath: node.path, newName: name),
            );
          }),
        ),
        if (node.isFeed) ...[
          ListTile(
            leading: const Icon(Icons.link),
            title: Text(l10n.rssEditFeedUrl),
            onTap: () => _closeThen(() async {
              final url = await RssTextInputDialog.show(
                parentContext,
                title: l10n.rssEditFeedUrl,
                label: l10n.rssFeedUrl,
                initialValue: node.url,
                minLines: 2,
                maxLines: 4,
                emptyError: l10n.rssFeedUrlRequired,
              );
              if (url == null || !parentContext.mounted) return;
              await _runBusy(
                parentContext,
                () => vm.setFeedUrl(path: node.path, url: url),
              );
            }),
          ),
          ListTile(
            leading: const Icon(Icons.copy),
            title: Text(l10n.rssCopyFeedUrl),
            onTap: () => _closeThen(() async {
              await Clipboard.setData(ClipboardData(text: node.url));
              if (!parentContext.mounted) return;
              ScaffoldMessenger.of(parentContext).showSnackBar(
                SnackBar(content: Text(l10n.copiedWithLabel(l10n.rssFeedUrl))),
              );
            }),
          ),
        ],
        ListTile(
          leading: Icon(
            Icons.delete_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          title: Text(
            l10n.actionDelete,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          onTap: () => _closeThen(() async {
            final ok = await ConfirmDialog.show(
              parentContext,
              title: l10n.actionDelete,
              message: l10n.rssConfirmDelete(node.displayName),
              confirmText: l10n.actionDelete,
              destructive: true,
            );
            if (ok != true || !parentContext.mounted) return;
            await _runBusy(
              parentContext,
              () => vm.removeItem(node.path),
            );
          }),
        ),
      ],
    );
  }
}
