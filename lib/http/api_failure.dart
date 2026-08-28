import 'package:dio/dio.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/l10n/app_localizations.dart';

/// API 调用失败信息（网络 / HTTP / 解析 / 无激活服务器等）。
class ApiFailure {
  const ApiFailure({
    required this.message,
    this.error,
    this.statusCode,
    this.isCancel = false,
  });

  /// 可读说明，可直接展示。
  final String message;

  final Object? error;
  final int? statusCode;
  final bool isCancel;

  factory ApiFailure.from(Object error, {AppLocalizations? l10n}) {
    if (error is ApiFailure) return error;
    final loc = l10n ?? lookupAppLocalizations(
      resolveAppLocale(AppLocaleMode.system),
    );
    if (error is NoActiveServerError) {
      return ApiFailure(message: loc.apiNoActiveServer, error: error);
    }
    if (error is DioException) {
      return ApiFailure(
        message: _dioMessage(error, loc),
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

  static String _dioMessage(DioException e, AppLocalizations l10n) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return l10n.apiTimeout;
      case DioExceptionType.connectionError:
        return l10n.apiConnectionError;
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        if (code == 401 || code == 403) {
          return l10n.apiUnauthorized;
        }
        return l10n.apiHttpStatus(code ?? 0);
      case DioExceptionType.badCertificate:
        return l10n.apiBadCertificate;
      case DioExceptionType.cancel:
        return l10n.apiCancelled;
      case DioExceptionType.unknown:
        return e.message ?? e.type.name;
    }
  }
}

/// 没有激活服务器。
class NoActiveServerError extends StateError {
  NoActiveServerError() : super('no_active_server');
}

/// 把 JSON object 转成实体；Dio 的 Map 可能不是 `Map<String, dynamic>`。
T Function(dynamic data) jsonParser<T>(
  T Function(Map<String, dynamic> json) fromJson,
) {
  return (data) => fromJson(Map<String, dynamic>.from(data as Map));
}
