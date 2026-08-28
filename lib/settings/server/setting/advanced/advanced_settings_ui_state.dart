import 'package:qbpanel/api/entity/response/network_interface_item.dart';
import 'package:qbpanel/l10n/app_localizations.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

/// WebUI「高级」页状态。
class AdvancedSettingsUiState {
  const AdvancedSettingsUiState({
    this.emptyState = const EmptyState.content(),
    this.saving = false,
    this.networkInterfaces = const [],
    this.interfaceAddresses = const [],
    this.resumeDataStorageType = AdvancedResumeDataStorage.legacy,
    this.torrentContentRemoveOption = AdvancedTorrentRemoveOption.delete,
    this.memoryWorkingSetLimit = 512,
    this.currentNetworkInterface = '',
    this.currentInterfaceAddress = '',
    this.saveResumeDataInterval = 60,
    this.saveStatisticsInterval = 15,
    this.torrentFileSizeLimitMib = 100,
    this.confirmTorrentRecheck = true,
    this.recheckCompletedTorrents = false,
    this.appInstanceName = '',
    this.refreshInterval = 1500,
    this.resolvePeerHostNames = false,
    this.resolvePeerCountries = true,
    this.reannounceWhenAddressChanged = false,
    this.enableEmbeddedTracker = false,
    this.embeddedTrackerPort = 9000,
    this.embeddedTrackerPortForwarding = false,
    this.markOfTheWeb = true,
    this.ignoreSslErrors = false,
    this.pythonExecutablePath = '',
    this.bdecodeDepthLimit = 100,
    this.bdecodeTokenLimit = 10000000,
    this.asyncIoThreads = 10,
    this.hashingThreads = 1,
    this.filePoolSize = 100,
    this.checkingMemoryUse = 32,
    this.diskCache = -1,
    this.diskCacheTtl = 60,
    this.diskQueueSizeKib = 1024,
    this.diskIoType = AdvancedDiskIoType.defaultType,
    this.diskIoReadMode = AdvancedDiskIoCacheMode.enableOsCache,
    this.diskIoWriteMode = AdvancedDiskIoWriteMode.enableOsCache,
    this.enableCoalesceReadWrite = false,
    this.enablePieceExtentAffinity = false,
    this.enableUploadSuggestions = false,
    this.sendBufferWatermark = 500,
    this.sendBufferLowWatermark = 10,
    this.sendBufferWatermarkFactor = 50,
    this.connectionSpeed = 30,
    this.seedingOutgoingConnections = false,
    this.socketSendBufferSizeKib = 0,
    this.socketReceiveBufferSizeKib = 0,
    this.socketBacklogSize = 30,
    this.outgoingPortsMin = 0,
    this.outgoingPortsMax = 0,
    this.upnpLeaseDuration = 0,
    this.peerTos = 1,
    this.utpTcpMixedMode = AdvancedUtpTcpMixedMode.preferTcp,
    this.hostnameCacheTtl = 1200,
    this.idnSupportEnabled = false,
    this.enableMultiConnectionsFromSameIp = false,
    this.enableMultiConnectionsFromSamePeerId = false,
    this.validateHttpsTrackerCertificate = true,
    this.ssrfMitigation = true,
    this.blockPeersOnPrivilegedPorts = false,
    this.uploadSlotsBehavior = AdvancedUploadSlotsBehavior.fixedSlots,
    this.uploadChokingAlgorithm = AdvancedUploadChokingAlgorithm.fastestUpload,
    this.announceToAllTrackers = false,
    this.announceToAllTiers = true,
    this.announceIp = '',
    this.announcePort = 0,
    this.maxConcurrentHttpAnnounces = 50,
    this.stopTrackerTimeout = 2,
    this.peerTurnover = 4,
    this.peerTurnoverCutoff = 90,
    this.peerTurnoverInterval = 300,
    this.requestQueueSize = 500,
    this.maxOutstandingBlockRequests = 0,
    this.dhtBootstrapNodes =
        'dht.libtorrent.org:25401, dht.transmissionbt.com:6881, router.bittorrent.com:6881',
    this.i2pInboundQuantity = 3,
    this.i2pOutboundQuantity = 3,
    this.i2pInboundLength = 3,
    this.i2pOutboundLength = 3,
  });

