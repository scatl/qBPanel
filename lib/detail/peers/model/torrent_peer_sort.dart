import 'package:qbpanel/api/entity/response/torrent_peer_response.dart';

enum PeerSortKey {
  country('国家/地区'),
  ip('IP/地址'),
  port('端口'),
  connection('连接'),
  flags('标志'),
  client('客户端'),
  peerId('对等节点 ID 客户端'),
  progress('进度'),
  dlSpeed('下载速度'),
  upSpeed('上传速度'),
  downloaded('已下载'),
  uploaded('已上传'),
  relevance('文件关联'),
  files('文件');

  const PeerSortKey(this.label);
  final String label;
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
