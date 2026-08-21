import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/http/api_call.dart';
import 'package:qbpanel/http/api_failure.dart';
import 'package:qbpanel/storage/db/app_database.dart';
import 'package:qbpanel/storage/db/app_database_provider.dart';

export 'package:qbpanel/http/api_call.dart';
export 'package:qbpanel/http/api_failure.dart';

/// qBittorrent WebUI API 客户端。
///
/// - 默认 [get]/[post]：用本地 `isActive == true` 的服务器拼 URL + Bearer
/// - [getWithConfig]：用调用方传入的连接参数（保存前探测等）
/// - 返回 [ApiCall]：`.onSuccess` / `.onFail`，不必再判断 [Response]
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(appDatabaseProvider));
});

class ApiClient {
  ApiClient(this._db);

  final AppDatabase _db;

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
      throw StateError('没有激活的服务器，请先在设置中添加并选中');
    }
    return server;
  }

  static String buildBaseUrl({
    required String host,
    required int port,
    required bool useHttps,
    String path = '',
  }) {
    final scheme = useHttps ? 'https' : 'http';
    final prefix = path.trim().replaceAll(RegExp(r'^/+|/+$'), '');
    if (prefix.isEmpty) {
      return '$scheme://$host:$port';
    }
    return '$scheme://$host:$port/$prefix';
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
    return buildBaseUrl(
      host: server.host,
      port: server.port,
      useHttps: server.useHttps,
      path: server.path,
    );
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

  Options _withAuth(String apiKey, Options? options) {
    final headers = Map<String, dynamic>.from(options?.headers ?? {});
    headers['Authorization'] = 'Bearer $apiKey';
    return (options ?? Options()).copyWith(headers: headers);
  }

  /// 使用指定连接信息发 GET（不读本地 active 服务器）。
  ApiCall<T> getWithConfig<T>({
    required String host,
    required int port,
    required bool useHttps,
    required String path,
    required String apiKey,
    required String apiPath,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? parser,
  }) {
    return ApiCall<T>(
      send: () => dio.get<dynamic>(
        buildUrl(
          host: host,
          port: port,
          useHttps: useHttps,
          path: path,
          apiPath: apiPath,
        ),
        queryParameters: queryParameters,
        options: _withAuth(apiKey, options),
        cancelToken: cancelToken,
      ),
      parser: parser,
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
        final server = await activeServer();
        return dio.get<dynamic>(
          resolveUrl(server, path),
          queryParameters: queryParameters,
          options: _withAuth(server.apiKey, options),
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        );
      },
      parser: parser,
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
        final server = await activeServer();
        return dio.post<dynamic>(
          resolveUrl(server, path),
          data: data,
          queryParameters: queryParameters,
          options: _withAuth(server.apiKey, options),
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );
      },
      parser: parser,
    );
  }

  /// 可读中文说明（不含业务前缀）。优先用 [ApiCall.onFail] 的 [ApiFailure.message]。
  static String messageOf(Object e) => ApiFailure.from(e).message;
}
