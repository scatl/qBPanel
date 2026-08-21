/// 分页刷新状态（对齐 Compose [UiState] 的常用字段）
class PagedRefreshState<T> {
  List<T> items = [];
  String? errorMessage;

  bool initLoading = false;
  bool refreshing = false;
  bool loadingMore = false;
  bool hasMore = false;
  bool success = false;
  bool error = false;

  bool get isEmpty => items.isEmpty;

  bool get showInitLoading => initLoading && isEmpty && !error;

  bool get showEmptyOrError => isEmpty && !initLoading;

  void beginInit() {
    initLoading = true;
    error = false;
    errorMessage = null;
    refreshing = false;
    loadingMore = false;
    success = false;
  }

  void beginRefresh() {
    refreshing = true;
    initLoading = false;
    error = false;
    errorMessage = null;
    success = false;
  }

  void beginLoadMore() {
    loadingMore = true;
    refreshing = false;
    initLoading = false;
    error = false;
    errorMessage = null;
    hasMore = true;
    success = false;
  }

  /// [append]：加载更多时追加；刷新/首次时替换
  void setSuccess({
    required List<T> data,
    required bool append,
    required bool hasMore,
  }) {
    items = append ? [...items, ...data] : List<T>.from(data);
    this.hasMore = hasMore;
    success = true;
    loadingMore = false;
    refreshing = false;
    initLoading = false;
    error = false;
    errorMessage = null;
  }

  void setEmpty() {
    items = [];
    hasMore = false;
    success = true;
    loadingMore = false;
    refreshing = false;
    initLoading = false;
    error = false;
    errorMessage = null;
  }

  /// 首次/刷新失败；[keepItems] 为 true 时保留已有列表（下拉刷新失败）
  void setError(String message, {bool keepItems = false}) {
    if (!keepItems) {
      items = [];
    }
    errorMessage = message;
    error = true;
    success = false;
    loadingMore = false;
    refreshing = false;
    initLoading = false;
    // 与 Compose 一致：出错时仍允许点 footer 重试加载更多
    if (keepItems) {
      hasMore = true;
    }
  }

  /// 仅加载更多失败：保留列表，footer 可重试
  void setLoadMoreError(String message) {
    errorMessage = message;
    error = true;
    success = false;
    loadingMore = false;
    refreshing = false;
    initLoading = false;
    hasMore = true;
  }
}

/// 重试类型（对齐 Compose [RetryType]）
enum PagedRetryType { init, loadMore }
