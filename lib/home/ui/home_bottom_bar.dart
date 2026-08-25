import 'package:qbpanel/api/entity/response/connection_status.dart';
import 'package:qbpanel/api/entity/response/server_state_response.dart';
import 'package:flutter/material.dart';
import 'package:qbpanel/home/ui/torrent_item.dart';
import 'package:qbpanel/util/byte_format.dart';

class HomeBottomBar extends StatelessWidget {
  const HomeBottomBar({
    super.key,
    required this.serverState,
    required this.onStatusTap,
    required this.onSpeedTap,
    required this.onAltSpeedPressed,
  });

  final ServerStateResponse serverState;

  /// 连接状态图标：打开服务器状态 sheet。
  final VoidCallback onStatusTap;

  /// 上下行速度：打开全局限速 dialog。
  final VoidCallback onSpeedTap;

  final VoidCallback onAltSpeedPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final status = serverState.connectionStatus;
    final statusColor = _connectionColor(scheme, status);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Material(
        color: scheme.surfaceContainer,
        clipBehavior: Clip.antiAlias,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                InkWell(
                  onTap: onStatusTap,
                  child: Tooltip(
                    message: status?.displayText ?? '服务器状态',
                    child: Icon(
                      _connectionIcon(status),
                      size: 20,
                      color: statusColor ?? scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  tooltip: serverState.useAltSpeedLimits == true
                      ? '关闭备用速度限制'
                      : '开启备用速度限制',
                  visualDensity: VisualDensity.compact,
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(32, 32),
                    backgroundColor: serverState.useAltSpeedLimits == true
                        ? scheme.primary
                        : null,
                    foregroundColor: serverState.useAltSpeedLimits == true
                        ? scheme.onPrimary
                        : scheme.onSurfaceVariant,
                  ),
                  onPressed: onAltSpeedPressed,
                  icon: Icon(
                    Icons.speed,
                    size: serverState.useAltSpeedLimits == true ? 18 : 20,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: onSpeedTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SpeedChip(
                        icon: Icons.south_rounded,
                        text: formatSpeed(serverState.dlInfoSpeed),
                        color: scheme.primary,
                      ),
                      const SizedBox(width: 16),
                      SpeedChip(
                        icon: Icons.north_rounded,
                        text: formatSpeed(serverState.upInfoSpeed),
                        color: scheme.tertiary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

IconData _connectionIcon(ConnectionStatus? status) {
  switch (status) {
    case ConnectionStatus.connected:
      return Icons.cloud_done_outlined;
    case ConnectionStatus.firewalled:
      return Icons.cloud_queue_outlined;
    case ConnectionStatus.disconnected:
      return Icons.cloud_off_outlined;
    default:
      return Icons.cloud_outlined;
  }
}

Color? _connectionColor(ColorScheme scheme, ConnectionStatus? status) {
  switch (status) {
    case ConnectionStatus.connected:
      return scheme.primary;
    case ConnectionStatus.firewalled:
      return scheme.tertiary;
    case ConnectionStatus.disconnected:
      return scheme.error;
    default:
      return null;
  }
}
