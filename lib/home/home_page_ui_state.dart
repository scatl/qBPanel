import 'package:qbpanel/api/entity/response/server_state_response.dart';
import 'package:qbpanel/api/entity/response/torrent_info_response.dart';
import 'package:qbpanel/home/entity/torrent_category_filter.dart';
import 'package:qbpanel/home/entity/torrent_category_node.dart';
import 'package:qbpanel/home/entity/torrent_sort.dart';
import 'package:qbpanel/home/entity/torrent_status_filter.dart';
import 'package:qbpanel/home/entity/torrent_tag.dart';
import 'package:qbpanel/storage/db/app_database.dart';
import 'package:qbpanel/widget/refresh/paged_refresh_state.dart';

class HomePageUiState {
  HomePageUiState({
    this.serverState,
    this.activeServer,
    this.statusFilter = TorrentStatusFilter.all,
    this.categoryFilter = TorrentCategoryFilter.all,
    this.tagFilter = TorrentTagFilter.all,
    this.sortKey = TorrentSortKey.state,
    this.sortAscending = true,
    this.searchQuery = '',
    this.hasTorrents = false,
    Map<TorrentStatusFilter, int>? statusCounts,
    List<TorrentCategoryNode>? categoryTree,
    this.categoryCounts = const TorrentCategoryCounts(),
    List<String>? tags,
    this.tagCounts = const TorrentTagCounts(),
    PagedRefreshState<TorrentInfoResponse>? pageListState,
  })  : statusCounts = statusCounts ?? const {},
        categoryTree = categoryTree ?? const [],
        tags = tags ?? const [],
        pageListState = pageListState ?? PagedRefreshState<TorrentInfoResponse>();

  final ServerStateResponse? serverState;

  /// 首页列表的加载/空/错误态；种子数据在 ViewModel 的 hash map 里。
  final PagedRefreshState<TorrentInfoResponse> pageListState;

  /// 当前 `isActive` 的服务器；`null` 时首页走引导空态。
  final QbServer? activeServer;

  /// 状态筛选；列表按此过滤，缓存仍是全量。
  final TorrentStatusFilter statusFilter;

  /// 分类筛选；与状态筛选同时生效（AND）。
  final TorrentCategoryFilter categoryFilter;

  /// 标签筛选；尚未接入列表过滤。
  final TorrentTagFilter tagFilter;

  /// 列表排序键；默认状态升序。
  final TorrentSortKey sortKey;

  /// `true` 为升序。
  final bool sortAscending;

  /// 名称搜索（空格分词 AND）；与筛选同时生效。
  final String searchQuery;

  /// 当前服务器缓存里是否有种子（未过滤）。
  final bool hasTorrents;

  /// 各状态在全量缓存中的数量；与当前选中筛选无关。
  final Map<TorrentStatusFilter, int> statusCounts;

  /// 分类树（按 `/` 分层）。
  final List<TorrentCategoryNode> categoryTree;

  /// 各分类数量；父分类含子孙。
  final TorrentCategoryCounts categoryCounts;

  /// 服务器上的标签名（排序后）。
  final List<String> tags;

  /// 各标签数量；一枚种子可计入多个标签。
  final TorrentTagCounts tagCounts;

  HomePageUiState copyWith({
    ServerStateResponse? serverState,
    PagedRefreshState<TorrentInfoResponse>? pageListState,
    QbServer? activeServer,
    TorrentStatusFilter? statusFilter,
    TorrentCategoryFilter? categoryFilter,
    TorrentTagFilter? tagFilter,
    TorrentSortKey? sortKey,
    bool? sortAscending,
    String? searchQuery,
    bool? hasTorrents,
    Map<TorrentStatusFilter, int>? statusCounts,
    List<TorrentCategoryNode>? categoryTree,
    TorrentCategoryCounts? categoryCounts,
    List<String>? tags,
    TorrentTagCounts? tagCounts,
  }) {
    return HomePageUiState(
      serverState: serverState ?? this.serverState,
      pageListState: pageListState ?? this.pageListState,
      activeServer: activeServer ?? this.activeServer,
      statusFilter: statusFilter ?? this.statusFilter,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      tagFilter: tagFilter ?? this.tagFilter,
      sortKey: sortKey ?? this.sortKey,
      sortAscending: sortAscending ?? this.sortAscending,
      searchQuery: searchQuery ?? this.searchQuery,
      hasTorrents: hasTorrents ?? this.hasTorrents,
      statusCounts: statusCounts ?? this.statusCounts,
      categoryTree: categoryTree ?? this.categoryTree,
      categoryCounts: categoryCounts ?? this.categoryCounts,
      tags: tags ?? this.tags,
      tagCounts: tagCounts ?? this.tagCounts,
    );
  }
}
