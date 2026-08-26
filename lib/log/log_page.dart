import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/log/main/main_log_tab.dart';
import 'package:qbpanel/log/main/main_log_view_model.dart';
import 'package:qbpanel/log/peer/peer_log_tab.dart';
import 'package:qbpanel/log/peer/peer_log_view_model.dart';
import 'package:qbpanel/widget/page_insets.dart';

class LogPage extends ConsumerStatefulWidget {
  const LogPage({super.key});

  @override
  ConsumerState<LogPage> createState() => _LogPageState();
}

class _LogPageState extends ConsumerState<LogPage>
    with TickerProviderStateMixin {
  static const _searchAnimDuration = Duration(milliseconds: 260);

  TabController? _tabController;
  AnimationController? _searchAnim;
  Animation<double>? _searchProgress;

  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  bool _searchActive = false;

  void _ensureControllers() {
    _tabController ??= TabController(length: 2, vsync: this)
      ..addListener(_onTabChanged);

    if (_searchAnim != null) return;
    _searchAnim = AnimationController(
      vsync: this,
      duration: _searchAnimDuration,
    );
    _searchProgress = CurvedAnimation(
      parent: _searchAnim!,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );
  }

  @override
  void initState() {
    super.initState();
    _ensureControllers();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncPollingForTab(_tabController!.index);
    });
  }

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    _tabController?.dispose();
    _searchAnim?.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController!.indexIsChanging) return;
    _syncPollingForTab(_tabController!.index);
  }

  void _syncPollingForTab(int index) {
    ref.read(mainLogProvider.notifier).setPollingEnabled(index == 0);
    ref.read(peerLogProvider.notifier).setPollingEnabled(index == 1);
  }

  Future<void> _openSearch() async {
    if (_searchActive) return;
    setState(() => _searchActive = true);
    await _searchAnim!.forward(from: 0);
    if (!mounted) return;
    _searchFocusNode.requestFocus();
  }

  Future<void> _closeSearch() async {
    _searchFocusNode.unfocus();
    await _searchAnim!.reverse();
    if (!mounted) return;
    _searchController.clear();
    _onSearchChanged('');
    setState(() => _searchActive = false);
  }

  void _onSearchChanged(String value) {
    ref.read(mainLogProvider.notifier).setSearchQuery(value);
    ref.read(peerLogProvider.notifier).setSearchQuery(value);
  }

  @override
  Widget build(BuildContext context) {
    _ensureControllers();

    final searchProgress = _searchProgress!;

    return AnimatedBuilder(
      animation: searchProgress,
      builder: (context, body) {
        final t = searchProgress.value;
        final titleSpacing = 16 - (12 * t);

        return Scaffold(
          appBar: AppBar(
            titleSpacing: titleSpacing,
            title: _LogAppBarSearchTitle(
              progress: searchProgress,
              showSearchField: _searchActive,
              controller: _searchController,
              focusNode: _searchFocusNode,
              onClose: _closeSearch,
              onChanged: _onSearchChanged,
            ),
            actions: [
              ClipRect(
                child: Align(
                  alignment: Alignment.centerRight,
                  widthFactor: (1 - t).clamp(0.0, 1.0),
                  child: Opacity(
                    opacity: (1 - t).clamp(0.0, 1.0),
                    child: IgnorePointer(
                      ignoring: t > 0.01,
                      child: IconButton(
                        tooltip: '搜索',
                        icon: const Icon(Icons.search),
                        onPressed: _openSearch,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: PageInsets.horizontal * t),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: '普通'),
                Tab(text: '封禁 IP'),
              ],
            ),
          ),
          body: body,
        );
      },
      child: TabBarView(
        controller: _tabController,
        children: const [
          MainLogTab(),
          PeerLogTab(),
        ],
      ),
    );
  }
}

class _LogAppBarSearchTitle extends StatelessWidget {
  const _LogAppBarSearchTitle({
    required this.progress,
    required this.showSearchField,
    required this.controller,
    required this.focusNode,
    required this.onClose,
    required this.onChanged,
  });

  final Animation<double> progress;
  final bool showSearchField;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClose;
  final ValueChanged<String> onChanged;

  static const _fieldHeight = 40.0;
  static const _fieldRadius = 20.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        final t = progress.value;
        final titleOpacity = (1 - t * 1.4).clamp(0.0, 1.0);
        final fieldOpacity = t.clamp(0.0, 1.0);
        final fieldScale = 0.94 + (0.06 * t);

        return SizedBox(
          height: _fieldHeight,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.centerLeft,
            clipBehavior: Clip.none,
            children: [
              Opacity(
                opacity: titleOpacity,
                child: Text(
                  '日志',
                  style: textTheme.titleLarge,
                ),
              ),
              if (showSearchField)
                Positioned.fill(
                  child: Opacity(
                    opacity: fieldOpacity,
                    child: Transform.scale(
                      scale: fieldScale,
                      alignment: Alignment.centerLeft,
                      child: Material(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(_fieldRadius),
                        clipBehavior: Clip.antiAlias,
                        child: TextField(
                          controller: controller,
                          focusNode: focusNode,
                          style: textTheme.bodyMedium,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            hintText: '搜索日志…',
                            hintStyle: textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            suffixIcon: IconButton(
                              tooltip: '关闭搜索',
                              icon: Icon(
                                Icons.close,
                                size: 20,
                                color: scheme.onSurfaceVariant,
                              ),
                              onPressed: onClose,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          onChanged: onChanged,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