  final EmptyState emptyState;
  final bool saving;

  final List<NetworkInterfaceItem> networkInterfaces;
  final List<String> interfaceAddresses;

  final AdvancedResumeDataStorage resumeDataStorageType;
  final AdvancedTorrentRemoveOption torrentContentRemoveOption;
  final int memoryWorkingSetLimit;
  final String currentNetworkInterface;
  final String currentInterfaceAddress;
  final int saveResumeDataInterval;
  final int saveStatisticsInterval;
  final int torrentFileSizeLimitMib;
  final bool confirmTorrentRecheck;
  final bool recheckCompletedTorrents;
  final String appInstanceName;
  final int refreshInterval;
  final bool resolvePeerHostNames;
  final bool resolvePeerCountries;
  final bool reannounceWhenAddressChanged;
  final bool enableEmbeddedTracker;
  final int embeddedTrackerPort;
  final bool embeddedTrackerPortForwarding;
  final bool markOfTheWeb;
  final bool ignoreSslErrors;
  final String pythonExecutablePath;

  final int bdecodeDepthLimit;
  final int bdecodeTokenLimit;
  final int asyncIoThreads;
  final int hashingThreads;
  final int filePoolSize;
  final int checkingMemoryUse;
  final int diskCache;
  final int diskCacheTtl;
  final int diskQueueSizeKib;
  final AdvancedDiskIoType diskIoType;
  final AdvancedDiskIoCacheMode diskIoReadMode;
  final AdvancedDiskIoWriteMode diskIoWriteMode;
  final bool enableCoalesceReadWrite;
  final bool enablePieceExtentAffinity;
  final bool enableUploadSuggestions;
  final int sendBufferWatermark;
  final int sendBufferLowWatermark;
  final int sendBufferWatermarkFactor;
  final int connectionSpeed;
  final bool seedingOutgoingConnections;
  final int socketSendBufferSizeKib;
  final int socketReceiveBufferSizeKib;
  final int socketBacklogSize;
  final int outgoingPortsMin;
  final int outgoingPortsMax;
  final int upnpLeaseDuration;
  final int peerTos;
  final AdvancedUtpTcpMixedMode utpTcpMixedMode;
  final int hostnameCacheTtl;
  final bool idnSupportEnabled;
  final bool enableMultiConnectionsFromSameIp;
  final bool enableMultiConnectionsFromSamePeerId;
  final bool validateHttpsTrackerCertificate;
  final bool ssrfMitigation;
  final bool blockPeersOnPrivilegedPorts;
  final AdvancedUploadSlotsBehavior uploadSlotsBehavior;
  final AdvancedUploadChokingAlgorithm uploadChokingAlgorithm;
  final bool announceToAllTrackers;
  final bool announceToAllTiers;
  final String announceIp;
  final int announcePort;
  final int maxConcurrentHttpAnnounces;
  final int stopTrackerTimeout;
  final int peerTurnover;
  final int peerTurnoverCutoff;
  final int peerTurnoverInterval;
  final int requestQueueSize;
  final int maxOutstandingBlockRequests;
  final String dhtBootstrapNodes;
  final int i2pInboundQuantity;
  final int i2pOutboundQuantity;
  final int i2pInboundLength;
  final int i2pOutboundLength;

  bool get ready => emptyState.ready;

