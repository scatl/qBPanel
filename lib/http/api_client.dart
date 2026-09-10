import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/http/api_call.dart';
import 'package:qbpanel/http/api_failure.dart';
import 'package:qbpanel/http/server_connection.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/l10n/app_localizations.dart';
import 'package:qbpanel/storage/db/app_database.dart';
import 'package:qbpanel/storage/db/app_database_provider.dart';

export 'package:qbpanel/http/api_call.dart';
export 'package:qbpanel/http/api_failure.dart';
export 'package:qbpanel/http/server_connection.dart';

/// qBittorrent WebUI API 客户端。
///
/// - 默认 [get]/[post]：用本地 `isActive == true` 的服务器
/// - 鉴权：有 API Key 则 Bearer；否则 Cookie（`auth/login` + SID）
/// - [getWithConfig] / [postWithConfig]：用调用方传入的连接参数（保存前探测等）
/// - 返回 [ApiCall]：`.onSuccess` / `.onFail`，不必再判断 [Response]
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    ref.watch(appDatabaseProvider),
    l10n: () => ref.read(appLocalizationsProvider),
  );
});

class ApiClient {
  ApiClient(this._db, {required AppLocalizations Function() l10n})
      : _l10n = l10n {
    dio.interceptors.add(CookieManager(_cookieJar));
  }

