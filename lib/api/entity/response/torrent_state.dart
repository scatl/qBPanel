/// qBittorrent 5.0 种子 `state`（`/torrents/info` 与 `sync/maindata` 单项相同）。
///
/// 取值见本地文档 [Get torrent list](docs/qbittorrent/WebUI-API-(qBittorrent-5.0).md)。
enum TorrentState {
  error('error', '错误'),
  missingFiles('missingFiles', '文件缺失'),
  uploading('uploading', '做种中'),
  stoppedUP('stoppedUP', '已完成'),
  queuedUP('queuedUP', '排队做种'),
  stalledUP('stalledUP', '做种已暂停'),
  checkingUP('checkingUP', '校验中'),
  forcedUP('forcedUP', '强制做种'),
  allocating('allocating', '分配空间'),
  downloading('downloading', '下载中'),
  metaDL('metaDL', '获取元数据'),
  forcedMetaDL('forcedMetaDL', '强制获取元数据'),
  stoppedDL('stoppedDL', '已停止'),
  queuedDL('queuedDL', '排队下载'),
  stalledDL('stalledDL', '下载已暂停'),
  checkingDL('checkingDL', '校验中'),
  forcedDL('forcedDL', '强制下载'),
  checkingResumeData('checkingResumeData', '检查恢复数据'),
  moving('moving', '移动中'),
  unknown('unknown', '未知');

  const TorrentState(this.apiValue, this.displayText);

  /// 接口 JSON 字符串。
  final String apiValue;

  /// 列表/详情展示用中文。
  final String displayText;

  /// 解析接口字段；缺省返回 `null`（便于增量 merge）；无法识别则为 [unknown]。
  static TorrentState? fromApi(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final s in TorrentState.values) {
      if (s.apiValue == raw) return s;
    }
    return TorrentState.unknown;
  }
}
