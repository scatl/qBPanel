import 'package:qbpanel/api/entity/response/json_read.dart';

/// `/api/v2/app/preferences`。按设置页逐步补字段。
class AppPreferencesResponse {
  const AppPreferencesResponse({
    // Behavior
    this.locale,
    this.confirmTorrentDeletion,
    this.statusBarExternalIp,
    this.fileLogEnabled,
    this.fileLogPath,
    this.fileLogBackupEnabled,
    this.fileLogMaxSize,
    this.fileLogDeleteOld,
    this.fileLogAge,
    this.fileLogAgeType,
    this.performanceWarning,
    // Downloads
    this.torrentContentLayout,
    this.addToTopOfQueue,
    this.addStoppedEnabled,
    this.torrentStopCondition,
    this.mergeTrackers,
    this.autoDeleteMode,
    this.preallocateAll,
    this.incompleteFilesExt,
    this.useUnwantedFolder,
    this.autoTmmEnabled,
    this.torrentChangedTmmEnabled,
    this.savePathChangedTmmEnabled,
    this.categoryChangedTmmEnabled,
    this.useCategoryPathsInManualMode,
    this.savePath,
    this.tempPathEnabled,
    this.tempPath,
    this.exportDir,
    this.exportDirFin,
    this.excludedFileNamesEnabled,
    this.excludedFileNames,
    this.mailNotificationEnabled,
    this.mailNotificationSender,
    this.mailNotificationEmail,
    this.mailNotificationSmtp,
    this.mailNotificationSslEnabled,
    this.mailNotificationEncryptionType,
    this.mailNotificationAuthEnabled,
    this.mailNotificationUsername,
    this.mailNotificationPassword,
    this.autorunOnTorrentAddedEnabled,
    this.autorunOnTorrentAddedProgram,
    this.autorunEnabled,
    this.autorunProgram,
    // Connection
    this.bittorrentProtocol,
    this.listenPort,
    this.upnp,
    this.maxConnec,
    this.maxConnecPerTorrent,
    this.maxUploads,
    this.maxUploadsPerTorrent,
    this.i2pEnabled,
    this.i2pAddress,
    this.i2pPort,
    this.i2pMixedMode,
    this.proxyType,
    this.proxyIp,
    this.proxyPort,
    this.proxyAuthEnabled,
    this.proxyUsername,
    this.proxyPassword,
    this.proxyHostnameLookup,
    this.proxyBittorrent,
    this.proxyPeerConnections,
    this.proxyRss,
    this.proxyMisc,
    this.ipFilterEnabled,
    this.ipFilterPath,
    this.ipFilterTrackers,
    this.bannedIps,
    // Speed
    this.upLimit,
    this.dlLimit,
    this.altUpLimit,
    this.altDlLimit,
    this.limitUtpRate,
    this.limitTcpOverhead,
    this.limitLanPeers,
    this.schedulerEnabled,
    this.scheduleFromHour,
    this.scheduleFromMin,
    this.scheduleToHour,
    this.scheduleToMin,
    this.schedulerDays,
    // BitTorrent
    this.dht,
    this.pex,
    this.lsd,
    this.encryption,
    this.anonymousMode,
    this.maxActiveCheckingTorrents,
    this.queueingEnabled,
    this.maxActiveDownloads,
    this.maxActiveUploads,
    this.maxActiveTorrents,
    this.dontCountSlowTorrents,
    this.slowTorrentDlRateThreshold,
    this.slowTorrentUlRateThreshold,
    this.slowTorrentInactiveTimer,
    this.maxRatioEnabled,
    this.maxRatio,
    this.maxSeedingTimeEnabled,
    this.maxSeedingTime,
    this.maxInactiveSeedingTimeEnabled,
    this.maxInactiveSeedingTime,
    this.maxRatioAct,
    this.addTrackersEnabled,
    this.addTrackers,
    this.addTrackersFromUrlEnabled,
    this.addTrackersUrl,
    this.addTrackersUrlList,
    // WebUI
    this.webUiDomainList,
    this.webUiAddress,
    this.webUiPort,
    this.webUiUpnp,
    this.useHttps,
    this.webUiHttpsCertPath,
    this.webUiHttpsKeyPath,
    this.webUiUsername,
    this.webUiApiKey,
    this.bypassLocalAuth,
    this.bypassAuthSubnetWhitelistEnabled,
    this.bypassAuthSubnetWhitelist,
    this.webUiMaxAuthFailCount,
    this.webUiBanDuration,
    this.webUiSessionTimeout,
    this.alternativeWebuiEnabled,
    this.alternativeWebuiPath,
    this.webUiClickjackingProtectionEnabled,
    this.webUiCsrfProtectionEnabled,
    this.webUiSecureCookieEnabled,
    this.webUiHostHeaderValidationEnabled,
    this.webUiUseCustomHttpHeadersEnabled,
    this.webUiCustomHttpHeaders,
    this.webUiReverseProxyEnabled,
    this.webUiReverseProxiesList,
    this.dyndnsEnabled,
    this.dyndnsService,
    this.dyndnsDomain,
    this.dyndnsUsername,
    this.dyndnsPassword,
    // Advanced
    this.resumeDataStorageType,
    this.torrentContentRemoveOption,
    this.memoryWorkingSetLimit,
    this.currentNetworkInterface,
    this.currentInterfaceName,
    this.currentInterfaceAddress,
    this.saveResumeDataInterval,
    this.saveStatisticsInterval,
    this.torrentFileSizeLimit,
    this.confirmTorrentRecheck,
    this.recheckCompletedTorrents,
    this.appInstanceName,
    this.refreshInterval,
    this.resolvePeerHostNames,
    this.resolvePeerCountries,
    this.reannounceWhenAddressChanged,
    this.enableEmbeddedTracker,
    this.embeddedTrackerPort,
    this.embeddedTrackerPortForwarding,
    this.markOfTheWeb,
    this.ignoreSslErrors,
    this.pythonExecutablePath,
    this.bdecodeDepthLimit,
    this.bdecodeTokenLimit,
    this.asyncIoThreads,
    this.hashingThreads,
    this.filePoolSize,
    this.checkingMemoryUse,
    this.diskCache,
    this.diskCacheTtl,
    this.diskQueueSize,
    this.diskIoType,
    this.diskIoReadMode,
    this.diskIoWriteMode,
    this.enableCoalesceReadWrite,
    this.enablePieceExtentAffinity,
    this.enableUploadSuggestions,
    this.sendBufferWatermark,
    this.sendBufferLowWatermark,
    this.sendBufferWatermarkFactor,
    this.connectionSpeed,
    this.seedingOutgoingConnections,
    this.socketSendBufferSize,
    this.socketReceiveBufferSize,
    this.socketBacklogSize,
    this.outgoingPortsMin,
    this.outgoingPortsMax,
    this.upnpLeaseDuration,
    this.peerTos,
    this.utpTcpMixedMode,
    this.hostnameCacheTtl,
    this.idnSupportEnabled,
    this.enableMultiConnectionsFromSameIp,
    this.enableMultiConnectionsFromSamePeerId,
    this.validateHttpsTrackerCertificate,
    this.ssrfMitigation,
    this.blockPeersOnPrivilegedPorts,
    this.uploadSlotsBehavior,
    this.uploadChokingAlgorithm,
    this.announceToAllTrackers,
    this.announceToAllTiers,
    this.announceIp,
    this.announcePort,
    this.maxConcurrentHttpAnnounces,
    this.stopTrackerTimeout,
    this.peerTurnover,
    this.peerTurnoverCutoff,
    this.peerTurnoverInterval,
    this.requestQueueSize,
    this.maxOutstandingBlockRequests,
    this.dhtBootstrapNodes,
    this.i2pInboundQuantity,
    this.i2pOutboundQuantity,
    this.i2pInboundLength,
    this.i2pOutboundLength,
  });

