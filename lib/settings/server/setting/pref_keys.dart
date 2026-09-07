/// GET `/app/preferences` 出现过的 key。写回时只提交这些，避免把 5.x 字段打到旧版。
Map<String, dynamic> pickPrefs(
  Set<String> presentKeys,
  Map<String, dynamic> payload,
) {
  if (presentKeys.isEmpty) return payload;
  return {
    for (final e in payload.entries)
      if (presentKeys.contains(e.key)) e.key: e.value,
  };
}

bool hasPref(Set<String> presentKeys, String key) => presentKeys.contains(key);

bool hasAnyPref(Set<String> presentKeys, Iterable<String> keys) =>
    keys.any(presentKeys.contains);
