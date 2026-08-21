import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:receive_intent/receive_intent.dart';
import 'package:qbpanel/router/app_router.dart';
import 'package:qbpanel/router/router_path.dart';
import 'package:qbpanel/storage/db/app_database_provider.dart';
import 'package:uri_content/uri_content.dart';

const _intentChannel = MethodChannel('qbpanel/intent');

/// 监听系统打开 / 分享的 `.torrent` 或 `magnet:`，导入到添加页或在首页提示。
class InboundTorrentOpen {
  InboundTorrentOpen(this._ref);

  final WidgetRef _ref;
  StreamSubscription<Intent?>? _sub;
  bool _started = false;
  String? _lastHandledKey;

  Future<void> start() async {
    if (_started || kIsWeb) return;
    _started = true;

    try {
      final initial = await ReceiveIntent.getInitialIntent();
      await _handle(initial);
    } catch (e, st) {
      debugPrint('InboundTorrentOpen initial: $e\n$st');
    }

    _sub = ReceiveIntent.receivedIntentStream.listen(
      _handle,
      onError: (Object e, StackTrace st) {
        debugPrint('InboundTorrentOpen stream: $e\n$st');
      },
    );
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }

  Future<void> _handle(Intent? intent) async {
    if (intent == null || intent.isNull) return;
    if (intent.action == 'android.intent.action.MAIN') return;

    final payload = _payloadFromIntent(intent);
    if (payload == null) return;

    final key = payload.key;
    if (key == _lastHandledKey) {
      await _clearLaunchIntent();
      return;
    }
    _lastHandledKey = key;

    final hasActive = await _hasActiveServer();
    if (!hasActive) {
      await _clearLaunchIntent();
      return;
    }

    String? location;
    if (payload.magnetUrl != null) {
      location = RouterPath.addTorrentWithParams(url: payload.magnetUrl);
    } else {
      final fileUri = Uri.tryParse(payload.fileUri!);
      if (fileUri == null) {
        await _clearLaunchIntent();
        return;
      }
      final bytes = await fileUri.getContentOrNull();
      if (bytes == null || bytes.isEmpty) {
        await _clearLaunchIntent();
        return;
      }
      final tempPath = await _saveTorrentToTemp(bytes, _fileNameFromUri(fileUri),);
      if (tempPath == null) {
        await _clearLaunchIntent();
        return;
      }
      location = RouterPath.addTorrentWithParams(torrentPath: tempPath);
    }

    await _clearLaunchIntent();
    _openAddTorrent(location);
  }

  void _openAddTorrent(String location) {
    if (appRouter.state.matchedLocation == RouterPath.addTorrent) {
      appRouter.go(location);
    } else {
      appRouter.push(location);
    }
  }

  Future<bool> _hasActiveServer() async {
    final db = _ref.read(appDatabaseProvider);
    final server = await (db.select(db.qbServers)
          ..where((t) => t.isActive.equals(true)))
        .getSingleOrNull();
    return server != null;
  }

  Future<void> _clearLaunchIntent() async {
    try {
      await _intentChannel.invokeMethod<void>('clearLaunchIntent');
    } catch (e, st) {
      debugPrint('clearLaunchIntent: $e\n$st');
    }
  }
}

