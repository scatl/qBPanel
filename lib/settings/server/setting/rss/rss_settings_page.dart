import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/router/router_path.dart';
import 'package:qbpanel/settings/server/setting/rss/rss_settings_view_model.dart';
import 'package:qbpanel/settings/widget/settings_group_card.dart';
import 'package:qbpanel/settings/widget/settings_input_field.dart';
import 'package:qbpanel/settings/widget/settings_switch_tile.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';

/// WebUI「RSS」选项。
class RssSettingsPage extends ConsumerStatefulWidget {
  const RssSettingsPage({
    super.key,
    required this.serverId,
  });

  final int serverId;

  @override
  ConsumerState<RssSettingsPage> createState() => _RssSettingsPageState();
}

class _RssSettingsPageState extends ConsumerState<RssSettingsPage> {
  final _refreshIntervalController = TextEditingController();
  final _fetchDelayController = TextEditingController();
  final _maxArticlesController = TextEditingController();
  final _filtersController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _refreshIntervalController.dispose();
    _fetchDelayController.dispose();
    _maxArticlesController.dispose();
    _filtersController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final ok = await ref.read(rssSettingsProvider.notifier).load();
    if (!mounted || !ok) return;
    final ui = ref.read(rssSettingsProvider);
    _refreshIntervalController.text = '${ui.rssRefreshInterval}';
    _fetchDelayController.text = '${ui.rssFetchDelay}';
    _maxArticlesController.text = '${ui.rssMaxArticlesPerFeed}';
    _filtersController.text = ui.rssSmartEpisodeFilters;
  }

  int _parseInt(TextEditingController controller, int fallback) {
    return int.tryParse(controller.text.trim()) ?? fallback;
  }

  void _syncTextFieldsToVm() {
    final vm = ref.read(rssSettingsProvider.notifier);
    final ui = ref.read(rssSettingsProvider);
    vm.applyTextFields(
      rssRefreshInterval:
          _parseInt(_refreshIntervalController, ui.rssRefreshInterval),
      rssFetchDelay: _parseInt(_fetchDelayController, ui.rssFetchDelay),
      rssMaxArticlesPerFeed:
          _parseInt(_maxArticlesController, ui.rssMaxArticlesPerFeed),
      rssSmartEpisodeFilters: _filtersController.text,
    );
  }

  Future<void> _onSave() async {
    FocusScope.of(context).unfocus();
    final ui = ref.read(rssSettingsProvider);
    if (!ui.ready || ui.saving) return;

    _syncTextFieldsToVm();
    LoadingDialog.show(context, message: context.l10n.saving);
    await Future<void>.delayed(Duration.zero);

    final error = await ref.read(rssSettingsProvider.notifier).save();
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

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(rssSettingsProvider);
    final vm = ref.read(rssSettingsProvider.notifier);
    final l10n = context.l10n;
    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;
    final canEdit = ui.ready && !ui.saving;
    final fetchingOn = canEdit && ui.rssProcessingEnabled;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.qbSetRss),
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
        onRetry: _load,
        padding: const EdgeInsets.all(24),
        builder: (context) => ListView(
          padding: EdgeInsets.fromLTRB(0, 8, 0, 24 + bottomSafe),
          children: [
            if (ui.hasPref('rss_processing_enabled') ||
                ui.hasPref('rss_refresh_interval') ||
                ui.hasPref('rss_fetch_delay') ||
                ui.hasPref('rss_max_articles_per_feed'))
              SettingsGroupCard(
                title: l10n.rssReader,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (ui.hasPref('rss_processing_enabled'))
                      SettingsSwitchTile(
                        title: l10n.rssEnableFetching,
                        value: ui.rssProcessingEnabled,
                        onChanged:
                            canEdit ? vm.setRssProcessingEnabled : null,
                      ),
                    if (ui.hasPref('rss_refresh_interval')) ...[
                      const SizedBox(height: 8),
                      SettingsInputField(
                        label: l10n.rssFeedsRefreshInterval,
                        controller: _refreshIntervalController,
                        enabled: fetchingOn,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        suffix: l10n.minutes,
                      ),
                    ],
                    if (ui.hasPref('rss_fetch_delay')) ...[
                      const SizedBox(height: 8),
                      SettingsInputField(
                        label: l10n.rssSameHostRequestDelay,
                        controller: _fetchDelayController,
                        enabled: fetchingOn,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        suffix: l10n.unitSeconds,
                      ),
                    ],
                    if (ui.hasPref('rss_max_articles_per_feed')) ...[
                      const SizedBox(height: 8),
                      SettingsInputField(
                        label: l10n.rssMaxArticlesPerFeed,
                        controller: _maxArticlesController,
                        enabled: fetchingOn,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: 12),
            SettingsGroupCard(
              title: l10n.rssAutoDownloader,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(
                children: [
                  if (ui.hasPref('rss_auto_downloading_enabled'))
                    SettingsSwitchTile(
                      title: l10n.rssEnableAutoDownloading,
                      value: ui.rssAutoDownloadingEnabled,
                      onChanged:
                          canEdit ? vm.setRssAutoDownloadingEnabled : null,
                    ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.rssAutoDownloadRules),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(RouterPath.rssRules),
                  ),
                ],
              ),
            ),
            if (ui.hasPref('rss_download_repack_proper_episodes') ||
                ui.hasPref('rss_smart_episode_filters')) ...[
              const SizedBox(height: 12),
              SettingsGroupCard(
                title: l10n.rssSmartEpisodeFilter,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (ui.hasPref('rss_download_repack_proper_episodes'))
                      SettingsSwitchTile(
                        title: l10n.rssDownloadRepackProper,
                        value: ui.rssDownloadRepackProperEpisodes,
                        onChanged: canEdit
                            ? vm.setRssDownloadRepackProperEpisodes
                            : null,
                      ),
                    if (ui.hasPref('rss_smart_episode_filters')) ...[
                      const SizedBox(height: 8),
                      SettingsInputField(
                        label: l10n.rssFilters,
                        controller: _filtersController,
                        enabled: canEdit,
                        minLines: 4,
                        maxLines: 8,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
