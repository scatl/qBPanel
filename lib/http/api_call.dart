import 'dart:async';

import 'package:dio/dio.dart';
import 'package:qbpanel/http/api_failure.dart';

/// 一次 API 调用。链式注册回调后 `await`，或只靠回调（同一同步块内注册即可）。
///
/// ```dart
/// await api.get(path, parser: jsonParser(Foo.fromJson))
///   .onSuccess((data) { ... })
///   .onFail((e) { ... });
/// ```
class ApiCall<T> implements Future<T?> {
  ApiCall({
    required Future<Response<dynamic>> Function() send,
    T Function(dynamic data)? parser,
  })  : _send = send,
        _parser = parser {
    scheduleMicrotask(_ensureStarted);
  }

  final Future<Response<dynamic>> Function() _send;
  final T Function(dynamic data)? _parser;

  FutureOr<void> Function(T data)? _onSuccess;
  FutureOr<void> Function(ApiFailure failure)? _onFail;
  FutureOr<void> Function()? _onComplete;

  Future<T?>? _started;

  ApiCall<T> onSuccess(FutureOr<void> Function(T data) callback) {
    _onSuccess = callback;
    return this;
  }

  ApiCall<T> onFail(FutureOr<void> Function(ApiFailure failure) callback) {
    _onFail = callback;
    return this;
  }

  ApiCall<T> onComplete(FutureOr<void> Function() callback) {
    _onComplete = callback;
    return this;
  }

  Future<T?> _ensureStarted() => _started ??= _execute();

  Future<T?> _execute() async {
    try {
      final response = await _send();
      final code = response.statusCode ?? 0;
      if (code < 200 || code >= 300) {
        await _emitFail(
          ApiFailure(message: '服务器返回 $code', statusCode: code),
        );
        return null;
      }
      final raw = response.data;
      final parser = _parser;
      final data = parser != null ? parser(raw) : raw as T;
      await _onSuccess?.call(data);
      return data;
    } catch (e) {
      await _emitFail(ApiFailure.from(e));
      return null;
    } finally {
      await _onComplete?.call();
    }
  }

  Future<void> _emitFail(ApiFailure failure) async {
    await _onFail?.call(failure);
  }

  @override
  Stream<T?> asStream() => _ensureStarted().asStream();

  @override
  Future<T?> catchError(
    Function onError, {
    bool Function(Object error)? test,
  }) {
    return _ensureStarted().catchError(onError, test: test);
  }

  @override
  Future<R> then<R>(
    FutureOr<R> Function(T? value) onValue, {
    Function? onError,
  }) {
    return _ensureStarted().then(onValue, onError: onError);
  }

  @override
  Future<T?> timeout(
    Duration timeLimit, {
    FutureOr<T?> Function()? onTimeout,
  }) {
    return _ensureStarted().timeout(timeLimit, onTimeout: onTimeout);
  }

  @override
  Future<T?> whenComplete(FutureOr<void> Function() action) {
    return _ensureStarted().whenComplete(action);
  }
}