Future<String?> _saveTorrentToTemp(Uint8List bytes, String name) async {
  try {
    final root = await getTemporaryDirectory();
    final dir = Directory(p.join(root.path, 'inbound_torrents'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final safeName = name.replaceAll(RegExp(r'[^\w.\-]+'), '_');
    final fileName = safeName.toLowerCase().endsWith('.torrent')
        ? safeName
        : '$safeName.torrent';
    final file = File(
      p.join(dir.path, '${DateTime.now().millisecondsSinceEpoch}_$fileName'),
    );
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  } catch (e, st) {
    debugPrint('saveTorrentToTemp: $e\n$st');
    return null;
  }
}

class _InboundPayload {
  const _InboundPayload.magnet(this.magnetUrl) : fileUri = null;

  const _InboundPayload.file(this.fileUri) : magnetUrl = null;

  final String? magnetUrl;
  final String? fileUri;

  String get key => magnetUrl ?? fileUri ?? '';
}

_InboundPayload? _payloadFromIntent(Intent intent) {
  final action = intent.action;

  if (action == 'android.intent.action.VIEW') {
    final data = intent.data?.trim();
    if (data == null || data.isEmpty) return null;
    final magnet = _asMagnetUrl(data);
    if (magnet != null) return _InboundPayload.magnet(magnet);
    if (_looksLikeTorrentUri(data) || _looksLikeTorrentMime(intent)) {
      return _InboundPayload.file(data);
    }
    return null;
  }

  if (action == 'android.intent.action.SEND') {
    final text = _extraText(intent.extra);
    final magnet = text == null ? null : _asMagnetUrl(text);
    if (magnet != null) return _InboundPayload.magnet(magnet);

    final stream = _extraStreamUri(intent.extra);
    if (stream != null) return _InboundPayload.file(stream);

    final data = intent.data?.trim();
    if (data != null && data.isNotEmpty) {
      final fromData = _asMagnetUrl(data);
      if (fromData != null) return _InboundPayload.magnet(fromData);
      if (_looksLikeTorrentUri(data)) return _InboundPayload.file(data);
    }
  }

  return null;
}

String? _asMagnetUrl(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;
  final match = RegExp(
    r'magnet:\?[^\s<>"{}|\\^`\[\]]+',
    caseSensitive: false,
  ).firstMatch(trimmed);
  if (match != null) return match.group(0);
  if (trimmed.toLowerCase().startsWith('magnet:')) return trimmed;
  return null;
}

String? _extraText(Map<String, dynamic>? extra) {
  if (extra == null) return null;
  const keys = [
    'android.intent.extra.TEXT',
    'android.intent.extra.text',
    'android.intent.extra.SUBJECT',
  ];
  for (final key in keys) {
    final value = extra[key];
    if (value is String && value.trim().isNotEmpty) return value;
  }
  return null;
}

bool _looksLikeTorrentMime(Intent intent) {
  final extra = intent.extra;
  if (extra == null) return false;
  final type = extra['android.intent.extra.MIME_TYPES'] ??
      extra['mimeType'] ??
      extra['type'];
  if (type is String) {
    return type.toLowerCase().contains('bittorrent');
  }
  if (type is List) {
    return type.any(
      (e) => e.toString().toLowerCase().contains('bittorrent'),
    );
  }
  return false;
}

bool _looksLikeTorrentUri(String raw) {
  final lower = raw.toLowerCase();
  if (lower.contains('.torrent')) return true;
  if (lower.startsWith('content://')) return true;
  return false;
}

String? _extraStreamUri(Map<String, dynamic>? extra) {
  if (extra == null) return null;
  const keys = [
    'android.intent.extra.STREAM',
    'android.intent.extra.stream',
  ];
  for (final key in keys) {
    final value = extra[key];
    final uri = _coerceUriString(value);
    if (uri != null) return uri;
  }
  return null;
}

String? _coerceUriString(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.startsWith('{')) {
      try {
        final map = jsonDecode(trimmed);
        if (map is Map) {
          return _coerceUriString(map['uri'] ?? map['path'] ?? map['data']);
        }
      } catch (_) {}
    }
    return trimmed;
  }
  if (value is Map) {
    return _coerceUriString(value['uri'] ?? value['path'] ?? value['data']);
  }
  if (value is List && value.isNotEmpty) {
    return _coerceUriString(value.first);
  }
  return value.toString();
}

String _fileNameFromUri(Uri uri) {
  final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
  if (segments.isNotEmpty) {
    final last = Uri.decodeComponent(segments.last);
    if (last.toLowerCase().endsWith('.torrent')) return last;
    if (last.contains('.')) {
      return last.toLowerCase().endsWith('.torrent') ? last : '$last.torrent';
    }
  }
  final queryName = uri.queryParameters['name'] ?? uri.queryParameters['file'];
  if (queryName != null && queryName.trim().isNotEmpty) {
    final name = queryName.trim();
    return name.toLowerCase().endsWith('.torrent') ? name : '$name.torrent';
  }
  return 'torrent.torrent';
}
