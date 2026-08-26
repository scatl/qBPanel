/// 空格分词 AND 匹配（对齐 qBittorrent WebUI `containsAllTerms`）。
bool logContainsAllTerms(String text, List<String> terms) {
  if (terms.isEmpty) return true;
  final haystack = text.toLowerCase();
  for (final term in terms) {
    if (term.isEmpty) continue;
    if (!haystack.contains(term)) return false;
  }
  return true;
}

List<String> parseLogSearchTerms(String query) {
  final trimmed = query.trim().toLowerCase();
  if (trimmed.isEmpty) return const [];
  return trimmed.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();
}
