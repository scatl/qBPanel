import 'package:qbpanel/api/entity/response/torrent_tracker_response.dart';

enum TrackerSortKey {
  url('URL'),
  tier('层级'),
  status('状态'),
  seeds('种子'),
  peers('用户'),
  leeches('下载者'),
  downloaded('完成次数'),
  message('消息'),
  nextAnnounce('下次宣告'),
  minAnnounce('最短宣告间隔');

  const TrackerSortKey(this.label);
  final String label;
}

List<TorrentTrackerResponse> sortTrackers(
  List<TorrentTrackerResponse> trackers,
  TrackerSortKey key,
  bool ascending,
) {
  final special = <TorrentTrackerResponse>[];
  final regular = <TorrentTrackerResponse>[];
  for (final tracker in trackers) {
    if (tracker.isSpecial) {
      special.add(tracker);
    } else {
      regular.add(tracker);
    }
  }
  regular.sort((a, b) {
    final result = _compareTracker(a, b, key);
    return ascending ? result : -result;
  });
  return [
    for (final tracker in [...special, ...regular])
      _withSortedEndpoints(tracker, key, ascending),
  ];
}

TorrentTrackerResponse _withSortedEndpoints(
  TorrentTrackerResponse tracker,
  TrackerSortKey key,
  bool ascending,
) {
  if (tracker.endpoints.length < 2) return tracker;
  final endpoints = List<TorrentTrackerEndpoint>.of(tracker.endpoints)
    ..sort((a, b) {
      final result = _compareEndpoint(a, b, key);
      return ascending ? result : -result;
    });
  return tracker.copyWith(endpoints: endpoints);
}

int _compareTracker(
  TorrentTrackerResponse a,
  TorrentTrackerResponse b,
  TrackerSortKey key,
) {
  final result = switch (key) {
    TrackerSortKey.url => _cmpString(a.displayName, b.displayName),
    TrackerSortKey.tier => _cmpTier(a.tier, b.tier),
    TrackerSortKey.status => _statusRank(
      status: a.status,
      updating: a.updating,
    ).compareTo(_statusRank(status: b.status, updating: b.updating)),
    TrackerSortKey.seeds => _cmpCount(a.numSeeds, b.numSeeds),
    TrackerSortKey.peers => _cmpCount(a.numPeers, b.numPeers),
    TrackerSortKey.leeches => _cmpCount(a.numLeeches, b.numLeeches),
    TrackerSortKey.downloaded => _cmpCount(a.numDownloaded, b.numDownloaded),
    TrackerSortKey.message => _cmpString(a.msg, b.msg),
    TrackerSortKey.nextAnnounce => _cmpNum(a.nextAnnounce, b.nextAnnounce),
    TrackerSortKey.minAnnounce => _cmpNum(a.minAnnounce, b.minAnnounce),
  };
  if (result != 0) return result;
  return _cmpString(a.url, b.url);
}

int _compareEndpoint(
  TorrentTrackerEndpoint a,
  TorrentTrackerEndpoint b,
  TrackerSortKey key,
) {
  final result = switch (key) {
    TrackerSortKey.url || TrackerSortKey.tier => _cmpString(a.name, b.name),
    TrackerSortKey.status => _statusRank(
      status: a.status,
      updating: a.updating,
    ).compareTo(_statusRank(status: b.status, updating: b.updating)),
    TrackerSortKey.seeds => _cmpCount(a.numSeeds, b.numSeeds),
    TrackerSortKey.peers => _cmpCount(a.numPeers, b.numPeers),
    TrackerSortKey.leeches => _cmpCount(a.numLeeches, b.numLeeches),
    TrackerSortKey.downloaded => _cmpCount(a.numDownloaded, b.numDownloaded),
    TrackerSortKey.message => _cmpString(a.msg, b.msg),
    TrackerSortKey.nextAnnounce => _cmpNum(a.nextAnnounce, b.nextAnnounce),
    TrackerSortKey.minAnnounce => _cmpNum(a.minAnnounce, b.minAnnounce),
  };
  if (result != 0) return result;
  return _cmpString(a.name, b.name);
}

int _statusRank({required int? status, required bool updating}) {
  if (updating || status == 3) return 3;
  return status ?? 99;
}

int _cmpString(String? a, String? b) {
  final left = a?.trim().toLowerCase() ?? '';
  final right = b?.trim().toLowerCase() ?? '';
  if (left.isEmpty != right.isEmpty) return left.isEmpty ? 1 : -1;
  return left.compareTo(right);
}

int _cmpNum(num? a, num? b) => (a ?? -1).compareTo(b ?? -1);

int _cmpTier(int? a, int? b) {
  final left = (a == null || a < 0) ? -1 : a;
  final right = (b == null || b < 0) ? -1 : b;
  return left.compareTo(right);
}

/// WebUI：N/A（`< 0`）排在有效数字前面。
int _cmpCount(int? a, int? b) {
  final leftNa = a == null || a < 0;
  final rightNa = b == null || b < 0;
  if (leftNa != rightNa) return leftNa ? -1 : 1;
  return (a ?? -1).compareTo(b ?? -1);
}
