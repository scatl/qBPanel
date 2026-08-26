import 'package:flutter/material.dart';
import 'package:qbpanel/log/model/log_day_section.dart';
import 'package:qbpanel/log/widget/log_date_header.dart';

/// 按日分组；滚动时仅保留一个吸顶标题，下一组标题顶掉上一组。
class LogStickyGroupedList<T> extends StatefulWidget {
  const LogStickyGroupedList({
    super.key,
    required this.sections,
    required this.itemBuilder,
    this.controller,
  });

  final List<LogDaySection<T>> sections;
  final Widget Function(BuildContext context, T entry) itemBuilder;
  final ScrollController? controller;

  @override
  State<LogStickyGroupedList<T>> createState() =>
      _LogStickyGroupedListState<T>();
}

class _LogStickyGroupedListState<T> extends State<LogStickyGroupedList<T>> {
  final _viewportKey = GlobalKey();
  final _headerKeys = <GlobalKey>[];
  ScrollController? _ownedController;
  String? _stickyLabel;
  int? _stuckSectionIndex;

  ScrollController get _scrollController =>
      widget.controller ?? _ownedController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _ownedController = ScrollController();
    }
    _syncHeaderKeys();
    _scrollController.addListener(_updateStickyLabel);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateStickyLabel());
  }

  @override
  void didUpdateWidget(covariant LogStickyGroupedList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncHeaderKeys();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateStickyLabel());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateStickyLabel);
    _ownedController?.dispose();
    super.dispose();
  }

  void _syncHeaderKeys() {
    while (_headerKeys.length < widget.sections.length) {
      _headerKeys.add(GlobalKey());
    }
    while (_headerKeys.length > widget.sections.length) {
      _headerKeys.removeLast();
    }
  }

  void _updateStickyLabel() {
    final viewportBox =
        _viewportKey.currentContext?.findRenderObject() as RenderBox?;
    if (viewportBox == null || !viewportBox.hasSize) return;

    final viewportTop = viewportBox.localToGlobal(Offset.zero).dy;
    String? label;
    int? stuckIndex;

    for (var i = 0; i < widget.sections.length; i++) {
      final headerContext = _headerKeys[i].currentContext;
      if (headerContext == null) continue;
      final headerBox = headerContext.findRenderObject() as RenderBox?;
      if (headerBox == null || !headerBox.hasSize) continue;

      final headerTop = headerBox.localToGlobal(Offset.zero).dy - viewportTop;
      if (headerTop <= 0) {
        label = widget.sections[i].dateLabel;
        stuckIndex = i;
      }
    }

    if (label == _stickyLabel && stuckIndex == _stuckSectionIndex) return;
    setState(() {
      _stickyLabel = label;
      _stuckSectionIndex = stuckIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: _viewportKey,
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (_) {
            _updateStickyLabel();
            return false;
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              for (var i = 0; i < widget.sections.length; i++) ...[
                SliverToBoxAdapter(
                  child: Opacity(
                    opacity: _stuckSectionIndex == i ? 0 : 1,
                    child: LogDateHeader(
                      key: _headerKeys[i],
                      label: widget.sections[i].dateLabel,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => widget.itemBuilder(
                      context,
                      widget.sections[i].entries[index],
                    ),
                    childCount: widget.sections[i].entries.length,
                  ),
                ),
              ],
              const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
            ],
          ),
        ),
        if (_stickyLabel != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: LogDateHeader(
                key: ValueKey(_stickyLabel),
                label: _stickyLabel!,
                filled: true,
              ),
            ),
          ),
      ],
    );
  }
}
