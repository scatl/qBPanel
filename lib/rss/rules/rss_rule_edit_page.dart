import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/add/add_torrent_ui_state.dart';
import 'package:qbpanel/api/qb_api_capabilities.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/rss/rules/rss_rule_edit_view_model.dart';
import 'package:qbpanel/rss/rules/ui/rss_rule_matching_dialog.dart';
import 'package:qbpanel/settings/widget/settings_group_card.dart';
import 'package:qbpanel/settings/widget/settings_input_field.dart';
import 'package:qbpanel/settings/widget/settings_switch_tile.dart';
import 'package:qbpanel/widget/check_row.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';
import 'package:qbpanel/widget/dropdown_field.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';
import 'package:qbpanel/widget/page_insets.dart';

enum _AddPausedChoice { useDefault, always, never }

enum _ContentLayoutChoice { useDefault, original, subfolder, noSubfolder }

_ContentLayoutChoice _contentLayoutChoice(String? apiValue) {
  return switch (apiValue) {
    'Original' => _ContentLayoutChoice.original,
    'Subfolder' => _ContentLayoutChoice.subfolder,
    'NoSubfolder' => _ContentLayoutChoice.noSubfolder,
    _ => _ContentLayoutChoice.useDefault,
  };
}

/// 新建 / 编辑自动下载规则。
class RssRuleEditPage extends ConsumerStatefulWidget {
  const RssRuleEditPage({
    super.key,
    required this.ruleName,
  });

  final String ruleName;

  @override
  ConsumerState<RssRuleEditPage> createState() => _RssRuleEditPageState();
}

class _RssRuleEditPageState extends ConsumerState<RssRuleEditPage> {
  final _nameController = TextEditingController();
  final _mustContainController = TextEditingController();
  final _mustNotContainController = TextEditingController();
  final _episodeFilterController = TextEditingController();
  final _ignoreDaysController = TextEditingController();
  final _savePathController = TextEditingController();
  var _filled = false;

  @override
  void dispose() {
    _nameController.dispose();
    _mustContainController.dispose();
    _mustNotContainController.dispose();
    _episodeFilterController.dispose();
    _ignoreDaysController.dispose();
    _savePathController.dispose();
    super.dispose();
  }

  RssRuleEditViewModel get _vm =>
      ref.read(rssRuleEditProvider(widget.ruleName).notifier);

  void _fillIfNeeded() {
    if (_filled) return;
    final ui = ref.read(rssRuleEditProvider(widget.ruleName));
    if (!ui.ready) return;
    _filled = true;
    final rule = ui.rule;
    _nameController.text = rule.name;
    _mustContainController.text = rule.mustContain;
    _mustNotContainController.text = rule.mustNotContain;
    _episodeFilterController.text = rule.episodeFilter;
    _ignoreDaysController.text = '${rule.ignoreDays}';
    _savePathController.text = rule.savePath;
  }

