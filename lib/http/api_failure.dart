import 'package:dio/dio.dart';

/// API 调用失败信息（网络 / HTTP / 解析 / 无激活服务器等）。
class ApiFailure {
  const ApiFailure({
    required this.message,
    this.error,
    this.statusCode,
    this.isCancel = false,
  });

  /// 可读中文说明，可直接展示。
  final String message;

  final Object? error;
  final int? statusCode;
  final bool isCancel;

  factory ApiFailure.from(Object error) {
    if (error is ApiFailure) return error;
    if (error is DioException) {
      return ApiFailure(
        message: _dioMessage(error),
        error: error,
        statusCode: error.response?.statusCode,
        isCancel: error.type == DioExceptionType.cancel,
      );
    }
    if (error is StateError) {
      return ApiFailure(message: error.message, error: error);
    }
    return ApiFailure(message: error.toString(), error: error);
  }

  static String _dioMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return '连接超时，请检查地址与端口';
      case DioExceptionType.connectionError:
        return '无法连接服务器，请检查网络与配置';
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        if (code == 401 || code == 403) {
          return 'API 密钥无效或无权限';
        }
        return '服务器返回 $code';
      case DioExceptionType.badCertificate:
        return 'HTTPS 证书不受信任';
      case DioExceptionType.cancel:
        return '请求已取消';
      case DioExceptionType.unknown:
        return e.message ?? e.type.name;
    }
  }
}

/// 把 JSON object 转成实体；Dio 的 Map 可能不是 `Map<String, dynamic>`。
T Function(dynamic data) jsonParser<T>(
  T Function(Map<String, dynamic> json) fromJson,
) {
  return (data) => fromJson(Map<String, dynamic>.from(data as Map));
}
