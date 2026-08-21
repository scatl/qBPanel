import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/entity/response/app_build_info_response.dart';
import 'package:qbpanel/api/entity/response/connection_status.dart';
import 'package:qbpanel/home/home_page_view_model.dart';
import 'package:qbpanel/widget/page_insets.dart';
import 'package:qbpanel/widget/sheet/blur_modal_bottom_sheet.dart';
import 'package:qbpanel/util/byte_format.dart';

class ServerStateSheet extends ConsumerWidget {
  const ServerStateSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showBlurModalBottomSheet<void>(
      context: context,
      builder: (_) => const ServerStateSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverState = ref.watch(homePageProvider.select((s) => s.serverState));
    final activeServer = ref.watch(
      homePageProvider.select((s) => s.activeServer),
    );
    final buildInfo = AppBuildInfoResponse.tryParse(activeServer?.buildInfo);
    final textTheme = Theme.of(context).textTheme;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.7;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text('服务器状态', style: textTheme.titleMedium),
          ),
          Flexible(
            child: serverState == null
                ? const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Text('暂无数据', textAlign: TextAlign.center),
                  )
                : ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 16),
                    children: [
                      _Section(
                        title: '连接',
                        rows: [
                          _Kv(
                            '连接状态',
                            serverState.connectionStatus?.displayText ?? '—',
                            valueColor: _connectionColor(
                              Theme.of(context).colorScheme,
                              serverState.connectionStatus,
                            ),
                          ),
                          _Kv('DHT 节点', _count(serverState.dhtNodes)),
                          _Kv(
                            'Peer 连接',
                            _count(serverState.totalPeerConnections),
                          ),
                          _Kv(
                            '外网 IPv4',
                            _text(serverState.lastExternalAddressV4),
                          ),
                          _Kv(
                            '外网 IPv6',
                            _text(serverState.lastExternalAddressV6),
                          ),
                        ],
                      ),
                      _Section(
                        title: '传输',
                        rows: [
                          _Kv(
                            '下载速度',
                            formatSpeed(serverState.dlInfoSpeed),
                          ),
                          _Kv(
                            '上传速度',
                            formatSpeed(serverState.upInfoSpeed),
                          ),
                          _Kv(
                            '本次下载',
                            _bytes(serverState.dlInfoData),
                          ),
                          _Kv(
                            '本次上传',
                            _bytes(serverState.upInfoData),
                          ),
                          _Kv(
                            '累计下载',
                            _bytes(serverState.alltimeDl),
                          ),
                          _Kv(
                            '累计上传',
                            _bytes(serverState.alltimeUl),
                          ),
                          _Kv('分享率', _ratio(serverState.globalRatio)),
                          _Kv(
                            '本次丢弃',
                            _bytes(serverState.totalWastedSession),
                          ),
                          _Kv(
                            '下载限速',
                            _rateLimit(serverState.dlRateLimit),
                          ),
                          _Kv(
                            '上传限速',
                            _rateLimit(serverState.upRateLimit),
                          ),
                          _Kv(
                            '备用限速',
                            _onOff(serverState.useAltSpeedLimits),
                          ),
                        ],
                      ),
                      _Section(
                        title: '磁盘与队列',
                        rows: [
                          _Kv(
                            '磁盘剩余',
                            _bytes(serverState.freeSpaceOnDisk),
                          ),
                          _Kv('种子排队', _onOff(serverState.queueing)),
                          _Kv(
                            '磁盘队列',
                            _count(serverState.queuedIoJobs),
                          ),
                          _Kv(
                            'Tracker 排队',
                            _count(serverState.queuedTrackerAnnounces),
                          ),
                          _Kv(
                            '待写入',
                            _bytes(serverState.totalQueuedSize),
                          ),
                          _Kv(
                            '队列等待',
                            _ms(serverState.averageTimeQueue),
                          ),
                        ],
                      ),
                      _Section(
                        title: '缓存',
                        rows: [
                          _Kv(
                            '缓存占用',
                            _bytes(serverState.totalBuffersSize),
                          ),
                          _Kv(
                            '读缓存命中',
                            _percent(serverState.readCacheHits),
                          ),
                          _Kv(
                            '读缓存过载',
                            _percent(serverState.readCacheOverload),
                          ),
                          _Kv(
                            '写缓存过载',
                            _percent(serverState.writeCacheOverload),
                          ),
                        ],
                      ),
                      _Section(
                        title: '应用',
                        rows: [
                          _Kv('应用版本', _text(activeServer?.appVersion)),
                          _Kv('API 版本', _text(activeServer?.apiVersion)),
                          _Kv('Qt', _text(buildInfo?.qt)),
                          _Kv('libtorrent', _text(buildInfo?.libtorrent)),
                          _Kv('Boost', _text(buildInfo?.boost)),
                          _Kv('OpenSSL', _text(buildInfo?.openssl)),
                          _Kv('zlib', _text(buildInfo?.zlib)),
                          _Kv('位数', _bitness(buildInfo?.bitness)),
                          _Kv('平台', _text(buildInfo?.platform)),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.rows});

  final String title;
  final List<_Kv> rows;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PageInsets.horizontal,
        8,
        PageInsets.horizontal,
        8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title,
              style: textTheme.titleSmall?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Material(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(children: rows),
            ),
          ),
        ],
      ),
    );
  }
}

class _Kv extends StatelessWidget {
  const _Kv(this.label, this.value, {this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: textTheme.bodyMedium?.copyWith(
                color: valueColor ?? scheme.onSurface,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
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

String _bytes(int? bytes) => formatBytes(bytes, fractionDigits: 2);

String _count(int? n) => n == null ? '—' : '$n';

String _ms(int? ms) => ms == null ? '—' : '$ms 毫秒';

String _onOff(bool? v) {
  if (v == null) return '—';
  return v ? '开' : '关';
}

String _rateLimit(int? bytesPerSec) {
  if (bytesPerSec == null || bytesPerSec <= 0) return '不限';
  return formatSpeed(bytesPerSec);
}

String _text(String? raw) {
  if (raw == null || raw.isEmpty) return '—';
  return raw;
}

String _bitness(int? bitness) {
  if (bitness == null || bitness <= 0) return '—';
  return '$bitness 位';
}

String _ratio(String? raw) {
  if (raw == null || raw.isEmpty || raw == '-') return '—';
  return raw;
}

String _percent(String? raw) {
  if (raw == null || raw.isEmpty || raw == '-') return '—';
  return raw.endsWith('%') ? raw : '$raw%';
}
