import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const _fileName = 'app_debug.log';
const _retainDays = 7;

String? _logFilePath;
bool _printedPath = false;
DateTime? _lastPrunedAt;
Future<void> _queue = Future.value();

/// 追加一行到应用支持目录下的 `app_debug.log`，只保留最近 [_retainDays] 天。
Future<void> appendAppLogLine(String line) {
  final next = _queue.then((_) => _appendUnlocked(line));
  _queue = next.catchError((_) {});
  return next;
}

Future<void> _appendUnlocked(String line) async {
  _logFilePath ??= p.join(
    (await getApplicationSupportDirectory()).path,
    _fileName,
  );
  if (!_printedPath) {
    _printedPath = true;
    debugPrint('[qBPanel] log file: $_logFilePath');
  }
  final file = File(_logFilePath!);
  try {
    await _pruneIfNeeded(file);
  } catch (e, st) {
    debugPrint('[qBPanel] log prune failed: $e\n$st');
  }
  await file.writeAsString('$line\n', mode: FileMode.append, flush: true);
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