  AdvancedSettingsUiState copyWith({
    EmptyState? emptyState,
    bool? saving,
    List<NetworkInterfaceItem>? networkInterfaces,
    List<String>? interfaceAddresses,
    AdvancedResumeDataStorage? resumeDataStorageType,
    AdvancedTorrentRemoveOption? torrentContentRemoveOption,
    int? memoryWorkingSetLimit,
    String? currentNetworkInterface,
    String? currentInterfaceAddress,
    int? saveResumeDataInterval,
    int? saveStatisticsInterval,
    int? torrentFileSizeLimitMib,
    bool? confirmTorrentRecheck,
    bool? recheckCompletedTorrents,
    String? appInstanceName,
    int? refreshInterval,
    bool? resolvePeerHostNames,
    bool? resolvePeerCountries,
    bool? reannounceWhenAddressChanged,
    bool? enableEmbeddedTracker,
    int? embeddedTrackerPort,
    bool? embeddedTrackerPortForwarding,
    bool? markOfTheWeb,
    bool? ignoreSslErrors,
    String? pythonExecutablePath,
    int? bdecodeDepthLimit,
    int? bdecodeTokenLimit,
    int? asyncIoThreads,
    int? hashingThreads,
    int? filePoolSize,
    int? checkingMemoryUse,
    int? diskCache,
    int? diskCacheTtl,
    int? diskQueueSizeKib,
    AdvancedDiskIoType? diskIoType,
    AdvancedDiskIoCacheMode? diskIoReadMode,
    AdvancedDiskIoWriteMode? diskIoWriteMode,
    bool? enableCoalesceReadWrite,
    bool? enablePieceExtentAffinity,
    bool? enableUploadSuggestions,
    int? sendBufferWatermark,
    int? sendBufferLowWatermark,
    int? sendBufferWatermarkFactor,
    int? connectionSpeed,
    bool? seedingOutgoingConnections,
    int? socketSendBufferSizeKib,
    int? socketReceiveBufferSizeKib,
    int? socketBacklogSize,
    int? outgoingPortsMin,
    int? outgoingPortsMax,
    int? upnpLeaseDuration,
    int? peerTos,
    AdvancedUtpTcpMixedMode? utpTcpMixedMode,
    int? hostnameCacheTtl,
    bool? idnSupportEnabled,
    bool? enableMultiConnectionsFromSameIp,
    bool? enableMultiConnectionsFromSamePeerId,
    bool? validateHttpsTrackerCertificate,
    bool? ssrfMitigation,
    bool? blockPeersOnPrivilegedPorts,
    AdvancedUploadSlotsBehavior? uploadSlotsBehavior,
    AdvancedUploadChokingAlgorithm? uploadChokingAlgorithm,
    bool? announceToAllTrackers,
    bool? announceToAllTiers,
    String? announceIp,
    int? announcePort,
    int? maxConcurrentHttpAnnounces,
    int? stopTrackerTimeout,
    int? peerTurnover,
    int? peerTurnoverCutoff,
    int? peerTurnoverInterval,
    int? requestQueueSize,
    int? maxOutstandingBlockRequests,
    String? dhtBootstrapNodes,
    int? i2pInboundQuantity,
    int? i2pOutboundQuantity,
    int? i2pInboundLength,
    int? i2pOutboundLength,
  }) {
    return AdvancedSettingsUiState(
      emptyState: emptyState ?? this.emptyState,
      saving: saving ?? this.saving,
      networkInterfaces: networkInterfaces ?? this.networkInterfaces,
      interfaceAddresses: interfaceAddresses ?? this.interfaceAddresses,
      resumeDataStorageType:
          resumeDataStorageType ?? this.resumeDataStorageType,
      torrentContentRemoveOption:
          torrentContentRemoveOption ?? this.torrentContentRemoveOption,
      memoryWorkingSetLimit:
          memoryWorkingSetLimit ?? this.memoryWorkingSetLimit,
      currentNetworkInterface:
          currentNetworkInterface ?? this.currentNetworkInterface,
      currentInterfaceAddress:
          currentInterfaceAddress ?? this.currentInterfaceAddress,
      saveResumeDataInterval:
          saveResumeDataInterval ?? this.saveResumeDataInterval,
      saveStatisticsInterval:
          saveStatisticsInterval ?? this.saveStatisticsInterval,
      torrentFileSizeLimitMib:
          torrentFileSizeLimitMib ?? this.torrentFileSizeLimitMib,
      confirmTorrentRecheck:
          confirmTorrentRecheck ?? this.confirmTorrentRecheck,
      recheckCompletedTorrents:
          recheckCompletedTorrents ?? this.recheckCompletedTorrents,
      appInstanceName: appInstanceName ?? this.appInstanceName,
      refreshInterval: refreshInterval ?? this.refreshInterval,
      resolvePeerHostNames:
          resolvePeerHostNames ?? this.resolvePeerHostNames,
      resolvePeerCountries:
          resolvePeerCountries ?? this.resolvePeerCountries,
      reannounceWhenAddressChanged: reannounceWhenAddressChanged ??
          this.reannounceWhenAddressChanged,
      enableEmbeddedTracker:
          enableEmbeddedTracker ?? this.enableEmbeddedTracker,
      embeddedTrackerPort: embeddedTrackerPort ?? this.embeddedTrackerPort,
      embeddedTrackerPortForwarding: embeddedTrackerPortForwarding ??
          this.embeddedTrackerPortForwarding,
      markOfTheWeb: markOfTheWeb ?? this.markOfTheWeb,
      ignoreSslErrors: ignoreSslErrors ?? this.ignoreSslErrors,
      pythonExecutablePath:
          pythonExecutablePath ?? this.pythonExecutablePath,
      bdecodeDepthLimit: bdecodeDepthLimit ?? this.bdecodeDepthLimit,
      bdecodeTokenLimit: bdecodeTokenLimit ?? this.bdecodeTokenLimit,
      asyncIoThreads: asyncIoThreads ?? this.asyncIoThreads,
      hashingThreads: hashingThreads ?? this.hashingThreads,
      filePoolSize: filePoolSize ?? this.filePoolSize,
      checkingMemoryUse: checkingMemoryUse ?? this.checkingMemoryUse,
      diskCache: diskCache ?? this.diskCache,
      diskCacheTtl: diskCacheTtl ?? this.diskCacheTtl,
      diskQueueSizeKib: diskQueueSizeKib ?? this.diskQueueSizeKib,
      diskIoType: diskIoType ?? this.diskIoType,
      diskIoReadMode: diskIoReadMode ?? this.diskIoReadMode,
      diskIoWriteMode: diskIoWriteMode ?? this.diskIoWriteMode,
      enableCoalesceReadWrite:
          enableCoalesceReadWrite ?? this.enableCoalesceReadWrite,
      enablePieceExtentAffinity:
          enablePieceExtentAffinity ?? this.enablePieceExtentAffinity,
      enableUploadSuggestions:
          enableUploadSuggestions ?? this.enableUploadSuggestions,
      sendBufferWatermark:
          sendBufferWatermark ?? this.sendBufferWatermark,
      sendBufferLowWatermark:
          sendBufferLowWatermark ?? this.sendBufferLowWatermark,
      sendBufferWatermarkFactor: sendBufferWatermarkFactor ??
          this.sendBufferWatermarkFactor,
      connectionSpeed: connectionSpeed ?? this.connectionSpeed,
      seedingOutgoingConnections:
          seedingOutgoingConnections ?? this.seedingOutgoingConnections,
      socketSendBufferSizeKib:
          socketSendBufferSizeKib ?? this.socketSendBufferSizeKib,
      socketReceiveBufferSizeKib:
          socketReceiveBufferSizeKib ?? this.socketReceiveBufferSizeKib,
      socketBacklogSize: socketBacklogSize ?? this.socketBacklogSize,
      outgoingPortsMin: outgoingPortsMin ?? this.outgoingPortsMin,
      outgoingPortsMax: outgoingPortsMax ?? this.outgoingPortsMax,
      upnpLeaseDuration: upnpLeaseDuration ?? this.upnpLeaseDuration,
      peerTos: peerTos ?? this.peerTos,
      utpTcpMixedMode: utpTcpMixedMode ?? this.utpTcpMixedMode,
      hostnameCacheTtl: hostnameCacheTtl ?? this.hostnameCacheTtl,
      idnSupportEnabled: idnSupportEnabled ?? this.idnSupportEnabled,
      enableMultiConnectionsFromSameIp: enableMultiConnectionsFromSameIp ??
          this.enableMultiConnectionsFromSameIp,
      enableMultiConnectionsFromSamePeerId:
          enableMultiConnectionsFromSamePeerId ??
              this.enableMultiConnectionsFromSamePeerId,
      validateHttpsTrackerCertificate: validateHttpsTrackerCertificate ??
          this.validateHttpsTrackerCertificate,
      ssrfMitigation: ssrfMitigation ?? this.ssrfMitigation,
      blockPeersOnPrivilegedPorts: blockPeersOnPrivilegedPorts ??
          this.blockPeersOnPrivilegedPorts,
      uploadSlotsBehavior:
          uploadSlotsBehavior ?? this.uploadSlotsBehavior,
      uploadChokingAlgorithm:
          uploadChokingAlgorithm ?? this.uploadChokingAlgorithm,
      announceToAllTrackers:
          announceToAllTrackers ?? this.announceToAllTrackers,
      announceToAllTiers: announceToAllTiers ?? this.announceToAllTiers,
      announceIp: announceIp ?? this.announceIp,
      announcePort: announcePort ?? this.announcePort,
      maxConcurrentHttpAnnounces:
          maxConcurrentHttpAnnounces ?? this.maxConcurrentHttpAnnounces,
      stopTrackerTimeout: stopTrackerTimeout ?? this.stopTrackerTimeout,
      peerTurnover: peerTurnover ?? this.peerTurnover,
      peerTurnoverCutoff: peerTurnoverCutoff ?? this.peerTurnoverCutoff,
      peerTurnoverInterval:
          peerTurnoverInterval ?? this.peerTurnoverInterval,
      requestQueueSize: requestQueueSize ?? this.requestQueueSize,
      maxOutstandingBlockRequests: maxOutstandingBlockRequests ??
          this.maxOutstandingBlockRequests,
      dhtBootstrapNodes: dhtBootstrapNodes ?? this.dhtBootstrapNodes,
      i2pInboundQuantity: i2pInboundQuantity ?? this.i2pInboundQuantity,
      i2pOutboundQuantity: i2pOutboundQuantity ?? this.i2pOutboundQuantity,
      i2pInboundLength: i2pInboundLength ?? this.i2pInboundLength,
      i2pOutboundLength: i2pOutboundLength ?? this.i2pOutboundLength,
    );
  }
}

