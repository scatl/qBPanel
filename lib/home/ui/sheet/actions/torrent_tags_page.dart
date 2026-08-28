import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/home/home_page_view_model.dart';
import 'package:qbpanel/home/entity/torrent_tag.dart';
import 'package:qbpanel/home/ui/dialog/tag_edit_dialog.dart';
import 'package:qbpanel/home/ui/torrent_category_tree.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/check_row.dart';
import 'package:qbpanel/widget/dialog/confirm_dialog.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';

class TorrentTagsPage extends ConsumerStatefulWidget {
  const TorrentTagsPage({
    super.key,
    required this.hash,
    required this.pageContext,
    required this.onBack,
  });

  final String hash;
  final BuildContext pageContext;
  final VoidCallback onBack;

  @override
  ConsumerState<TorrentTagsPage> createState() => _TorrentTagsPageState();
}

class _TorrentTagsPageState extends ConsumerState<TorrentTagsPage> {
  bool _busy = false;
  bool _clearing = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    ref.watch(homePageProvider);
    final vm = ref.read(homePageProvider.notifier);
    final torrent = vm.torrentByHash(widget.hash);
    final serverTags = ref.read(homePageProvider).tags;
    final selected = splitTorrentTags(torrent?.tags).toSet();
    final names = <String>{...serverTags, ...selected}.toList()..sort();
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 8, 8),
          child: Row(
            children: [
              IconButton(
                tooltip: l10n.actionBack,
                visualDensity: VisualDensity.compact,
                onPressed: _busy ? null : widget.onBack,
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Text(
                  l10n.tags,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: l10n.addTag,
                visualDensity: VisualDensity.compact,
                onPressed: _busy ? null : _createTag,
                icon: const Icon(Icons.new_label_outlined),
              ),
              FilterIconButton(
                tooltip: l10n.deleteUnusedTags,
                iconSize: 22,
                icon: Icons.label_off_outlined,
                onPressed: _busy ? null : _removeUnusedTags,
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
        Flexible(
          child: names.isEmpty
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Text(
                    l10n.noTagsHint,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                )
              : ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    for (final name in names)
                      CheckRow(
                        label: name,
                        value: selected.contains(name),
                        enabled: !_busy,
                        onChanged: (value) => _toggle(
                          name,
                          enable: value,
                        ),
                        trailing: FilterIconButton(
                          tooltip: l10n.deleteTag,
                          icon: Icons.delete_outline,
                          onPressed: _busy ? null : () => _deleteTag(name),
                        ),
                      ),
                  ],
                ),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Text(
              _error!,
              style: textTheme.bodySmall?.copyWith(color: scheme.error),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: OutlinedButton(
            onPressed: _busy || selected.isEmpty ? null : _clearTags,
            child: _clearing
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: scheme.primary,
                    ),
                  )
                : Text(l10n.removeTags),
          ),
        ),
      ],
    );
  }

  Future<void> _createTag() async {
    final created = await TagEditDialog.show(context);
    if (created != true || !mounted) return;
    setState(() => _error = null);
  }

  Future<void> _deleteTag(String tag) async {
    final l10n = context.l10n;
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.deleteTag,
      message: l10n.confirmDeleteTag(tag),
      confirmText: l10n.actionDelete,
    );
    if (confirmed != true || !mounted) return;
    LoadingDialog.show(context, message: l10n.deleting);
    final error = await ref.read(homePageProvider.notifier).deleteTag(tag);
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    if (error == null) return;
    setState(() => _error = error);
  }

  Future<void> _removeUnusedTags() async {
    final vm = ref.read(homePageProvider.notifier);
    final names = vm.unusedTagNames();
    final l10n = context.l10n;
    if (names.isEmpty) {
      ScaffoldMessenger.of(widget.pageContext).showSnackBar(
        SnackBar(content: Text(l10n.noUnusedTags)),
      );
      return;
    }
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.deleteUnusedTags,
      message: l10n.confirmDeleteUnusedTags(names.length),
      confirmText: l10n.actionDelete,
    );
    if (confirmed != true || !mounted) return;
    LoadingDialog.show(context, message: l10n.deleting);
    final error = await vm.deleteUnusedTags();
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    if (error == null) return;
    setState(() => _error = error);
  }

  Future<void> _toggle(String name, {required bool enable}) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final vm = ref.read(homePageProvider.notifier);
    final error = enable
        ? await vm.addTorrentTags(widget.hash, [name])
        : await vm.removeTorrentTags(widget.hash, [name]);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = error;
    });
  }

  Future<void> _clearTags() async {
    setState(() {
      _busy = true;
      _clearing = true;
      _error = null;
    });
    final error =
        await ref.read(homePageProvider.notifier).clearTorrentTags(widget.hash);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _clearing = false;
      _error = error;
    });
    if (error != null || !widget.pageContext.mounted) return;
    ScaffoldMessenger.of(widget.pageContext).showSnackBar(
      SnackBar(content: Text(context.l10n.tagsRemoved)),
    );
  }
}
