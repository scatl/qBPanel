import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/entity/response/app_preferences_response.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/settings/server/setting/webui/webui_settings_ui_state.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';
import 'package:qbpanel/storage/db/app_database.dart';
import 'package:qbpanel/storage/db/app_database_provider.dart';

final webUiSettingsProvider =
    NotifierProvider<WebUiSettingsViewModel, WebUiSettingsUiState>(
  WebUiSettingsViewModel.new,
);

class WebUiSettingsViewModel extends Notifier<WebUiSettingsUiState> {
  @override
  WebUiSettingsUiState build() => const WebUiSettingsUiState();

  Future<bool> load() async {
    state = state.copyWith(emptyState: const EmptyState.loading());
    String? error;
    AppPreferencesResponse? prefs;
    await ref
        .read(apiClientProvider)
        .get(
          ApiPath.application.preferences,
          parser: jsonParser(AppPreferencesResponse.fromJson),
        )
        .onSuccess((data) => prefs = data)
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });

    if (prefs == null) {
      state = state.copyWith(
        emptyState: EmptyState.error(error ?? ref.read(appLocalizationsProvider).loadSettingsFailed),
      );
      return false;
    }

    final data = prefs!;
    state = state.copyWith(
      emptyState: const EmptyState.content(),
      webUiDomainList: data.webUiDomainList ?? '*',
      webUiAddress: data.webUiAddress ?? '*',
      webUiPort: data.webUiPort ?? 8080,
      webUiUpnp: data.webUiUpnp ?? false,
      useHttps: data.useHttps ?? false,
      webUiHttpsCertPath: data.webUiHttpsCertPath ?? '',
      webUiHttpsKeyPath: data.webUiHttpsKeyPath ?? '',
      webUiUsername: data.webUiUsername ?? 'admin',
      webUiPassword: '',
      webUiApiKey: data.webUiApiKey ?? '',
      bypassLocalAuth: data.bypassLocalAuth ?? false,
      bypassAuthSubnetWhitelistEnabled:
          data.bypassAuthSubnetWhitelistEnabled ?? false,
      bypassAuthSubnetWhitelist: data.bypassAuthSubnetWhitelist ?? '',
      webUiMaxAuthFailCount: data.webUiMaxAuthFailCount ?? 5,
      webUiBanDuration: data.webUiBanDuration ?? 3600,
      webUiSessionTimeout: data.webUiSessionTimeout ?? 3600,
      alternativeWebuiEnabled: data.alternativeWebuiEnabled ?? false,
      alternativeWebuiPath: data.alternativeWebuiPath ?? '',
      webUiClickjackingProtectionEnabled:
          data.webUiClickjackingProtectionEnabled ?? true,
      webUiCsrfProtectionEnabled: data.webUiCsrfProtectionEnabled ?? true,
      webUiSecureCookieEnabled: data.webUiSecureCookieEnabled ?? true,
      webUiHostHeaderValidationEnabled:
          data.webUiHostHeaderValidationEnabled ?? true,
      webUiUseCustomHttpHeadersEnabled:
          data.webUiUseCustomHttpHeadersEnabled ?? false,
      webUiCustomHttpHeaders: data.webUiCustomHttpHeaders ?? '',
      webUiReverseProxyEnabled: data.webUiReverseProxyEnabled ?? false,
      webUiReverseProxiesList: data.webUiReverseProxiesList ?? '',
      dyndnsEnabled: data.dyndnsEnabled ?? false,
      dyndnsService: WebUiDynDnsService.fromApi(data.dyndnsService),
      dyndnsDomain: data.dyndnsDomain ?? '',
      dyndnsUsername: data.dyndnsUsername ?? '',
      dyndnsPassword: data.dyndnsPassword ?? '',
    );
    return true;
  }

  void setWebUiDomainList(String value) {
    state = state.copyWith(webUiDomainList: value);
  }

  void setWebUiAddress(String value) {
    state = state.copyWith(webUiAddress: value);
  }

  void setWebUiPort(int value) {
    state = state.copyWith(webUiPort: value);
  }

  void setWebUiUpnp(bool value) {
    state = state.copyWith(webUiUpnp: value);
  }

  void setUseHttps(bool value) {
    state = state.copyWith(useHttps: value);
  }

  void setWebUiHttpsCertPath(String value) {
    state = state.copyWith(webUiHttpsCertPath: value);
  }

  void setWebUiHttpsKeyPath(String value) {
    state = state.copyWith(webUiHttpsKeyPath: value);
  }

  void setWebUiUsername(String value) {
    state = state.copyWith(webUiUsername: value);
  }

  void setWebUiPassword(String value) {
    state = state.copyWith(webUiPassword: value);
  }

  void setBypassLocalAuth(bool value) {
    state = state.copyWith(bypassLocalAuth: value);
  }

  void setBypassAuthSubnetWhitelistEnabled(bool value) {
    state = state.copyWith(bypassAuthSubnetWhitelistEnabled: value);
  }

  void setBypassAuthSubnetWhitelist(String value) {
    state = state.copyWith(bypassAuthSubnetWhitelist: value);
  }

  void setWebUiMaxAuthFailCount(int value) {
    state = state.copyWith(webUiMaxAuthFailCount: value);
  }

  void setWebUiBanDuration(int value) {
    state = state.copyWith(webUiBanDuration: value);
  }

  void setWebUiSessionTimeout(int value) {
    state = state.copyWith(webUiSessionTimeout: value);
  }

  void setAlternativeWebuiEnabled(bool value) {
    state = state.copyWith(alternativeWebuiEnabled: value);
  }

  void setAlternativeWebuiPath(String value) {
    state = state.copyWith(alternativeWebuiPath: value);
  }

  void setWebUiClickjackingProtectionEnabled(bool value) {
    state = state.copyWith(webUiClickjackingProtectionEnabled: value);
  }

  void setWebUiCsrfProtectionEnabled(bool value) {
    state = state.copyWith(webUiCsrfProtectionEnabled: value);
  }

  void setWebUiSecureCookieEnabled(bool value) {
    state = state.copyWith(webUiSecureCookieEnabled: value);
  }

  void setWebUiHostHeaderValidationEnabled(bool value) {
    state = state.copyWith(webUiHostHeaderValidationEnabled: value);
  }

  void setWebUiUseCustomHttpHeadersEnabled(bool value) {
    state = state.copyWith(webUiUseCustomHttpHeadersEnabled: value);
  }

  void setWebUiCustomHttpHeaders(String value) {
    state = state.copyWith(webUiCustomHttpHeaders: value);
  }

  void setWebUiReverseProxyEnabled(bool value) {
    state = state.copyWith(webUiReverseProxyEnabled: value);
  }

  void setWebUiReverseProxiesList(String value) {
    state = state.copyWith(webUiReverseProxiesList: value);
  }

  void setDyndnsEnabled(bool value) {
    state = state.copyWith(dyndnsEnabled: value);
  }

  void setDyndnsService(WebUiDynDnsService value) {
    state = state.copyWith(dyndnsService: value);
  }

  void setDyndnsDomain(String value) {
    state = state.copyWith(dyndnsDomain: value);
  }

  void setDyndnsUsername(String value) {
    state = state.copyWith(dyndnsUsername: value);
  }

  void setDyndnsPassword(String value) {
    state = state.copyWith(dyndnsPassword: value);
  }

  /// 生成或重置 API 密钥；成功返回 `null`，并同步本机 [serverId] 的密钥。
  Future<String?> rotateApiKey(int serverId) async {
    if (state.apiKeyBusy) return null;

    state = state.copyWith(apiKeyBusy: true);
    String? error;
    String? newKey;
    await ref
        .read(apiClientProvider)
        .post(
          ApiPath.application.rotateAPIKey,
          parser: _parseApiKeyResponse,
        )
        .onSuccess((key) => newKey = key)
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });

    final key = newKey?.trim() ?? '';
    if (key.isEmpty) {
      state = state.copyWith(apiKeyBusy: false);
      return error ?? ref.read(appLocalizationsProvider).cannotResetApiKey;
    }

    await _syncLocalApiKey(serverId, key);
    state = state.copyWith(apiKeyBusy: false, webUiApiKey: key);
    return null;
  }

  /// 删除 API 密钥；成功返回 `null`，并清空本机 [serverId] 的密钥。
  Future<String?> deleteApiKey(int serverId) async {
    if (state.apiKeyBusy) return null;

    state = state.copyWith(apiKeyBusy: true);
    String? error;
    var ok = false;
    await ref
        .read(apiClientProvider)
        .post(
          ApiPath.application.deleteAPIKey,
          parser: (_) {},
        )
        .onSuccess((_) => ok = true)
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });

    if (!ok) {
      state = state.copyWith(apiKeyBusy: false);
      return error ?? ref.read(appLocalizationsProvider).cannotDeleteApiKey;
    }

    await _syncLocalApiKey(serverId, '');
    state = state.copyWith(apiKeyBusy: false, webUiApiKey: '');
    return null;
  }

  Future<void> _syncLocalApiKey(int serverId, String apiKey) async {
    final db = ref.read(appDatabaseProvider);
    await (db.update(db.qbServers)..where((t) => t.id.equals(serverId))).write(
      QbServersCompanion(
        apiKey: Value(apiKey),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  static String _parseApiKeyResponse(dynamic data) {
    if (data is Map) {
      final key = data['apiKey'];
      if (key == null) return '';
      return key.toString();
    }
    return '';
  }

  /// 成功返回 `null`。
  Future<String?> save() async {
    if (state.saving) return null;

    final port = state.webUiPort;
    if (port < 1 || port > 65535) {
      return ref.read(appLocalizationsProvider).webUiPortRange;
    }
    if (state.useHttps) {
      if (state.webUiHttpsCertPath.trim().isEmpty) {
        return ref.read(appLocalizationsProvider).httpsCertPathRequired;
      }
      if (state.webUiHttpsKeyPath.trim().isEmpty) {
        return ref.read(appLocalizationsProvider).httpsKeyPathRequired;
      }
    }
    final username = state.webUiUsername.trim();
    if (username.length < 3) {
      return ref.read(appLocalizationsProvider).webUiUsernameMinLength;
    }
    if (username.contains(':')) {
      return ref.read(appLocalizationsProvider).webUiUsernameNoColon;
    }
    final password = state.webUiPassword;
    if (password.isNotEmpty && password.length < 6) {
      return ref.read(appLocalizationsProvider).webUiPasswordMinLength;
    }
    if (state.alternativeWebuiEnabled &&
        state.alternativeWebuiPath.trim().isEmpty) {
      return ref.read(appLocalizationsProvider).altWebUiPathRequired;
    }

    state = state.copyWith(saving: true);
    final payload = <String, dynamic>{
      'web_ui_domain_list': state.webUiDomainList,
      'web_ui_address': state.webUiAddress.trim(),
      'web_ui_port': port,
      'web_ui_upnp': state.webUiUpnp,
      'use_https': state.useHttps,
      'web_ui_https_cert_path': state.webUiHttpsCertPath.trim(),
      'web_ui_https_key_path': state.webUiHttpsKeyPath.trim(),
      'web_ui_username': username,
      'bypass_local_auth': state.bypassLocalAuth,
      'bypass_auth_subnet_whitelist_enabled':
          state.bypassAuthSubnetWhitelistEnabled,
      'bypass_auth_subnet_whitelist': state.bypassAuthSubnetWhitelist,
      'web_ui_max_auth_fail_count': state.webUiMaxAuthFailCount,
      'web_ui_ban_duration': state.webUiBanDuration,
      'web_ui_session_timeout': state.webUiSessionTimeout,
      'alternative_webui_enabled': state.alternativeWebuiEnabled,
      'alternative_webui_path': state.alternativeWebuiPath.trim(),
      'web_ui_clickjacking_protection_enabled':
          state.webUiClickjackingProtectionEnabled,
      'web_ui_csrf_protection_enabled': state.webUiCsrfProtectionEnabled,
      'web_ui_secure_cookie_enabled': state.webUiSecureCookieEnabled,
      'web_ui_host_header_validation_enabled':
          state.webUiHostHeaderValidationEnabled,
      'web_ui_use_custom_http_headers_enabled':
          state.webUiUseCustomHttpHeadersEnabled,
      'web_ui_custom_http_headers': state.webUiCustomHttpHeaders,
      'web_ui_reverse_proxy_enabled': state.webUiReverseProxyEnabled,
      'web_ui_reverse_proxies_list': state.webUiReverseProxiesList,
      'dyndns_enabled': state.dyndnsEnabled,
      'dyndns_service': state.dyndnsService.apiValue,
      'dyndns_domain': state.dyndnsDomain.trim(),
      'dyndns_username': state.dyndnsUsername.trim(),
      'dyndns_password': state.dyndnsPassword,
    };
    if (password.isNotEmpty) {
      payload['web_ui_password'] = password;
    }

    String? error;
    await ref
        .read(apiClientProvider)
        .post(
          ApiPath.application.setPreferences,
          data: {'json': jsonEncode(payload)},
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });

    state = state.copyWith(saving: false);
    return error;
  }
}
