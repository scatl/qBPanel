import 'package:qbpanel/l10n/app_localizations.dart';

/// qBittorrent `server_state.connection_status`（`sync/maindata` / `transfer/info` 同源）。
///
/// 源码：`isListening()` 为 false → [disconnected]；
/// 正在监听且有入站连接 → [connected]；正在监听但尚无入站 → [firewalled]。
enum ConnectionStatus {
  connected('connected'),
  firewalled('firewalled'),
  disconnected('disconnected'),
  unknown('unknown');

  const ConnectionStatus(this.apiValue);

  /// 接口 JSON 字符串。
  final String apiValue;

  /// 底栏/详情展示文案。
  String label(AppLocalizations l10n) => switch (this) {
        ConnectionStatus.connected => l10n.connectionStatusConnected,
        ConnectionStatus.firewalled => l10n.connectionStatusFirewalled,
        ConnectionStatus.disconnected => l10n.connectionStatusDisconnected,
        ConnectionStatus.unknown => l10n.connectionStatusUnknown,
      };

  /// 解析接口字段；缺省返回 `null`（便于增量 merge）；无法识别则为 [unknown]。
  static ConnectionStatus? fromApi(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final s in ConnectionStatus.values) {
      if (s.apiValue == raw) return s;
    }
    return ConnectionStatus.unknown;
  }
}