  // Behavior
  final String? locale;
  final bool? confirmTorrentDeletion;
  final bool? statusBarExternalIp;
  final bool? fileLogEnabled;
  final String? fileLogPath;
  final bool? fileLogBackupEnabled;
  final int? fileLogMaxSize;
  final bool? fileLogDeleteOld;
  final int? fileLogAge;
  final int? fileLogAgeType;
  final bool? performanceWarning;

  // Downloads
  final String? torrentContentLayout;
  final bool? addToTopOfQueue;
  final bool? addStoppedEnabled;
  final String? torrentStopCondition;
  final bool? mergeTrackers;
  final int? autoDeleteMode;
  final bool? preallocateAll;
  final bool? incompleteFilesExt;
  final bool? useUnwantedFolder;
  final bool? autoTmmEnabled;
  final bool? torrentChangedTmmEnabled;
  final bool? savePathChangedTmmEnabled;
  final bool? categoryChangedTmmEnabled;
  final bool? useCategoryPathsInManualMode;
  final String? savePath;
  final bool? tempPathEnabled;
  final String? tempPath;
  final String? exportDir;
  final String? exportDirFin;
  final bool? excludedFileNamesEnabled;
  final String? excludedFileNames;
  final bool? mailNotificationEnabled;
  final String? mailNotificationSender;
  final String? mailNotificationEmail;
  final String? mailNotificationSmtp;
  final bool? mailNotificationSslEnabled;
  final String? mailNotificationEncryptionType;
  final bool? mailNotificationAuthEnabled;
  final String? mailNotificationUsername;
  final String? mailNotificationPassword;
  final bool? autorunOnTorrentAddedEnabled;
  final String? autorunOnTorrentAddedProgram;
  final bool? autorunEnabled;
  final String? autorunProgram;

