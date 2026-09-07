import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/entity/response/app_build_info_response.dart';
import 'package:qbpanel/api/web_api_version.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/settings/server/modify/server_modify_ui_state.dart';
import 'package:qbpanel/storage/db/app_database.dart';
import 'package:qbpanel/storage/db/app_database_provider.dart';

final serverModifyProvider =
    NotifierProvider<ServerModifyViewModel, ServerModifyUiState>(
  ServerModifyViewModel.new,
);

class ServerModifyViewModel extends Notifier<ServerModifyUiState> {
  @override
  ServerModifyUiState build() => const ServerModifyUiState();

  void reset() {
    state = const ServerModifyUiState();
  }

  void setUseHttps(bool value) {
    state = state.copyWith(useHttps: value);
  }

  void setLoginMethod(ServerLoginMethod value) {
    state = state.copyWith(
      loginMethod: value,
      credentialsError: false,
      clearFormErrorMessage: !state.nameError && !state.hostError,
    );
  }

  void clearFieldError({
    bool name = false,
    bool host = false,
    bool credentials = false,
  }) {
    if (!name && !host && !credentials) return;
    final next = state.copyWith(
      nameError: name ? false : state.nameError,
      hostError: host ? false : state.hostError,
      credentialsError: credentials ? false : state.credentialsError,
    );
    state = next.copyWith(clearFormErrorMessage: !next.hasFieldError);
  }

  /// 按 id 读取本地配置；不存在返回 `null`。
  Future<QbServer?> loadForEdit(int serverId) async {
    state = state.copyWith(
      initializing: true,
      clearFormErrorMessage: true,
      nameError: false,
      hostError: false,
      credentialsError: false,
    );

    final db = ref.read(appDatabaseProvider);
    final server = await (db.select(db.qbServers)
          ..where((t) => t.id.equals(serverId)))
        .getSingleOrNull();

    if (server == null) {
      state = state.copyWith(
        initializing: false,
        formErrorMessage: ref.read(appLocalizationsProvider).serverNotFound,
      );
      return null;
    }

    state = state.copyWith(
      initializing: false,
      useHttps: server.useHttps,
      loginMethod: server.apiKey.trim().isNotEmpty
          ? ServerLoginMethod.apiKey
          : ServerLoginMethod.account,
      clearFormErrorMessage: true,
    );
    return server;
  }

