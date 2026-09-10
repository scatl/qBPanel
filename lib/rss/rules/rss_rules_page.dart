import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qbpanel/api/entity/response/rss_rule_response.dart';
import 'package:qbpanel/api/qb_api_capabilities.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/router/router_path.dart';
import 'package:qbpanel/rss/rules/rss_rules_view_model.dart';
import 'package:qbpanel/widget/dialog/confirm_dialog.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';
import 'package:qbpanel/widget/page_insets.dart';
import 'package:qbpanel/widget/refresh/paged_refresh_list.dart';

/// RSS 自动下载规则列表。
class RssRulesPage extends ConsumerWidget {
  const RssRulesPage({super.key});

  Future<void> _openEdit(
    BuildContext context,
    WidgetRef ref, {
    String? name,
  }) async {
    await context.push(RouterPath.rssRuleEditWithParams(name: name));
    if (!context.mounted) return;
    await ref.read(rssRulesProvider.notifier).refresh();
  }

  Future<void> _openRssSettings(BuildContext context, WidgetRef ref) async {
    final serverId = ref.read(activeServerProvider).value?.id;
    if (serverId == null) return;
    await context.push(RouterPath.serverSettingsRssWithParams(serverId));
    if (!context.mounted) return;
    await ref.read(rssRulesProvider.notifier).refresh();
  }

  Future<void> _setEnabled(
    BuildContext context,
    WidgetRef ref,
    RssAutoDownloadRule rule,
    bool enabled,
  ) async {
    final error =
        await ref.read(rssRulesProvider.notifier).setEnabled(rule, enabled);
    if (!context.mounted || error == null) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    RssAutoDownloadRule rule,
  ) async {
    final l10n = context.l10n;
    final ok = await ConfirmDialog.show(
      context,
      title: l10n.actionDelete,
      message: l10n.rssConfirmDelete(rule.name),
      confirmText: l10n.actionDelete,
      destructive: true,
    );
    if (ok != true || !context.mounted) return;
    LoadingDialog.show(context, message: l10n.saving);
    final error =
        await ref.read(rssRulesProvider.notifier).removeRule(rule.name);
    if (!context.mounted) return;
    LoadingDialog.dismiss(context);
    if (error == null) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(rssRulesProvider);
    final vm = ref.read(rssRulesProvider.notifier);
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.rssAutoDownloadRules),
        actions: [
          IconButton(
            tooltip: l10n.rssNewRule,
            icon: const Icon(Icons.add),
            onPressed: () => _openEdit(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          if (!ui.autoDownloadingEnabled)
            Material(
              color: scheme.errorContainer,
              child: InkWell(
                onTap: () => _openRssSettings(context, ref),
                child: Padding(
                  padding: PageInsets.content.copyWith(top: 10, bottom: 10),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: scheme.onErrorContainer),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.rssAutoDownloadingDisabledBanner,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: scheme.onErrorContainer,
                              ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: scheme.onErrorContainer,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: PagedRefreshList<RssAutoDownloadRule>(
              state: ui.list,
              enableLoadMore: false,
              emptyTitle: l10n.rssEmptyRulesTitle,
              emptySubtitle: l10n.rssEmptyRulesSubtitle,
              emptyIcon: Icons.rule_outlined,
              padding: const EdgeInsets.only(bottom: 24),
              onRefresh: vm.refresh,
              itemBuilder: (context, index, rule) {
                final busy = ui.busyRuleNames.contains(rule.name);
                return _RssRuleItem(
                  rule: rule,
                  busy: busy,
                  onTap: () => _openEdit(context, ref, name: rule.name),
                  onEnabledChanged: (enabled) =>
                      _setEnabled(context, ref, rule, enabled),
                  onDelete: () => _confirmDelete(context, ref, rule),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RssRuleItem extends StatelessWidget {
  const _RssRuleItem({
    required this.rule,
    required this.busy,
    required this.onTap,
    required this.onEnabledChanged,
    required this.onDelete,
  });

  final RssAutoDownloadRule rule;
  final bool busy;
  final VoidCallback onTap;
  final ValueChanged<bool> onEnabledChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final subtitle = rule.mustContain.trim().isEmpty
        ? null
        : rule.mustContain.trim();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PageInsets.horizontal,
        vertical: 6,
      ),
      child: Material(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onDelete,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 4, 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        rule.name,
                        style: textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Switch(
                  value: rule.enabled,
                  onChanged: busy ? null : onEnabledChanged,
                ),
                IconButton(
                  tooltip: l10n.actionDelete,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: busy ? null : onDelete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