  // Connection
  final int? bittorrentProtocol;
  final int? listenPort;
  final bool? upnp;
  final int? maxConnec;
  final int? maxConnecPerTorrent;
  final int? maxUploads;
  final int? maxUploadsPerTorrent;
  final bool? i2pEnabled;
  final String? i2pAddress;
  final int? i2pPort;
  final bool? i2pMixedMode;
  final String? proxyType;
  final String? proxyIp;
  final int? proxyPort;
  final bool? proxyAuthEnabled;
  final String? proxyUsername;
  final String? proxyPassword;
  final bool? proxyHostnameLookup;
  final bool? proxyBittorrent;
  final bool? proxyPeerConnections;
  final bool? proxyRss;
  final bool? proxyMisc;
  final bool? ipFilterEnabled;
  final String? ipFilterPath;
  final bool? ipFilterTrackers;
  final String? bannedIps;

  // Speed
  final int? upLimit;
  final int? dlLimit;
  final int? altUpLimit;
  final int? altDlLimit;
  final bool? limitUtpRate;
  final bool? limitTcpOverhead;
  final bool? limitLanPeers;
  final bool? schedulerEnabled;
  final int? scheduleFromHour;
  final int? scheduleFromMin;
  final int? scheduleToHour;
  final int? scheduleToMin;
  final int? schedulerDays;

  // BitTorrent
  final bool? dht;
  final bool? pex;
  final bool? lsd;
  final int? encryption;
  final bool? anonymousMode;
  final int? maxActiveCheckingTorrents;
  final bool? queueingEnabled;
  final int? maxActiveDownloads;
  final int? maxActiveUploads;
  final int? maxActiveTorrents;
  final bool? dontCountSlowTorrents;
  final int? slowTorrentDlRateThreshold;
  final int? slowTorrentUlRateThreshold;
  final int? slowTorrentInactiveTimer;
  final bool? maxRatioEnabled;
  final double? maxRatio;
  final bool? maxSeedingTimeEnabled;
  final int? maxSeedingTime;
  final bool? maxInactiveSeedingTimeEnabled;
  final int? maxInactiveSeedingTime;
  final int? maxRatioAct;
  final bool? addTrackersEnabled;
  final String? addTrackers;
  final bool? addTrackersFromUrlEnabled;
  final String? addTrackersUrl;
  final String? addTrackersUrlList;

