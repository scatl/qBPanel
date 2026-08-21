import 'package:qbpanel/api/entity/response/torrent_properties_response.dart';
import 'package:qbpanel/api/entity/response/torrent_state.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

class TorrentDetailUiState {
  const TorrentDetailUiState({
    this.emptyState = const EmptyState.loading(),
    this.properties,
    this.pieceStates = const [],
    this.pieceAvailability = const [],
    this.listState,
  });

  final EmptyState emptyState;
  final TorrentPropertiesResponse? properties;
  final List<int> pieceStates;
  final List<int> pieceAvailability;

  /// 首页 maindata 缓存里的状态，用来决定是否显示可用性条。
  final TorrentState? listState;

  /// 对齐 Web：有元数据、未下完，且不在停止/排队/校验/错误。
  bool get showAvailability {
    final props = properties;
    if (props == null) return false;
    if (props.hasMetadata == false) return false;
    if ((props.progress ?? 0) >= 1) return false;
    final raw = listState?.apiValue ?? '';
    if (raw.contains('stopped') ||
        raw.contains('queued') ||
        raw.contains('checking') ||
        raw.contains('error') ||
        raw.contains('missingFiles')) {
      return false;
    }
    return true;
  }

  TorrentDetailUiState copyWith({
    EmptyState? emptyState,
    TorrentPropertiesResponse? properties,
    List<int>? pieceStates,
    List<int>? pieceAvailability,
    TorrentState? listState,
  }) {
    return TorrentDetailUiState(
      emptyState: emptyState ?? this.emptyState,
      properties: properties ?? this.properties,
      pieceStates: pieceStates ?? this.pieceStates,
      pieceAvailability: pieceAvailability ?? this.pieceAvailability,
      listState: listState ?? this.listState,
    );
  }
}
