import 'package:qbpanel/api/entity/response/torrent_peer_response.dart';
import 'package:qbpanel/l10n/app_localizations.dart';

enum PeerSortKey {
  country,
  ip,
  port,
  connection,
  flags,
  client,
  peerId,
  progress,
  dlSpeed,
  upSpeed,
  downloaded,
  uploaded,
  relevance,
  files;

  String label(AppLocalizations l10n) => switch (this) {
        PeerSortKey.country => l10n.sortCountry,
        PeerSortKey.ip => l10n.sortIp,
        PeerSortKey.port => l10n.sortPort,
        PeerSortKey.connection => l10n.sortConnection,
        PeerSortKey.flags => l10n.sortFlags,
        PeerSortKey.client => l10n.sortClient,
        PeerSortKey.peerId => l10n.sortPeerIdClient,
        PeerSortKey.progress => l10n.sortProgress,
        PeerSortKey.dlSpeed => l10n.sortDownloadSpeed,
        PeerSortKey.upSpeed => l10n.sortUploadSpeed,
        PeerSortKey.downloaded => l10n.sortDownloaded,
        PeerSortKey.uploaded => l10n.sortUploaded,
        PeerSortKey.relevance => l10n.sortRelevance,
        PeerSortKey.files => l10n.sortFiles,
      };
}

List<TorrentPeerResponse> sortPeers(
  List<TorrentPeerResponse> peers,
  PeerSortKey key,
  bool ascending,
) {
  final next = List<TorrentPeerResponse>.of(peers);
  next.sort((a, b) {
    final result = _compare(a, b, key);
    return ascending ? result : -result;
  });
  return next;
}

int _compare(TorrentPeerResponse a, TorrentPeerResponse b, PeerSortKey key) {
  final result = switch (key) {
    PeerSortKey.country => _cmpString(a.country, b.country),
    PeerSortKey.ip => _cmpIp(a.ip ?? a.id, b.ip ?? b.id),
    PeerSortKey.port => _cmpNum(a.port, b.port),
    PeerSortKey.connection => _cmpString(a.connection, b.connection),
    PeerSortKey.flags => _cmpString(a.flags, b.flags),
    PeerSortKey.client => _cmpString(a.client, b.client),
    PeerSortKey.peerId => _cmpString(a.peerIdClient, b.peerIdClient),
    PeerSortKey.progress => _cmpNum(a.progress, b.progress),
    PeerSortKey.dlSpeed => _cmpNum(a.dlSpeed, b.dlSpeed),
    PeerSortKey.upSpeed => _cmpNum(a.upSpeed, b.upSpeed),
    PeerSortKey.downloaded => _cmpNum(a.downloaded, b.downloaded),
    PeerSortKey.uploaded => _cmpNum(a.uploaded, b.uploaded),
    PeerSortKey.relevance => _cmpNum(a.relevance, b.relevance),
    PeerSortKey.files => _cmpString(a.files, b.files),
  };
  if (result != 0) return result;
  return _cmpString(a.id, b.id);
}

int _cmpString(String? a, String? b) {
  final left = a?.trim().toLowerCase() ?? '';
  final right = b?.trim().toLowerCase() ?? '';
  if (left.isEmpty != right.isEmpty) return left.isEmpty ? 1 : -1;
  return left.compareTo(right);
}

int _cmpNum(num? a, num? b) => (a ?? -1).compareTo(b ?? -1);

int _cmpIp(String a, String b) {
  final left = _ipv4(a);
  final right = _ipv4(b);
  if (left != null && right != null) {
    for (var i = 0; i < 4; i++) {
      final c = left[i].compareTo(right[i]);
      if (c != 0) return c;
    }
    return 0;
  }
  return _cmpString(a, b);
}

List<int>? _ipv4(String value) {
  final host = value.split('%').first.split(':').first;
  final parts = host.split('.');
  if (parts.length != 4) return null;
  final nums = <int>[];
  for (final part in parts) {
    final n = int.tryParse(part);
    if (n == null || n < 0 || n > 255) return null;
    nums.add(n);
  }
  return nums;
}
