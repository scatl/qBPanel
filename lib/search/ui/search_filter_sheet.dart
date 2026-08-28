import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/search/entity/search_result_filter.dart';
import 'package:qbpanel/search/search_view_model.dart';
import 'package:qbpanel/widget/page_insets.dart';
import 'package:qbpanel/widget/sheet/blur_modal_bottom_sheet.dart';

class SearchFilterSheet extends ConsumerStatefulWidget {
  const SearchFilterSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showBlurModalBottomSheet<void>(
      context: context,
      builder: (context) {
        final height = MediaQuery.sizeOf(context).height * 0.72;
        return SizedBox(
          height: height,
          child: const ScaffoldMessenger(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SearchFilterSheet(),
            ),
          ),
        );
      },
    );
  }

  @override
  ConsumerState<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends ConsumerState<SearchFilterSheet> {
  late final TextEditingController _minSeeders;
  late final TextEditingController _maxSeeders;
  late final TextEditingController _minSize;
  late final TextEditingController _maxSize;
  late SearchSizeUnit _minSizeUnit;
  late SearchSizeUnit _maxSizeUnit;

  @override
  void initState() {
    super.initState();
    final filter = ref.read(searchProvider).resultFilter;
    _minSeeders = TextEditingController(
      text: filter.minSeeders > 0 ? '${filter.minSeeders}' : '',
    );
    _maxSeeders = TextEditingController(
      text: filter.maxSeeders > 0 ? '${filter.maxSeeders}' : '',
    );
    _minSize = TextEditingController(
      text: filter.minSizeValue > 0 ? '${filter.minSizeValue}' : '',
    );
    _maxSize = TextEditingController(
      text: filter.maxSizeValue > 0 ? '${filter.maxSizeValue}' : '',
    );
    _minSizeUnit = SearchSizeUnit.fromPower(filter.minSizeUnit);
    _maxSizeUnit = SearchSizeUnit.fromPower(filter.maxSizeUnit);
  }

  @override
  void dispose() {
    _minSeeders.dispose();
    _maxSeeders.dispose();
    _minSize.dispose();
    _maxSize.dispose();
    super.dispose();
  }

  void _apply() {
    final filter = SearchResultFilter(
      minSeeders: int.tryParse(_minSeeders.text.trim()) ?? 0,
      maxSeeders: int.tryParse(_maxSeeders.text.trim()) ?? 0,
      minSizeValue: double.tryParse(_minSize.text.trim()) ?? 0,
      minSizeUnit: _minSizeUnit.power,
      maxSizeValue: double.tryParse(_maxSize.text.trim()) ?? 0,
      maxSizeUnit: _maxSizeUnit.power,
    );
    ref.read(searchProvider.notifier).setResultFilter(filter);
    Navigator.of(context).pop();
  }

  void _clear() {
    ref.read(searchProvider.notifier).setResultFilter(const SearchResultFilter());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final filtering = ref.watch(
      searchProvider.select((s) => s.resultFilter.isActive),
    );
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(l10n.resultFilter, style: textTheme.titleMedium),
              ),
              TextButton(
                onPressed: filtering ? _clear : null,
                child: Text(l10n.actionClear),
              ),
            ],
          ),
        ),
        Padding(
          padding: PageInsets.content,
          child: Text(
            l10n.resultFilterHint,
            style: textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _RangeSection(
          title: l10n.seeders,
          minController: _minSeeders,
          maxController: _maxSeeders,
        ),
        const SizedBox(height: 16),
        _SizeRangeSection(
          title: l10n.sortSize,
          minController: _minSize,
          maxController: _maxSize,
          minUnit: _minSizeUnit,
          maxUnit: _maxSizeUnit,
          onMinUnitChanged: (unit) => setState(() => _minSizeUnit = unit),
          onMaxUnitChanged: (unit) => setState(() => _maxSizeUnit = unit),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: FilledButton(
            onPressed: _apply,
            child: Text(l10n.actionApply),
          ),
        ),
      ],
    );
  }
}

class _RangeSection extends StatelessWidget {
  const _RangeSection({
    required this.title,
    required this.minController,
    required this.maxController,
  });

  final String title;
  final TextEditingController minController;
  final TextEditingController maxController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PageInsets.content,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: minController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: context.l10n.minValue,
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(context.l10n.rangeTo),
              ),
              Expanded(
                child: TextField(
                  controller: maxController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: context.l10n.maxValue,
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SizeRangeSection extends StatelessWidget {
  const _SizeRangeSection({
    required this.title,
    required this.minController,
    required this.maxController,
    required this.minUnit,
    required this.maxUnit,
    required this.onMinUnitChanged,
    required this.onMaxUnitChanged,
  });

  final String title;
  final TextEditingController minController;
  final TextEditingController maxController;
  final SearchSizeUnit minUnit;
  final SearchSizeUnit maxUnit;
  final ValueChanged<SearchSizeUnit> onMinUnitChanged;
  final ValueChanged<SearchSizeUnit> onMaxUnitChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PageInsets.content,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: minController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: context.l10n.minValue,
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 92,
                child: DropdownButtonFormField<SearchSizeUnit>(
                  value: minUnit,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: SearchSizeUnit.values
                      .map(
                        (unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(unit.label),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value != null) onMinUnitChanged(value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: maxController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: context.l10n.maxValue,
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 92,
                child: DropdownButtonFormField<SearchSizeUnit>(
                  value: maxUnit,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: SearchSizeUnit.values
                      .map(
                        (unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(unit.label),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value != null) onMaxUnitChanged(value);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
