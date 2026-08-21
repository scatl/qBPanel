import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/settings/server/setting/speed/speed_settings_ui_state.dart';
import 'package:qbpanel/settings/server/setting/speed/speed_settings_view_model.dart';
import 'package:qbpanel/widget/dropdown_field.dart';
import 'package:qbpanel/settings/widget/settings_group_card.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';
import 'package:qbpanel/settings/widget/settings_nested_card.dart';
import 'package:qbpanel/settings/widget/settings_switch_tile.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';

/// WebUI「速度」选项。
class SpeedSettingsPage extends ConsumerStatefulWidget {
  const SpeedSettingsPage({
    super.key,
    required this.serverId,
  });

  final int serverId;

  @override
  ConsumerState<SpeedSettingsPage> createState() => _SpeedSettingsPageState();
}

class _SpeedSettingsPageState extends ConsumerState<SpeedSettingsPage> {
  final _upLimitController = TextEditingController();
  final _dlLimitController = TextEditingController();
  final _altUpLimitController = TextEditingController();
  final _altDlLimitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _upLimitController.dispose();
    _dlLimitController.dispose();
    _altUpLimitController.dispose();
    _altDlLimitController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final ok = await ref.read(speedSettingsProvider.notifier).load();
    if (!mounted || !ok) return;
    final ui = ref.read(speedSettingsProvider);
    _upLimitController.text = '${ui.upLimitKib}';
    _dlLimitController.text = '${ui.dlLimitKib}';
    _altUpLimitController.text = '${ui.altUpLimitKib}';
    _altDlLimitController.text = '${ui.altDlLimitKib}';
  }

  int _parseKib(TextEditingController controller, int fallback) {
    return int.tryParse(controller.text.trim()) ?? fallback;
  }

  void _syncTextFieldsToVm() {
    final vm = ref.read(speedSettingsProvider.notifier);
    final ui = ref.read(speedSettingsProvider);
    vm.setUpLimitKib(_parseKib(_upLimitController, ui.upLimitKib));
    vm.setDlLimitKib(_parseKib(_dlLimitController, ui.dlLimitKib));
    vm.setAltUpLimitKib(_parseKib(_altUpLimitController, ui.altUpLimitKib));
    vm.setAltDlLimitKib(_parseKib(_altDlLimitController, ui.altDlLimitKib));
  }

  Future<void> _onSave() async {
    FocusScope.of(context).unfocus();
    final ui = ref.read(speedSettingsProvider);
    if (!ui.ready || ui.saving) return;

    _syncTextFieldsToVm();
    LoadingDialog.show(context, message: '保存中…');
    await Future<void>.delayed(Duration.zero);

    final error = await ref.read(speedSettingsProvider.notifier).save();
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error == null ? '已保存' : '保存失败：$error')),
    );
  }

  Future<void> _pickTime({
    required int hour,
    required int minute,
    required void Function(int hour, int minute) onPicked,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked == null) return;
    onPicked(picked.hour, picked.minute);
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(speedSettingsProvider);
    final vm = ref.read(speedSettingsProvider.notifier);
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;
    final canEdit = ui.ready && !ui.saving;
    final scheduleOn = canEdit && ui.schedulerEnabled;

    return Scaffold(
      appBar: AppBar(
        title: const Text('速度'),
        actions: [
          IconButton(
            tooltip: '保存',
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
                      title: '全局速度限制',
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _RateField(
                            label: '上传',
                            controller: _upLimitController,
                            enabled: canEdit,
                          ),
                          const SizedBox(height: 8),
                          _RateField(
                            label: '下载',
                            controller: _dlLimitController,
                            enabled: canEdit,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '0 为无限制',
                            style: textTheme.bodySmall?.copyWith(
                              color: scheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      title: '备用速度限制',
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _RateField(
                            label: '上传',
                            controller: _altUpLimitController,
                            enabled: canEdit,
                          ),
                          const SizedBox(height: 8),
                          _RateField(
                            label: '下载',
                            controller: _altDlLimitController,
                            enabled: canEdit,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '0 为无限制',
                            style: textTheme.bodySmall?.copyWith(
                              color: scheme.outline,
                            ),
                          ),
                          SettingsNestedCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SettingsSwitchTile(
                                  title: '计划备用速度限制的启用时间',
                                  value: ui.schedulerEnabled,
                                  onChanged: canEdit
                                      ? vm.setSchedulerEnabled
                                      : null,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      _TimeField(
                                        label: '从',
                                        hour: ui.scheduleFromHour,
                                        minute: ui.scheduleFromMin,
                                        enabled: scheduleOn,
                                        onTap: () => _pickTime(
                                          hour: ui.scheduleFromHour,
                                          minute: ui.scheduleFromMin,
                                          onPicked: (hour, minute) {
                                            vm.setScheduleFrom(
                                              hour: hour,
                                              minute: minute,
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      _TimeField(
                                        label: '到',
                                        hour: ui.scheduleToHour,
                                        minute: ui.scheduleToMin,
                                        enabled: scheduleOn,
                                        onTap: () => _pickTime(
                                          hour: ui.scheduleToHour,
                                          minute: ui.scheduleToMin,
                                          onPicked: (hour, minute) {
                                            vm.setScheduleTo(
                                              hour: hour,
                                              minute: minute,
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Flexible(
                                        child: DropdownField<
                                            SpeedSchedulerDays>(
                                          label: '时间',
                                          value: ui.schedulerDays,
                                          enabled: scheduleOn,
                                          compact: true,
                                          items: [
                                            for (final item
                                                in SpeedSchedulerDays.values)
                                              DropdownMenuItem(
                                                value: item,
                                                child: Text(item.label),
                                              ),
                                          ],
                                          onChanged: vm.setSchedulerDays,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      title: '设置速度限制',
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Column(
                        children: [
                          SettingsSwitchTile(
                            title: '对 µTP 协议进行速度限制',
                            value: ui.limitUtpRate,
                            onChanged: canEdit ? vm.setLimitUtpRate : null,
                          ),
                          SettingsSwitchTile(
                            title: '对传送总开销进行速度限制',
                            value: ui.limitTcpOverhead,
                            onChanged:
                                canEdit ? vm.setLimitTcpOverhead : null,
                          ),
                          SettingsSwitchTile(
                            title: '对本地网络用户进行速度限制',
                            value: ui.limitLanPeers,
                            onChanged: canEdit ? vm.setLimitLanPeers : null,
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

class _RateField extends StatelessWidget {
  const _RateField({
    required this.label,
    required this.controller,
    required this.enabled,
  });

  final String label;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.bodyLarge),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: enabled,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'KiB/s',
              style: textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.label,
    required this.hour,
    required this.minute,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final int hour;
  final int minute;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final value =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    final labelColor = enabled
        ? scheme.onSurface
        : scheme.onSurface.withValues(alpha: 0.38);
    final valueColor = enabled
        ? scheme.outline
        : scheme.outline.withValues(alpha: 0.38);

    return Row(
      children: [
        Text(label, style: textTheme.bodyLarge?.copyWith(color: labelColor)),
        const SizedBox(width: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text(
                value,
                style: textTheme.bodyMedium?.copyWith(color: valueColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
