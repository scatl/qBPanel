import 'package:qbpanel/widget/empty/empty_state.dart';

/// WebUI「WebUI」页状态。
class WebUiSettingsUiState {
  const WebUiSettingsUiState({
    this.emptyState = const EmptyState.content(),
    this.saving = false,
    this.apiKeyBusy = false,
    this.webUiDomainList = '*',
    this.webUiAddress = '*',
    this.webUiPort = 8080,
    this.webUiUpnp = false,
    this.useHttps = false,
    this.webUiHttpsCertPath = '',
    this.webUiHttpsKeyPath = '',
    this.webUiUsername = 'admin',
    this.webUiPassword = '',
    this.webUiApiKey = '',
    this.bypassLocalAuth = false,
    this.bypassAuthSubnetWhitelistEnabled = false,
    this.bypassAuthSubnetWhitelist = '',
    this.webUiMaxAuthFailCount = 5,
    this.webUiBanDuration = 3600,
    this.webUiSessionTimeout = 3600,
    this.alternativeWebuiEnabled = false,
    this.alternativeWebuiPath = '',
    this.webUiClickjackingProtectionEnabled = true,
    this.webUiCsrfProtectionEnabled = true,
    this.webUiSecureCookieEnabled = true,
    this.webUiHostHeaderValidationEnabled = true,
    this.webUiUseCustomHttpHeadersEnabled = false,
    this.webUiCustomHttpHeaders = '',
    this.webUiReverseProxyEnabled = false,
    this.webUiReverseProxiesList = '',
    this.dyndnsEnabled = false,
    this.dyndnsService = WebUiDynDnsService.dyndns,
    this.dyndnsDomain = '',
    this.dyndnsUsername = '',
    this.dyndnsPassword = '',
  });

  final EmptyState emptyState;
  final bool saving;
  final bool apiKeyBusy;

  final String webUiDomainList;
  final String webUiAddress;
  final int webUiPort;
  final bool webUiUpnp;
  final bool useHttps;
  final String webUiHttpsCertPath;
  final String webUiHttpsKeyPath;

  final String webUiUsername;
  /// 仅本地编辑；空表示不修改服务器密码。
  final String webUiPassword;
  final String webUiApiKey;
  final bool bypassLocalAuth;
  final bool bypassAuthSubnetWhitelistEnabled;
  final String bypassAuthSubnetWhitelist;
  final int webUiMaxAuthFailCount;
  final int webUiBanDuration;
  final int webUiSessionTimeout;

  final bool alternativeWebuiEnabled;
  final String alternativeWebuiPath;

  final bool webUiClickjackingProtectionEnabled;
  final bool webUiCsrfProtectionEnabled;
  final bool webUiSecureCookieEnabled;
  final bool webUiHostHeaderValidationEnabled;

  final bool webUiUseCustomHttpHeadersEnabled;
  final String webUiCustomHttpHeaders;

  final bool webUiReverseProxyEnabled;
  final String webUiReverseProxiesList;

  final bool dyndnsEnabled;
  final WebUiDynDnsService dyndnsService;
  final String dyndnsDomain;
  final String dyndnsUsername;
  final String dyndnsPassword;

  bool get ready => emptyState.ready;

  bool get hasApiKey => webUiApiKey.isNotEmpty;

  /// 与 WebUI 一致：前 4 + 中间圆点 + 后 6。
  String get maskedApiKey {
    final key = webUiApiKey;
    if (key.isEmpty) return '';
    if (key.length <= 10) return '•' * key.length;
    return '${key.substring(0, 4)}'
        '${'•' * (key.length - 10)}'
        '${key.substring(key.length - 6)}';
  }

