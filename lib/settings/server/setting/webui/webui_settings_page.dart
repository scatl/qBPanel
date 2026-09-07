import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/qb_api_capabilities.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/settings/server/setting/webui/webui_settings_ui_state.dart';
import 'package:qbpanel/settings/server/setting/webui/webui_settings_view_model.dart';
import 'package:qbpanel/widget/dropdown_field.dart';
import 'package:qbpanel/settings/widget/settings_group_card.dart';
import 'package:qbpanel/settings/widget/settings_input_field.dart';
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
      title: context.l10n.confirmSaveWebUiTitle,
      message: context.l10n.confirmSaveWebUi,
      confirmText: context.l10n.actionSave,
      destructive: true,
      confirmCountdownSeconds: 5,
    );
    if (confirmed != true || !mounted) return;

    _syncTextFieldsToVm();
    LoadingDialog.show(context, message: context.l10n.saving);
    await Future<void>.delayed(Duration.zero);

    final error = await ref.read(webUiSettingsProvider.notifier).save();
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error == null ? context.l10n.saved : context.l10n.saveFailed(error))),
    );
  }

  Future<void> _copyApiKey() async {
    final key = ref.read(webUiSettingsProvider).webUiApiKey;
    if (key.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: key));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.copiedApiKey)),
    );
  }

  Future<void> _rotateApiKey() async {
    final ui = ref.read(webUiSettingsProvider);
    if (!ui.ready || ui.saving || ui.apiKeyBusy) return;

    final hasKey = ui.hasApiKey;
    final confirmed = await ConfirmDialog.show(
      context,
      title: hasKey ? context.l10n.resetApiKey : context.l10n.generateApiKey,
      message: hasKey
          ? context.l10n.confirmResetApiKey
          : context.l10n.confirmGenerateApiKey,
      confirmText: hasKey ? context.l10n.actionReset : context.l10n.actionGenerate,
      destructive: hasKey,
      confirmCountdownSeconds: hasKey ? 5 : 0,
    );
    if (confirmed != true || !mounted) return;

    LoadingDialog.show(context, message: hasKey ? context.l10n.resetting : context.l10n.generating);
    await Future<void>.delayed(Duration.zero);
    final error = await ref
        .read(webUiSettingsProvider.notifier)
        .rotateApiKey(widget.serverId);
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error ?? (hasKey ? context.l10n.apiKeyReset : context.l10n.apiKeyGenerated),
        ),
      ),
    );
  }

  Future<void> _deleteApiKey() async {
    final ui = ref.read(webUiSettingsProvider);
    if (!ui.ready || ui.saving || ui.apiKeyBusy || !ui.hasApiKey) return;

    final confirmed = await ConfirmDialog.show(
      context,
      title: context.l10n.deleteApiKey,
      message: context.l10n.confirmDeleteApiKey,
      confirmText: context.l10n.actionDelete,
      destructive: true,
      confirmCountdownSeconds: 5,
    );
    if (confirmed != true || !mounted) return;

    LoadingDialog.show(context, message: context.l10n.deleting);
    await Future<void>.delayed(Duration.zero);
    final error = await ref
        .read(webUiSettingsProvider.notifier)
        .deleteApiKey(widget.serverId);
    if (!mounted) return;
    LoadingDialog.dismiss(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error ?? context.l10n.apiKeyDeleted)),
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
    final cap = ref.watch(qbApiCapabilitiesProvider);
    final hostHeaderOn = canEdit && ui.webUiHostHeaderValidationEnabled;
    final apiKeyActionsOn = canEdit;

    return Scaffold(
      appBar: AppBar(
        title: const Text('WebUI'),
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
                              context.l10n.webUiWarning,
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
                      title: context.l10n.webUiRemoteControl,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SettingsInputField(
                            label: context.l10n.ipAddress,
                            controller: _addressController,
                            enabled: canEdit,
                          ),
                          const SizedBox(height: 8),
                          SettingsInputField(
                            label: context.l10n.port,
                            controller: _portController,
                            enabled: canEdit,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          SettingsSwitchTile(
                            title: context.l10n.upnpPortForward,
                            value: ui.webUiUpnp,
                            onChanged: canEdit ? vm.setWebUiUpnp : null,
                          ),
                          SettingsSwitchTile(
                            title: context.l10n.useHttpsInsteadOfHttp,
                            value: ui.useHttps,
                            onChanged: canEdit ? vm.setUseHttps : null,
                          ),
                          SettingsInputField(
                            label: context.l10n.certificate,
                            controller: _httpsCertController,
                            enabled: httpsOn,
                            minLines: 1,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 8),
                          SettingsInputField(
                            label: context.l10n.privateKey,
                            controller: _httpsKeyController,
                            enabled: httpsOn,
                            minLines: 1,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      title: context.l10n.authentication,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SettingsInputField(
                            label: context.l10n.username,
                            controller: _usernameController,
                            enabled: canEdit,
                          ),
                          const SizedBox(height: 8),
                          SettingsInputField(
                            label: context.l10n.password,
                            controller: _passwordController,
                            enabled: canEdit,
                            obscureText: true,
                            hintText: context.l10n.passwordLeaveBlank,
                          ),
                          SettingsSwitchTile(
                            title: context.l10n.bypassAuthLocalhost,
                            value: ui.bypassLocalAuth,
                            onChanged: canEdit ? vm.setBypassLocalAuth : null,
                          ),
                          SettingsNestedCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SettingsSwitchTile(
                                  title: context.l10n.bypassAuthWhitelist,
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
                                  decoration: InputDecoration(
                                    hintText: context.l10n.subnetWhitelistHint,
                                    alignLabelWithHint: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          SettingsInputField(
                            label: context.l10n.banAfterFailedAttempts,
                            controller: _maxAuthFailController,
                            enabled: canEdit,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          const SizedBox(height: 8),
                          SettingsInputField(
                            label: context.l10n.banFor,
                            controller: _banDurationController,
                            enabled: canEdit,
                            suffix: context.l10n.unitSeconds,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          const SizedBox(height: 8),
                          SettingsInputField(
                            label: context.l10n.sessionTimeout,
                            controller: _sessionTimeoutController,
                            enabled: canEdit,
                            suffix: context.l10n.unitSeconds,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (cap.supportsApiKey) ...[
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      title: context.l10n.apiKey,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.privateKey,
                                style: textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                key: ValueKey('api-key-${ui.webUiApiKey}'),
                                initialValue: ui.maskedApiKey,
                                readOnly: true,
                              ),
                            ],
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
                                child: Text(context.l10n.copy),
                              ),
                              TextButton(
                                onPressed:
                                    apiKeyActionsOn ? _rotateApiKey : null,
                                child: Text(
                                  ui.hasApiKey ? context.l10n.resetApiKey : context.l10n.generateApiKey,
                                ),
                              ),
                              TextButton(
                                onPressed: apiKeyActionsOn && ui.hasApiKey
                                    ? _deleteApiKey
                                    : null,
                                style: TextButton.styleFrom(
                                  foregroundColor: scheme.error,
                                ),
                                child: Text(context.l10n.actionDelete),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ],
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SettingsSwitchTile(
                            title: context.l10n.useAlternativeWebUi,
                            value: ui.alternativeWebuiEnabled,
                            onChanged:
                                canEdit ? vm.setAlternativeWebuiEnabled : null,
                          ),
                          SettingsInputField(
                            label: context.l10n.filePath,
                            controller: _altWebuiPathController,
                            enabled: altOn,
                            minLines: 1,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SettingsGroupCard(
                      title: context.l10n.security,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SettingsSwitchTile(
                            title: context.l10n.clickjackingProtection,
                            value: ui.webUiClickjackingProtectionEnabled,
                            onChanged: canEdit
                                ? vm.setWebUiClickjackingProtectionEnabled
                                : null,
                          ),
                          SettingsSwitchTile(
                            title: context.l10n.csrfProtection,
                            value: ui.webUiCsrfProtectionEnabled,
                            onChanged: canEdit
                                ? vm.setWebUiCsrfProtectionEnabled
                                : null,
                          ),
                          SettingsSwitchTile(
                            title: context.l10n.secureCookie,
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
                                  title: context.l10n.hostHeaderValidation,
                                  value: ui.webUiHostHeaderValidationEnabled,
                                  onChanged: canEdit
                                      ? vm.setWebUiHostHeaderValidationEnabled
                                      : null,
                                ),
                                SettingsInputField(
                                  label: context.l10n.serverDomains,
                                  controller: _domainListController,
                                  enabled: hostHeaderOn,
                                  minLines: 1,
                                  maxLines: 3,
                                  hintText: '*',
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
                            title: context.l10n.customHttpHeaders,
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
                            decoration: InputDecoration(
                              hintText: context.l10n.oneHeaderPerLine,
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
                            title: context.l10n.reverseProxySupport,
                            value: ui.webUiReverseProxyEnabled,
                            onChanged: canEdit
                                ? vm.setWebUiReverseProxyEnabled
                                : null,
                          ),
                          SettingsInputField(
                            label: context.l10n.trustedProxiesList,
                            controller: _reverseProxiesController,
                            enabled: reverseOn,
                            minLines: 2,
                            maxLines: 4,
                            hintText: context.l10n.onePerLine,
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
                            title: context.l10n.updateDynDns,
                            value: ui.dyndnsEnabled,
                            onChanged: canEdit ? vm.setDyndnsEnabled : null,
                          ),
                          DropdownField<WebUiDynDnsService>(
                            label: context.l10n.dynDnsService,
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
                          SettingsInputField(
                            label: context.l10n.domain,
                            controller: _dyndnsDomainController,
                            enabled: dyndnsOn,
                          ),
                          const SizedBox(height: 8),
                          SettingsInputField(
                            label: context.l10n.username,
                            controller: _dyndnsUsernameController,
                            enabled: dyndnsOn,
                          ),
                          const SizedBox(height: 8),
                          SettingsInputField(
                            label: context.l10n.password,
                            controller: _dyndnsPasswordController,
                            enabled: dyndnsOn,
                            obscureText: true,
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
