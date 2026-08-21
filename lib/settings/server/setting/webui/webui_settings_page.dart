import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/settings/server/setting/webui/webui_settings_ui_state.dart';
import 'package:qbpanel/settings/server/setting/webui/webui_settings_view_model.dart';
import 'package:qbpanel/widget/dropdown_field.dart';
import 'package:qbpanel/settings/widget/settings_group_card.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';
import 'package:qbpanel/settings/widget/settings_nested_card.dart';
import 'package:qbpanel/settings/widget/settings_switch_tile.dart';
import 'package:qbpanel/widget/dialog/confirm_dialog.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';

/// WebUI「WebUI」选项。
class WebUiSettingsPage extends ConsumerStatefulWidget {
  const WebUiSettingsPage({
    super.key,
    required this.serverId,
  });

  final int serverId;

  @override
  ConsumerState<WebUiSettingsPage> createState() => _WebUiSettingsPageState();
}

class _WebUiSettingsPageState extends ConsumerState<WebUiSettingsPage> {
  final _domainListController = TextEditingController();
  final _addressController = TextEditingController();
  final _portController = TextEditingController();
  final _httpsCertController = TextEditingController();
  final _httpsKeyController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _subnetWhitelistController = TextEditingController();
  final _maxAuthFailController = TextEditingController();
  final _banDurationController = TextEditingController();
  final _sessionTimeoutController = TextEditingController();
  final _altWebuiPathController = TextEditingController();
  final _customHeadersController = TextEditingController();
  final _reverseProxiesController = TextEditingController();
  final _dyndnsDomainController = TextEditingController();
  final _dyndnsUsernameController = TextEditingController();
  final _dyndnsPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _domainListController.dispose();
    _addressController.dispose();
    _portController.dispose();
    _httpsCertController.dispose();
    _httpsKeyController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _subnetWhitelistController.dispose();
    _maxAuthFailController.dispose();
    _banDurationController.dispose();
    _sessionTimeoutController.dispose();
    _altWebuiPathController.dispose();
    _customHeadersController.dispose();
    _reverseProxiesController.dispose();
    _dyndnsDomainController.dispose();
    _dyndnsUsernameController.dispose();
    _dyndnsPasswordController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final ok = await ref.read(webUiSettingsProvider.notifier).load();
    if (!mounted || !ok) return;
    final ui = ref.read(webUiSettingsProvider);
    _domainListController.text = ui.webUiDomainList;
    _addressController.text = ui.webUiAddress;
    _portController.text = '${ui.webUiPort}';
    _httpsCertController.text = ui.webUiHttpsCertPath;
    _httpsKeyController.text = ui.webUiHttpsKeyPath;
    _usernameController.text = ui.webUiUsername;
    _passwordController.text = '';
    _subnetWhitelistController.text = ui.bypassAuthSubnetWhitelist;
    _maxAuthFailController.text = '${ui.webUiMaxAuthFailCount}';
    _banDurationController.text = '${ui.webUiBanDuration}';
    _sessionTimeoutController.text = '${ui.webUiSessionTimeout}';
    _altWebuiPathController.text = ui.alternativeWebuiPath;
    _customHeadersController.text = ui.webUiCustomHttpHeaders;
    _reverseProxiesController.text = ui.webUiReverseProxiesList;
    _dyndnsDomainController.text = ui.dyndnsDomain;
    _dyndnsUsernameController.text = ui.dyndnsUsername;
    _dyndnsPasswordController.text = ui.dyndnsPassword;
  }

  int _parseInt(TextEditingController controller, int fallback) {
    return int.tryParse(controller.text.trim()) ?? fallback;
  }

  void _syncTextFieldsToVm() {
    final vm = ref.read(webUiSettingsProvider.notifier);
    final ui = ref.read(webUiSettingsProvider);
    vm.setWebUiDomainList(_domainListController.text);
    vm.setWebUiAddress(_addressController.text);
    vm.setWebUiPort(_parseInt(_portController, ui.webUiPort));
    vm.setWebUiHttpsCertPath(_httpsCertController.text);
    vm.setWebUiHttpsKeyPath(_httpsKeyController.text);
    vm.setWebUiUsername(_usernameController.text);
    vm.setWebUiPassword(_passwordController.text);
    vm.setBypassAuthSubnetWhitelist(_subnetWhitelistController.text);
    vm.setWebUiMaxAuthFailCount(
      _parseInt(_maxAuthFailController, ui.webUiMaxAuthFailCount),
    );
    vm.setWebUiBanDuration(
      _parseInt(_banDurationController, ui.webUiBanDuration),
    );
    vm.setWebUiSessionTimeout(
      _parseInt(_sessionTimeoutController, ui.webUiSessionTimeout),
    );
    vm.setAlternativeWebuiPath(_altWebuiPathController.text);
    vm.setWebUiCustomHttpHeaders(_customHeadersController.text);
    vm.setWebUiReverseProxiesList(_reverseProxiesController.text);
    vm.setDyndnsDomain(_dyndnsDomainController.text);
    vm.setDyndnsUsername(_dyndnsUsernameController.text);
    vm.setDyndnsPassword(_dyndnsPasswordController.text);
  }

  Future<void> _onSave() async {
    FocusScope.of(context).unfocus();
    final ui = ref.read(webUiSettingsProvider);
    if (!ui.ready || ui.saving) return;

    final confirmed = await ConfirmDialog.show(
      context,
      title: '确认保存 WebUI 设置',
      message: '修改地址、端口、HTTPS、用户名密码或安全选项后，本 App 可能暂时无法连接服务器。'
          '请确认你仍能通过其他方式访问 qBittorrent。确定继续保存吗？',
      confirmText: '保存',
      destructive: true,
      confirmCountdownSeconds: 5,
    );
    if (confirmed != true || !mounted) return;

    _syncTextFieldsToVm();
    LoadingDialog.show(context, message: '保存中…');
    await Future<void>.delayed(Duration.zero);

    final error = await ref.read(webUiSettingsProvider.notifier).save();
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error == null ? '已保存' : '保存失败：$error')),
    );
  }

  Future<void> _copyApiKey() async {
    final key = ref.read(webUiSettingsProvider).webUiApiKey;
    if (key.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: key));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已复制 API 密钥')),
    );
  }

  Future<void> _rotateApiKey() async {
    final ui = ref.read(webUiSettingsProvider);
    if (!ui.ready || ui.saving || ui.apiKeyBusy) return;

    final hasKey = ui.hasApiKey;
    final confirmed = await ConfirmDialog.show(
      context,
      title: hasKey ? '重置 API key' : '生成 API 密钥',
      message: hasKey
          ? '重置该 API key 吗？当前 key 会立即停止工作，会生成新 key。'
              '本 App 会自动更新本地保存的密钥。'
          : '生成 API key 吗？这枚 key 可用于和 qBittorrent 的 API 互动。'
              '本 App 会自动保存到本地服务器配置。',
      confirmText: hasKey ? '重置' : '生成',
      destructive: hasKey,
      confirmCountdownSeconds: hasKey ? 5 : 0,
    );
    if (confirmed != true || !mounted) return;

    LoadingDialog.show(context, message: hasKey ? '重置中…' : '生成中…');
    await Future<void>.delayed(Duration.zero);
    final error = await ref
        .read(webUiSettingsProvider.notifier)
        .rotateApiKey(widget.serverId);
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error ?? (hasKey ? '已重置 API key' : '已生成 API 密钥'),
        ),
      ),
    );
  }

  Future<void> _deleteApiKey() async {
    final ui = ref.read(webUiSettingsProvider);
    if (!ui.ready || ui.saving || ui.apiKeyBusy || !ui.hasApiKey) return;

    final confirmed = await ConfirmDialog.show(
      context,
      title: '删除 API 密钥',
      message: '删除此 API key 吗？当前 key 会立即停止工作。'
          '本 App 将无法继续连接，请随后在服务器设置中重新配置密钥。',
      confirmText: '删除',
      destructive: true,
      confirmCountdownSeconds: 5,
    );
    if (confirmed != true || !mounted) return;

    LoadingDialog.show(context, message: '删除中…');
    await Future<void>.delayed(Duration.zero);
    final error = await ref
        .read(webUiSettingsProvider.notifier)
        .deleteApiKey(widget.serverId);
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error ?? '已删除 API 密钥')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(webUiSettingsProvider);
    final vm = ref.read(webUiSettingsProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;
    final canEdit = ui.ready && !ui.saving && !ui.apiKeyBusy;
    final httpsOn = canEdit && ui.useHttps;
    final altOn = canEdit && ui.alternativeWebuiEnabled;
    final headersOn = canEdit && ui.webUiUseCustomHttpHeadersEnabled;
    final reverseOn = canEdit && ui.webUiReverseProxyEnabled;
    final dyndnsOn = canEdit && ui.dyndnsEnabled;
    final subnetOn = canEdit && ui.bypassAuthSubnetWhitelistEnabled;
    final hostHeaderOn = canEdit && ui.webUiHostHeaderValidationEnabled;
    final apiKeyActionsOn = canEdit;

    return Scaffold(
      appBar: AppBar(
        title: const Text('WebUI'),
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
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 22,
                            color: scheme.error,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '此处修改的是服务器 WebUI 自身配置。错误地更改地址、端口、'
                              'HTTPS、认证或安全选项可能导致本 App 无法再连接该服务器，'
                              '请谨慎操作并确保仍有其他方式访问 qBittorrent。',
                              style: textTheme.bodySmall?.copyWith(
                                color: scheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      title: 'Web 用户界面（远程控制）',
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: _addressController,
                            enabled: canEdit,
                            decoration: const InputDecoration(
                              labelText: 'IP 地址',
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _portController,
                            enabled: canEdit,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              labelText: '端口',
                            ),
                          ),
                          SettingsSwitchTile(
                            title: '使用我的路由器的 UPnP / NAT-PMP 端口转发',
                            value: ui.webUiUpnp,
                            onChanged: canEdit ? vm.setWebUiUpnp : null,
                          ),
                          SettingsSwitchTile(
                            title: '使用 HTTPS 而不是 HTTP',
                            value: ui.useHttps,
                            onChanged: canEdit ? vm.setUseHttps : null,
                          ),
                          TextField(
                            controller: _httpsCertController,
                            enabled: httpsOn,
                            minLines: 1,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: '证书',
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _httpsKeyController,
                            enabled: httpsOn,
                            minLines: 1,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: '密钥',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      title: '验证',
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: _usernameController,
                            enabled: canEdit,
                            decoration: const InputDecoration(
                              labelText: '用户名',
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            enabled: canEdit,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: '密码',
                              hintText: '留空表示不修改',
                            ),
                          ),
                          SettingsSwitchTile(
                            title: '对本地主机上的客户端跳过身份验证',
                            value: ui.bypassLocalAuth,
                            onChanged: canEdit ? vm.setBypassLocalAuth : null,
                          ),
                          SettingsNestedCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SettingsSwitchTile(
                                  title: '对 IP 子网白名单中的客户端跳过身份验证',
                                  value: ui.bypassAuthSubnetWhitelistEnabled,
                                  onChanged: canEdit
                                      ? vm.setBypassAuthSubnetWhitelistEnabled
                                      : null,
                                ),
                                TextField(
                                  controller: _subnetWhitelistController,
                                  enabled: subnetOn,
                                  minLines: 2,
                                  maxLines: 5,
                                  decoration: const InputDecoration(
                                    hintText: '例如 192.168.1.0/24',
                                    alignLabelWithHint: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          _LabeledNumberField(
                            label: '连续失败后禁止客户端',
                            controller: _maxAuthFailController,
                            enabled: canEdit,
                          ),
                          const SizedBox(height: 8),
                          _LabeledNumberField(
                            label: '禁止',
                            controller: _banDurationController,
                            enabled: canEdit,
                            suffix: '秒',
                          ),
                          const SizedBox(height: 8),
                          _LabeledNumberField(
                            label: '会话超时',
                            controller: _sessionTimeoutController,
                            enabled: canEdit,
                            suffix: '秒',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      title: 'API 密钥',
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            key: ValueKey('api-key-${ui.webUiApiKey}'),
                            initialValue: ui.maskedApiKey,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: '密钥',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              TextButton(
                                onPressed: apiKeyActionsOn && ui.hasApiKey
                                    ? _copyApiKey
                                    : null,
                                child: const Text('复制'),
                              ),
                              TextButton(
                                onPressed:
                                    apiKeyActionsOn ? _rotateApiKey : null,
                                child: Text(
                                  ui.hasApiKey ? '重置 API key' : '生成 API 密钥',
                                ),
                              ),
                              TextButton(
                                onPressed: apiKeyActionsOn && ui.hasApiKey
                                    ? _deleteApiKey
                                    : null,
                                style: TextButton.styleFrom(
                                  foregroundColor: scheme.error,
                                ),
                                child: const Text('删除'),
                              ),
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
                            title: '使用备选 WebUI',
                            value: ui.alternativeWebuiEnabled,
                            onChanged:
                                canEdit ? vm.setAlternativeWebuiEnabled : null,
                          ),
                          TextField(
                            controller: _altWebuiPathController,
                            enabled: altOn,
                            minLines: 1,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: '文件路径',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      title: '安全',
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SettingsSwitchTile(
                            title: '启用“点击劫持”保护',
                            value: ui.webUiClickjackingProtectionEnabled,
                            onChanged: canEdit
                                ? vm.setWebUiClickjackingProtectionEnabled
                                : null,
                          ),
                          SettingsSwitchTile(
                            title: '启用跨站请求伪造 (CSRF) 保护',
                            value: ui.webUiCsrfProtectionEnabled,
                            onChanged: canEdit
                                ? vm.setWebUiCsrfProtectionEnabled
                                : null,
                          ),
                          SettingsSwitchTile(
                            title: '启用 cookie Secure 标志（需要 HTTPS 或本机连接）',
                            value: ui.webUiSecureCookieEnabled,
                            onChanged: canEdit
                                ? vm.setWebUiSecureCookieEnabled
                                : null,
                          ),
                          SettingsNestedCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SettingsSwitchTile(
                                  title: '启用 Host 标头验证',
                                  value: ui.webUiHostHeaderValidationEnabled,
                                  onChanged: canEdit
                                      ? vm.setWebUiHostHeaderValidationEnabled
                                      : null,
                                ),
                                TextField(
                                  controller: _domainListController,
                                  enabled: hostHeaderOn,
                                  minLines: 1,
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    labelText: '服务器域名',
                                    hintText: '*',
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
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SettingsSwitchTile(
                            title: '启用自定义 HTTP 头',
                            value: ui.webUiUseCustomHttpHeadersEnabled,
                            onChanged: canEdit
                                ? vm.setWebUiUseCustomHttpHeadersEnabled
                                : null,
                          ),
                          TextField(
                            controller: _customHeadersController,
                            enabled: headersOn,
                            minLines: 3,
                            maxLines: 6,
                            decoration: const InputDecoration(
                              hintText: '每行一个 Header',
                              alignLabelWithHint: true,
                            ),
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
                            title: '启用反向代理支持',
                            value: ui.webUiReverseProxyEnabled,
                            onChanged: canEdit
                                ? vm.setWebUiReverseProxyEnabled
                                : null,
                          ),
                          TextField(
                            controller: _reverseProxiesController,
                            enabled: reverseOn,
                            minLines: 2,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              labelText: '受信任的代理列表',
                              hintText: '每行一个',
                              alignLabelWithHint: true,
                            ),
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
                            title: '更新我的动态域名',
                            value: ui.dyndnsEnabled,
                            onChanged: canEdit ? vm.setDyndnsEnabled : null,
                          ),
                          DropdownField<WebUiDynDnsService>(
                            label: '服务',
                            value: ui.dyndnsService,
                            enabled: dyndnsOn,
                            items: [
                              for (final item in WebUiDynDnsService.values)
                                DropdownMenuItem(
                                  value: item,
                                  child: Text(item.label),
                                ),
                            ],
                            onChanged: vm.setDyndnsService,
                          ),
                          TextField(
                            controller: _dyndnsDomainController,
                            enabled: dyndnsOn,
                            decoration: const InputDecoration(
                              labelText: '域名',
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _dyndnsUsernameController,
                            enabled: dyndnsOn,
                            decoration: const InputDecoration(
                              labelText: '用户名',
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _dyndnsPasswordController,
                            enabled: dyndnsOn,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: '密码',
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

class _LabeledNumberField extends StatelessWidget {
  const _LabeledNumberField({
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
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyLarge?.copyWith(
            color: enabled ? null : scheme.onSurface.withValues(alpha: 0.38),
          ),
        ),
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
            if (suffix != null) ...[
              const SizedBox(width: 8),
              Text(
                suffix!,
                style: textTheme.bodyMedium?.copyWith(color: scheme.outline),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
