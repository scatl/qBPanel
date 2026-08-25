import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/entity/response/network_interface_item.dart';
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
    LoadingDialog.show(context, message: '保存中…');
    await Future<void>.delayed(Duration.zero);

    final error = await ref.read(advancedSettingsProvider.notifier).save();
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error ?? '已保存')),
    );
  }

  List<DropdownMenuItem<String>> _networkInterfaceItems(
    List<NetworkInterfaceItem> interfaces,
    String current,
  ) {
    final items = <DropdownMenuItem<String>>[
      const DropdownMenuItem(value: '', child: Text('任意接口')),
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
            child: Text(AdvancedBindAddressOption.labelOf(value)),
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
        title: const Text('高级'),
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
              title: 'qBittorrent',
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownField<AdvancedResumeDataStorage>(
                    label: '恢复数据存储类型（需重启）',
                    value: ui.resumeDataStorageType,
                    enabled: canEdit,
                    items: [
                      for (final item in AdvancedResumeDataStorage.values)
                        DropdownMenuItem(
                          value: item,
                          child: Text(item.label),
                        ),
                    ],
                    onChanged: vm.setResumeDataStorageType,
                  ),
                  const SizedBox(height: 8),
                  DropdownField<AdvancedTorrentRemoveOption>(
                    label: '删除种子内容方式',
                    value: ui.torrentContentRemoveOption,
                    enabled: canEdit,
                    items: [
                      for (final item in AdvancedTorrentRemoveOption.values)
                        DropdownMenuItem(
                          value: item,
                          child: Text(item.label),
                        ),
                    ],
                    onChanged: vm.setTorrentContentRemoveOption,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '物理内存 (RAM) 使用上限',
                    controller: _memoryLimitController,
                    enabled: canEdit,
                    suffix: 'MiB',
                  ),
                  const SizedBox(height: 8),
                  DropdownField<String>(
                    label: '网络接口',
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
                    label: '可选绑定 IP 地址',
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
                    label: '保存恢复数据间隔',
                    controller: _saveResumeIntervalController,
                    enabled: canEdit,
                    suffix: '分钟',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '保存统计信息间隔',
                    controller: _saveStatsIntervalController,
                    enabled: canEdit,
                    suffix: '分钟',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '.torrent 文件大小限制',
                    controller: _torrentFileSizeController,
                    enabled: canEdit,
                    suffix: 'MiB',
                  ),
                  SettingsSwitchTile(
                    title: '确认重新检查种子',
                    value: ui.confirmTorrentRecheck,
                    onChanged: canEdit ? vm.setConfirmTorrentRecheck : null,
                  ),
                  SettingsSwitchTile(
                    title: '完成时重新检查种子',
                    value: ui.recheckCompletedTorrents,
                    onChanged:
                        canEdit ? vm.setRecheckCompletedTorrents : null,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _appInstanceController,
                    enabled: canEdit,
                    decoration: const InputDecoration(
                      labelText: '自定义应用程序实例名称',
                    ),
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '刷新间隔',
                    controller: _refreshIntervalController,
                    enabled: canEdit,
                    suffix: '毫秒',
                  ),
                  SettingsSwitchTile(
                    title: '解析 peer 主机名',
                    value: ui.resolvePeerHostNames,
                    onChanged: canEdit ? vm.setResolvePeerHostNames : null,
                  ),
                  SettingsSwitchTile(
                    title: '解析 peer 国家/地区',
                    value: ui.resolvePeerCountries,
                    onChanged: canEdit ? vm.setResolvePeerCountries : null,
                  ),
                  SettingsSwitchTile(
                    title: 'IP 或端口变化时向所有 tracker 重新 announce',
                    value: ui.reannounceWhenAddressChanged,
                    onChanged:
                        canEdit ? vm.setReannounceWhenAddressChanged : null,
                  ),
                  SettingsNestedCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SettingsSwitchTile(
                          title: '启用嵌入式 tracker',
                          value: ui.enableEmbeddedTracker,
                          onChanged:
                              canEdit ? vm.setEnableEmbeddedTracker : null,
                        ),
                        _NumberField(
                          label: '嵌入式 tracker 端口',
                          controller: _embeddedPortController,
                          enabled: embeddedOn,
                        ),
                        SettingsSwitchTile(
                          title: '为嵌入式 tracker 启用端口转发',
                          value: ui.embeddedTrackerPortForwarding,
                          onChanged: embeddedOn
                              ? vm.setEmbeddedTrackerPortForwarding
                              : null,
                        ),
                      ],
                    ),
                  ),
                  SettingsSwitchTile(
                    title: '为下载的文件启用 Mark-of-the-Web（需 macOS 或 Windows）',
                    value: ui.markOfTheWeb,
                    onChanged: canEdit ? vm.setMarkOfTheWeb : null,
                  ),
                  SettingsSwitchTile(
                    title: '忽略 SSL 错误',
                    value: ui.ignoreSslErrors,
                    onChanged: canEdit ? vm.setIgnoreSslErrors : null,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _pythonPathController,
                    enabled: canEdit,
                    minLines: 1,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Python 可执行文件路径（可能需要重启）',
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
                    label: 'Bdecode 深度限制',
                    controller: _bdecodeDepthController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: 'Bdecode 令牌限制',
                    controller: _bdecodeTokenController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '异步 I/O 线程数',
                    controller: _asyncIoThreadsController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '哈希线程数',
                    controller: _hashingThreadsController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '文件池大小',
                    controller: _filePoolSizeController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '检查种子时的未决内存',
                    controller: _checkingMemoryController,
                    enabled: canEdit,
                    suffix: 'MiB',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '磁盘缓存',
                    controller: _diskCacheController,
                    enabled: canEdit,
                    suffix: 'MiB',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '磁盘缓存过期间隔',
                    controller: _diskCacheTtlController,
                    enabled: canEdit,
                    suffix: '秒',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '磁盘队列大小',
                    controller: _diskQueueController,
                    enabled: canEdit,
                    suffix: 'KiB',
                  ),
                  const SizedBox(height: 8),
                  DropdownField<AdvancedDiskIoType>(
                    label: '磁盘 IO 类型（需重启）',
                    value: ui.diskIoType,
                    enabled: canEdit,
                    items: [
                      for (final item in AdvancedDiskIoType.values)
                        DropdownMenuItem(
                          value: item,
                          child: Text(item.label),
                        ),
                    ],
                    onChanged: vm.setDiskIoType,
                  ),
                  const SizedBox(height: 8),
                  DropdownField<AdvancedDiskIoCacheMode>(
                    label: '磁盘 IO 读取模式',
                    value: ui.diskIoReadMode,
                    enabled: canEdit,
                    items: [
                      for (final item in AdvancedDiskIoCacheMode.values)
                        DropdownMenuItem(
                          value: item,
                          child: Text(item.label),
                        ),
                    ],
                    onChanged: vm.setDiskIoReadMode,
                  ),
                  const SizedBox(height: 8),
                  DropdownField<AdvancedDiskIoWriteMode>(
                    label: '磁盘 IO 写入模式',
                    value: ui.diskIoWriteMode,
                    enabled: canEdit,
                    items: [
                      for (final item in AdvancedDiskIoWriteMode.values)
                        DropdownMenuItem(
                          value: item,
                          child: Text(item.label),
                        ),
                    ],
                    onChanged: vm.setDiskIoWriteMode,
                  ),
                  SettingsSwitchTile(
                    title: '合并读写',
                    value: ui.enableCoalesceReadWrite,
                    onChanged: canEdit ? vm.setEnableCoalesceReadWrite : null,
                  ),
                  SettingsSwitchTile(
                    title: '使用分块范围亲和性',
                    value: ui.enablePieceExtentAffinity,
                    onChanged:
                        canEdit ? vm.setEnablePieceExtentAffinity : null,
                  ),
                  SettingsSwitchTile(
                    title: '发送上传分块建议',
                    value: ui.enableUploadSuggestions,
                    onChanged: canEdit ? vm.setEnableUploadSuggestions : null,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '发送缓冲区水位线',
                    controller: _sendBufferController,
                    enabled: canEdit,
                    suffix: 'KiB',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '发送缓冲区低水位线',
                    controller: _sendBufferLowController,
                    enabled: canEdit,
                    suffix: 'KiB',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '发送缓冲区水位线系数',
                    controller: _sendBufferFactorController,
                    enabled: canEdit,
                    suffix: '%',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '每秒传出连接数',
                    controller: _connectionSpeedController,
                    enabled: canEdit,
                  ),
                  SettingsSwitchTile(
                    title: '做种时允许传出连接',
                    value: ui.seedingOutgoingConnections,
                    onChanged:
                        canEdit ? vm.setSeedingOutgoingConnections : null,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '套接字发送缓冲区大小（0：系统默认）',
                    controller: _socketSendController,
                    enabled: canEdit,
                    suffix: 'KiB',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '套接字接收缓冲区大小（0：系统默认）',
                    controller: _socketReceiveController,
                    enabled: canEdit,
                    suffix: 'KiB',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '套接字 backlog 大小',
                    controller: _socketBacklogController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '传出端口（最小，0：禁用）',
                    controller: _outgoingMinController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '传出端口（最大，0：禁用）',
                    controller: _outgoingMaxController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: 'UPnP 租约时长（0：永久）',
                    controller: _upnpLeaseController,
                    enabled: canEdit,
                    suffix: '秒',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '连接 peer 的 DSCP',
                    controller: _peerDscpController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  DropdownField<AdvancedUtpTcpMixedMode>(
                    label: 'μTP-TCP 混合模式算法',
                    value: ui.utpTcpMixedMode,
                    enabled: canEdit,
                    items: [
                      for (final item in AdvancedUtpTcpMixedMode.values)
                        DropdownMenuItem(
                          value: item,
                          child: Text(item.label),
                        ),
                    ],
                    onChanged: vm.setUtpTcpMixedMode,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '内部主机名解析器缓存过期间隔',
                    controller: _hostnameCacheController,
                    enabled: canEdit,
                    suffix: '秒',
                  ),
                  SettingsSwitchTile(
                    title: '支持国际化域名 (IDN)',
                    value: ui.idnSupportEnabled,
                    onChanged: canEdit ? vm.setIdnSupportEnabled : null,
                  ),
                  SettingsSwitchTile(
                    title: '允许来自同一 IP 地址的多个连接',
                    value: ui.enableMultiConnectionsFromSameIp,
                    onChanged: canEdit
                        ? vm.setEnableMultiConnectionsFromSameIp
                        : null,
                  ),
                  SettingsSwitchTile(
                    title: '允许来自同一 Peer ID 的多个连接',
                    value: ui.enableMultiConnectionsFromSamePeerId,
                    onChanged: canEdit
                        ? vm.setEnableMultiConnectionsFromSamePeerId
                        : null,
                  ),
                  SettingsSwitchTile(
                    title: '验证 HTTPS tracker 证书',
                    value: ui.validateHttpsTrackerCertificate,
                    onChanged: canEdit
                        ? vm.setValidateHttpsTrackerCertificate
                        : null,
                  ),
                  SettingsSwitchTile(
                    title: '服务端请求伪造 (SSRF) 缓解',
                    value: ui.ssrfMitigation,
                    onChanged: canEdit ? vm.setSsrfMitigation : null,
                  ),
                  SettingsSwitchTile(
                    title: '禁止连接到特权端口上的 peer',
                    value: ui.blockPeersOnPrivilegedPorts,
                    onChanged:
                        canEdit ? vm.setBlockPeersOnPrivilegedPorts : null,
                  ),
                  const SizedBox(height: 8),
                  DropdownField<AdvancedUploadSlotsBehavior>(
                    label: '上传槽行为',
                    value: ui.uploadSlotsBehavior,
                    enabled: canEdit,
                    items: [
                      for (final item in AdvancedUploadSlotsBehavior.values)
                        DropdownMenuItem(
                          value: item,
                          child: Text(item.label),
                        ),
                    ],
                    onChanged: vm.setUploadSlotsBehavior,
                  ),
                  const SizedBox(height: 8),
                  DropdownField<AdvancedUploadChokingAlgorithm>(
                    label: '上传阻塞算法',
                    value: ui.uploadChokingAlgorithm,
                    enabled: canEdit,
                    items: [
                      for (final item in AdvancedUploadChokingAlgorithm.values)
                        DropdownMenuItem(
                          value: item,
                          child: Text(item.label),
                        ),
                    ],
                    onChanged: vm.setUploadChokingAlgorithm,
                  ),
                  SettingsSwitchTile(
                    title: '始终向层级内所有 tracker 宣布',
                    value: ui.announceToAllTiers,
                    onChanged: canEdit ? vm.setAnnounceToAllTiers : null,
                  ),
                  SettingsSwitchTile(
                    title: '始终向 tier 内所有 tracker 宣布',
                    value: ui.announceToAllTrackers,
                    onChanged: canEdit ? vm.setAnnounceToAllTrackers : null,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _announceIpController,
                    enabled: canEdit,
                    decoration: const InputDecoration(
                      labelText: '向 tracker 报告的 IP（需重启）',
                    ),
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '向 tracker 报告的端口（需重启，0：监听端口）',
                    controller: _announcePortController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '最大并发 HTTP announce 数',
                    controller: _maxHttpAnnouncesController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '停止 tracker 超时（0：禁用）',
                    controller: _stopTrackerTimeoutController,
                    enabled: canEdit,
                    suffix: '秒',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: 'Peer 轮换断开百分比',
                    controller: _peerTurnoverController,
                    enabled: canEdit,
                    suffix: '%',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: 'Peer 轮换阈值百分比',
                    controller: _peerTurnoverCutoffController,
                    enabled: canEdit,
                    suffix: '%',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: 'Peer 轮换断开间隔',
                    controller: _peerTurnoverIntervalController,
                    enabled: canEdit,
                    suffix: '秒',
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '对单个 peer 的最大未完成请求数',
                    controller: _requestQueueController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: '来自 peer 的最大未完成块请求数',
                    controller: _maxBlockRequestsController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _dhtBootstrapController,
                    enabled: canEdit,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'DHT 引导节点',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'I2P 隧道',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: 'I2P 入站数量',
                    controller: _i2pInboundQtyController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: 'I2P 出站数量',
                    controller: _i2pOutboundQtyController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: 'I2P 入站长度',
                    controller: _i2pInboundLenController,
                    enabled: canEdit,
                  ),
                  const SizedBox(height: 8),
                  _NumberField(
                    label: 'I2P 出站长度',
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
