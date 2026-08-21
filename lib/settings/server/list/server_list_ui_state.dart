import 'package:qbpanel/storage/db/app_database.dart';
import 'package:qbpanel/widget/refresh/paged_refresh_state.dart';

class ServerListUiState {
  ServerListUiState({
    PagedRefreshState<QbServer>? list,
    this.activeServer,
  }) : list = list ?? PagedRefreshState<QbServer>();

  final PagedRefreshState<QbServer> list;

  final QbServer? activeServer;

  ServerListUiState copyWith({
    PagedRefreshState<QbServer>? list,
    QbServer? activeServer,
  }) {
    return ServerListUiState(
      list: list ?? this.list,
      activeServer: activeServer
    );
  }
}
