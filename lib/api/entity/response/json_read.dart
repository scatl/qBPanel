/// Shared JSON field readers for API response entities.
library;

import 'dart:convert';

int? readInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

double? readDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

bool? readBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  final s = value.toString().toLowerCase();
  if (s == 'true' || s == '1') return true;
  if (s == 'false' || s == '0') return false;
  return null;
}

String? readString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  return value.toString();
}

List<String> readStringList(dynamic value) {
  if (value is! List) return const [];
  return value.map((e) => e.toString()).toList(growable: false);
}

List<int> readIntList(dynamic value) {
  if (value is! List) return const [];
  if (value.isEmpty) return const [];
  if (value is List<int>) return value;
  final length = value.length;
  final out = List<int>.filled(length, 0, growable: false);
  for (var i = 0; i < length; i++) {
    final e = value[i];
    if (e is int) {
      out[i] = e;
    } else if (e is num) {
      out[i] = e.toInt();
    }
  }
  return out;
}

/// 给 [compute] 用的顶层入口：在 isolate 里 `jsonDecode` 整段 piece 数组。
List<int> decodeIntListJson(String raw) {
  return readIntList(jsonDecode(raw));
}

Map<String, dynamic>? readMap(dynamic value) {
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}
