import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/entity/response/network_interface_item.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/settings/server/setting/advanced/advanced_settings_ui_state.dart';
import 'package:qbpanel/settings/server/setting/advanced/advanced_settings_view_model.dart';
import 'package:qbpanel/widget/dropdown_field.dart';
import 'package:qbpanel/settings/widget/settings_group_card.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';
import 'package:qbpanel/settings/widget/settings_nested_card.dart';
import 'package:qbpanel/settings/widget/settings_switch_tile.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';

/// WebUI「高级」选项。
class AdvancedSettingsPage extends ConsumerStatefulWidget {
  const AdvancedSettingsPage({
    super.key,
    required this.serverId,
  });

  final int serverId;

  @override
  ConsumerState<AdvancedSettingsPage> createState() =>
      _AdvancedSettingsPageState();
}

class _AdvancedSettingsPageState extends ConsumerState<AdvancedSettingsPage> {
  final _memoryLimitController = TextEditingController();
  final _saveResumeIntervalController = TextEditingController();
  final _saveStatsIntervalController = TextEditingController();
  final _torrentFileSizeController = TextEditingController();
  final _appInstanceController = TextEditingController();
  final _refreshIntervalController = TextEditingController();
  final _embeddedPortController = TextEditingController();
  final _pythonPathController = TextEditingController();
  final _bdecodeDepthController = TextEditingController();
  final _bdecodeTokenController = TextEditingController();
  final _asyncIoThreadsController = TextEditingController();
  final _hashingThreadsController = TextEditingController();
  final _filePoolSizeController = TextEditingController();
  final _checkingMemoryController = TextEditingController();
  final _diskCacheController = TextEditingController();
  final _diskCacheTtlController = TextEditingController();
  final _diskQueueController = TextEditingController();
  final _sendBufferController = TextEditingController();
  final _sendBufferLowController = TextEditingController();
  final _sendBufferFactorController = TextEditingController();
  final _connectionSpeedController = TextEditingController();
  final _socketSendController = TextEditingController();
  final _socketReceiveController = TextEditingController();
  final _socketBacklogController = TextEditingController();
  final _outgoingMinController = TextEditingController();
  final _outgoingMaxController = TextEditingController();
  final _upnpLeaseController = TextEditingController();
  final _peerDscpController = TextEditingController();
  final _hostnameCacheController = TextEditingController();
  final _announceIpController = TextEditingController();
  final _announcePortController = TextEditingController();
  final _maxHttpAnnouncesController = TextEditingController();
  final _stopTrackerTimeoutController = TextEditingController();
  final _peerTurnoverController = TextEditingController();
  final _peerTurnoverCutoffController = TextEditingController();
  final _peerTurnoverIntervalController = TextEditingController();
  final _requestQueueController = TextEditingController();
  final _maxBlockRequestsController = TextEditingController();
  final _dhtBootstrapController = TextEditingController();
  final _i2pInboundQtyController = TextEditingController();
  final _i2pOutboundQtyController = TextEditingController();
  final _i2pInboundLenController = TextEditingController();
  final _i2pOutboundLenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    for (final c in [
      _memoryLimitController,
      _saveResumeIntervalController,
      _saveStatsIntervalController,
      _torrentFileSizeController,
      _appInstanceController,
      _refreshIntervalController,
      _embeddedPortController,
      _pythonPathController,
      _bdecodeDepthController,
      _bdecodeTokenController,
      _asyncIoThreadsController,
      _hashingThreadsController,
      _filePoolSizeController,
      _checkingMemoryController,
      _diskCacheController,
      _diskCacheTtlController,
      _diskQueueController,
      _sendBufferController,
      _sendBufferLowController,
      _sendBufferFactorController,
      _connectionSpeedController,
      _socketSendController,
      _socketReceiveController,
      _socketBacklogController,
      _outgoingMinController,
      _outgoingMaxController,
      _upnpLeaseController,
      _peerDscpController,
      _hostnameCacheController,
      _announceIpController,
      _announcePortController,
      _maxHttpAnnouncesController,
      _stopTrackerTimeoutController,
      _peerTurnoverController,
      _peerTurnoverCutoffController,
      _peerTurnoverIntervalController,
      _requestQueueController,
      _maxBlockRequestsController,
      _dhtBootstrapController,
      _i2pInboundQtyController,
      _i2pOutboundQtyController,
      _i2pInboundLenController,
      _i2pOutboundLenController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    final ok = await ref.read(advancedSettingsProvider.notifier).load();
    if (!mounted || !ok) return;
    _fillControllers(ref.read(advancedSettingsProvider));
  }

  void _fillControllers(AdvancedSettingsUiState ui) {
    _memoryLimitController.text = '${ui.memoryWorkingSetLimit}';
    _saveResumeIntervalController.text = '${ui.saveResumeDataInterval}';
    _saveStatsIntervalController.text = '${ui.saveStatisticsInterval}';
    _torrentFileSizeController.text = '${ui.torrentFileSizeLimitMib}';
    _appInstanceController.text = ui.appInstanceName;
    _refreshIntervalController.text = '${ui.refreshInterval}';
    _embeddedPortController.text = '${ui.embeddedTrackerPort}';
    _pythonPathController.text = ui.pythonExecutablePath;
    _bdecodeDepthController.text = '${ui.bdecodeDepthLimit}';
    _bdecodeTokenController.text = '${ui.bdecodeTokenLimit}';
    _asyncIoThreadsController.text = '${ui.asyncIoThreads}';
    _hashingThreadsController.text = '${ui.hashingThreads}';
    _filePoolSizeController.text = '${ui.filePoolSize}';
    _checkingMemoryController.text = '${ui.checkingMemoryUse}';
    _diskCacheController.text = '${ui.diskCache}';
    _diskCacheTtlController.text = '${ui.diskCacheTtl}';
    _diskQueueController.text = '${ui.diskQueueSizeKib}';
    _sendBufferController.text = '${ui.sendBufferWatermark}';
    _sendBufferLowController.text = '${ui.sendBufferLowWatermark}';
    _sendBufferFactorController.text = '${ui.sendBufferWatermarkFactor}';
    _connectionSpeedController.text = '${ui.connectionSpeed}';
    _socketSendController.text = '${ui.socketSendBufferSizeKib}';
    _socketReceiveController.text = '${ui.socketReceiveBufferSizeKib}';
    _socketBacklogController.text = '${ui.socketBacklogSize}';
    _outgoingMinController.text = '${ui.outgoingPortsMin}';
    _outgoingMaxController.text = '${ui.outgoingPortsMax}';
    _upnpLeaseController.text = '${ui.upnpLeaseDuration}';
    _peerDscpController.text = '${ui.peerTos}';
    _hostnameCacheController.text = '${ui.hostnameCacheTtl}';
    _announceIpController.text = ui.announceIp;
    _announcePortController.text = '${ui.announcePort}';
    _maxHttpAnnouncesController.text = '${ui.maxConcurrentHttpAnnounces}';
    _stopTrackerTimeoutController.text = '${ui.stopTrackerTimeout}';
    _peerTurnoverController.text = '${ui.peerTurnover}';
    _peerTurnoverCutoffController.text = '${ui.peerTurnoverCutoff}';
    _peerTurnoverIntervalController.text = '${ui.peerTurnoverInterval}';
    _requestQueueController.text = '${ui.requestQueueSize}';
    _maxBlockRequestsController.text = '${ui.maxOutstandingBlockRequests}';
    _dhtBootstrapController.text = ui.dhtBootstrapNodes;
    _i2pInboundQtyController.text = '${ui.i2pInboundQuantity}';
    _i2pOutboundQtyController.text = '${ui.i2pOutboundQuantity}';
    _i2pInboundLenController.text = '${ui.i2pInboundLength}';
    _i2pOutboundLenController.text = '${ui.i2pOutboundLength}';
  }

  int _parseInt(TextEditingController controller, int fallback) {
    return int.tryParse(controller.text.trim()) ?? fallback;
  }

  void _syncTextFieldsToVm() {
    final vm = ref.read(advancedSettingsProvider.notifier);
    final ui = ref.read(advancedSettingsProvider);
    vm.applyTextAndNumbers(
      memoryWorkingSetLimit:
          _parseInt(_memoryLimitController, ui.memoryWorkingSetLimit),
      saveResumeDataInterval:
          _parseInt(_saveResumeIntervalController, ui.saveResumeDataInterval),
      saveStatisticsInterval:
          _parseInt(_saveStatsIntervalController, ui.saveStatisticsInterval),
      torrentFileSizeLimitMib:
          _parseInt(_torrentFileSizeController, ui.torrentFileSizeLimitMib),
      appInstanceName: _appInstanceController.text,
      refreshInterval:
          _parseInt(_refreshIntervalController, ui.refreshInterval),
      embeddedTrackerPort:
          _parseInt(_embeddedPortController, ui.embeddedTrackerPort),
      pythonExecutablePath: _pythonPathController.text,
      bdecodeDepthLimit:
          _parseInt(_bdecodeDepthController, ui.bdecodeDepthLimit),
      bdecodeTokenLimit:
          _parseInt(_bdecodeTokenController, ui.bdecodeTokenLimit),
      asyncIoThreads: _parseInt(_asyncIoThreadsController, ui.asyncIoThreads),
      hashingThreads: _parseInt(_hashingThreadsController, ui.hashingThreads),
      filePoolSize: _parseInt(_filePoolSizeController, ui.filePoolSize),
      checkingMemoryUse:
          _parseInt(_checkingMemoryController, ui.checkingMemoryUse),
      diskCache: _parseInt(_diskCacheController, ui.diskCache),
      diskCacheTtl: _parseInt(_diskCacheTtlController, ui.diskCacheTtl),
      diskQueueSizeKib: _parseInt(_diskQueueController, ui.diskQueueSizeKib),
      sendBufferWatermark:
          _parseInt(_sendBufferController, ui.sendBufferWatermark),
      sendBufferLowWatermark:
          _parseInt(_sendBufferLowController, ui.sendBufferLowWatermark),
      sendBufferWatermarkFactor: _parseInt(
        _sendBufferFactorController,
        ui.sendBufferWatermarkFactor,
      ),
      connectionSpeed:
          _parseInt(_connectionSpeedController, ui.connectionSpeed),
      socketSendBufferSizeKib:
          _parseInt(_socketSendController, ui.socketSendBufferSizeKib),
      socketReceiveBufferSizeKib:
          _parseInt(_socketReceiveController, ui.socketReceiveBufferSizeKib),
      socketBacklogSize:
          _parseInt(_socketBacklogController, ui.socketBacklogSize),
      outgoingPortsMin: _parseInt(_outgoingMinController, ui.outgoingPortsMin),
      outgoingPortsMax: _parseInt(_outgoingMaxController, ui.outgoingPortsMax),
      upnpLeaseDuration:
          _parseInt(_upnpLeaseController, ui.upnpLeaseDuration),
      peerTos: _parseInt(_peerDscpController, ui.peerTos),
      hostnameCacheTtl:
          _parseInt(_hostnameCacheController, ui.hostnameCacheTtl),
      announceIp: _announceIpController.text,
      announcePort: _parseInt(_announcePortController, ui.announcePort),
      maxConcurrentHttpAnnounces: _parseInt(
        _maxHttpAnnouncesController,
        ui.maxConcurrentHttpAnnounces,
      ),
      stopTrackerTimeout:
          _parseInt(_stopTrackerTimeoutController, ui.stopTrackerTimeout),
      peerTurnover: _parseInt(_peerTurnoverController, ui.peerTurnover),
      peerTurnoverCutoff:
          _parseInt(_peerTurnoverCutoffController, ui.peerTurnoverCutoff),
      peerTurnoverInterval: _parseInt(
        _peerTurnoverIntervalController,
        ui.peerTurnoverInterval,
      ),
      requestQueueSize:
          _parseInt(_requestQueueController, ui.requestQueueSize),
      maxOutstandingBlockRequests: _parseInt(
        _maxBlockRequestsController,
        ui.maxOutstandingBlockRequests,
      ),
      dhtBootstrapNodes: _dhtBootstrapController.text,
      i2pInboundQuantity:
          _parseInt(_i2pInboundQtyController, ui.i2pInboundQuantity),
      i2pOutboundQuantity:
          _parseInt(_i2pOutboundQtyController, ui.i2pOutboundQuantity),
      i2pInboundLength:
          _parseInt(_i2pInboundLenController, ui.i2pInboundLength),
      i2pOutboundLength:
          _parseInt(_i2pOutboundLenController, ui.i2pOutboundLength),
    );
  }

  Future<void> _onSave() async {
    FocusScope.of(context).unfocus();
    final ui = ref.read(advancedSettingsProvider);
    if (!ui.ready || ui.saving) return;

    _syncTextFieldsToVm();
    LoadingDialog.show(context, message: context.l10n.saving);
    await Future<void>.delayed(Duration.zero);

    final error = await ref.read(advancedSettingsProvider.notifier).save();
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error ?? context.l10n.saved)),
    );
  }

  List<DropdownMenuItem<String>> _networkInterfaceItems(
    List<NetworkInterfaceItem> interfaces,
    String current,
  ) {
    final items = <DropdownMenuItem<String>>[
      DropdownMenuItem(value: '', child: Text(context.l10n.anyInterface)),
    ];
    if (current.isNotEmpty &&
        !interfaces.any((e) => e.value == current)) {
      items.add(DropdownMenuItem(value: current, child: Text(current)));
    }
    for (final iface in interfaces) {
      items.add(
        DropdownMenuItem(
          value: iface.value,
          child: Text(iface.name.isEmpty ? iface.value : iface.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<String>> _bindAddressItems(
    List<String> addresses,
    String current,
  ) {
    final values = <String>{
      ...AdvancedBindAddressOption.fixedValues,
      ...addresses,
      if (current.isNotEmpty) current,
    };
    return values
        .map(
          (value) => DropdownMenuItem(
            value: value,
            child: Text(AdvancedBindAddressOption.labelOf(value, context.l10n)),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(advancedSettingsProvider);
    final vm = ref.read(advancedSettingsProvider.notifier);
    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;
    final canEdit = ui.ready && !ui.saving;
    final embeddedOn = canEdit && ui.enableEmbeddedTracker;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.qbSetAdvanced),
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
              title: 'qBittorrent',
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownField<AdvancedResumeDataStorage>(
                    label: context.l10n.resumeDataStorage,
                    value: ui.resumeDataStorageType,
                    enabled: canEdit,
                    items: [
                      for (final item in AdvancedResumeDataStorage.values)
                        DropdownMenuItem(
                          value: item,
                          child: Text(item.label(context.l10n)),
                        ),
                    ],
                    onChanged: vm.setResumeDataStorageType,
                  ),
                  const SizedBox(height: 8),
                  DropdownField<AdvancedTorrentRemoveOption>(
                    label: context.l10n.torrentContentRemoveOption,
                    value: ui.torrentContentRemoveOption,
                    enabled: canEdit,
                    items: [
                      for (final item in AdvancedTorrentRemoveOption.values)
                        DropdownMenuItem(
                          value: item,
                          child: Text(item.label(context.l10n)),
                        ),
                    ],
                    onChanged: vm.setTorrentContentRemoveOption,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.physicalMemoryLimit,
                    controller: _memoryLimitController,
                    enabled: canEdit,
                    suffix: 'MiB',
                  ),
                  const SizedBox(height: 8),
                  DropdownField<String>(
                    label: context.l10n.networkInterface,
                    value: ui.currentNetworkInterface,
                    enabled: canEdit,
                    items: _networkInterfaceItems(
                      ui.networkInterfaces,
                      ui.currentNetworkInterface,
                    ),
                    onChanged: vm.setCurrentNetworkInterface,
                  ),
                  const SizedBox(height: 8),
                  DropdownField<String>(
                    label: context.l10n.optionalBindAddress,
                    value: ui.currentInterfaceAddress,
                    enabled: canEdit,
                    items: _bindAddressItems(
                      ui.interfaceAddresses,
                      ui.currentInterfaceAddress,
                    ),
                    onChanged: vm.setCurrentInterfaceAddress,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.saveResumeDataInterval,
                    controller: _saveResumeIntervalController,
                    enabled: canEdit,
                    suffix: context.l10n.minutes,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.saveStatisticsInterval,
                    controller: _saveStatsIntervalController,
                    enabled: canEdit,
                    suffix: context.l10n.minutes,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.torrentFileSizeLimit,
                    controller: _torrentFileSizeController,
                    enabled: canEdit,
                    suffix: 'MiB',
                  ),
                  SettingsSwitchTile(
                    title: context.l10n.confirmTorrentRecheck,
                    value: ui.confirmTorrentRecheck,
                    onChanged: canEdit ? vm.setConfirmTorrentRecheck : null,
                  ),
                  SettingsSwitchTile(
                    title: context.l10n.recheckCompletedTorrents,
                    value: ui.recheckCompletedTorrents,
                    onChanged:
                        canEdit ? vm.setRecheckCompletedTorrents : null,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _appInstanceController,
                    enabled: canEdit,
                    decoration: InputDecoration(
                      labelText: context.l10n.appInstanceName,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.refreshInterval,
                    controller: _refreshIntervalController,
                    enabled: canEdit,
                    suffix: context.l10n.unitMilliseconds,
                  ),
                  SettingsSwitchTile(
                    title: context.l10n.resolvePeerHostnames,
                    value: ui.resolvePeerHostNames,
                    onChanged: canEdit ? vm.setResolvePeerHostNames : null,
                  ),
                  SettingsSwitchTile(
                    title: context.l10n.resolvePeerCountries,
                    value: ui.resolvePeerCountries,
                    onChanged: canEdit ? vm.setResolvePeerCountries : null,
                  ),
                  SettingsSwitchTile(
                    title: context.l10n.reannounceWhenAddressChanges,
                    value: ui.reannounceWhenAddressChanged,
                    onChanged:
                        canEdit ? vm.setReannounceWhenAddressChanged : null,
                  ),
                  SettingsNestedCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SettingsSwitchTile(
                          title: context.l10n.enableEmbeddedTracker,
                          value: ui.enableEmbeddedTracker,
                          onChanged:
                              canEdit ? vm.setEnableEmbeddedTracker : null,
                        ),
                        _NumberField(
                          label: context.l10n.embeddedTrackerPort,
                          controller: _embeddedPortController,
                          enabled: embeddedOn,
                        ),
                        SettingsSwitchTile(
                          title: context.l10n.embeddedTrackerPortForwarding,
                          value: ui.embeddedTrackerPortForwarding,
                          onChanged: embeddedOn
                              ? vm.setEmbeddedTrackerPortForwarding
                              : null,
                        ),
                      ],
                    ),
                  ),
                  SettingsSwitchTile(
                    title: context.l10n.enableMotw,
                    value: ui.markOfTheWeb,
                    onChanged: canEdit ? vm.setMarkOfTheWeb : null,
                  ),
                  SettingsSwitchTile(
                    title: context.l10n.ignoreSslErrors,
                    value: ui.ignoreSslErrors,
                    onChanged: canEdit ? vm.setIgnoreSslErrors : null,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _pythonPathController,
                    enabled: canEdit,
                    minLines: 1,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: context.l10n.pythonExecutablePath,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SettingsGroupCard(
              title: 'libtorrent',
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _NumberField(
                    label: context.l10n.bdecodeDepthLimit,
                    controller: _bdecodeDepthController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.bdecodeTokenLimit,
                    controller: _bdecodeTokenController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.asyncIoThreads,
                    controller: _asyncIoThreadsController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.hashingThreads,
                    controller: _hashingThreadsController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.filePoolSize,
                    controller: _filePoolSizeController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.outstandingMemoryWhenChecking,
                    controller: _checkingMemoryController,
                    enabled: canEdit,
                    suffix: 'MiB',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.diskCache,
                    controller: _diskCacheController,
                    enabled: canEdit,
                    suffix: 'MiB',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.diskCacheTtl,
                    controller: _diskCacheTtlController,
                    enabled: canEdit,
                    suffix: context.l10n.unitSeconds,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.diskQueueSize,
                    controller: _diskQueueController,
                    enabled: canEdit,
                    suffix: 'KiB',
                  ),
                  const SizedBox(height: 8),
                  DropdownField<AdvancedDiskIoType>(
                    label: context.l10n.diskIoType,
                    value: ui.diskIoType,
                    enabled: canEdit,
                    items: [
                      for (final item in AdvancedDiskIoType.values)
                        DropdownMenuItem(
                          value: item,
                          child: Text(item.label(context.l10n)),
                        ),
                    ],
                    onChanged: vm.setDiskIoType,
                  ),
                  const SizedBox(height: 8),
                  DropdownField<AdvancedDiskIoCacheMode>(
                    label: context.l10n.diskIoReadMode,
                    value: ui.diskIoReadMode,
                    enabled: canEdit,
                    items: [
                      for (final item in AdvancedDiskIoCacheMode.values)
                        DropdownMenuItem(
                          value: item,
                          child: Text(item.label(context.l10n)),
                        ),
                    ],
                    onChanged: vm.setDiskIoReadMode,
                  ),
                  const SizedBox(height: 8),
                  DropdownField<AdvancedDiskIoWriteMode>(
                    label: context.l10n.diskIoWriteMode,
                    value: ui.diskIoWriteMode,
                    enabled: canEdit,
                    items: [
                      for (final item in AdvancedDiskIoWriteMode.values)
                        DropdownMenuItem(
                          value: item,
                          child: Text(item.label(context.l10n)),
                        ),
                    ],
                    onChanged: vm.setDiskIoWriteMode,
                  ),
                  SettingsSwitchTile(
                    title: context.l10n.coalesceReadsWrites,
                    value: ui.enableCoalesceReadWrite,
                    onChanged: canEdit ? vm.setEnableCoalesceReadWrite : null,
                  ),
                  SettingsSwitchTile(
                    title: context.l10n.pieceExtentAffinity,
                    value: ui.enablePieceExtentAffinity,
                    onChanged:
                        canEdit ? vm.setEnablePieceExtentAffinity : null,
                  ),
                  SettingsSwitchTile(
                    title: context.l10n.sendUploadPieceSuggestions,
                    value: ui.enableUploadSuggestions,
                    onChanged: canEdit ? vm.setEnableUploadSuggestions : null,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.sendBufferWatermark,
                    controller: _sendBufferController,
                    enabled: canEdit,
                    suffix: 'KiB',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.sendBufferLowWatermark,
                    controller: _sendBufferLowController,
                    enabled: canEdit,
                    suffix: 'KiB',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.sendBufferWatermarkFactor,
                    controller: _sendBufferFactorController,
                    enabled: canEdit,
                    suffix: '%',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.outgoingConnectionsPerSecond,
                    controller: _connectionSpeedController,
                    enabled: canEdit,
                  ),
                  SettingsSwitchTile(
                    title: context.l10n.allowOutgoingWhenSeeding,
                    value: ui.seedingOutgoingConnections,
                    onChanged:
                        canEdit ? vm.setSeedingOutgoingConnections : null,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.socketSendBufferSize,
                    controller: _socketSendController,
                    enabled: canEdit,
                    suffix: 'KiB',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.socketReceiveBufferSize,
                    controller: _socketReceiveController,
                    enabled: canEdit,
                    suffix: 'KiB',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.socketBacklogSize,
                    controller: _socketBacklogController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.outgoingPortsMin,
                    controller: _outgoingMinController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.outgoingPortsMax,
                    controller: _outgoingMaxController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.upnpLeaseDuration,
                    controller: _upnpLeaseController,
                    enabled: canEdit,
                    suffix: context.l10n.unitSeconds,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.peerTos,
                    controller: _peerDscpController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  DropdownField<AdvancedUtpTcpMixedMode>(
                    label: context.l10n.utpTcpMixedMode,
                    value: ui.utpTcpMixedMode,
                    enabled: canEdit,
                    items: [
                      for (final item in AdvancedUtpTcpMixedMode.values)
                        DropdownMenuItem(
                          value: item,
                          child: Text(item.label(context.l10n)),
                        ),
                    ],
                    onChanged: vm.setUtpTcpMixedMode,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.resolverCacheTtl,
                    controller: _hostnameCacheController,
                    enabled: canEdit,
                    suffix: context.l10n.unitSeconds,
                  ),
                  SettingsSwitchTile(
                    title: context.l10n.idnSupport,
                    value: ui.idnSupportEnabled,
                    onChanged: canEdit ? vm.setIdnSupportEnabled : null,
                  ),
                  SettingsSwitchTile(
                    title: context.l10n.allowMultipleConnectionsFromSameIp,
                    value: ui.enableMultiConnectionsFromSameIp,
                    onChanged: canEdit
                        ? vm.setEnableMultiConnectionsFromSameIp
                        : null,
                  ),
                  SettingsSwitchTile(
                    title: context.l10n.allowMultipleConnectionsFromSamePeerId,
                    value: ui.enableMultiConnectionsFromSamePeerId,
                    onChanged: canEdit
                        ? vm.setEnableMultiConnectionsFromSamePeerId
                        : null,
                  ),
                  SettingsSwitchTile(
                    title: context.l10n.validateHttpsTrackerCert,
                    value: ui.validateHttpsTrackerCertificate,
                    onChanged: canEdit
                        ? vm.setValidateHttpsTrackerCertificate
                        : null,
                  ),
                  SettingsSwitchTile(
                    title: context.l10n.ssrfMitigation,
                    value: ui.ssrfMitigation,
                    onChanged: canEdit ? vm.setSsrfMitigation : null,
                  ),
                  SettingsSwitchTile(
                    title: context.l10n.blockPeersOnPrivilegedPorts,
                    value: ui.blockPeersOnPrivilegedPorts,
                    onChanged:
                        canEdit ? vm.setBlockPeersOnPrivilegedPorts : null,
                  ),
                  const SizedBox(height: 8),
                  DropdownField<AdvancedUploadSlotsBehavior>(
                    label: context.l10n.uploadSlotsBehavior,
                    value: ui.uploadSlotsBehavior,
                    enabled: canEdit,
                    items: [
                      for (final item in AdvancedUploadSlotsBehavior.values)
                        DropdownMenuItem(
                          value: item,
                          child: Text(item.label(context.l10n)),
                        ),
                    ],
                    onChanged: vm.setUploadSlotsBehavior,
                  ),
                  const SizedBox(height: 8),
                  DropdownField<AdvancedUploadChokingAlgorithm>(
                    label: context.l10n.uploadChokingAlgorithm,
                    value: ui.uploadChokingAlgorithm,
                    enabled: canEdit,
                    items: [
                      for (final item in AdvancedUploadChokingAlgorithm.values)
                        DropdownMenuItem(
                          value: item,
                          child: Text(item.label(context.l10n)),
                        ),
                    ],
                    onChanged: vm.setUploadChokingAlgorithm,
                  ),
                  SettingsSwitchTile(
                    title: context.l10n.announceToAllTrackers,
                    value: ui.announceToAllTiers,
                    onChanged: canEdit ? vm.setAnnounceToAllTiers : null,
                  ),
                  SettingsSwitchTile(
                    title: context.l10n.announceToAllTiers,
                    value: ui.announceToAllTrackers,
                    onChanged: canEdit ? vm.setAnnounceToAllTrackers : null,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _announceIpController,
                    enabled: canEdit,
                    decoration: InputDecoration(
                      labelText: context.l10n.announceIp,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.announcePort,
                    controller: _announcePortController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.maxConcurrentHttpAnnounces,
                    controller: _maxHttpAnnouncesController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.stopTrackerTimeout,
                    controller: _stopTrackerTimeoutController,
                    enabled: canEdit,
                    suffix: context.l10n.unitSeconds,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.peerTurnover,
                    controller: _peerTurnoverController,
                    enabled: canEdit,
                    suffix: '%',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.peerTurnoverCutoff,
                    controller: _peerTurnoverCutoffController,
                    enabled: canEdit,
                    suffix: '%',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.peerTurnoverInterval,
                    controller: _peerTurnoverIntervalController,
                    enabled: canEdit,
                    suffix: context.l10n.unitSeconds,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.requestQueueSize,
                    controller: _requestQueueController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.maxOutstandingPieceRequests,
                    controller: _maxBlockRequestsController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _dhtBootstrapController,
                    enabled: canEdit,
                    minLines: 2,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: context.l10n.dhtBootstrapNodes,
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.l10n.i2pTunnel,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.i2pInboundQuantity,
                    controller: _i2pInboundQtyController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.i2pOutboundQuantity,
                    controller: _i2pOutboundQtyController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.i2pInboundLength,
                    controller: _i2pInboundLenController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: context.l10n.i2pOutboundLength,
                    controller: _i2pOutboundLenController,
                    enabled: canEdit,
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
    required this.label,
    required this.controller,
    required this.enabled,
    this.suffix,
  });

  final String label;
  final TextEditingController controller;
  final bool enabled;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: const TextInputType.numberWithOptions(signed: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'-?\d*'))],
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        suffixStyle: TextStyle(color: scheme.outline),
      ),
    );
  }
}