  Future<void> _onSave() async {
    FocusScope.of(context).unfocus();
    final ui = ref.read(rssRuleEditProvider(widget.ruleName));
    if (!ui.ready || ui.saving) return;

    LoadingDialog.show(context, message: context.l10n.saving);
    await Future<void>.delayed(Duration.zero);
    final error = await _vm.save(
      name: _nameController.text,
      mustContain: _mustContainController.text,
      mustNotContain: _mustNotContainController.text,
      episodeFilter: _episodeFilterController.text,
      ignoreDays: int.tryParse(_ignoreDaysController.text.trim()) ?? 0,
      savePath: _savePathController.text,
    );
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error == null ? context.l10n.saved : context.l10n.saveFailed(error),
        ),
      ),
    );
  }

  Future<void> _onMatching() async {
    LoadingDialog.show(context, message: context.l10n.saving);
    await Future<void>.delayed(Duration.zero);
    final error = await _vm.loadMatchingArticles();
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }
    final matching = ref.read(rssRuleEditProvider(widget.ruleName)).matching;
    await RssRuleMatchingDialog.show(context, matching: matching);
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(rssRuleEditProvider(widget.ruleName));
    final vm = _vm;
    final l10n = context.l10n;
    final cap = ref.watch(qbApiCapabilitiesProvider);
    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;
    final canEdit = ui.ready && !ui.saving;
    final rule = ui.rule;

    ref.listen(rssRuleEditProvider(widget.ruleName), (prev, next) {
      _fillIfNeeded();
    });
    _fillIfNeeded();

    final addPaused = switch (rule.addPaused) {
      true => _AddPausedChoice.always,
      false => _AddPausedChoice.never,
      null => _AddPausedChoice.useDefault,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ui.isNew ? l10n.rssNewRule : l10n.rssEditRule,
        ),
        actions: [
          IconButton(
            tooltip: l10n.actionSave,
            icon: const Icon(Icons.save),
            onPressed: canEdit ? _onSave : null,
          ),
        ],
      ),
      body: EmptyStateHost(
        state: ui.emptyState,
        onRetry: vm.load,
        padding: const EdgeInsets.all(24),
        builder: (context) => ListView(
          padding: EdgeInsets.fromLTRB(0, 8, 0, 24 + bottomSafe),
          children: [
            SettingsGroupCard(
              title: l10n.rssRuleDefinition,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SettingsSwitchTile(
                    title: l10n.rssRuleEnabled,
                    value: rule.enabled,
                    onChanged: canEdit
                        ? (v) => vm.setRule(rule.copyWith(enabled: v))
                        : null,
                  ),
                  SettingsInputField(
                    label: l10n.rssRuleName,
                    controller: _nameController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  SettingsSwitchTile(
                    title: l10n.rssRuleUseRegex,
                    value: rule.useRegex,
                    onChanged: canEdit
                        ? (v) => vm.setRule(rule.copyWith(useRegex: v))
                        : null,
                  ),
                  SettingsInputField(
                    label: l10n.rssRuleMustContain,
                    controller: _mustContainController,
                    enabled: canEdit,
                    minLines: 1,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),
                  SettingsInputField(
                    label: l10n.rssRuleMustNotContain,
                    controller: _mustNotContainController,
                    enabled: canEdit,
                    minLines: 1,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),
                  SettingsInputField(
                    label: l10n.rssRuleEpisodeFilter,
                    controller: _episodeFilterController,
                    enabled: canEdit,
                    hintText: l10n.rssRuleEpisodeFilterHint,
                  ),
                  SettingsSwitchTile(
                    title: l10n.rssRuleSmartFilter,
                    value: rule.smartFilter,
                    onChanged: canEdit
                        ? (v) => vm.setRule(rule.copyWith(smartFilter: v))
                        : null,
                  ),
                  SettingsInputField(
                    label: l10n.rssRuleIgnoreDays,
                    controller: _ignoreDaysController,
                    enabled: canEdit,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    suffix: l10n.rssRuleDays,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SettingsGroupCard(
              title: l10n.rssRuleAffectedFeeds,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: ui.feeds.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        l10n.rssRuleNoFeeds,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            TextButton(
                              onPressed:
                                  canEdit ? () => vm.setAllFeeds(true) : null,
                              child: Text(l10n.rssRuleSelectAllFeeds),
                            ),
                            TextButton(
                              onPressed:
                                  canEdit ? () => vm.setAllFeeds(false) : null,
                              child: Text(l10n.rssRuleSelectNoneFeeds),
                            ),
                          ],
                        ),
                        for (final feed in ui.feeds)
                          if (feed.url.isNotEmpty)
                            CheckRow(
                              label: feed.displayName,
                              value: rule.affectedFeeds.contains(feed.url),
                              enabled: canEdit,
                              onChanged: (v) => vm.toggleFeed(feed.url, v),
                            ),
                      ],
                    ),
            ),
            const SizedBox(height: 12),
            SettingsGroupCard(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.rssRuleAssignCategory,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilterChip(
                        label: Text(l10n.filterUncategorized),
                        selected: rule.assignedCategory.isEmpty,
                        onSelected: canEdit
                            ? (_) => vm.setRule(
                                  rule.copyWith(assignedCategory: ''),
                                )
                            : null,
                      ),
                      for (final name in ui.categories)
                        FilterChip(
                          label: Text(name),
                          selected: rule.assignedCategory == name,
                          onSelected: canEdit
                              ? (selected) => vm.setRule(
                                    rule.copyWith(
                                      assignedCategory: selected ? name : '',
                                    ),
                                  )
                              : null,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SettingsInputField(
                    label: l10n.rssRuleSaveTo,
                    controller: _savePathController,
                    enabled: canEdit,
                    minLines: 1,
                    maxLines: 3,
                  ),
                  DropdownField<_AddPausedChoice>(
                    label: l10n.rssRuleAddPaused,
                    value: addPaused,
                    enabled: canEdit,
                    items: [
                      DropdownMenuItem(
                        value: _AddPausedChoice.useDefault,
                        child: Text(l10n.rssRuleUseDefault),
                      ),
                      DropdownMenuItem(
                        value: _AddPausedChoice.always,
                        child: Text(l10n.rssRuleAddPausedAlways),
                      ),
                      DropdownMenuItem(
                        value: _AddPausedChoice.never,
                        child: Text(l10n.rssRuleAddPausedNever),
                      ),
                    ],
                    onChanged: (choice) {
                      switch (choice) {
                        case _AddPausedChoice.useDefault:
                          vm.setRule(rule.copyWith(clearAddPaused: true));
                        case _AddPausedChoice.always:
                          vm.setRule(rule.copyWith(addPaused: true));
                        case _AddPausedChoice.never:
                          vm.setRule(rule.copyWith(addPaused: false));
                      }
                    },
                  ),
                  if (cap.hasContentLayout)
                    DropdownField<_ContentLayoutChoice>(
                      label: l10n.rssRuleContentLayout,
                      value: _contentLayoutChoice(rule.torrentContentLayout),
                      enabled: canEdit,
                      items: [
                        DropdownMenuItem(
                          value: _ContentLayoutChoice.useDefault,
                          child: Text(l10n.rssRuleUseDefault),
                        ),
                        DropdownMenuItem(
                          value: _ContentLayoutChoice.original,
                          child: Text(
                            TorrentContentLayout.original.label(l10n),
                          ),
                        ),
                        DropdownMenuItem(
                          value: _ContentLayoutChoice.subfolder,
                          child: Text(
                            TorrentContentLayout.createSubfolder.label(l10n),
                          ),
                        ),
                        DropdownMenuItem(
                          value: _ContentLayoutChoice.noSubfolder,
                          child: Text(l10n.rssRuleLayoutNoSubfolder),
                        ),
                      ],
                      onChanged: (choice) {
                        switch (choice) {
                          case _ContentLayoutChoice.useDefault:
                            vm.setRule(
                              rule.copyWith(clearTorrentContentLayout: true),
                            );
                          case _ContentLayoutChoice.original:
                            vm.setRule(
                              rule.copyWith(
                                torrentContentLayout:
                                    TorrentContentLayout.original.apiValue,
                              ),
                            );
                          case _ContentLayoutChoice.subfolder:
                            vm.setRule(
                              rule.copyWith(
                                torrentContentLayout: TorrentContentLayout
                                    .createSubfolder.apiValue,
                              ),
                            );
                          case _ContentLayoutChoice.noSubfolder:
                            vm.setRule(
                              rule.copyWith(
                                torrentContentLayout: TorrentContentLayout
                                    .noSubfolder.apiValue,
                              ),
                            );
                        }
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: PageInsets.content,
              child: OutlinedButton.icon(
                onPressed: canEdit && !ui.isNew ? _onMatching : null,
                icon: const Icon(Icons.playlist_add_check_outlined),
                label: Text(l10n.rssRuleMatchingArticles),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
