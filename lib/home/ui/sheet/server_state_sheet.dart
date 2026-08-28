import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/entity/response/app_build_info_response.dart';
import 'package:qbpanel/api/entity/response/connection_status.dart';
import 'package:qbpanel/home/home_page_view_model.dart';
import 'package:qbpanel/l10n/app_localizations.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
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
    final l10n = context.l10n;
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
            child: Text(l10n.homeServerStatus, style: textTheme.titleMedium),
          ),
          Flexible(
            child: serverState == null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Text(l10n.emptyNoData, textAlign: TextAlign.center),
                  )
                : ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 16),
                    children: [
                      _Section(
                        title: l10n.connection,
                        rows: [
                          _Kv(
                            l10n.ssConnectionStatus,
                            serverState.connectionStatus?.label(l10n) ??
                                '—',
                            valueColor: _connectionColor(
                              Theme.of(context).colorScheme,
                              serverState.connectionStatus,
                            ),
                          ),
                          _Kv(l10n.ssDhtNodes, _count(serverState.dhtNodes)),
                          _Kv(
                            l10n.ssPeerConnections,
                            _count(serverState.totalPeerConnections),
                          ),
                          _Kv(
                            l10n.ssExternalIpv4,
                            _text(serverState.lastExternalAddressV4),
                          ),
                          _Kv(
                            l10n.ssExternalIpv6,
                            _text(serverState.lastExternalAddressV6),
                          ),
                        ],
                      ),
                      _Section(
                        title: l10n.transfer,
                        rows: [
                          _Kv(
                            l10n.sortDownloadSpeed,
                            formatSpeed(serverState.dlInfoSpeed),
                          ),
                          _Kv(
                            l10n.sortUploadSpeed,
                            formatSpeed(serverState.upInfoSpeed),
                          ),
                          _Kv(
                            l10n.ssSessionDownload,
                            _bytes(serverState.dlInfoData),
                          ),
                          _Kv(
                            l10n.ssSessionUpload,
                            _bytes(serverState.upInfoData),
                          ),
                          _Kv(
                            l10n.ssAllTimeDownload,
                            _bytes(serverState.alltimeDl),
                          ),
                          _Kv(
                            l10n.ssAllTimeUpload,
                            _bytes(serverState.alltimeUl),
                          ),
                          _Kv(l10n.sortRatio, _ratio(serverState.globalRatio)),
                          _Kv(
                            l10n.ssSessionWasted,
                            _bytes(serverState.totalWastedSession),
                          ),
                          _Kv(
                            l10n.ssDlRateLimit,
                            _rateLimit(serverState.dlRateLimit, l10n),
                          ),
                          _Kv(
                            l10n.ssUpRateLimit,
                            _rateLimit(serverState.upRateLimit, l10n),
                          ),
                          _Kv(
                            l10n.ssAltSpeed,
                            _onOff(serverState.useAltSpeedLimits, l10n),
                          ),
                        ],
                      ),
                      _Section(
                        title: l10n.ssDiskAndQueue,
                        rows: [
                          _Kv(
                            l10n.ssFreeSpace,
                            _bytes(serverState.freeSpaceOnDisk),
                          ),
                          _Kv(
                            l10n.ssTorrentQueueing,
                            _onOff(serverState.queueing, l10n),
                          ),
                          _Kv(
                            l10n.ssDiskQueue,
                            _count(serverState.queuedIoJobs),
                          ),
                          _Kv(
                            l10n.ssTrackerQueue,
                            _count(serverState.queuedTrackerAnnounces),
                          ),
                          _Kv(
                            l10n.ssWritePending,
                            _bytes(serverState.totalQueuedSize),
                          ),
                          _Kv(
                            l10n.ssQueued,
                            _ms(serverState.averageTimeQueue, l10n),
                          ),
                        ],
                      ),
                      _Section(
                        title: l10n.ssCache,
                        rows: [
                          _Kv(
                            l10n.ssCacheUsed,
                            _bytes(serverState.totalBuffersSize),
                          ),
                          _Kv(
                            l10n.ssReadCacheHits,
                            _percent(serverState.readCacheHits),
                          ),
                          _Kv(
                            l10n.ssReadCacheOverload,
                            _percent(serverState.readCacheOverload),
                          ),
                          _Kv(
                            l10n.ssWriteCacheOverload,
                            _percent(serverState.writeCacheOverload),
                          ),
                        ],
                      ),
                      _Section(
                        title: l10n.application,
                        rows: [
                          _Kv(l10n.ssAppVersion, _text(activeServer?.appVersion)),
                          _Kv(l10n.ssApiVersion, _text(activeServer?.apiVersion)),
                          _Kv('Qt', _text(buildInfo?.qt)),
                          _Kv('libtorrent', _text(buildInfo?.libtorrent)),
                          _Kv('Boost', _text(buildInfo?.boost)),
                          _Kv('OpenSSL', _text(buildInfo?.openssl)),
                          _Kv('zlib', _text(buildInfo?.zlib)),
                          _Kv(l10n.ssBitness, _bitness(buildInfo?.bitness, l10n)),
                          _Kv(l10n.ssPlatform, _text(buildInfo?.platform)),
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

String _ms(int? ms, AppLocalizations l10n) =>
    ms == null ? '—' : l10n.milliseconds(ms);

String _onOff(bool? v, AppLocalizations l10n) {
  if (v == null) return '—';
  return v ? l10n.onLabel : l10n.offLabel;
}

String _rateLimit(int? bytesPerSec, AppLocalizations l10n) {
  if (bytesPerSec == null || bytesPerSec <= 0) return l10n.unlimitedSpeed;
  return formatSpeed(bytesPerSec);
}

String _text(String? raw) {
  if (raw == null || raw.isEmpty) return '—';
  return raw;
}

String _bitness(int? bitness, AppLocalizations l10n) {
  if (bitness == null || bitness <= 0) return '—';
  return l10n.bitnessValue(bitness);
}

String _ratio(String? raw) {
  if (raw == null || raw.isEmpty || raw == '-') return '—';
  return raw;
}

String _percent(String? raw) {
  if (raw == null || raw.isEmpty || raw == '-') return '—';
  return raw.endsWith('%') ? raw : '$raw%';
}
