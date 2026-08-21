import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';

import 'paged_refresh_state.dart';

/// 外部触发刷新（从子页返回等）
class PagedRefreshController {
  Future<void> Function()? _callRefresh;

  void _attach(Future<void> Function() callRefresh) {
    _callRefresh = callRefresh;
  }

  void _detach() {
    _callRefresh = null;
  }

  Future<void> callRefresh() async {
    await _callRefresh?.call();
  }
}

/// 基于 EasyRefresh 的分页列表（对齐 Compose [SwipeRefresh] 的核心行为）
///
/// - 首次加载：页面中间转圈
/// - 下拉刷新
/// - 距底部 [triggerLoadMoreOffset] 条时预加载下一页
/// - 空 / 错误 / 没有更多 的占位与重试
/// - 非错误空态可自定义图标和跳转按钮（[emptyIcon] / [emptyActionText] / [onEmptyAction]）
class PagedRefreshList<T> extends StatefulWidget {
  const PagedRefreshList({
    super.key,
    required this.state,
    required this.onRefresh,
    required this.itemBuilder,
    this.onLoadMore,
    this.controller,
    this.scrollController,
    this.onRetry,
    this.enableRefresh = true,
    this.enableLoadMore = true,
    this.triggerLoadMoreOffset = 5,
    this.padding = EdgeInsets.zero,
    this.emptyTitle = '暂无数据',
    this.emptySubtitle,
    this.emptyIcon,
    this.emptyActionText,
    this.onEmptyAction,
    this.errorActionText = '重试',
    this.showNoMoreMessage = true,
    this.itemExtent,
    this.separatorBuilder,
  });

  final PagedRefreshState<T> state;
  final PagedRefreshController? controller;

  /// 由外部持有时可在 Widget 重建后保留滚动位置（如抽屉 GlobalKey）
  final ScrollController? scrollController;

  /// 下拉刷新 / 首次重试：由外部改 [state] 并拉数据
  final Future<void> Function() onRefresh;

  /// 预加载 / 上拉 / footer 重试
  final Future<void> Function()? onLoadMore;

  final void Function(PagedRetryType type)? onRetry;

  final bool enableRefresh;
  final bool enableLoadMore;

  /// 剩余未展示条数 ≤ 该值时触发预加载（默认 5，对齐 Compose）
  final int triggerLoadMoreOffset;

  final EdgeInsetsGeometry padding;
  final String emptyTitle;
  final String? emptySubtitle;

  /// 非错误空态图标；默认 `Icons.inbox_outlined`。错误态仍用 `error_outline`。
  final IconData? emptyIcon;

  /// 非错误空态按钮文案；与 [onEmptyAction] 同时有值才显示。
  final String? emptyActionText;

  /// 非错误空态按钮；错误态走 [errorActionText] + 重试。
  final VoidCallback? onEmptyAction;

  /// 错误态按钮文案，默认「重试」。
  final String errorActionText;

  final bool showNoMoreMessage;

  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final double? itemExtent;
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  @override
  State<PagedRefreshList<T>> createState() => PagedRefreshListState<T>();
}

class PagedRefreshListState<T> extends State<PagedRefreshList<T>> {
  final _refresh = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  /// 已对「当时列表长度」触发过预加载，避免同一页反复打 onLoadMore
  int _preloadedAtSize = 0;