  final AppDatabase _db;
  final AppLocalizations Function() _l10n;
  final CookieJar _cookieJar = CookieJar();
  final Set<String> _loggedIn = {};

  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      responseType: ResponseType.json,
      headers: const {
        Headers.acceptHeader: '*/*',
      },
    ),
  );

  /// 当前激活的服务器；没有则抛错。
  Future<QbServer> activeServer() async {
    final server = await (_db.select(_db.qbServers)
          ..where((t) => t.isActive.equals(true)))
        .getSingleOrNull();
    if (server == null) {
      throw NoActiveServerError();
    }
    return server;
  }

  static String buildBaseUrl({
    required String host,
    required int port,
    required bool useHttps,
    String path = '',
  }) {
    return ServerConnection(
      host: host,
      port: port,
      useHttps: useHttps,
      path: path,
    ).baseUrl;
  }

  static String buildUrl({
    required String host,
    required int port,
    required bool useHttps,
    String path = '',
    required String apiPath,
  }) {
    final base = buildBaseUrl(
      host: host,
      port: port,
      useHttps: useHttps,
      path: path,
    ).replaceAll(RegExp(r'/+$'), '');
    final suffix = apiPath.startsWith('/') ? apiPath : '/$apiPath';
    return '$base$suffix';
  }

  /// `{scheme}://{host}:{port}` 或带路径前缀
  static String baseUrlOf(QbServer server) {
    return ServerConnection.fromServer(server).baseUrl;
  }

  static String resolveUrl(QbServer server, String apiPath) {
    return buildUrl(
      host: server.host,
      port: server.port,
      useHttps: server.useHttps,
      path: server.path,
      apiPath: apiPath,
    );
  }

  static String resolveConnectionUrl(ServerConnection config, String apiPath) {
    return buildUrl(
      host: config.host,
      port: config.port,
      useHttps: config.useHttps,
      path: config.path,
      apiPath: apiPath,
    );
  }

  Map<String, dynamic> _csrfHeaders(ServerConnection config) {
    final origin = config.baseUrl.replaceAll(RegExp(r'/+$'), '');
    return {
      'Referer': origin,
      'Origin': origin,
    };
  }

  Options _withAuth(ServerConnection config, Options? options) {
    final headers = Map<String, dynamic>.from(options?.headers ?? {});
    headers.addAll(_csrfHeaders(config));
    if (config.usesApiKey) {
      headers['Authorization'] = 'Bearer ${config.apiKey.trim()}';
    }
    return (options ?? Options()).copyWith(headers: headers);
  }

  Future<void> ensureSession(
    ServerConnection config, {
    bool force = false,
  }) async {
    if (config.usesApiKey) return;
    if (!config.usesCookie) {
      throw MissingCredentialsError();
    }
    final key = config.sessionKey;
    if (!force && _loggedIn.contains(key)) return;

    final l10n = _l10n();
    final response = await dio.post<dynamic>(
      resolveConnectionUrl(config, ApiPath.auth.login),
      data: {
        'username': config.username.trim(),
        'password': config.password,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        responseType: ResponseType.plain,
        headers: _csrfHeaders(config),
      ),
    );
    final body = response.data?.toString().trim().toLowerCase() ?? '';
    final code = response.statusCode ?? 0;
    if (code == 200 && (body == 'ok.' || body == 'ok')) {
      _loggedIn.add(key);
      return;
    }
    _loggedIn.remove(key);
    throw DioException(
      requestOptions: response.requestOptions,
      response: Response<dynamic>(
        requestOptions: response.requestOptions,
        statusCode: 401,
        data: response.data,
      ),
      type: DioExceptionType.badResponse,
      message: l10n.apiUnauthorized,
    );
  }

  bool _shouldRelogin(ServerConnection config, DioException e) {
    if (!config.usesCookie) return false;
    final code = e.response?.statusCode;
    return code == 401 || code == 403;
  }

  Future<Response<dynamic>> _sendWithAuth({
    required ServerConnection config,
    required Future<Response<dynamic>> Function(Options options) send,
    Options? options,
  }) async {
    await ensureSession(config);
    try {
      return await send(_withAuth(config, options));
    } on DioException catch (e) {
      if (!_shouldRelogin(config, e)) rethrow;
      await ensureSession(config, force: true);
      return await send(_withAuth(config, options));
    }
  }

  /// 使用指定连接信息发 GET（不读本地 active 服务器）。
  ApiCall<T> getWithConfig<T>({
    required ServerConnection config,
    required String apiPath,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? parser,
  }) {
    return ApiCall<T>(
      send: () => _sendWithAuth(
        config: config,
        options: options,
        send: (opts) => dio.get<dynamic>(
          resolveConnectionUrl(config, apiPath),
          queryParameters: queryParameters,
          options: opts,
          cancelToken: cancelToken,
        ),
      ),
      parser: parser,
      l10n: _l10n,
      method: 'GET',
      path: apiPath,
    );
  }

  /// 使用指定连接信息发 POST。
  ApiCall<T> postWithConfig<T>({
    required ServerConnection config,
    required String apiPath,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? parser,
  }) {
    return ApiCall<T>(
      send: () => _sendWithAuth(
        config: config,
        options: options,
        send: (opts) => dio.post<dynamic>(
          resolveConnectionUrl(config, apiPath),
          data: data,
          queryParameters: queryParameters,
          options: opts,
          cancelToken: cancelToken,
        ),
      ),
      parser: parser,
      l10n: _l10n,
      method: 'POST',
      path: apiPath,
    );
  }

  ApiCall<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic data)? parser,
  }) {
    return ApiCall<T>(
      send: () async {
        final config = ServerConnection.fromServer(await activeServer());
        return _sendWithAuth(
          config: config,
          options: options,
          send: (opts) => dio.get<dynamic>(
            resolveConnectionUrl(config, path),
            queryParameters: queryParameters,
            options: opts,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress,
          ),
        );
      },
      parser: parser,
      l10n: _l10n,
      method: 'GET',
      path: path,
    );
  }

  ApiCall<T> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic data)? parser,
  }) {
    return ApiCall<T>(
      send: () async {
        final config = ServerConnection.fromServer(await activeServer());
        return _sendWithAuth(
          config: config,
          options: options,
          send: (opts) => dio.post<dynamic>(
            resolveConnectionUrl(config, path),
            data: data,
            queryParameters: queryParameters,
            options: opts,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          ),
        );
      },
      parser: parser,
      l10n: _l10n,
      method: 'POST',
      path: path,
    );
  }

  /// 可读说明（不含业务前缀）。优先用 [ApiCall.onFail] 的 [ApiFailure.message]。
  String messageOf(Object e) => ApiFailure.from(e, l10n: _l10n()).message;
}