/// `resume_data_storage_type`
enum AdvancedResumeDataStorage {
  legacy('Legacy'),
  sqlite('SQLite');

  const AdvancedResumeDataStorage(this.apiValue);
  final String apiValue;

  String label(AppLocalizations l10n) => switch (this) {
        AdvancedResumeDataStorage.legacy => l10n.resumeFastresume,
        AdvancedResumeDataStorage.sqlite => l10n.resumeSqlite,
      };

  static AdvancedResumeDataStorage fromApi(String? value) {
    for (final item in values) {
      if (item.apiValue == value) return item;
    }
    return AdvancedResumeDataStorage.legacy;
  }
}

/// `torrent_content_remove_option`
enum AdvancedTorrentRemoveOption {
  delete('Delete'),
  moveToTrash('MoveToTrash');

  const AdvancedTorrentRemoveOption(this.apiValue);
  final String apiValue;

  String label(AppLocalizations l10n) => switch (this) {
        AdvancedTorrentRemoveOption.delete => l10n.removeDeleteFiles,
        AdvancedTorrentRemoveOption.moveToTrash => l10n.removeMoveToTrash,
      };

  static AdvancedTorrentRemoveOption fromApi(String? value) {
    for (final item in values) {
      if (item.apiValue == value) return item;
    }
    return AdvancedTorrentRemoveOption.delete;
  }
}

