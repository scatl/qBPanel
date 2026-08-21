import 'dart:convert';

import 'package:qbpanel/api/entity/response/json_read.dart';

/// `/api/v2/app/buildInfo`
class AppBuildInfoResponse {
  const AppBuildInfoResponse({
    this.qt,
    this.libtorrent,
    this.boost,
    this.openssl,
    this.zlib,
    this.bitness,
    this.platform,
  });

  final String? qt;
  final String? libtorrent;
  final String? boost;
  final String? openssl;
  final String? zlib;
  final int? bitness;
  final String? platform;

  factory AppBuildInfoResponse.fromJson(Map<String, dynamic> json) {
    return AppBuildInfoResponse(
      qt: readString(json['qt']),
      libtorrent: readString(json['libtorrent']),
      boost: readString(json['boost']),
      openssl: readString(json['openssl']),
      zlib: readString(json['zlib']),
      bitness: readInt(json['bitness']),
      platform: readString(json['platform']),
    );
  }

  Map<String, dynamic> toJson() => {
        if (qt != null) 'qt': qt,
        if (libtorrent != null) 'libtorrent': libtorrent,
        if (boost != null) 'boost': boost,
        if (openssl != null) 'openssl': openssl,
        if (zlib != null) 'zlib': zlib,
        if (bitness != null) 'bitness': bitness,
        if (platform != null) 'platform': platform,
      };

  String toJsonString() => jsonEncode(toJson());

  static AppBuildInfoResponse? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      return AppBuildInfoResponse.fromJson(Map<String, dynamic>.from(decoded));
    } catch (_) {
      return null;
    }
  }
}
