import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qbpanel/api/entity/response/search_plugin_response.dart';
import 'package:qbpanel/router/router_path.dart';
import 'package:qbpanel/search/entity/search_result_filter.dart';
import 'package:qbpanel/search/search_ui_state.dart';
import 'package:qbpanel/search/search_view_model.dart';
import 'package:qbpanel/search/ui/search_filter_sheet.dart';
import 'package:qbpanel/search/ui/search_result_action_dialog.dart';
import 'package:qbpanel/search/ui/search_result_item.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';
import 'package:qbpanel/widget/page_insets.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _patternController = TextEditingController();
  final _resultFilterController = TextEditingController();
  final _patternFocus = FocusNode();
  bool _searchFormExpanded = true;

  @override
  void dispose() {
    _patternController.dispose();
    _resultFilterController.dispose();
    _patternFocus.unfocus();
    _patternFocus.dispose();
    super.dispose();
  }

  Future<void> _submitSearch() async {
    _patternFocus.unfocus();
    await ref.read(searchProvider.notifier).startSearch();
    if (!mounted) return;
    if (ref.read(searchProvider).hasSearchJob) {
      setState(() => _searchFormExpanded = false);
    }
  }

  void _expandSearchForm() {
    setState(() => _searchFormExpanded = true);
  }

  void _collapseSearchForm() {
    _patternFocus.unfocus();
    setState(() => _searchFormExpanded = false);
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(searchProvider);
    final vm = ref.read(searchProvider.notifier);
    final scheme = Theme.of(context).colorScheme;
    final rangeFiltering = ui.resultFilter.isActive;
    final showExpandedForm = !ui.hasSearchJob || _searchFormExpanded;

    return Scaffold(
      appBar: AppBar(
        title: const Text('搜索种子'),
        actions: [
          if (ui.hasSearchJob)
            IconButton(
              tooltip: rangeFiltering ? '筛选中' : '筛选结果',
              icon: Icon(
                Icons.filter_alt_outlined,
                color: rangeFiltering ? scheme.primary : null,
              ),
              onPressed: () => SearchFilterSheet.show(context),
            ),
          if (ui.isRunning)
            IconButton(
              tooltip: '停止搜索',
              icon: const Icon(Icons.stop_circle_outlined),
              onPressed: vm.stopSearch,
            ),
          IconButton(
            tooltip: '搜索插件',
            icon: const Icon(Icons.extension_outlined),
            onPressed: () async {
              await context.push(RouterPath.searchPlugins);
              if (!context.mounted) return;
              ref.read(searchProvider.notifier).reloadPlugins();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeInOutCubic,
            alignment: Alignment.topCenter,
            child: showExpandedForm
                ? _SearchFormSection(
                    ui: ui,
                    patternController: _patternController,
                    patternFocus: _patternFocus,
                    onPatternChanged: vm.setPatternInput,
                    onCategoryChanged: vm.setCategory,
                    onPluginChanged: vm.setPluginMode,
                    onSubmit: _submitSearch,
                    onCollapse:
                        ui.hasSearchJob ? _collapseSearchForm : null,
                  )
                : _CollapsedSearchBar(
                    ui: ui,
                    onExpand: _expandSearchForm,
                  ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (ui.isRunning) _SearchProgressBar(ui: ui),
                if (ui.hasSearchJob)
                  _ResultFilterField(
                    controller: _resultFilterController,
                    onChanged: vm.setResultFilterQuery,
                  ),
                Expanded(
                  child: EmptyStateHost(
                    state: ui.emptyState,
                    onEmptyAction: ui.resultFiltering
                        ? () {
                            _resultFilterController.clear();
                            vm.clearResultFilter();
                          }
                        : null,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: ui.displayedResults.length,
                      itemBuilder: (context, index) {
                        final result = ui.displayedResults[index];
                        return SearchResultItem(
                          result: result,
                          onTap: () => SearchResultActionDialog.show(
                            context: context,
                            result: result,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchFormSection extends StatelessWidget {
  const _SearchFormSection({
    required this.ui,
    required this.patternController,
    required this.patternFocus,
    required this.onPatternChanged,
    required this.onCategoryChanged,
    required this.onPluginChanged,
    required this.onSubmit,
    this.onCollapse,
  });

  final SearchUiState ui;
  final TextEditingController patternController;
  final FocusNode patternFocus;
  final ValueChanged<String> onPatternChanged;
  final ValueChanged<String> onCategoryChanged;
  final void Function(SearchPluginMode mode, {String? pluginName}) onPluginChanged;
  final Future<void> Function() onSubmit;
  final VoidCallback? onCollapse;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainerLow,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          PageInsets.horizontal,
          12,
          PageInsets.horizontal,
          onCollapse != null ? 0 : 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: patternController,
              focusNode: patternFocus,
              enabled: !ui.pluginsLoading && !ui.isRunning,
              textInputAction: TextInputAction.search,
              onChanged: onPatternChanged,
              onSubmitted: (_) {
                if (ui.canSearch) onSubmit();
              },
              decoration: InputDecoration(
                hintText: '搜索关键词',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: ui.patternInput.isEmpty
                    ? null
                    : IconButton(
                        tooltip: '清除',
                        icon: const Icon(Icons.clear),
                        onPressed: ui.isRunning
                            ? null
                            : () {
                                patternController.clear();
                                onPatternChanged('');
                              },
                      ),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _CategoryDropdown(
                    options: ui.categoryOptions,
                    value: ui.selectedCategoryId,
                    enabled: !ui.pluginsLoading && !ui.isRunning,
                    onChanged: onCategoryChanged,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _PluginDropdown(
                    plugins: ui.plugins,
                    mode: ui.pluginMode,
                    selectedPluginName: ui.selectedPluginName,
                    enabled: !ui.pluginsLoading && !ui.isRunning,
                    onChanged: onPluginChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: ui.canSearch ? onSubmit : null,
              icon: ui.startingSearch
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: scheme.onPrimary,
                      ),
                    )
                  : const Icon(Icons.travel_explore_outlined),
              label: Text(ui.startingSearch ? '启动中…' : '搜索'),
            ),
            if (onCollapse != null)
              IconButton(
                tooltip: '收起',
                onPressed: onCollapse,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minHeight: 36),
                icon: Icon(
                  Icons.keyboard_arrow_up_rounded,
                  color: scheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CollapsedSearchBar extends StatelessWidget {
  const _CollapsedSearchBar({
    required this.ui,
    required this.onExpand,
  });

  final SearchUiState ui;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final pattern = ui.searchPattern.isNotEmpty
        ? ui.searchPattern
        : ui.patternInput.trim();
    final subtitle =
        '${_categoryLabel(ui)} · ${_pluginLabel(ui)}';

    return Material(
      color: scheme.surfaceContainerLow,
      child: InkWell(
        onTap: onExpand,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
          child: Row(
            children: [
              IconButton(
                tooltip: '展开搜索条件',
                onPressed: onExpand,
                icon: const Icon(Icons.search),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pattern.isEmpty ? '搜索条件' : pattern,
                      style: textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: '展开搜索条件',
                onPressed: onExpand,
                icon: const Icon(Icons.unfold_more),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _categoryLabel(SearchUiState ui) {
  for (final option in ui.categoryOptions) {
    if (option.id == ui.selectedCategoryId) {
      return option.name;
    }
  }
  return ui.selectedCategoryId;
}

String _pluginLabel(SearchUiState ui) {
  return switch (ui.pluginMode) {
    SearchPluginMode.enabled => '已启用插件',
    SearchPluginMode.all => '全部插件',
    SearchPluginMode.single => () {
        for (final plugin in ui.plugins) {
          if (plugin.name == ui.selectedPluginName) {
            return plugin.fullName.isNotEmpty ? plugin.fullName : plugin.name;
          }
        }
        return ui.selectedPluginName ?? '指定插件';
      }(),
  };
}

class _ResultFilterField extends StatefulWidget {
  const _ResultFilterField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  State<_ResultFilterField> createState() => _ResultFilterFieldState();
}

class _ResultFilterFieldState extends State<_ResultFilterField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PageInsets.horizontal,
        8,
        PageInsets.horizontal,
        4,
      ),
      child: TextField(
        controller: widget.controller,
        textInputAction: TextInputAction.search,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: '筛选结果名称…',
          prefixIcon: const Icon(Icons.filter_list_outlined),
          suffixIcon: widget.controller.text.isEmpty
              ? null
              : IconButton(
                  tooltip: '清除',
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onChanged('');
                  },
                ),
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}

class _SearchProgressBar extends StatelessWidget {
  const _SearchProgressBar({required this.ui});

  final SearchUiState ui;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final visible = ui.displayedResults.length;
    final total = ui.totalResults;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(
          minHeight: 3,
          backgroundColor: scheme.surfaceContainerHighest,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            PageInsets.horizontal,
            8,
            PageInsets.horizontal,
            0,
          ),
          child: Text(
            visible == total
                ? '搜索中 · 已找到 $total 条'
                : '搜索中 · 已找到 $total 条（显示 $visible 条）',
            style: textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({
    required this.options,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final List<SearchCategoryOption> options;
  final String value;
  final bool enabled;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: options.any((o) => o.id == value) ? value : options.first.id,
      decoration: const InputDecoration(
        labelText: '分类',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      items: options
          .map(
            (option) => DropdownMenuItem(
              value: option.id,
              child: Text(option.name, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(growable: false),
      selectedItemBuilder: (context) => options
          .map(
            (option) => Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                option.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          )
          .toList(growable: false),
      onChanged: enabled ? (next) => onChanged(next ?? 'all') : null,
    );
  }
}

class _PluginDropdown extends StatelessWidget {
  const _PluginDropdown({
    required this.plugins,
    required this.mode,
    required this.selectedPluginName,
    required this.enabled,
    required this.onChanged,
  });

  final List<SearchPluginResponse> plugins;
  final SearchPluginMode mode;
  final String? selectedPluginName;
  final bool enabled;
  final void Function(SearchPluginMode mode, {String? pluginName}) onChanged;

  String get _value {
    return switch (mode) {
      SearchPluginMode.enabled => '__enabled__',
      SearchPluginMode.all => '__all__',
      SearchPluginMode.single => selectedPluginName ?? '__enabled__',
    };
  }

  @override
  Widget build(BuildContext context) {
    final items = <DropdownMenuItem<String>>[
      const DropdownMenuItem(
        value: '__enabled__',
        child: Text('已启用插件'),
      ),
      const DropdownMenuItem(
        value: '__all__',
        child: Text('全部插件'),
      ),
      ...plugins.map(
        (plugin) => DropdownMenuItem(
          value: plugin.name,
          child: Text(
            plugin.fullName.isNotEmpty ? plugin.fullName : plugin.name,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ];

    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: items.any((item) => item.value == _value)
          ? _value
          : '__enabled__',
      decoration: const InputDecoration(
        labelText: '插件',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      items: items,
      selectedItemBuilder: (context) => items
          .map(
            (item) => Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                _itemLabel(item.value!),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          )
          .toList(growable: false),
      onChanged: enabled
          ? (next) {
              switch (next) {
                case '__enabled__':
                  onChanged(SearchPluginMode.enabled);
                case '__all__':
                  onChanged(SearchPluginMode.all);
                case null:
                  break;
                default:
                  onChanged(SearchPluginMode.single, pluginName: next);
              }
            }
          : null,
    );
  }

  String _itemLabel(String value) {
    return switch (value) {
      '__enabled__' => '已启用插件',
      '__all__' => '全部插件',
      _ => () {
          for (final plugin in plugins) {
            if (plugin.name == value) {
              return plugin.fullName.isNotEmpty ? plugin.fullName : plugin.name;
            }
          }
          return value;
        }(),
    };
  }
}