/// `disk_io_type`
enum AdvancedDiskIoType {
  defaultType(0),
  memoryMapped(1),
  posix(2),
  simplePreadPwrite(3),
  preadPwrite(4);

  const AdvancedDiskIoType(this.apiValue);
  final int apiValue;

  String label(AppLocalizations l10n) => switch (this) {
        AdvancedDiskIoType.defaultType => l10n.defaultOption,
        AdvancedDiskIoType.memoryMapped => l10n.diskIoMemoryMapped,
        AdvancedDiskIoType.posix => l10n.diskIoPosix,
        AdvancedDiskIoType.simplePreadPwrite => l10n.diskIoSimplePread,
        AdvancedDiskIoType.preadPwrite => 'pread/pwrite',
      };

  static AdvancedDiskIoType fromApi(int? value) {
    for (final item in values) {
      if (item.apiValue == value) return item;
    }
    return AdvancedDiskIoType.defaultType;
  }
}

/// `disk_io_read_mode`
enum AdvancedDiskIoCacheMode {
  disableOsCache(0),
  enableOsCache(1);

  const AdvancedDiskIoCacheMode(this.apiValue);
  final int apiValue;

  String label(AppLocalizations l10n) => switch (this) {
        AdvancedDiskIoCacheMode.disableOsCache => l10n.osCacheDisable,
        AdvancedDiskIoCacheMode.enableOsCache => l10n.osCacheEnable,
      };

