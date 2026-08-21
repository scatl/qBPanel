import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/settings/server/setting/connection/connection_settings_ui_state.dart';
import 'package:qbpanel/settings/server/setting/connection/connection_settings_view_model.dart';
import 'package:qbpanel/widget/dropdown_field.dart';
import 'package:qbpanel/settings/widget/settings_group_card.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';
import 'package:qbpanel/settings/widget/settings_nested_card.dart';
import 'package:qbpanel/settings/widget/settings_switch_tile.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';

/// WebUI「连接」选项。
class ConnectionSettingsPage extends ConsumerStatefulWidget {
  const ConnectionSettingsPage({
    super.key,
    required this.serverId,
  });

  final int serverId;

  @override
  ConsumerState<ConnectionSettingsPage> createState() =>
      _ConnectionSettingsPageState();
}

class _ConnectionSettingsPageState
    extends ConsumerState<ConnectionSettingsPage> {
  final _listenPortController = TextEditingController();
  final _maxConnecController = TextEditingController();
  final _maxConnecPerTorrentController = TextEditingController();
  final _maxUploadsController = TextEditingController();
  final _maxUploadsPerTorrentController = TextEditingController();
  final _i2pAddressController = TextEditingController();
  final _i2pPortController = TextEditingController();
  final _proxyHostController = TextEditingController();
  final _proxyPortController = TextEditingController();
  final _proxyUsernameController = TextEditingController();
  final _proxyPasswordController = TextEditingController();
  final _ipFilterPathController = TextEditingController();
  final _bannedIpsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _listenPortController.dispose();
    _maxConnecController.dispose();
    _maxConnecPerTorrentController.dispose();
    _maxUploadsController.dispose();
    _maxUploadsPerTorrentController.dispose();
    _i2pAddressController.dispose();
    _i2pPortController.dispose();
    _proxyHostController.dispose();
    _proxyPortController.dispose();
    _proxyUsernameController.dispose();
    _proxyPasswordController.dispose();
    _ipFilterPathController.dispose();
    _bannedIpsController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final ok = await ref.read(connectionSettingsProvider.notifier).load();
    if (!mounted || !ok) return;
    _fillControllers(ref.read(connectionSettingsProvider));
  }

  void _fillControllers(ConnectionSettingsUiState ui) {
    _listenPortController.text = '${ui.listenPort}';
    _maxConnecController.text = '${ui.maxConnec}';
    _maxConnecPerTorrentController.text = '${ui.maxConnecPerTorrent}';
    _maxUploadsController.text = '${ui.maxUploads}';
    _maxUploadsPerTorrentController.text = '${ui.maxUploadsPerTorrent}';
    _i2pAddressController.text = ui.i2pAddress;
    _i2pPortController.text = '${ui.i2pPort}';
    _proxyHostController.text = ui.proxyIp;
    _proxyPortController.text = '${ui.proxyPort}';
    _proxyUsernameController.text = ui.proxyUsername;
    _proxyPasswordController.text = ui.proxyPassword;
    _ipFilterPathController.text = ui.ipFilterPath;
    _bannedIpsController.text = ui.bannedIps;
  }

  int _parseInt(TextEditingController controller, int fallback) {
    return int.tryParse(controller.text.trim()) ?? fallback;
  }

  void _syncTextFieldsToVm() {
    final vm = ref.read(connectionSettingsProvider.notifier);
    final ui = ref.read(connectionSettingsProvider);
    vm.setListenPort(_parseInt(_listenPortController, ui.listenPort));
    vm.setMaxConnec(_parseInt(_maxConnecController, ui.maxConnec));
    vm.setMaxConnecPerTorrent(
      _parseInt(_maxConnecPerTorrentController, ui.maxConnecPerTorrent),
    );
    vm.setMaxUploads(_parseInt(_maxUploadsController, ui.maxUploads));
    vm.setMaxUploadsPerTorrent(
      _parseInt(_maxUploadsPerTorrentController, ui.maxUploadsPerTorrent),
    );
    vm.setI2pAddress(_i2pAddressController.text);
    vm.setI2pPort(_parseInt(_i2pPortController, ui.i2pPort));
    vm.setProxyIp(_proxyHostController.text);
    vm.setProxyPort(_parseInt(_proxyPortController, ui.proxyPort));
    vm.setProxyUsername(_proxyUsernameController.text);
    vm.setProxyPassword(_proxyPasswordController.text);
    vm.setIpFilterPath(_ipFilterPathController.text);
    vm.setBannedIps(_bannedIpsController.text);
  }

  Future<void> _onRandomPort() async {
    final vm = ref.read(connectionSettingsProvider.notifier);
    vm.randomizeListenPort();
    _listenPortController.text =
        '${ref.read(connectionSettingsProvider).listenPort}';
  }

  Future<void> _onSave() async {
    FocusScope.of(context).unfocus();
    final ui = ref.read(connectionSettingsProvider);
    if (!ui.ready || ui.saving) return;

    _syncTextFieldsToVm();
    LoadingDialog.show(context, message: '保存中…');
    await Future<void>.delayed(Duration.zero);

    final error = await ref.read(connectionSettingsProvider.notifier).save();
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error == null ? '已保存' : '保存失败：$error')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(connectionSettingsProvider);
    final vm = ref.read(connectionSettingsProvider.notifier);
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;
    final canEdit = ui.ready && !ui.saving;
    final proxyEnabled = canEdit && ui.proxyEnabled;
    final proxyAuthCapable = canEdit && ui.proxySupportsAuth;
    final i2pOn = canEdit && ui.i2pEnabled;

    return Scaffold(
      appBar: AppBar(
        title: const Text('连接'),
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
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: DropdownField<ConnectionPeerProtocol>(
                        label: '对等节点连接协议',
                        value: ui.peerProtocol,
                        enabled: canEdit,
                        items: [
                          for (final item in ConnectionPeerProtocol.values)
                            DropdownMenuItem(
                              value: item,
                              child: Text(item.label),
                            ),
                        ],
                        onChanged: vm.setPeerProtocol,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      title: '监听端口',
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '用于传入连接的端口',
                            style: textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _listenPortController,
                                  enabled: canEdit,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: canEdit ? _onRandomPort : null,
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                ),
                                child: const Text('随机'),
                              ),
                            ],
                          ),
                          SettingsSwitchTile(
                            title: '使用我的路由器的 UPnP / NAT-PMP 端口转发',
                            value: ui.upnp,
                            onChanged: canEdit ? vm.setUpnp : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      title: '连接限制',
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SettingsSwitchTile(
                            title: '全局最大连接数',
                            value: ui.maxConnecEnabled,
                            onChanged:
                                canEdit ? vm.setMaxConnecEnabled : null,
                          ),
                          TextField(
                            controller: _maxConnecController,
                            enabled: canEdit && ui.maxConnecEnabled,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          const SizedBox(height: 8),
                          SettingsSwitchTile(
                            title: '每 torrent 最大连接数',
                            value: ui.maxConnecPerTorrentEnabled,
                            onChanged: canEdit
                                ? vm.setMaxConnecPerTorrentEnabled
                                : null,
                          ),
                          TextField(
                            controller: _maxConnecPerTorrentController,
                            enabled:
                                canEdit && ui.maxConnecPerTorrentEnabled,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          const SizedBox(height: 8),
                          SettingsSwitchTile(
                            title: '全局上传窗口数上限',
                            value: ui.maxUploadsEnabled,
                            onChanged:
                                canEdit ? vm.setMaxUploadsEnabled : null,
                          ),
                          TextField(
                            controller: _maxUploadsController,
                            enabled: canEdit && ui.maxUploadsEnabled,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          const SizedBox(height: 8),
                          SettingsSwitchTile(
                            title: '每个 torrent 上传窗口数上限',
                            value: ui.maxUploadsPerTorrentEnabled,
                            onChanged: canEdit
                                ? vm.setMaxUploadsPerTorrentEnabled
                                : null,
                          ),
                          TextField(
                            controller: _maxUploadsPerTorrentController,
                            enabled:
                                canEdit && ui.maxUploadsPerTorrentEnabled,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
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
                            title: 'I2P（实验性）',
                            value: ui.i2pEnabled,
                            onChanged: canEdit ? vm.setI2pEnabled : null,
                          ),
                          TextField(
                            controller: _i2pAddressController,
                            enabled: i2pOn,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: '主机',
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _i2pPortController,
                            enabled: i2pOn,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              labelText: '端口',
                            ),
                          ),
                          SettingsSwitchTile(
                            title: '混合模式',
                            value: ui.i2pMixedMode,
                            onChanged: i2pOn ? vm.setI2pMixedMode : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      title: '代理服务器',
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DropdownField<ConnectionProxyType>(
                            label: '类型',
                            value: ui.proxyType,
                            enabled: canEdit,
                            items: [
                              for (final item in ConnectionProxyType.values)
                                DropdownMenuItem(
                                  value: item,
                                  child: Text(item.label),
                                ),
                            ],
                            onChanged: vm.setProxyType,
                          ),
                          TextField(
                            controller: _proxyHostController,
                            enabled: proxyEnabled,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: '主机',
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _proxyPortController,
                            enabled: proxyEnabled,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              labelText: '端口',
                            ),
                          ),
                          SettingsSwitchTile(
                            title: '通过代理查找主机名',
                            value: ui.proxyHostnameLookup,
                            onChanged: proxyAuthCapable
                                ? vm.setProxyHostnameLookup
                                : null,
                          ),
                          SettingsNestedCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SettingsSwitchTile(
                                  title: '验证',
                                  value: ui.proxyAuthEnabled,
                                  onChanged: proxyAuthCapable
                                      ? vm.setProxyAuthEnabled
                                      : null,
                                ),
                                TextField(
                                  controller: _proxyUsernameController,
                                  enabled: proxyAuthCapable &&
                                      ui.proxyAuthEnabled,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    labelText: '用户名',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _proxyPasswordController,
                                  enabled: proxyAuthCapable &&
                                      ui.proxyAuthEnabled,
                                  obscureText: true,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                    labelText: '密码',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '注意：密码以非加密形式保存',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: scheme.outline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SettingsSwitchTile(
                            title: '对 BitTorrent 目的使用代理',
                            value: ui.proxyBittorrent,
                            onChanged:
                                proxyEnabled ? vm.setProxyBittorrent : null,
                          ),
                          SettingsSwitchTile(
                            title: '使用代理服务器进行用户连接',
                            value: ui.proxyPeerConnections,
                            onChanged: proxyEnabled && ui.proxyBittorrent
                                ? vm.setProxyPeerConnections
                                : null,
                          ),
                          SettingsSwitchTile(
                            title: '对 RSS 目的使用代理',
                            value: ui.proxyRss,
                            onChanged:
                                proxyAuthCapable ? vm.setProxyRss : null,
                          ),
                          SettingsSwitchTile(
                            title: '对常规目的使用代理',
                            value: ui.proxyMisc,
                            onChanged:
                                proxyAuthCapable ? vm.setProxyMisc : null,
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
                            title: 'IP 过滤',
                            value: ui.ipFilterEnabled,
                            onChanged:
                                canEdit ? vm.setIpFilterEnabled : null,
                          ),
                          TextField(
                            controller: _ipFilterPathController,
                            enabled: canEdit && ui.ipFilterEnabled,
                            minLines: 1,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: '过滤规则路径 (.dat, .p2p, .p2b)',
                            ),
                          ),
                          SettingsSwitchTile(
                            title: '匹配 tracker',
                            value: ui.ipFilterTrackers,
                            onChanged: canEdit && ui.ipFilterEnabled
                                ? vm.setIpFilterTrackers
                                : null,
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _bannedIpsController,
                            enabled: canEdit,
                            minLines: 4,
                            maxLines: 8,
                            decoration: const InputDecoration(
                              labelText: '手动屏蔽 IP 地址',
                              alignLabelWithHint: true,
                              hintText: '每行一个 IP',
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