  // WebUI
  final String? webUiDomainList;
  final String? webUiAddress;
  final int? webUiPort;
  final bool? webUiUpnp;
  final bool? useHttps;
  final String? webUiHttpsCertPath;
  final String? webUiHttpsKeyPath;
  final String? webUiUsername;
  final String? webUiApiKey;
  final bool? bypassLocalAuth;
  final bool? bypassAuthSubnetWhitelistEnabled;
  final String? bypassAuthSubnetWhitelist;
  final int? webUiMaxAuthFailCount;
  final int? webUiBanDuration;
  final int? webUiSessionTimeout;
  final bool? alternativeWebuiEnabled;
  final String? alternativeWebuiPath;
  final bool? webUiClickjackingProtectionEnabled;
  final bool? webUiCsrfProtectionEnabled;
  final bool? webUiSecureCookieEnabled;
  final bool? webUiHostHeaderValidationEnabled;
  final bool? webUiUseCustomHttpHeadersEnabled;
  final String? webUiCustomHttpHeaders;
  final bool? webUiReverseProxyEnabled;
  final String? webUiReverseProxiesList;
  final bool? dyndnsEnabled;
  final int? dyndnsService;
  final String? dyndnsDomain;
  final String? dyndnsUsername;
  final String? dyndnsPassword;

  // Advanced
  final String? resumeDataStorageType;
  final String? torrentContentRemoveOption;
  final int? memoryWorkingSetLimit;
  final String? currentNetworkInterface;
  final String? currentInterfaceName;
  final String? currentInterfaceAddress;
  final int? saveResumeDataInterval;
  final int? saveStatisticsInterval;
  final int? torrentFileSizeLimit;
  final bool? confirmTorrentRecheck;
  final bool? recheckCompletedTorrents;
  final String? appInstanceName;
  final int? refreshInterval;
  final bool? resolvePeerHostNames;
  final bool? resolvePeerCountries;
  final bool? reannounceWhenAddressChanged;
  final bool? enableEmbeddedTracker;
  final int? embeddedTrackerPort;
  final bool? embeddedTrackerPortForwarding;
  final bool? markOfTheWeb;
  final bool? ignoreSslErrors;
  final String? pythonExecutablePath;
  final int? bdecodeDepthLimit;
  final int? bdecodeTokenLimit;
  final int? asyncIoThreads;
  final int? hashingThreads;
  final int? filePoolSize;
  final int? checkingMemoryUse;
  final int? diskCache;
  final int? diskCacheTtl;
  final int? diskQueueSize;
  final int? diskIoType;
  final int? diskIoReadMode;
  final int? diskIoWriteMode;
  final bool? enableCoalesceReadWrite;
  final bool? enablePieceExtentAffinity;
  final bool? enableUploadSuggestions;
  final int? sendBufferWatermark;
  final int? sendBufferLowWatermark;
  final int? sendBufferWatermarkFactor;
  final int? connectionSpeed;
  final bool? seedingOutgoingConnections;
  final int? socketSendBufferSize;
  final int? socketReceiveBufferSize;
  final int? socketBacklogSize;
  final int? outgoingPortsMin;
  final int? outgoingPortsMax;
  final int? upnpLeaseDuration;
  final int? peerTos;
  final int? utpTcpMixedMode;
  final int? hostnameCacheTtl;
  final bool? idnSupportEnabled;
  final bool? enableMultiConnectionsFromSameIp;
  final bool? enableMultiConnectionsFromSamePeerId;
  final bool? validateHttpsTrackerCertificate;
  final bool? ssrfMitigation;
  final bool? blockPeersOnPrivilegedPorts;
  final int? uploadSlotsBehavior;
  final int? uploadChokingAlgorithm;
  final bool? announceToAllTrackers;
  final bool? announceToAllTiers;
  final String? announceIp;
  final int? announcePort;
  final int? maxConcurrentHttpAnnounces;
  final int? stopTrackerTimeout;
  final int? peerTurnover;
  final int? peerTurnoverCutoff;
  final int? peerTurnoverInterval;
  final int? requestQueueSize;
  final int? maxOutstandingBlockRequests;
  final String? dhtBootstrapNodes;
  final int? i2pInboundQuantity;
  final int? i2pOutboundQuantity;
  final int? i2pInboundLength;
  final int? i2pOutboundLength;

