class ServerModifyUiState {
  const ServerModifyUiState({
    this.initializing = false,
    this.nameError = false,
    this.hostError = false,
    this.apiKeyError = false,
    this.formErrorMessage,
    this.useHttps = false,
  });

  /// 编辑模式下正在从本地加载服务器
  final bool initializing;

  final bool nameError;
  final bool hostError;
  final bool apiKeyError;

  /// 显示在 HTTPS 开关与保存按钮之间
  final String? formErrorMessage;

  final bool useHttps;

  bool get hasFieldError => nameError || hostError || apiKeyError;

  ServerModifyUiState copyWith({
    bool? initializing,
    bool? nameError,
    bool? hostError,
    bool? apiKeyError,
    String? formErrorMessage,
    bool clearFormErrorMessage = false,
    bool? useHttps,
  }) {
    return ServerModifyUiState(
      initializing: initializing ?? this.initializing,
      nameError: nameError ?? this.nameError,
      hostError: hostError ?? this.hostError,
      apiKeyError: apiKeyError ?? this.apiKeyError,
      formErrorMessage: clearFormErrorMessage
          ? null
          : (formErrorMessage ?? this.formErrorMessage),
      useHttps: useHttps ?? this.useHttps,
    );
  }
}