  /// 本地字段校验 → 登录/鉴权 → 拉取 version / webapiVersion / buildInfo → 成功后写入。
  ///
  /// [serverId] 非空时更新该行，保留原 `isActive`；为空时新增。
  Future<bool> save({
    int? serverId,
    required String name,
    required String host,
    required String portText,
    required String path,
    required String apiKey,
    required String username,
    required String password,
  }) async {
    final nameTrim = name.trim();
    final hostTrim = host.trim();
    final usesApiKey = state.loginMethod == ServerLoginMethod.apiKey;
    final apiKeyTrim = usesApiKey ? apiKey.trim() : '';
    final usernameTrim = usesApiKey ? '' : username.trim();
    final passwordTrim = usesApiKey ? '' : password;
    final portTrim = portText.trim();
    final pathTrim = path.trim().replaceAll(RegExp(r'^/+|/+$'), '');

    final nameError = nameTrim.isEmpty;
    final hostError = hostTrim.isEmpty;
    final credentialsError = usesApiKey
        ? apiKeyTrim.isEmpty
        : usernameTrim.isEmpty || passwordTrim.isEmpty;

    if (nameError || hostError || credentialsError) {
      final l10n = ref.read(appLocalizationsProvider);
      state = state.copyWith(
        nameError: nameError,
        hostError: hostError,
        credentialsError: credentialsError,
        formErrorMessage: credentialsError
            ? l10n.credentialsRequired
            : l10n.pleaseFillFields(
                [
                  if (nameError) l10n.serverName,
                  if (hostError) l10n.host,
                ].join(l10n.listSeparator),
              ),
      );
      return false;
    }

    state = state.copyWith(
      nameError: false,
      hostError: false,
      credentialsError: false,
      clearFormErrorMessage: true,
    );

    final port = portTrim.isEmpty ? 80 : int.parse(portTrim);
    final config = ServerConnection(
      host: hostTrim,
      port: port,
      useHttps: state.useHttps,
      path: pathTrim,
      apiKey: apiKeyTrim,
      username: usernameTrim,
      password: passwordTrim,
    );
    final probed = await _probeAppInfo(config);
    if (probed == null) return false;

    final db = ref.read(appDatabaseProvider);

    if (serverId != null) {
      final updated = await (db.update(db.qbServers)
            ..where((t) => t.id.equals(serverId)))
          .write(
        QbServersCompanion(
          name: Value(nameTrim),
          host: Value(hostTrim),
          port: Value(port),
          useHttps: Value(state.useHttps),
          path: Value(pathTrim),
          apiKey: Value(apiKeyTrim),
          username: Value(usernameTrim),
          password: Value(passwordTrim),
          appVersion: Value(probed.appVersion),
          apiVersion: Value(probed.apiVersion),
          buildInfo: Value(probed.buildInfo),
          updatedAt: Value(DateTime.now()),
        ),
      );
      if (updated == 0) {
        state = state.copyWith(
          formErrorMessage: ref.read(appLocalizationsProvider).saveFailedServerGone,
        );
        return false;
      }
      return true;
    }

    final active = await (db.select(db.qbServers)
          ..where((t) => t.isActive.equals(true)))
        .getSingleOrNull();

    await db.into(db.qbServers).insert(
          QbServersCompanion.insert(
            name: nameTrim,
            host: hostTrim,
            port: Value(port),
            useHttps: Value(state.useHttps),
            path: Value(pathTrim),
            apiKey: Value(apiKeyTrim),
            username: Value(usernameTrim),
            password: Value(passwordTrim),
            appVersion: Value(probed.appVersion),
            apiVersion: Value(probed.apiVersion),
            buildInfo: Value(probed.buildInfo),
            isActive: Value(active == null),
          ),
        );

    return true;
  }

  /// version / webapiVersion 是纯文本；`2.0` 走 JSON 会被解析成数字。
  static String? _plainVersion(dynamic data) {
    final text = data?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }

  /// 探活并拉取版本信息。API 版本必须成功，其余失败则存空。
  Future<({String appVersion, String apiVersion, String buildInfo})?>
      _probeAppInfo(ServerConnection config) async {
    final api = ref.read(apiClientProvider);
    final l10n = ref.read(appLocalizationsProvider);
    final plain = Options(responseType: ResponseType.plain);
    String? probeError;

    final apiVersion = await api
        .getWithConfig<String?>(
          config: config,
          apiPath: ApiPath.application.apiVersion,
          options: plain,
          parser: _plainVersion,
        )
        .onFail((e) {
          probeError ??= e.message;
        });

    if (apiVersion == null) {
      state = state.copyWith(
        formErrorMessage: l10n.probeFailed(
          probeError ?? l10n.cannotGetApiVersion,
        ),
      );
      return null;
    }

    final parsed = WebApiVersion.tryParse(apiVersion);
    if (parsed == null || !parsed.isSupported) {
      state = state.copyWith(formErrorMessage: l10n.apiVersionTooOld);
      return null;
    }

    String appVersion = '';
    String buildInfo = '';
    await Future.wait([
      api
          .getWithConfig<String?>(
            config: config,
            apiPath: ApiPath.application.appVersion,
            options: plain,
            parser: _plainVersion,
          )
          .onSuccess((data) {
            appVersion = data ?? '';
          }),
      api
          .getWithConfig<AppBuildInfoResponse>(
            config: config,
            apiPath: ApiPath.application.buildInfo,
            parser: jsonParser(AppBuildInfoResponse.fromJson),
          )
          .onSuccess((data) {
            buildInfo = data.toJsonString();
          }),
    ]);

    return (
      appVersion: appVersion,
      apiVersion: apiVersion,
      buildInfo: buildInfo,
    );
  }
}
