/// qBittorrent `server_state.connection_status`（`sync/maindata` / `transfer/info` 同源）。
///
/// 源码：`isListening()` 为 false → [disconnected]；
/// 正在监听且有入站连接 → [connected]；正在监听但尚无入站 → [firewalled]。
enum ConnectionStatus {
  connected('connected', '已连接'),
  firewalled('firewalled', '无法入站'),
  disconnected('disconnected', '未连接'),
  unknown('unknown', '未知');

  const ConnectionStatus(this.apiValue, this.displayText);

  /// 接口 JSON 字符串。
  final String apiValue;

  /// 底栏/详情展示用中文。
  final String displayText;

  /// 解析接口字段；缺省返回 `null`（便于增量 merge）；无法识别则为 [unknown]。
  static ConnectionStatus? fromApi(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final s in ConnectionStatus.values) {
      if (s.apiValue == raw) return s;
    }
    return ConnectionStatus.unknown;
  }
}
