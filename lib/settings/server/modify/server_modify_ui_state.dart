import 'package:qbpanel/l10n/app_localizations.dart';

class ServerModifyUiState {
  const ServerModifyUiState({
    this.initializing = false,
    this.nameError = false,
    this.hostError = false,
    this.credentialsError = false,
    this.formErrorMessage,
    this.useHttps = false,
    this.loginMethod = ServerLoginMethod.account,
  });

  /// 编辑模式下正在从本地加载服务器
  final bool initializing;

  final bool nameError;
  final bool hostError;
  final bool credentialsError;

  /// 显示在 HTTPS 开关与保存按钮之间
  final String? formErrorMessage;

  final bool useHttps;

  final ServerLoginMethod loginMethod;

  bool get hasFieldError => nameError || hostError || credentialsError;

  ServerModifyUiState copyWith({
    bool? initializing,
    bool? nameError,
    bool? hostError,
    bool? credentialsError,
    String? formErrorMessage,
    bool clearFormErrorMessage = false,
    bool? useHttps,
    ServerLoginMethod? loginMethod,
  }) {
    return ServerModifyUiState(
      initializing: initializing ?? this.initializing,
      nameError: nameError ?? this.nameError,
      hostError: hostError ?? this.hostError,
      credentialsError: credentialsError ?? this.credentialsError,
      formErrorMessage: clearFormErrorMessage
          ? null
          : (formErrorMessage ?? this.formErrorMessage),
      useHttps: useHttps ?? this.useHttps,
      loginMethod: loginMethod ?? this.loginMethod,
    );
  }
}

/// 保存服务器时的鉴权方式：Bearer API Key 或 Cookie 账号。
enum ServerLoginMethod {
  apiKey,
  account;

  String label(AppLocalizations l10n) => switch (this) {
        ServerLoginMethod.apiKey => l10n.loginMethodApiKey,
        ServerLoginMethod.account => l10n.loginMethodAccount,
      };
}