  PagedRefreshState<T> get _state => widget.state;

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(_handleRefresh);
  }

  @override
  void didUpdateWidget(covariant PagedRefreshList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach();
      widget.controller?._attach(_handleRefresh);
    }
  }

  @override
  void dispose() {
    widget.controller?._detach();
    _refresh.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await widget.onRefresh();
    if (!mounted) return;
    _preloadedAtSize = 0;
    setState(() {});
    _refresh
      ..finishRefresh(
        _state.error && _state.isEmpty
            ? IndicatorResult.fail
            : IndicatorResult.success,
      )
      ..resetFooter()
      ..finishLoad(
        !_state.hasMore ? IndicatorResult.noMore : IndicatorResult.success,
      );
  }

  Future<void> _handleLoad() async {
    if (!_state.hasMore) {
      _refresh.finishLoad(IndicatorResult.noMore);
      return;
    }
    if (_state.loadingMore || _state.refreshing || _state.initLoading) {
      _refresh.finishLoad(IndicatorResult.success);
      return;
    }
    await widget.onLoadMore?.call();
    if (!mounted) return;
    setState(() {});
    if (_state.error) {
      _refresh.finishLoad(IndicatorResult.fail);
      return;
    }
    _refresh.finishLoad(
      !_state.hasMore ? IndicatorResult.noMore : IndicatorResult.success,
    );
  }

  void _maybePreload(int index) {
    if (!widget.enableLoadMore) return;
    if (!_state.hasMore ||
        _state.loadingMore ||
        _state.refreshing ||
        _state.initLoading ||
        _state.error) {
      return;
    }
    final size = _state.items.length;
    if (size == 0) return;
    if (size - index > widget.triggerLoadMoreOffset) return;
    if (_preloadedAtSize >= size) return;

    _preloadedAtSize = size;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_state.loadingMore || !_state.hasMore || _state.error) return;
      widget.onLoadMore?.call().then((_) {
        if (!mounted) return;
        setState(() {});
        _refresh.finishLoad(
          _state.error
              ? IndicatorResult.fail
              : (!_state.hasMore
                  ? IndicatorResult.noMore
                  : IndicatorResult.success),
        );
      });
    });
  }

  Future<void> _retry(PagedRetryType type) async {
    widget.onRetry?.call(type);
    if (type == PagedRetryType.init) {
      _preloadedAtSize = 0;
      await widget.onRefresh();
      if (mounted) setState(() {});
    } else {
      await widget.onLoadMore?.call();
      if (!mounted) return;
      setState(() {});
      _refresh.finishLoad(
        _state.error
            ? IndicatorResult.fail
            : (!_state.hasMore
                ? IndicatorResult.noMore
                : IndicatorResult.success),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_state.showInitLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final canPull = widget.enableRefresh;
    final canLoad = widget.enableLoadMore && !_state.isEmpty;

    return EasyRefresh(
      controller: _refresh,
      header: MaterialHeader(),
      footer: MaterialFooter(),
      onRefresh: canPull ? _handleRefresh : null,
      onLoad: canLoad ? _handleLoad : null,
      child: _buildScrollable(context),
    );
  }

  Widget _buildScrollable(BuildContext context) {
    if (_state.showEmptyOrError) {
      return ListView(
        controller: widget.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: widget.padding,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.7,
            child: EmptyStateView(
              tone: EmptyStateTone.page,
              state: EmptyState(
                isEmpty: true,
                errorMessage: _state.error
                    ? (_state.errorMessage ?? '加载失败')
                    : null,
                emptyTitle: widget.emptyTitle,
                emptySubtitle: widget.emptySubtitle,
                emptyIcon: widget.emptyIcon,
                emptyActionText: widget.emptyActionText,
                errorActionText: widget.errorActionText,
              ),
              onRetry: () => _retry(PagedRetryType.init),
              onEmptyAction: widget.onEmptyAction,
            ),
          ),
        ],
      );
    }

    final count = _state.items.length;
    final sep = widget.separatorBuilder;

    if (sep != null) {
      return ListView.separated(
        controller: widget.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: widget.padding,
        itemCount: count,
        separatorBuilder: sep,
        itemBuilder: (context, index) {
          _maybePreload(index);
          return widget.itemBuilder(context, index, _state.items[index]);
        },
      );
    }

    return ListView.builder(
      controller: widget.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: widget.padding,
      itemCount: count,
      itemExtent: widget.itemExtent,
      itemBuilder: (context, index) {
        _maybePreload(index);
        return widget.itemBuilder(context, index, _state.items[index]);
      },
    );
  }
}
