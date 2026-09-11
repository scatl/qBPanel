import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:qbpanel/util/app_log_file_result.dart';

const _fileName = 'app_debug.log';
const _retainDays = 7;

String? _logFilePath;
bool _printedPath = false;
DateTime? _lastPrunedAt;
Future<void> _queue = Future.value();

bool get appLogFileSupported => true;

Future<String> _resolveLogFilePath() async {
  _logFilePath ??= p.join(
    (await getApplicationSupportDirectory()).path,
    _fileName,
  );
  return _logFilePath!;
}

/// 追加一行到应用支持目录下的 `app_debug.log`，只保留最近 [_retainDays] 天。
Future<void> appendAppLogLine(String line) {
  final next = _queue.then((_) => _appendUnlocked(line));
  _queue = next.catchError((_) {});
  return next;
}

Future<void> _appendUnlocked(String line) async {
  final path = await _resolveLogFilePath();
  if (!_printedPath) {
    _printedPath = true;
    debugPrint('[qBPanel] log file: $path');
  }
  final file = File(path);
  try {
    await _pruneIfNeeded(file);
  } catch (e, st) {
    debugPrint('[qBPanel] log prune failed: $e\n$st');
  }
  await file.writeAsString('$line\n', mode: FileMode.append, flush: true);
}

/// 读取本地诊断日志全文（按写入顺序，旧 → 新）。
Future<AppLogFileReadResult> readAppLogFile() async {
  final path = await _resolveLogFilePath();
  final file = File(path);
  if (!await file.exists()) {
    return const AppLogFileReadResult(supported: true, lines: []);
  }
  final stat = await file.stat();
  final lines = <String>[];
  await for (final raw in file
      .openRead()
      .transform(utf8.decoder)
      .transform(const LineSplitter())) {
    if (raw.isEmpty) continue;
    lines.add(raw);
  }
  return AppLogFileReadResult(
    supported: true,
    lines: lines,
    length: stat.size,
    modified: stat.modified,
  );
}

Future<void> _pruneIfNeeded(File file) async {
  final now = DateTime.now();
  if (_lastPrunedAt != null &&
      now.difference(_lastPrunedAt!) < const Duration(days: 1)) {
    return;
  }
  _lastPrunedAt = now;
  if (!await file.exists()) return;

  final cutoff = now.subtract(const Duration(days: _retainDays));
  final tmp = File('${file.path}.tmp');
  final sink = tmp.openWrite();
  var dropped = false;
  try {
    await for (final raw in file
        .openRead()
        .transform(utf8.decoder)
        .transform(const LineSplitter())) {
      if (raw.isEmpty) continue;
      final ts = DateTime.tryParse(raw.split(' ').first);
      if (ts != null && ts.isBefore(cutoff)) {
        dropped = true;
        continue;
      }
      sink.writeln(raw);
    }
  } finally {
    await sink.close();
  }

  if (!dropped) {
    if (await tmp.exists()) await tmp.delete();
    return;
  }

  if (await file.exists()) await file.delete();
  await tmp.rename(file.path);
}
