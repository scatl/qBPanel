import 'package:flutter/material.dart';
import 'package:qbpanel/detail/content/torrent_content_node.dart';
import 'package:qbpanel/detail/content/widget/torrent_content_item.dart';

class TorrentContentTree extends StatelessWidget {
  const TorrentContentTree({
    super.key,
    required this.roots,
    required this.collapsedPaths,
    required this.onToggle,
    required this.onPriorityChanged,
    this.onLongPress,
    this.showTransferStats = true,
  });

  final List<TorrentContentNode> roots;
  final Set<String> collapsedPaths;
  final ValueChanged<String> onToggle;
  final void Function(TorrentContentNode node, int priority) onPriorityChanged;
  final ValueChanged<TorrentContentNode>? onLongPress;
  final bool showTransferStats;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < roots.length; i++)
          _ContentBranch(
            key: ValueKey(roots[i].path),
            node: roots[i],
            depth: 0,
            isLast: i == roots.length - 1,
            ancestorContinues: const [],
            collapsedPaths: collapsedPaths,
            showTransferStats: showTransferStats,
            onToggle: onToggle,
            onPriorityChanged: onPriorityChanged,
            onLongPress: onLongPress,
          ),
      ],
    );
  }
}

class _ContentBranch extends StatelessWidget {
  const _ContentBranch({
    super.key,
    required this.node,
    required this.depth,
    required this.isLast,
    required this.ancestorContinues,
    required this.collapsedPaths,
    required this.showTransferStats,
    required this.onToggle,
    required this.onPriorityChanged,
    this.onLongPress,
  });

  final TorrentContentNode node;
  final int depth;
  final bool isLast;
  final List<bool> ancestorContinues;
  final Set<String> collapsedPaths;
  final bool showTransferStats;
  final ValueChanged<String> onToggle;
  final void Function(TorrentContentNode node, int priority) onPriorityChanged;
  final ValueChanged<TorrentContentNode>? onLongPress;

  @override
  Widget build(BuildContext context) {
    final expanded = !collapsedPaths.contains(node.path);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TorrentContentItem(
          row: TorrentContentRow(node: node, depth: depth),
          expanded: expanded,
          isLast: isLast,
          ancestorContinues: ancestorContinues,
          showTransferStats: showTransferStats,
          onToggleExpand: node.isFolder ? () => onToggle(node.path) : null,
          onPriorityChanged: (priority) => onPriorityChanged(node, priority),
          onLongPress: onLongPress == null ? null : () => onLongPress!(node),
        ),
        if (node.isFolder)
          _ExpandableChildren(
            expanded: expanded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < node.children.length; i++)
                  _ContentBranch(
                    key: ValueKey(node.children[i].path),
                    node: node.children[i],
                    depth: depth + 1,
                    isLast: i == node.children.length - 1,
                    ancestorContinues: [
                      ...ancestorContinues,
                      if (depth > 0) !isLast,
                    ],
                    collapsedPaths: collapsedPaths,
                    showTransferStats: showTransferStats,
                    onToggle: onToggle,
                    onPriorityChanged: onPriorityChanged,
                    onLongPress: onLongPress,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ExpandableChildren extends StatefulWidget {
  const _ExpandableChildren({required this.expanded, required this.child});

  final bool expanded;
  final Widget child;

  @override
  State<_ExpandableChildren> createState() => _ExpandableChildrenState();
}

class _ExpandableChildrenState extends State<_ExpandableChildren>
    with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 220);

  late final AnimationController _controller;
  late final Animation<double> _sizeFactor;
  late bool _holdChild;

  @override
  void initState() {
    super.initState();
    _holdChild = widget.expanded;
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
      value: widget.expanded ? 1 : 0,
    );
    _sizeFactor = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _controller.addStatusListener(_onStatus);
  }

  @override
  void didUpdateWidget(covariant _ExpandableChildren oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expanded == oldWidget.expanded) return;
    if (widget.expanded) {
      _holdChild = true;
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.dismissed && !widget.expanded && _holdChild) {
      setState(() => _holdChild = false);
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onStatus);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_holdChild && !widget.expanded) {
      return const SizedBox(width: double.infinity);
    }
    return SizeTransition(
      alignment: Alignment.topCenter,
      sizeFactor: _sizeFactor,
      child: widget.child,
    );
  }
}
