import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qbpanel/api/entity/response/torrent_tracker_response.dart';
import 'package:qbpanel/detail/trackers/edit_tracker_dialog.dart';
import 'package:qbpanel/detail/trackers/torrent_trackers_view_model.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';
import 'package:qbpanel/widget/dialog/confirm_dialog.dart';

abstract final class TrackerActionDialog {
  TrackerActionDialog._();

  static Future<void> show({
    required BuildContext context,
    required TorrentTrackerResponse tracker,
    required TorrentTrackersViewModel viewModel,
    required bool canReannounce,
  }) {
    final editable = !tracker.isSpecial;
    if (!editable && !canReannounce) return Future.value();

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
          child: _TrackerActionContent(
            tracker: tracker,
            editable: editable,
            canReannounce: canReannounce,
            onEdit: () {
              Navigator.of(ctx).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!context.mounted) return;
                EditTrackerDialog.show(
                  context: context,
                  viewModel: viewModel,
                  tracker: tracker,
                );
              });
            },
            onRemove: () {
              Navigator.of(ctx).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  _removeTracker(context, tracker, viewModel);
                }
              });
            },
            onCopy: () async {
              Navigator.of(ctx).pop();
              await Clipboard.setData(ClipboardData(text: tracker.url));
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('已复制 Tracker URL')));
            },
            onReannounce: () {
              Navigator.of(ctx).pop();
              _reannounce(context, viewModel, url: tracker.url);
            },
            onReannounceAll: () {
              Navigator.of(ctx).pop();
              _reannounce(context, viewModel);
            },
          ),
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
    );
  }
}

Future<void> _removeTracker(
  BuildContext context,
  TorrentTrackerResponse tracker,
  TorrentTrackersViewModel viewModel,
) async {
  final confirmed = await ConfirmDialog.show(
    context,
    title: '删除 Tracker',
    message: '确定删除 ${tracker.displayName}？',
    confirmText: '删除',
    destructive: true,
  );
  if (confirmed != true || !context.mounted) return;
  final error = await viewModel.removeTracker(tracker.url);
  if (!context.mounted) return;
  if (error == null) return;
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('删除失败：$error')));
}

Future<void> _reannounce(
  BuildContext context,
  TorrentTrackersViewModel viewModel, {
  String? url,
}) async {
  final error = await viewModel.reannounce(url: url);
  if (!context.mounted) return;
  if (error == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(url == null ? '已重新宣告全部 Tracker' : '已重新宣告该 Tracker'),
      ),
    );
    return;
  }
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('重新宣告失败：$error')));
}

class _TrackerActionContent extends StatelessWidget {
  const _TrackerActionContent({
    required this.tracker,
    required this.editable,
    required this.canReannounce,
    required this.onEdit,
    required this.onRemove,
    required this.onCopy,
    required this.onReannounce,
    required this.onReannounceAll,
  });

  final TorrentTrackerResponse tracker;
  final bool editable;
  final bool canReannounce;
  final VoidCallback onEdit;
  final VoidCallback onRemove;
  final VoidCallback onCopy;
  final VoidCallback onReannounce;
  final VoidCallback onReannounceAll;

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
            tracker.displayName,
            style: textTheme.titleMedium?.copyWith(color: scheme.onSurface),
          ),
        ),
        if (editable) ...[
          _ActionTile(
            icon: Icons.edit_outlined,
            label: '编辑 Tracker URL',
            onTap: onEdit,
          ),
          _ActionTile(
            icon: Icons.delete_outline,
            label: '删除 Tracker',
            foreground: scheme.error,
            onTap: onRemove,
          ),
          _ActionTile(
            icon: Icons.copy_outlined,
            label: '复制 Tracker URL',
            onTap: onCopy,
          ),
        ],
        if (canReannounce) ...[
          if (editable)
            _ActionTile(
              icon: Icons.campaign_outlined,
              label: '强制重新宣告选中的 Tracker',
              onTap: onReannounce,
            ),
          _ActionTile(
            icon: Icons.campaign,
            label: '强制重新宣告全部 Tracker',
            onTap: onReannounceAll,
          ),
        ],
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
