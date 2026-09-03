import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:qbpanel/http/api_failure.dart';
import 'package:qbpanel/util/app_log_file_stub.dart'
    if (dart.library.io) 'package:qbpanel/util/app_log_file_io.dart';

/// 应用诊断日志：控制台 + 本地文件（Web 只打控制台）。
///
/// [tag] 用来区分模块，例如 `add`、`inbound`。
///
/// ```dart
/// appLog('add', 'submit tap');
/// ```
///
/// 文件路径会在首次写入时打印，Windows 一般在
/// `%AppData%\com.scatl\qbpanel\app_debug.log`
/// 本地文件只保留最近 7 天。
void appLog(String tag, String message) {
  final line = '${DateTime.now().toIso8601String()} [$tag] $message';
  debugPrint('[qBPanel] $line');
  appendAppLogLine(line).catchError((Object e, StackTrace st) {
    debugPrint('[qBPanel] log write failed: $e\n$st');
  });
}

String appLogPreview(String? text, {int max = 180}) {
  if (text == null || text.isEmpty) return '<empty>';
  final oneLine = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (oneLine.length <= max) return oneLine;
  return '${oneLine.substring(0, max)}…(len=${oneLine.length})';
}

String appLogHeadHex(List<int>? bytes, {int count = 12}) {
  if (bytes == null || bytes.isEmpty) return '<no-bytes>';
  final n = bytes.length < count ? bytes.length : count;
  final hex = bytes
      .sublist(0, n)
      .map((b) => b.toRadixString(16).padLeft(2, '0'))
      .join(' ');
  return 'len=${bytes.length} head=$hex';
}

String appLogApiFailure(ApiFailure e) {
  final buf = StringBuffer(
    'status=${e.statusCode} message=${e.message}',
  );
  final err = e.error;
  if (err is DioException) {
    buf.write(' dioType=${err.type} path=${err.requestOptions.path}');
    final data = err.response?.data;
    if (data != null) {
      buf.write(' body=${appLogPreview('$data', max: 800)}');
    }
  }
  return buf.toString();
}

void appLogFormData(String tag, FormData formData) {
  for (final field in formData.fields) {
    appLog(tag, 'form.field ${field.key}=${appLogPreview(field.value)}');
  }
  for (final file in formData.files) {
    final part = file.value;
    appLog(
      tag,
      'form.file ${file.key} filename=${part.filename} length=${part.length}',
    );
  }
}
