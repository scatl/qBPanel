import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/settings/server/setting/bittorrent/bittorrent_settings_ui_state.dart';
import 'package:qbpanel/settings/server/setting/bittorrent/bittorrent_settings_view_model.dart';
import 'package:qbpanel/widget/dropdown_field.dart';
import 'package:qbpanel/settings/widget/settings_group_card.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';
import 'package:qbpanel/settings/widget/settings_nested_card.dart';
import 'package:qbpanel/settings/widget/settings_switch_tile.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';

/// WebUI「BitTorrent」选项。
class BittorrentSettingsPage extends ConsumerStatefulWidget {
  const BittorrentSettingsPage({
    super.key,
    required this.serverId,
  });

  final int serverId;

  @override
  ConsumerState<BittorrentSettingsPage> createState() =>
      _BittorrentSettingsPageState();
}

class _BittorrentSettingsPageState
    extends ConsumerState<BittorrentSettingsPage> {
  final _maxActiveCheckingController = TextEditingController();
  final _maxActiveDlController = TextEditingController();
  final _maxActiveUpController = TextEditingController();
  final _maxActiveTorrentsController = TextEditingController();
  final _dlThresholdController = TextEditingController();
  final _ulThresholdController = TextEditingController();
  final _inactiveTimerController = TextEditingController();
  final _maxRatioController = TextEditingController();
  final _maxSeedingTimeController = TextEditingController();
  final _maxInactiveSeedingTimeController = TextEditingController();
  final _addTrackersController = TextEditingController();
  final _addTrackersUrlController = TextEditingController();
  final _fetchedTrackersController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _maxActiveCheckingController.dispose();
    _maxActiveDlController.dispose();
    _maxActiveUpController.dispose();
    _maxActiveTorrentsController.dispose();
    _dlThresholdController.dispose();
    _ulThresholdController.dispose();
    _inactiveTimerController.dispose();
    _maxRatioController.dispose();
    _maxSeedingTimeController.dispose();
    _maxInactiveSeedingTimeController.dispose();
    _addTrackersController.dispose();
    _addTrackersUrlController.dispose();
    _fetchedTrackersController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final ok = await ref.read(bittorrentSettingsProvider.notifier).load();
    if (!mounted || !ok) return;
    final ui = ref.read(bittorrentSettingsProvider);
    _maxActiveCheckingController.text = '${ui.maxActiveCheckingTorrents}';
    _maxActiveDlController.text = '${ui.maxActiveDownloads}';
    _maxActiveUpController.text = '${ui.maxActiveUploads}';
    _maxActiveTorrentsController.text = '${ui.maxActiveTorrents}';
    _dlThresholdController.text = '${ui.slowTorrentDlRateThreshold}';
    _ulThresholdController.text = '${ui.slowTorrentUlRateThreshold}';
    _inactiveTimerController.text = '${ui.slowTorrentInactiveTimer}';
    _maxRatioController.text = _ratioText(ui.maxRatio);
    _maxSeedingTimeController.text = '${ui.maxSeedingTime}';
    _maxInactiveSeedingTimeController.text = '${ui.maxInactiveSeedingTime}';
    _addTrackersController.text = ui.addTrackers;
    _addTrackersUrlController.text = ui.addTrackersUrl;
    _fetchedTrackersController.text = ui.addTrackersUrlList;
  }

  String _ratioText(double value) {
    if (value == value.roundToDouble()) return '${value.round()}';
    return value.toString();
  }

  int _parseInt(TextEditingController controller, int fallback) {
    return int.tryParse(controller.text.trim()) ?? fallback;
  }

  double _parseRatio() {
    return double.tryParse(_maxRatioController.text.trim()) ??
        ref.read(bittorrentSettingsProvider).maxRatio;
  }

  void _syncTextFieldsToVm() {
    final vm = ref.read(bittorrentSettingsProvider.notifier);
    final ui = ref.read(bittorrentSettingsProvider);
    vm.setMaxActiveCheckingTorrents(
      _parseInt(_maxActiveCheckingController, ui.maxActiveCheckingTorrents),
    );
    vm.setMaxActiveDownloads(
      _parseInt(_maxActiveDlController, ui.maxActiveDownloads),
    );
    vm.setMaxActiveUploads(
      _parseInt(_maxActiveUpController, ui.maxActiveUploads),
    );
    vm.setMaxActiveTorrents(
      _parseInt(_maxActiveTorrentsController, ui.maxActiveTorrents),
    );
    vm.setSlowTorrentDlRateThreshold(
      _parseInt(_dlThresholdController, ui.slowTorrentDlRateThreshold),
    );
    vm.setSlowTorrentUlRateThreshold(
      _parseInt(_ulThresholdController, ui.slowTorrentUlRateThreshold),
    );
    vm.setSlowTorrentInactiveTimer(
      _parseInt(_inactiveTimerController, ui.slowTorrentInactiveTimer),
    );
    vm.setMaxRatio(_parseRatio());
    vm.setMaxSeedingTime(
      _parseInt(_maxSeedingTimeController, ui.maxSeedingTime),
    );
    vm.setMaxInactiveSeedingTime(
      _parseInt(_maxInactiveSeedingTimeController, ui.maxInactiveSeedingTime),
    );
    vm.setAddTrackers(_addTrackersController.text);
    vm.setAddTrackersUrl(_addTrackersUrlController.text);
  }

  Future<void> _onSave() async {
    FocusScope.of(context).unfocus();
    final ui = ref.read(bittorrentSettingsProvider);
    if (!ui.ready || ui.saving) return;

    _syncTextFieldsToVm();
    LoadingDialog.show(context, message: context.l10n.saving);
    await Future<void>.delayed(Duration.zero);

    final error = await ref.read(bittorrentSettingsProvider.notifier).save();
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error == null ? context.l10n.saved : context.l10n.saveFailed(error))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(bittorrentSettingsProvider);
    final vm = ref.read(bittorrentSettingsProvider.notifier);
    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;
    final canEdit = ui.ready && !ui.saving;
    final queueOn = canEdit && ui.queueingEnabled;
    final slowOn = queueOn && ui.dontCountSlowTorrents;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BitTorrent'),
        actions: [
          IconButton(
            tooltip: context.l10n.actionSave,
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
                    SettingsGroupCard(
                      title: context.l10n.privacy,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SettingsSwitchTile(
                            title: context.l10n.enableDht,
                            value: ui.dht,
                            onChanged: canEdit ? vm.setDht : null,
                          ),
                          SettingsSwitchTile(
                            title: context.l10n.enablePex,
                            value: ui.pex,
                            onChanged: canEdit ? vm.setPex : null,
                          ),
                          SettingsSwitchTile(
                            title: context.l10n.enableLsd,
                            value: ui.lsd,
                            onChanged: canEdit ? vm.setLsd : null,
                          ),
                          DropdownField<BittorrentEncryption>(
                            label: context.l10n.encryptionMode,
                            value: ui.encryption,
                            enabled: canEdit,
                            items: [
                              for (final item in BittorrentEncryption.values)
                                DropdownMenuItem(
                                  value: item,
                                  child: Text(item.label(context.l10n)),
                                ),
                            ],
                            onChanged: vm.setEncryption,
                          ),
                          SettingsSwitchTile(
                            title: context.l10n.anonymousMode,
                            value: ui.anonymousMode,
                            onChanged: canEdit ? vm.setAnonymousMode : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: _NumberField(
                        label: context.l10n.maxActiveCheckingTorrents,
                        controller: _maxActiveCheckingController,
                        enabled: canEdit,
                        signed: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SettingsSwitchTile(
                            title: context.l10n.ssTorrentQueueing,
                            value: ui.queueingEnabled,
                            onChanged: canEdit ? vm.setQueueingEnabled : null,
                          ),
                          _NumberField(
                            label: context.l10n.maxActiveDownloads,
                            controller: _maxActiveDlController,
                            enabled: queueOn,
                            signed: true,
                          ),
                          const SizedBox(height: 8),
                          _NumberField(
                            label: context.l10n.maxActiveUploads,
                            controller: _maxActiveUpController,
                            enabled: queueOn,
                            signed: true,
                          ),
                          const SizedBox(height: 8),
                          _NumberField(
                            label: context.l10n.maxActiveTorrents,
                            controller: _maxActiveTorrentsController,
                            enabled: queueOn,
                            signed: true,
                          ),
                          SettingsNestedCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SettingsSwitchTile(
                                  title: context.l10n.ignoreSlowTorrents,
                                  value: ui.dontCountSlowTorrents,
                                  onChanged: queueOn
                                      ? vm.setDontCountSlowTorrents
                                      : null,
                                ),
                                _NumberField(
                                  label: context.l10n.downloadRateThreshold,
                                  controller: _dlThresholdController,
                                  enabled: slowOn,
                                  suffix: 'KiB/s',
                                ),
                                const SizedBox(height: 8),
                                _NumberField(
                                  label: context.l10n.uploadRateThreshold,
                                  controller: _ulThresholdController,
                                  enabled: slowOn,
                                  suffix: 'KiB/s',
                                ),
                                const SizedBox(height: 8),
                                _NumberField(
                                  label: context.l10n.torrentInactivityTimer,
                                  controller: _inactiveTimerController,
                                  enabled: slowOn,
                                  suffix: context.l10n.unitSeconds,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      title: context.l10n.seedingLimits,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SettingsSwitchTile(
                            title: context.l10n.whenRatioReaches,
                            value: ui.maxRatioEnabled,
                            onChanged:
                                canEdit ? vm.setMaxRatioEnabled : null,
                          ),
                          TextField(
                            controller: _maxRatioController,
                            enabled: canEdit && ui.maxRatioEnabled,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SettingsSwitchTile(
                            title: context.l10n.whenSeedingTimeReaches,
                            value: ui.maxSeedingTimeEnabled,
                            onChanged:
                                canEdit ? vm.setMaxSeedingTimeEnabled : null,
                          ),
                          _NumberField(
                            controller: _maxSeedingTimeController,
                            enabled: canEdit && ui.maxSeedingTimeEnabled,
                            suffix: context.l10n.minutes,
                          ),
                          const SizedBox(height: 8),
                          SettingsSwitchTile(
                            title: context.l10n.whenInactiveSeedingTimeReaches,
                            value: ui.maxInactiveSeedingTimeEnabled,
                            onChanged: canEdit
                                ? vm.setMaxInactiveSeedingTimeEnabled
                                : null,
                          ),
                          _NumberField(
                            controller: _maxInactiveSeedingTimeController,
                            enabled:
                                canEdit && ui.maxInactiveSeedingTimeEnabled,
                            suffix: context.l10n.minutes,
                          ),
                          DropdownField<BittorrentMaxRatioAct>(
                            label: context.l10n.then,
                            value: ui.maxRatioAct,
                            enabled: canEdit,
                            items: [
                              for (final item in BittorrentMaxRatioAct.values)
                                DropdownMenuItem(
                                  value: item,
                                  child: Text(item.label(context.l10n)),
                                ),
                            ],
                            onChanged: vm.setMaxRatioAct,
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
                          SettingsSwitchTile(
                            title: context.l10n.autoAddTrackers,
                            value: ui.addTrackersEnabled,
                            onChanged:
                                canEdit ? vm.setAddTrackersEnabled : null,
                          ),
                          TextField(
                            controller: _addTrackersController,
                            enabled: canEdit && ui.addTrackersEnabled,
                            minLines: 4,
                            maxLines: 8,
                            decoration: InputDecoration(
                              hintText: context.l10n.oneTrackerPerLine,
                              alignLabelWithHint: true,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SettingsSwitchTile(
                            title: context.l10n.autoAddTrackersFromUrl,
                            value: ui.addTrackersFromUrlEnabled,
                            onChanged: canEdit
                                ? vm.setAddTrackersFromUrlEnabled
                                : null,
                          ),
                          TextField(
                            controller: _addTrackersUrlController,
                            enabled:
                                canEdit && ui.addTrackersFromUrlEnabled,
                            decoration: InputDecoration(
                              labelText: context.l10n.url,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _fetchedTrackersController,
                            readOnly: true,
                            minLines: 4,
                            maxLines: 8,
                            keyboardType: TextInputType.multiline,
                            scrollPhysics:
                                const AlwaysScrollableScrollPhysics(),
                            decoration: InputDecoration(
                              labelText: context.l10n.fetchedTrackers,
                              alignLabelWithHint: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    this.label,
    required this.controller,
    required this.enabled,
    this.suffix,
    this.signed = false,
  });

  final String? label;
  final TextEditingController controller;
  final bool enabled;
  final String? suffix;
  final bool signed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final field = Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                signed ? RegExp(r'^-?\d*') : RegExp(r'^\d*'),
              ),
            ],
          ),
        ),
        if (suffix != null) ...[
          const SizedBox(width: 8),
          Text(
            suffix!,
            style: textTheme.bodyMedium?.copyWith(color: scheme.outline),
          ),
        ],
      ],
    );
    if (label == null) return field;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: textTheme.bodyLarge?.copyWith(
            color: enabled ? null : scheme.onSurface.withValues(alpha: 0.38),
          ),
        ),
        const SizedBox(height: 4),
        field,
      ],
    );
  }
}
