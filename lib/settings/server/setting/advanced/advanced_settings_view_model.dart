import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/entity/response/app_preferences_response.dart';
import 'package:qbpanel/api/entity/response/network_interface_item.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/settings/server/setting/advanced/advanced_settings_ui_state.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

final advancedSettingsProvider =
    NotifierProvider<AdvancedSettingsViewModel, AdvancedSettingsUiState>(
  AdvancedSettingsViewModel.new,
);

class AdvancedSettingsViewModel extends Notifier<AdvancedSettingsUiState> {
  @override
  AdvancedSettingsUiState build() => const AdvancedSettingsUiState();

  Future<bool> load() async {
    state = state.copyWith(emptyState: const EmptyState.loading());
    String? error;
    AppPreferencesResponse? prefs;
    await ref
        .read(apiClientProvider)
        .get(
          ApiPath.application.preferences,
          parser: jsonParser(AppPreferencesResponse.fromJson),
        )
        .onSuccess((data) => prefs = data)
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });

    if (prefs == null) {
      state = state.copyWith(
        emptyState: EmptyState.error(error ?? ref.read(appLocalizationsProvider).loadSettingsFailed),
      );
      return false;
    }

    final data = prefs!;
    final iface = data.currentNetworkInterface ?? '';
    final interfaces = await _fetchNetworkInterfaces(
      iface: iface,
      ifaceName: data.currentInterfaceName,
    );
    final addresses = await _fetchInterfaceAddresses(iface);

    state = state.copyWith(
      emptyState: const EmptyState.content(),
      networkInterfaces: interfaces,
      interfaceAddresses: addresses,
      resumeDataStorageType:
          AdvancedResumeDataStorage.fromApi(data.resumeDataStorageType),
      torrentContentRemoveOption:
          AdvancedTorrentRemoveOption.fromApi(data.torrentContentRemoveOption),
      memoryWorkingSetLimit: data.memoryWorkingSetLimit ?? 512,
      currentNetworkInterface: iface,
      currentInterfaceAddress: data.currentInterfaceAddress ?? '',
      saveResumeDataInterval: data.saveResumeDataInterval ?? 60,
      saveStatisticsInterval: data.saveStatisticsInterval ?? 15,
      torrentFileSizeLimitMib: _bytesToMib(data.torrentFileSizeLimit, 100),
      confirmTorrentRecheck: data.confirmTorrentRecheck ?? true,
      recheckCompletedTorrents: data.recheckCompletedTorrents ?? false,
      appInstanceName: data.appInstanceName ?? '',
      refreshInterval: data.refreshInterval ?? 1500,
      resolvePeerHostNames: data.resolvePeerHostNames ?? false,
      resolvePeerCountries: data.resolvePeerCountries ?? true,
      reannounceWhenAddressChanged:
          data.reannounceWhenAddressChanged ?? false,
      enableEmbeddedTracker: data.enableEmbeddedTracker ?? false,
      embeddedTrackerPort: data.embeddedTrackerPort ?? 9000,
      embeddedTrackerPortForwarding:
          data.embeddedTrackerPortForwarding ?? false,
      markOfTheWeb: data.markOfTheWeb ?? true,
      ignoreSslErrors: data.ignoreSslErrors ?? false,
      pythonExecutablePath: data.pythonExecutablePath ?? '',
      bdecodeDepthLimit: data.bdecodeDepthLimit ?? 100,
      bdecodeTokenLimit: data.bdecodeTokenLimit ?? 10000000,
      asyncIoThreads: data.asyncIoThreads ?? 10,
      hashingThreads: data.hashingThreads ?? 1,
      filePoolSize: data.filePoolSize ?? 100,
      checkingMemoryUse: data.checkingMemoryUse ?? 32,
      diskCache: data.diskCache ?? -1,
      diskCacheTtl: data.diskCacheTtl ?? 60,
      diskQueueSizeKib: _bytesToKib(data.diskQueueSize, 1024),
      diskIoType: AdvancedDiskIoType.fromApi(data.diskIoType),
      diskIoReadMode: AdvancedDiskIoCacheMode.fromApi(data.diskIoReadMode),
      diskIoWriteMode: AdvancedDiskIoWriteMode.fromApi(data.diskIoWriteMode),
      enableCoalesceReadWrite: data.enableCoalesceReadWrite ?? false,
      enablePieceExtentAffinity: data.enablePieceExtentAffinity ?? false,
      enableUploadSuggestions: data.enableUploadSuggestions ?? false,
      sendBufferWatermark: data.sendBufferWatermark ?? 500,
      sendBufferLowWatermark: data.sendBufferLowWatermark ?? 10,
      sendBufferWatermarkFactor: data.sendBufferWatermarkFactor ?? 50,
      connectionSpeed: data.connectionSpeed ?? 30,
      seedingOutgoingConnections: data.seedingOutgoingConnections ?? false,
      socketSendBufferSizeKib: _bytesToKib(data.socketSendBufferSize, 0),
      socketReceiveBufferSizeKib:
          _bytesToKib(data.socketReceiveBufferSize, 0),
      socketBacklogSize: data.socketBacklogSize ?? 30,
      outgoingPortsMin: data.outgoingPortsMin ?? 0,
      outgoingPortsMax: data.outgoingPortsMax ?? 0,
      upnpLeaseDuration: data.upnpLeaseDuration ?? 0,
      peerTos: data.peerTos ?? 1,
      utpTcpMixedMode: AdvancedUtpTcpMixedMode.fromApi(data.utpTcpMixedMode),
      hostnameCacheTtl: data.hostnameCacheTtl ?? 1200,
      idnSupportEnabled: data.idnSupportEnabled ?? false,
      enableMultiConnectionsFromSameIp:
          data.enableMultiConnectionsFromSameIp ?? false,
      enableMultiConnectionsFromSamePeerId:
          data.enableMultiConnectionsFromSamePeerId ?? false,
      validateHttpsTrackerCertificate:
          data.validateHttpsTrackerCertificate ?? true,
      ssrfMitigation: data.ssrfMitigation ?? true,
      blockPeersOnPrivilegedPorts:
          data.blockPeersOnPrivilegedPorts ?? false,
      uploadSlotsBehavior:
          AdvancedUploadSlotsBehavior.fromApi(data.uploadSlotsBehavior),
      uploadChokingAlgorithm:
          AdvancedUploadChokingAlgorithm.fromApi(data.uploadChokingAlgorithm),
      announceToAllTrackers: data.announceToAllTrackers ?? false,
      announceToAllTiers: data.announceToAllTiers ?? true,
      announceIp: data.announceIp ?? '',
      announcePort: data.announcePort ?? 0,
      maxConcurrentHttpAnnounces: data.maxConcurrentHttpAnnounces ?? 50,
      stopTrackerTimeout: data.stopTrackerTimeout ?? 2,
      peerTurnover: data.peerTurnover ?? 4,
      peerTurnoverCutoff: data.peerTurnoverCutoff ?? 90,
      peerTurnoverInterval: data.peerTurnoverInterval ?? 300,
      requestQueueSize: data.requestQueueSize ?? 500,
      maxOutstandingBlockRequests: data.maxOutstandingBlockRequests ?? 0,
      dhtBootstrapNodes: data.dhtBootstrapNodes ??
          'dht.libtorrent.org:25401, dht.transmissionbt.com:6881, router.bittorrent.com:6881',
      i2pInboundQuantity: data.i2pInboundQuantity ?? 3,
      i2pOutboundQuantity: data.i2pOutboundQuantity ?? 3,
      i2pInboundLength: data.i2pInboundLength ?? 3,
      i2pOutboundLength: data.i2pOutboundLength ?? 3,
    );
    return true;
  }

  Future<void> setCurrentNetworkInterface(String value) async {
    state = state.copyWith(
      currentNetworkInterface: value,
      currentInterfaceAddress: '',
    );
    final addresses = await _fetchInterfaceAddresses(value);
    state = state.copyWith(interfaceAddresses: addresses);
  }

  void setCurrentInterfaceAddress(String value) {
    state = state.copyWith(currentInterfaceAddress: value);
  }

  void setResumeDataStorageType(AdvancedResumeDataStorage value) {
    state = state.copyWith(resumeDataStorageType: value);
  }

  void setTorrentContentRemoveOption(AdvancedTorrentRemoveOption value) {
    state = state.copyWith(torrentContentRemoveOption: value);
  }

  void setConfirmTorrentRecheck(bool value) {
    state = state.copyWith(confirmTorrentRecheck: value);
  }

  void setRecheckCompletedTorrents(bool value) {
    state = state.copyWith(recheckCompletedTorrents: value);
  }

  void setResolvePeerHostNames(bool value) {
    state = state.copyWith(resolvePeerHostNames: value);
  }

  void setResolvePeerCountries(bool value) {
    state = state.copyWith(resolvePeerCountries: value);
  }

  void setReannounceWhenAddressChanged(bool value) {
    state = state.copyWith(reannounceWhenAddressChanged: value);
  }

  void setEnableEmbeddedTracker(bool value) {
    state = state.copyWith(enableEmbeddedTracker: value);
  }

  void setEmbeddedTrackerPortForwarding(bool value) {
    state = state.copyWith(embeddedTrackerPortForwarding: value);
  }

  void setMarkOfTheWeb(bool value) {
    state = state.copyWith(markOfTheWeb: value);
  }

  void setIgnoreSslErrors(bool value) {
    state = state.copyWith(ignoreSslErrors: value);
  }

  void setEnableCoalesceReadWrite(bool value) {
    state = state.copyWith(enableCoalesceReadWrite: value);
  }

  void setEnablePieceExtentAffinity(bool value) {
    state = state.copyWith(enablePieceExtentAffinity: value);
  }

  void setEnableUploadSuggestions(bool value) {
    state = state.copyWith(enableUploadSuggestions: value);
  }

  void setSeedingOutgoingConnections(bool value) {
    state = state.copyWith(seedingOutgoingConnections: value);
  }

  void setIdnSupportEnabled(bool value) {
    state = state.copyWith(idnSupportEnabled: value);
  }

  void setEnableMultiConnectionsFromSameIp(bool value) {
    state = state.copyWith(enableMultiConnectionsFromSameIp: value);
  }

  void setEnableMultiConnectionsFromSamePeerId(bool value) {
    state = state.copyWith(enableMultiConnectionsFromSamePeerId: value);
  }

  void setValidateHttpsTrackerCertificate(bool value) {
    state = state.copyWith(validateHttpsTrackerCertificate: value);
  }

  void setSsrfMitigation(bool value) {
    state = state.copyWith(ssrfMitigation: value);
  }

  void setBlockPeersOnPrivilegedPorts(bool value) {
    state = state.copyWith(blockPeersOnPrivilegedPorts: value);
  }

  void setAnnounceToAllTrackers(bool value) {
    state = state.copyWith(announceToAllTrackers: value);
  }

  void setAnnounceToAllTiers(bool value) {
    state = state.copyWith(announceToAllTiers: value);
  }

  void setDiskIoType(AdvancedDiskIoType value) {
    state = state.copyWith(diskIoType: value);
  }

  void setDiskIoReadMode(AdvancedDiskIoCacheMode value) {
    state = state.copyWith(diskIoReadMode: value);
  }

  void setDiskIoWriteMode(AdvancedDiskIoWriteMode value) {
    state = state.copyWith(diskIoWriteMode: value);
  }

  void setUtpTcpMixedMode(AdvancedUtpTcpMixedMode value) {
    state = state.copyWith(utpTcpMixedMode: value);
  }

  void setUploadSlotsBehavior(AdvancedUploadSlotsBehavior value) {
    state = state.copyWith(uploadSlotsBehavior: value);
  }

  void setUploadChokingAlgorithm(AdvancedUploadChokingAlgorithm value) {
    state = state.copyWith(uploadChokingAlgorithm: value);
  }

  void applyTextAndNumbers({
    required int memoryWorkingSetLimit,
    required int saveResumeDataInterval,
    required int saveStatisticsInterval,
    required int torrentFileSizeLimitMib,
    required String appInstanceName,
    required int refreshInterval,
    required int embeddedTrackerPort,
    required String pythonExecutablePath,
    required int bdecodeDepthLimit,
    required int bdecodeTokenLimit,
    required int asyncIoThreads,
    required int hashingThreads,
    required int filePoolSize,
    required int checkingMemoryUse,
    required int diskCache,
    required int diskCacheTtl,
    required int diskQueueSizeKib,
    required int sendBufferWatermark,
    required int sendBufferLowWatermark,
    required int sendBufferWatermarkFactor,
    required int connectionSpeed,
    required int socketSendBufferSizeKib,
    required int socketReceiveBufferSizeKib,
    required int socketBacklogSize,
    required int outgoingPortsMin,
    required int outgoingPortsMax,
    required int upnpLeaseDuration,
    required int peerTos,
    required int hostnameCacheTtl,
    required String announceIp,
    required int announcePort,
    required int maxConcurrentHttpAnnounces,
    required int stopTrackerTimeout,
    required int peerTurnover,
    required int peerTurnoverCutoff,
    required int peerTurnoverInterval,
    required int requestQueueSize,
    required int maxOutstandingBlockRequests,
    required String dhtBootstrapNodes,
    required int i2pInboundQuantity,
    required int i2pOutboundQuantity,
    required int i2pInboundLength,
    required int i2pOutboundLength,
  }) {
    state = state.copyWith(
      memoryWorkingSetLimit: memoryWorkingSetLimit,
      saveResumeDataInterval: saveResumeDataInterval,
      saveStatisticsInterval: saveStatisticsInterval,
      torrentFileSizeLimitMib: torrentFileSizeLimitMib,
      appInstanceName: appInstanceName,
      refreshInterval: refreshInterval,
      embeddedTrackerPort: embeddedTrackerPort,
      pythonExecutablePath: pythonExecutablePath,
      bdecodeDepthLimit: bdecodeDepthLimit,
      bdecodeTokenLimit: bdecodeTokenLimit,
      asyncIoThreads: asyncIoThreads,
      hashingThreads: hashingThreads,
      filePoolSize: filePoolSize,
      checkingMemoryUse: checkingMemoryUse,
      diskCache: diskCache,
      diskCacheTtl: diskCacheTtl,
      diskQueueSizeKib: diskQueueSizeKib,
      sendBufferWatermark: sendBufferWatermark,
      sendBufferLowWatermark: sendBufferLowWatermark,
      sendBufferWatermarkFactor: sendBufferWatermarkFactor,
      connectionSpeed: connectionSpeed,
      socketSendBufferSizeKib: socketSendBufferSizeKib,
      socketReceiveBufferSizeKib: socketReceiveBufferSizeKib,
      socketBacklogSize: socketBacklogSize,
      outgoingPortsMin: outgoingPortsMin,
      outgoingPortsMax: outgoingPortsMax,
      upnpLeaseDuration: upnpLeaseDuration,
      peerTos: peerTos,
      hostnameCacheTtl: hostnameCacheTtl,
      announceIp: announceIp,
      announcePort: announcePort,
      maxConcurrentHttpAnnounces: maxConcurrentHttpAnnounces,
      stopTrackerTimeout: stopTrackerTimeout,
      peerTurnover: peerTurnover,
      peerTurnoverCutoff: peerTurnoverCutoff,
      peerTurnoverInterval: peerTurnoverInterval,
      requestQueueSize: requestQueueSize,
      maxOutstandingBlockRequests: maxOutstandingBlockRequests,
      dhtBootstrapNodes: dhtBootstrapNodes,
      i2pInboundQuantity: i2pInboundQuantity,
      i2pOutboundQuantity: i2pOutboundQuantity,
      i2pInboundLength: i2pInboundLength,
      i2pOutboundLength: i2pOutboundLength,
    );
  }

  Future<String?> save() async {
    if (state.saving) return null;

    if (state.checkingMemoryUse <= 0 || state.checkingMemoryUse > 1024) {
      return ref.read(appLocalizationsProvider).invalidCheckingMemory;
    }
    if (state.peerTos < 0 || state.peerTos > 255) {
      return ref.read(appLocalizationsProvider).invalidPeerDscp;
    }
    if (state.announcePort < 0 || state.announcePort > 65535) {
      return ref.read(appLocalizationsProvider).invalidAnnouncePort;
    }
    if (state.peerTurnover < 0 || state.peerTurnover > 100) {
      return ref.read(appLocalizationsProvider).invalidPeerTurnover;
    }
    if (state.peerTurnoverCutoff < 0 || state.peerTurnoverCutoff > 100) {
      return ref.read(appLocalizationsProvider).invalidPeerTurnoverCutoff;
    }
    if (state.peerTurnoverInterval < 0 || state.peerTurnoverInterval > 3600) {
      return ref.read(appLocalizationsProvider).invalidPeerTurnoverInterval;
    }

    final pyPath = state.pythonExecutablePath;
    if (pyPath.isNotEmpty &&
        (pyPath.startsWith('"') ||
            pyPath.startsWith("'") ||
            pyPath.endsWith('"') ||
            pyPath.endsWith("'"))) {
      return ref.read(appLocalizationsProvider).pythonPathNoQuotes;
    }

    state = state.copyWith(saving: true);
    final payload = <String, dynamic>{
      'resume_data_storage_type': state.resumeDataStorageType.apiValue,
      'torrent_content_remove_option': state.torrentContentRemoveOption.apiValue,
      'memory_working_set_limit': state.memoryWorkingSetLimit,
      'current_network_interface': state.currentNetworkInterface,
      'current_interface_address': state.currentInterfaceAddress,
      'save_resume_data_interval': state.saveResumeDataInterval,
      'save_statistics_interval': state.saveStatisticsInterval,
      'torrent_file_size_limit':
          state.torrentFileSizeLimitMib * 1024 * 1024,
      'confirm_torrent_recheck': state.confirmTorrentRecheck,
      'recheck_completed_torrents': state.recheckCompletedTorrents,
      'app_instance_name': state.appInstanceName.trim(),
      'refresh_interval': state.refreshInterval,
      'resolve_peer_host_names': state.resolvePeerHostNames,
      'resolve_peer_countries': state.resolvePeerCountries,
      'reannounce_when_address_changed': state.reannounceWhenAddressChanged,
      'enable_embedded_tracker': state.enableEmbeddedTracker,
      'embedded_tracker_port': state.embeddedTrackerPort,
      'embedded_tracker_port_forwarding': state.embeddedTrackerPortForwarding,
      'mark_of_the_web': state.markOfTheWeb,
      'ignore_ssl_errors': state.ignoreSslErrors,
      'python_executable_path': pyPath,
      'bdecode_depth_limit': state.bdecodeDepthLimit,
      'bdecode_token_limit': state.bdecodeTokenLimit,
      'async_io_threads': state.asyncIoThreads,
      'hashing_threads': state.hashingThreads,
      'file_pool_size': state.filePoolSize,
      'checking_memory_use': state.checkingMemoryUse,
      'disk_cache': state.diskCache,
      'disk_cache_ttl': state.diskCacheTtl,
      'disk_queue_size': state.diskQueueSizeKib * 1024,
      'disk_io_type': state.diskIoType.apiValue,
      'disk_io_read_mode': state.diskIoReadMode.apiValue,
      'disk_io_write_mode': state.diskIoWriteMode.apiValue,
      'enable_coalesce_read_write': state.enableCoalesceReadWrite,
      'enable_piece_extent_affinity': state.enablePieceExtentAffinity,
      'enable_upload_suggestions': state.enableUploadSuggestions,
      'send_buffer_watermark': state.sendBufferWatermark,
      'send_buffer_low_watermark': state.sendBufferLowWatermark,
      'send_buffer_watermark_factor': state.sendBufferWatermarkFactor,
      'connection_speed': state.connectionSpeed,
      'seeding_outgoing_connections': state.seedingOutgoingConnections,
      'socket_send_buffer_size': state.socketSendBufferSizeKib * 1024,
      'socket_receive_buffer_size': state.socketReceiveBufferSizeKib * 1024,
      'socket_backlog_size': state.socketBacklogSize,
      'outgoing_ports_min': state.outgoingPortsMin,
      'outgoing_ports_max': state.outgoingPortsMax,
      'upnp_lease_duration': state.upnpLeaseDuration,
      'peer_tos': state.peerTos,
      'utp_tcp_mixed_mode': state.utpTcpMixedMode.apiValue,
      'hostname_cache_ttl': state.hostnameCacheTtl,
      'idn_support_enabled': state.idnSupportEnabled,
      'enable_multi_connections_from_same_ip':
          state.enableMultiConnectionsFromSameIp,
      'enable_multi_connections_from_same_peer_id':
          state.enableMultiConnectionsFromSamePeerId,
      'validate_https_tracker_certificate':
          state.validateHttpsTrackerCertificate,
      'ssrf_mitigation': state.ssrfMitigation,
      'block_peers_on_privileged_ports': state.blockPeersOnPrivilegedPorts,
      'upload_slots_behavior': state.uploadSlotsBehavior.apiValue,
      'upload_choking_algorithm': state.uploadChokingAlgorithm.apiValue,
      'announce_to_all_trackers': state.announceToAllTrackers,
      'announce_to_all_tiers': state.announceToAllTiers,
      'announce_ip': state.announceIp.trim(),
      'announce_port': state.announcePort,
      'max_concurrent_http_announces': state.maxConcurrentHttpAnnounces,
      'stop_tracker_timeout': state.stopTrackerTimeout,
      'peer_turnover': state.peerTurnover,
      'peer_turnover_cutoff': state.peerTurnoverCutoff,
      'peer_turnover_interval': state.peerTurnoverInterval,
      'request_queue_size': state.requestQueueSize,
      'max_outstanding_block_requests': state.maxOutstandingBlockRequests,
      'dht_bootstrap_nodes': state.dhtBootstrapNodes,
      'i2p_inbound_quantity': state.i2pInboundQuantity,
      'i2p_outbound_quantity': state.i2pOutboundQuantity,
      'i2p_inbound_length': state.i2pInboundLength,
      'i2p_outbound_length': state.i2pOutboundLength,
    };

    String? error;
    await ref
        .read(apiClientProvider)
        .post(
          ApiPath.application.setPreferences,
          data: {'json': jsonEncode(payload)},
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });

    state = state.copyWith(saving: false);
    return error;
  }

  Future<List<NetworkInterfaceItem>> _fetchNetworkInterfaces({
    required String iface,
    String? ifaceName,
  }) async {
    List<NetworkInterfaceItem>? items;
    await ref
        .read(apiClientProvider)
        .get(
          ApiPath.application.networkInterfaceList,
          parser: _parseNetworkInterfaces,
        )
        .onSuccess((data) => items = data);

    final list = List<NetworkInterfaceItem>.from(items ?? const []);
    if (iface.isNotEmpty && !list.any((e) => e.value == iface)) {
      list.add(
        NetworkInterfaceItem(
          name: (ifaceName?.isNotEmpty ?? false) ? ifaceName! : iface,
          value: iface,
        ),
      );
    }
    return list;
  }

  Future<List<String>> _fetchInterfaceAddresses(String iface) async {
    List<String>? items;
    await ref
        .read(apiClientProvider)
        .get(
          ApiPath.application.networkInterfaceAddressList,
          queryParameters: {'iface': iface},
          parser: _parseAddressList,
        )
        .onSuccess((data) => items = data);
    return items ?? const [];
  }

  static List<NetworkInterfaceItem> _parseNetworkInterfaces(dynamic data) {
    if (data is! List) return const [];
    return data
        .map((e) => NetworkInterfaceItem.fromJson(
              Map<String, dynamic>.from(e as Map),
            ))
        .toList();
  }

  static List<String> _parseAddressList(dynamic data) {
    if (data is! List) return const [];
    return data.map((e) => e.toString()).toList();
  }

  static int _bytesToMib(int? bytes, int fallback) {
    if (bytes == null || bytes <= 0) return fallback;
    return (bytes / (1024 * 1024)).round();
  }

  static int _bytesToKib(int? bytes, int fallback) {
    if (bytes == null || bytes <= 0) return fallback;
    return (bytes / 1024).round();
  }
}
