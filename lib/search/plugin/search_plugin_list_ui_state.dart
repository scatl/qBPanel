import 'package:qbpanel/api/entity/response/search_plugin_response.dart';
import 'package:qbpanel/widget/refresh/paged_refresh_state.dart';

class SearchPluginListUiState {
  SearchPluginListUiState({
    PagedRefreshState<SearchPluginResponse>? list,
    this.busyPluginNames = const {},
    this.updating = false,
  }) : list = list ?? PagedRefreshState<SearchPluginResponse>();

  final PagedRefreshState<SearchPluginResponse> list;
  final Set<String> busyPluginNames;
  final bool updating;

  SearchPluginListUiState copyWith({
    PagedRefreshState<SearchPluginResponse>? list,
    Set<String>? busyPluginNames,
    bool? updating,
  }) {
    return SearchPluginListUiState(
      list: list ?? this.list,
      busyPluginNames: busyPluginNames ?? this.busyPluginNames,
      updating: updating ?? this.updating,
    );
  }
}