  /// 兼容旧版 `mail_notification_ssl_enabled` 与新版 `encryption_type`。
  bool get mailSslOrEncryptionEnabled {
    final type = mailNotificationEncryptionType?.trim();
    if (type != null && type.isNotEmpty) {
      return type.toLowerCase() != 'none';
    }
    return mailNotificationSslEnabled ?? false;
  }

  factory AppPreferencesResponse.fromJson(Map<String, dynamic> json) {
    return AppPreferencesResponse(
      locale: readString(json['locale']),
      confirmTorrentDeletion: readBool(json['confirm_torrent_deletion']),
      statusBarExternalIp: readBool(json['status_bar_external_ip']),
      fileLogEnabled: readBool(json['file_log_enabled']),
      fileLogPath: readString(json['file_log_path']),
      fileLogBackupEnabled: readBool(json['file_log_backup_enabled']),
      fileLogMaxSize: readInt(json['file_log_max_size']),
      fileLogDeleteOld: readBool(json['file_log_delete_old']),
      fileLogAge: readInt(json['file_log_age']),
      fileLogAgeType: readInt(json['file_log_age_type']),
      performanceWarning: readBool(json['performance_warning']),
      torrentContentLayout: readString(json['torrent_content_layout']),
      addToTopOfQueue: readBool(json['add_to_top_of_queue']),
      addStoppedEnabled: readBool(json['add_stopped_enabled']),
      torrentStopCondition: readString(json['torrent_stop_condition']),
      mergeTrackers: readBool(json['merge_trackers']),
      autoDeleteMode: readInt(json['auto_delete_mode']),
      preallocateAll: readBool(json['preallocate_all']),
      incompleteFilesExt: readBool(json['incomplete_files_ext']),
      useUnwantedFolder: readBool(json['use_unwanted_folder']),
      autoTmmEnabled: readBool(json['auto_tmm_enabled']),
      torrentChangedTmmEnabled: readBool(json['torrent_changed_tmm_enabled']),
      savePathChangedTmmEnabled: readBool(json['save_path_changed_tmm_enabled']),
      categoryChangedTmmEnabled: readBool(json['category_changed_tmm_enabled']),
      useCategoryPathsInManualMode:
          readBool(json['use_category_paths_in_manual_mode']),
      savePath: readString(json['save_path']),
      tempPathEnabled: readBool(json['temp_path_enabled']),
      tempPath: readString(json['temp_path']),
      exportDir: readString(json['export_dir']),
      exportDirFin: readString(json['export_dir_fin']),
      excludedFileNamesEnabled: readBool(json['excluded_file_names_enabled']),
      excludedFileNames: readString(json['excluded_file_names']),
      mailNotificationEnabled: readBool(json['mail_notification_enabled']),
      mailNotificationSender: readString(json['mail_notification_sender']),
      mailNotificationEmail: readString(json['mail_notification_email']),
      mailNotificationSmtp: readString(json['mail_notification_smtp']),
      mailNotificationSslEnabled:
          readBool(json['mail_notification_ssl_enabled']),
      mailNotificationEncryptionType:
          readString(json['mail_notification_encryption_type']),
      mailNotificationAuthEnabled:
          readBool(json['mail_notification_auth_enabled']),
      mailNotificationUsername: readString(json['mail_notification_username']),
      mailNotificationPassword: readString(json['mail_notification_password']),
      autorunOnTorrentAddedEnabled:
          readBool(json['autorun_on_torrent_added_enabled']),
      autorunOnTorrentAddedProgram:
          readString(json['autorun_on_torrent_added_program']),
      autorunEnabled: readBool(json['autorun_enabled']),
      autorunProgram: readString(json['autorun_program']),
      bittorrentProtocol: readInt(json['bittorrent_protocol']),
      listenPort: readInt(json['listen_port']),
      upnp: readBool(json['upnp']),
      maxConnec: readInt(json['max_connec']),
      maxConnecPerTorrent: readInt(json['max_connec_per_torrent']),
      maxUploads: readInt(json['max_uploads']),
      maxUploadsPerTorrent: readInt(json['max_uploads_per_torrent']),
      i2pEnabled: readBool(json['i2p_enabled']),
      i2pAddress: readString(json['i2p_address']),
      i2pPort: readInt(json['i2p_port']),
      i2pMixedMode: readBool(json['i2p_mixed_mode']),
      proxyType: _readProxyType(json['proxy_type']),
      proxyIp: readString(json['proxy_ip']),
      proxyPort: readInt(json['proxy_port']),
      proxyAuthEnabled: readBool(json['proxy_auth_enabled']),
      proxyUsername: readString(json['proxy_username']),
      proxyPassword: readString(json['proxy_password']),
      proxyHostnameLookup: readBool(json['proxy_hostname_lookup']),
      proxyBittorrent: readBool(json['proxy_bittorrent']),
      proxyPeerConnections: readBool(json['proxy_peer_connections']),
      proxyRss: readBool(json['proxy_rss']),
      proxyMisc: readBool(json['proxy_misc']),
      ipFilterEnabled: readBool(json['ip_filter_enabled']),
      ipFilterPath: readString(json['ip_filter_path']),
      ipFilterTrackers: readBool(json['ip_filter_trackers']),
      bannedIps: readString(json['banned_IPs']),
      upLimit: readInt(json['up_limit']),
      dlLimit: readInt(json['dl_limit']),
      altUpLimit: readInt(json['alt_up_limit']),
      altDlLimit: readInt(json['alt_dl_limit']),
      limitUtpRate: readBool(json['limit_utp_rate']),
      limitTcpOverhead: readBool(json['limit_tcp_overhead']),
      limitLanPeers: readBool(json['limit_lan_peers']),
      schedulerEnabled: readBool(json['scheduler_enabled']),
      scheduleFromHour: readInt(json['schedule_from_hour']),
      scheduleFromMin: readInt(json['schedule_from_min']),
      scheduleToHour: readInt(json['schedule_to_hour']),
      scheduleToMin: readInt(json['schedule_to_min']),
      schedulerDays: readInt(json['scheduler_days']),
      dht: readBool(json['dht']),
      pex: readBool(json['pex']),
      lsd: readBool(json['lsd']),
      encryption: readInt(json['encryption']),
      anonymousMode: readBool(json['anonymous_mode']),
      maxActiveCheckingTorrents: readInt(json['max_active_checking_torrents']),
      queueingEnabled: readBool(json['queueing_enabled']),
      maxActiveDownloads: readInt(json['max_active_downloads']),
      maxActiveUploads: readInt(json['max_active_uploads']),
      maxActiveTorrents: readInt(json['max_active_torrents']),
      dontCountSlowTorrents: readBool(json['dont_count_slow_torrents']),
      slowTorrentDlRateThreshold:
          readInt(json['slow_torrent_dl_rate_threshold']),
      slowTorrentUlRateThreshold:
          readInt(json['slow_torrent_ul_rate_threshold']),
      slowTorrentInactiveTimer: readInt(json['slow_torrent_inactive_timer']),
      maxRatioEnabled: readBool(json['max_ratio_enabled']),
      maxRatio: readDouble(json['max_ratio']),
      maxSeedingTimeEnabled: readBool(json['max_seeding_time_enabled']),
      maxSeedingTime: readInt(json['max_seeding_time']),
      maxInactiveSeedingTimeEnabled:
          readBool(json['max_inactive_seeding_time_enabled']),
      maxInactiveSeedingTime: readInt(json['max_inactive_seeding_time']),
      maxRatioAct: readInt(json['max_ratio_act']),
      addTrackersEnabled: readBool(json['add_trackers_enabled']),
      addTrackers: readString(json['add_trackers']),
      addTrackersFromUrlEnabled:
          readBool(json['add_trackers_from_url_enabled']),
      addTrackersUrl: readString(json['add_trackers_url']),
      addTrackersUrlList: readString(json['add_trackers_url_list']),
      webUiDomainList: readString(json['web_ui_domain_list']),
      webUiAddress: readString(json['web_ui_address']),
      webUiPort: readInt(json['web_ui_port']),
      webUiUpnp: readBool(json['web_ui_upnp']),
      useHttps: readBool(json['use_https']),
      webUiHttpsCertPath: readString(json['web_ui_https_cert_path']),
      webUiHttpsKeyPath: readString(json['web_ui_https_key_path']),
      webUiUsername: readString(json['web_ui_username']),
      webUiApiKey: readString(json['web_ui_api_key']),
      bypassLocalAuth: readBool(json['bypass_local_auth']),
      bypassAuthSubnetWhitelistEnabled:
          readBool(json['bypass_auth_subnet_whitelist_enabled']),
      bypassAuthSubnetWhitelist:
          readString(json['bypass_auth_subnet_whitelist']),
      webUiMaxAuthFailCount: readInt(json['web_ui_max_auth_fail_count']),
      webUiBanDuration: readInt(json['web_ui_ban_duration']),
      webUiSessionTimeout: readInt(json['web_ui_session_timeout']),
      alternativeWebuiEnabled: readBool(json['alternative_webui_enabled']),
      alternativeWebuiPath: readString(json['alternative_webui_path']),
      webUiClickjackingProtectionEnabled:
          readBool(json['web_ui_clickjacking_protection_enabled']),
      webUiCsrfProtectionEnabled:
          readBool(json['web_ui_csrf_protection_enabled']),
      webUiSecureCookieEnabled: readBool(json['web_ui_secure_cookie_enabled']),
      webUiHostHeaderValidationEnabled:
          readBool(json['web_ui_host_header_validation_enabled']),
      webUiUseCustomHttpHeadersEnabled:
          readBool(json['web_ui_use_custom_http_headers_enabled']),
      webUiCustomHttpHeaders: readString(json['web_ui_custom_http_headers']),
      webUiReverseProxyEnabled: readBool(json['web_ui_reverse_proxy_enabled']),
      webUiReverseProxiesList: readString(json['web_ui_reverse_proxies_list']),
      dyndnsEnabled: readBool(json['dyndns_enabled']),
      dyndnsService: readInt(json['dyndns_service']),
      dyndnsDomain: readString(json['dyndns_domain']),
      dyndnsUsername: readString(json['dyndns_username']),
      dyndnsPassword: readString(json['dyndns_password']),
      resumeDataStorageType: readString(json['resume_data_storage_type']),
      torrentContentRemoveOption: readString(json['torrent_content_remove_option']),
      memoryWorkingSetLimit: readInt(json['memory_working_set_limit']),
      currentNetworkInterface: readString(json['current_network_interface']),
      currentInterfaceName: readString(json['current_interface_name']),
      currentInterfaceAddress: readString(json['current_interface_address']),
      saveResumeDataInterval: readInt(json['save_resume_data_interval']),
      saveStatisticsInterval: readInt(json['save_statistics_interval']),
      torrentFileSizeLimit: readInt(json['torrent_file_size_limit']),
      confirmTorrentRecheck: readBool(json['confirm_torrent_recheck']),
      recheckCompletedTorrents: readBool(json['recheck_completed_torrents']),
      appInstanceName: readString(json['app_instance_name']),
      refreshInterval: readInt(json['refresh_interval']),
      resolvePeerHostNames: readBool(json['resolve_peer_host_names']),
      resolvePeerCountries: readBool(json['resolve_peer_countries']),
      reannounceWhenAddressChanged:
          readBool(json['reannounce_when_address_changed']),
      enableEmbeddedTracker: readBool(json['enable_embedded_tracker']),
      embeddedTrackerPort: readInt(json['embedded_tracker_port']),
      embeddedTrackerPortForwarding:
          readBool(json['embedded_tracker_port_forwarding']),
      markOfTheWeb: readBool(json['mark_of_the_web']),
      ignoreSslErrors: readBool(json['ignore_ssl_errors']),
      pythonExecutablePath: readString(json['python_executable_path']),
      bdecodeDepthLimit: readInt(json['bdecode_depth_limit']),
      bdecodeTokenLimit: readInt(json['bdecode_token_limit']),
      asyncIoThreads: readInt(json['async_io_threads']),
      hashingThreads: readInt(json['hashing_threads']),
      filePoolSize: readInt(json['file_pool_size']),
      checkingMemoryUse: readInt(json['checking_memory_use']),
      diskCache: readInt(json['disk_cache']),
      diskCacheTtl: readInt(json['disk_cache_ttl']),
      diskQueueSize: readInt(json['disk_queue_size']),
      diskIoType: readInt(json['disk_io_type']),
      diskIoReadMode: readInt(json['disk_io_read_mode']),
      diskIoWriteMode: readInt(json['disk_io_write_mode']),
      enableCoalesceReadWrite: readBool(json['enable_coalesce_read_write']),
      enablePieceExtentAffinity: readBool(json['enable_piece_extent_affinity']),
      enableUploadSuggestions: readBool(json['enable_upload_suggestions']),
      sendBufferWatermark: readInt(json['send_buffer_watermark']),
      sendBufferLowWatermark: readInt(json['send_buffer_low_watermark']),
      sendBufferWatermarkFactor: readInt(json['send_buffer_watermark_factor']),
      connectionSpeed: readInt(json['connection_speed']),
      seedingOutgoingConnections: readBool(json['seeding_outgoing_connections']),
      socketSendBufferSize: readInt(json['socket_send_buffer_size']),
      socketReceiveBufferSize: readInt(json['socket_receive_buffer_size']),
      socketBacklogSize: readInt(json['socket_backlog_size']),
      outgoingPortsMin: readInt(json['outgoing_ports_min']),
      outgoingPortsMax: readInt(json['outgoing_ports_max']),
      upnpLeaseDuration: readInt(json['upnp_lease_duration']),
      peerTos: readInt(json['peer_tos']),
      utpTcpMixedMode: readInt(json['utp_tcp_mixed_mode']),
      hostnameCacheTtl: readInt(json['hostname_cache_ttl']),
      idnSupportEnabled: readBool(json['idn_support_enabled']),
      enableMultiConnectionsFromSameIp:
          readBool(json['enable_multi_connections_from_same_ip']),
      enableMultiConnectionsFromSamePeerId:
          readBool(json['enable_multi_connections_from_same_peer_id']),
      validateHttpsTrackerCertificate:
          readBool(json['validate_https_tracker_certificate']),
      ssrfMitigation: readBool(json['ssrf_mitigation']),
      blockPeersOnPrivilegedPorts:
          readBool(json['block_peers_on_privileged_ports']),
      uploadSlotsBehavior: readInt(json['upload_slots_behavior']),
      uploadChokingAlgorithm: readInt(json['upload_choking_algorithm']),
      announceToAllTrackers: readBool(json['announce_to_all_trackers']),
      announceToAllTiers: readBool(json['announce_to_all_tiers']),
      announceIp: readString(json['announce_ip']),
      announcePort: readInt(json['announce_port']),
      maxConcurrentHttpAnnounces:
          readInt(json['max_concurrent_http_announces']),
      stopTrackerTimeout: readInt(json['stop_tracker_timeout']),
      peerTurnover: readInt(json['peer_turnover']),
      peerTurnoverCutoff: readInt(json['peer_turnover_cutoff']),
      peerTurnoverInterval: readInt(json['peer_turnover_interval']),
      requestQueueSize: readInt(json['request_queue_size']),
      maxOutstandingBlockRequests:
          readInt(json['max_outstanding_block_requests']),
      dhtBootstrapNodes: readString(json['dht_bootstrap_nodes']),
      i2pInboundQuantity: readInt(json['i2p_inbound_quantity']),
      i2pOutboundQuantity: readInt(json['i2p_outbound_quantity']),
      i2pInboundLength: readInt(json['i2p_inbound_length']),
      i2pOutboundLength: readInt(json['i2p_outbound_length']),
    );
  }
}

/// 5.x 为 `None`/`SOCKS4`/`SOCKS5`/`HTTP`；旧版为整数。
String? _readProxyType(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  final code = readInt(value);
  if (code == null) return value.toString();
  switch (code) {
    case 1:
    case 3:
      return 'HTTP';
    case 2:
    case 4:
      return 'SOCKS5';
    case 5:
      return 'SOCKS4';
    default:
      return 'None';
  }
}