  static AdvancedDiskIoCacheMode fromApi(int? value) {
    for (final item in values) {
      if (item.apiValue == value) return item;
    }
    return AdvancedDiskIoCacheMode.enableOsCache;
  }
}

/// `disk_io_write_mode`
enum AdvancedDiskIoWriteMode {
  disableOsCache(0),
  enableOsCache(1),
  writeThrough(2);

  const AdvancedDiskIoWriteMode(this.apiValue);
  final int apiValue;

  String label(AppLocalizations l10n) => switch (this) {
        AdvancedDiskIoWriteMode.disableOsCache => l10n.osCacheDisable,
        AdvancedDiskIoWriteMode.enableOsCache => l10n.osCacheEnable,
        AdvancedDiskIoWriteMode.writeThrough => l10n.osCacheWriteThrough,
      };

  static AdvancedDiskIoWriteMode fromApi(int? value) {
    for (final item in values) {
      if (item.apiValue == value) return item;
    }
    return AdvancedDiskIoWriteMode.enableOsCache;
  }
}

/// `utp_tcp_mixed_mode`
enum AdvancedUtpTcpMixedMode {
  preferTcp(0),
  peerProportional(1);

  const AdvancedUtpTcpMixedMode(this.apiValue);
  final int apiValue;

  String label(AppLocalizations l10n) => switch (this) {
        AdvancedUtpTcpMixedMode.preferTcp => l10n.utpPreferTcp,
        AdvancedUtpTcpMixedMode.peerProportional => l10n.utpPeerProportional,
      };

  static AdvancedUtpTcpMixedMode fromApi(int? value) {
    for (final item in values) {
      if (item.apiValue == value) return item;
    }
    return AdvancedUtpTcpMixedMode.preferTcp;
  }
}

/// `upload_slots_behavior`
enum AdvancedUploadSlotsBehavior {
  fixedSlots(0),
  uploadRateBased(1);

  const AdvancedUploadSlotsBehavior(this.apiValue);
  final int apiValue;

  String label(AppLocalizations l10n) => switch (this) {
        AdvancedUploadSlotsBehavior.fixedSlots => l10n.uploadSlotsFixed,
        AdvancedUploadSlotsBehavior.uploadRateBased => l10n.uploadSlotsRateBased,
      };

  static AdvancedUploadSlotsBehavior fromApi(int? value) {
    for (final item in values) {
      if (item.apiValue == value) return item;
    }
    return AdvancedUploadSlotsBehavior.fixedSlots;
  }
}

/// `upload_choking_algorithm`
enum AdvancedUploadChokingAlgorithm {
  roundRobin(0),
  fastestUpload(1),
  antiLeech(2);

  const AdvancedUploadChokingAlgorithm(this.apiValue);
  final int apiValue;

  String label(AppLocalizations l10n) => switch (this) {
        AdvancedUploadChokingAlgorithm.roundRobin => l10n.chokeRoundRobin,
        AdvancedUploadChokingAlgorithm.fastestUpload => l10n.chokeFastestUpload,
        AdvancedUploadChokingAlgorithm.antiLeech => l10n.chokeAntiLeech,
      };

  static AdvancedUploadChokingAlgorithm fromApi(int? value) {
    for (final item in values) {
      if (item.apiValue == value) return item;
    }
    return AdvancedUploadChokingAlgorithm.fastestUpload;
  }
}

/// 绑定 IP 下拉固定项 + 服务器返回地址。
abstract final class AdvancedBindAddressOption {
  AdvancedBindAddressOption._();

  static const all = '';
  static const allIpv4 = '0.0.0.0';
  static const allIpv6 = '::';

  static String labelOf(String value, AppLocalizations l10n) {
    return switch (value) {
      all => l10n.bindAllAddresses,
      allIpv4 => l10n.bindAllIpv4,
      allIpv6 => l10n.bindAllIpv6,
      _ => value,
    };
  }

  static const fixedValues = [all, allIpv4, allIpv6];
}