  WebUiSettingsUiState copyWith({
    EmptyState? emptyState,
    bool? saving,
    bool? apiKeyBusy,
    String? webUiDomainList,
    String? webUiAddress,
    int? webUiPort,
    bool? webUiUpnp,
    bool? useHttps,
    String? webUiHttpsCertPath,
    String? webUiHttpsKeyPath,
    String? webUiUsername,
    String? webUiPassword,
    String? webUiApiKey,
    bool? bypassLocalAuth,
    bool? bypassAuthSubnetWhitelistEnabled,
    String? bypassAuthSubnetWhitelist,
    int? webUiMaxAuthFailCount,
    int? webUiBanDuration,
    int? webUiSessionTimeout,
    bool? alternativeWebuiEnabled,
    String? alternativeWebuiPath,
    bool? webUiClickjackingProtectionEnabled,
    bool? webUiCsrfProtectionEnabled,
    bool? webUiSecureCookieEnabled,
    bool? webUiHostHeaderValidationEnabled,
    bool? webUiUseCustomHttpHeadersEnabled,
    String? webUiCustomHttpHeaders,
    bool? webUiReverseProxyEnabled,
    String? webUiReverseProxiesList,
    bool? dyndnsEnabled,
    WebUiDynDnsService? dyndnsService,
    String? dyndnsDomain,
    String? dyndnsUsername,
    String? dyndnsPassword,
  }) {
    return WebUiSettingsUiState(
      emptyState: emptyState ?? this.emptyState,
      saving: saving ?? this.saving,
      apiKeyBusy: apiKeyBusy ?? this.apiKeyBusy,
      webUiDomainList: webUiDomainList ?? this.webUiDomainList,
      webUiAddress: webUiAddress ?? this.webUiAddress,
      webUiPort: webUiPort ?? this.webUiPort,
      webUiUpnp: webUiUpnp ?? this.webUiUpnp,
      useHttps: useHttps ?? this.useHttps,
      webUiHttpsCertPath: webUiHttpsCertPath ?? this.webUiHttpsCertPath,
      webUiHttpsKeyPath: webUiHttpsKeyPath ?? this.webUiHttpsKeyPath,
      webUiUsername: webUiUsername ?? this.webUiUsername,
      webUiPassword: webUiPassword ?? this.webUiPassword,
      webUiApiKey: webUiApiKey ?? this.webUiApiKey,
      bypassLocalAuth: bypassLocalAuth ?? this.bypassLocalAuth,
      bypassAuthSubnetWhitelistEnabled: bypassAuthSubnetWhitelistEnabled ??
          this.bypassAuthSubnetWhitelistEnabled,
      bypassAuthSubnetWhitelist:
          bypassAuthSubnetWhitelist ?? this.bypassAuthSubnetWhitelist,
      webUiMaxAuthFailCount:
          webUiMaxAuthFailCount ?? this.webUiMaxAuthFailCount,
      webUiBanDuration: webUiBanDuration ?? this.webUiBanDuration,
      webUiSessionTimeout: webUiSessionTimeout ?? this.webUiSessionTimeout,
      alternativeWebuiEnabled:
          alternativeWebuiEnabled ?? this.alternativeWebuiEnabled,
      alternativeWebuiPath: alternativeWebuiPath ?? this.alternativeWebuiPath,
      webUiClickjackingProtectionEnabled:
          webUiClickjackingProtectionEnabled ??
              this.webUiClickjackingProtectionEnabled,
      webUiCsrfProtectionEnabled:
          webUiCsrfProtectionEnabled ?? this.webUiCsrfProtectionEnabled,
      webUiSecureCookieEnabled:
          webUiSecureCookieEnabled ?? this.webUiSecureCookieEnabled,
      webUiHostHeaderValidationEnabled: webUiHostHeaderValidationEnabled ??
          this.webUiHostHeaderValidationEnabled,
      webUiUseCustomHttpHeadersEnabled: webUiUseCustomHttpHeadersEnabled ??
          this.webUiUseCustomHttpHeadersEnabled,
      webUiCustomHttpHeaders:
          webUiCustomHttpHeaders ?? this.webUiCustomHttpHeaders,
      webUiReverseProxyEnabled:
          webUiReverseProxyEnabled ?? this.webUiReverseProxyEnabled,
      webUiReverseProxiesList:
          webUiReverseProxiesList ?? this.webUiReverseProxiesList,
      dyndnsEnabled: dyndnsEnabled ?? this.dyndnsEnabled,
      dyndnsService: dyndnsService ?? this.dyndnsService,
      dyndnsDomain: dyndnsDomain ?? this.dyndnsDomain,
      dyndnsUsername: dyndnsUsername ?? this.dyndnsUsername,
      dyndnsPassword: dyndnsPassword ?? this.dyndnsPassword,
    );
  }
}

/// `dyndns_service`
enum WebUiDynDnsService {
  dyndns('DynDNS', 0),
  noIp('NO-IP', 1);

  const WebUiDynDnsService(this.label, this.apiValue);
  final String label;
  final int apiValue;

  static WebUiDynDnsService fromApi(int? value) {
    for (final item in values) {
      if (item.apiValue == value) return item;
    }
    return WebUiDynDnsService.dyndns;
  }
}
