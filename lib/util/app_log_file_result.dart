/// 读取 `app_debug.log` 的结果（Web stub 返回 [supported] = false）。
class AppLogFileReadResult {
  const AppLogFileReadResult({
    required this.supported,
    required this.lines,
    this.length = 0,
    this.modified,
  });

  final bool supported;
  final List<String> lines;
  final int length;
  final DateTime? modified;
}
