import 'package:qbpanel/api/entity/response/server_state_response.dart';
import 'package:flutter/material.dart';
import 'package:qbpanel/home/ui/torrent_item.dart';
import 'package:qbpanel/util/byte_format.dart';

class HomeBottomBar extends StatelessWidget {
  const HomeBottomBar({
    super.key,
    required this.serverState,
    required this.onTap,
    required this.onAltSpeedPressed,
  });

  final ServerStateResponse serverState;

  /// 磁盘 / 速度区域；不含左侧限速按钮。
  final VoidCallback onTap;

  final VoidCallback onAltSpeedPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

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
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: onTap,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.storage_outlined,
                                size: 16,
                              ),
                              Text(
                                formatBytes(
                                  serverState.freeSpaceOnDisk,
                                  fractionDigits: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}