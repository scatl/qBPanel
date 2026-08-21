import 'package:flutter/material.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';

class DetailSortOption<T> {
  const DetailSortOption({required this.value, required this.label});

  final T value;
  final String label;
}

abstract final class DetailSortDialog {
  DetailSortDialog._();

  static Future<void> show<T>({
    required BuildContext context,
    required String title,
    required List<DetailSortOption<T>> options,
    required T selected,
    required bool ascending,
    required void Function(T value) onSelect,
  }) {
    return showGeneralDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: BlurDialogMotion.duration,
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return BlurDialogScaffold(
          animation: animation,
          onBarrierTap: () => Navigator.of(ctx).pop(),
          panelConstraints: const BoxConstraints(minWidth: 220, maxWidth: 280),
          panelPadding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: _DetailSortContent<T>(
            title: title,
            options: options,
            selected: selected,
            ascending: ascending,
            onSelect: onSelect,
          ),
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
    );
  }
}

class _DetailSortContent<T> extends StatefulWidget {
  const _DetailSortContent({
    required this.title,
    required this.options,
    required this.selected,
    required this.ascending,
    required this.onSelect,
  });

  final String title;
  final List<DetailSortOption<T>> options;
  final T selected;
  final bool ascending;
  final ValueChanged<T> onSelect;

  @override
  State<_DetailSortContent<T>> createState() => _DetailSortContentState<T>();
}

class _DetailSortContentState<T> extends State<_DetailSortContent<T>> {
  late T _selected = widget.selected;
  late bool _ascending = widget.ascending;
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onTap(T value) {
    setState(() {
      if (_selected == value) {
        _ascending = !_ascending;
      } else {
        _selected = value;
        _ascending = true;
      }
    });
    widget.onSelect(value);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.title,
          style: textTheme.titleMedium?.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.5,
          ),
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  for (final option in widget.options)
                    _SortTile(
                      label: option.label,
                      selected: option.value == _selected,
                      ascending: _ascending,
                      onTap: () => _onTap(option.value),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SortTile extends StatelessWidget {
  const _SortTile({
    required this.label,
    required this.selected,
    required this.ascending,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool ascending;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            children: [
              SizedBox(
                width: 22,
                child: selected
                    ? Icon(
                        ascending ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 16,
                        color: scheme.primary,
                      )
                    : null,
              ),
              Expanded(
                child: Text(
                  label,
                  style: textTheme.bodyMedium?.copyWith(
                    color: selected ? scheme.primary : scheme.onSurface,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
