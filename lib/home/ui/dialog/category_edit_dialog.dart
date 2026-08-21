import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/entity/response/torrent_category_response.dart';
import 'package:qbpanel/home/home_page_view_model.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';

enum CategoryEditMode { create, createSubcategory, edit }

class CategoryEditDialog extends ConsumerStatefulWidget {
  const CategoryEditDialog({
    super.key,
    required this.animation,
    required this.mode,
    this.parentPath,
    this.categoryName,
  });

  final Animation<double> animation;
  final CategoryEditMode mode;
  final String? parentPath;
  final String? categoryName;

  static Future<bool?> show(
    BuildContext context, {
    required CategoryEditMode mode,
    String? parentPath,
    String? categoryName,
  }) {
    return showGeneralDialog<bool>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: BlurDialogMotion.duration,
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return CategoryEditDialog(
          animation: animation,
          mode: mode,
          parentPath: parentPath,
          categoryName: categoryName,
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
    );
  }

  @override
  ConsumerState<CategoryEditDialog> createState() => _CategoryEditDialogState();
}

class _CategoryEditDialogState extends ConsumerState<CategoryEditDialog> {
  final _nameController = TextEditingController();
  final _parentPathController = TextEditingController();
  final _savePathController = TextEditingController();
  final _downloadPathController = TextEditingController();

  bool _ready = false;
  bool _saving = false;
  String? _nameError;
  String? _submitError;
  String? _defaultSavePath;
  CategoryIncompletePathMode _incompletePathMode =
      CategoryIncompletePathMode.followDefault;

  bool get _isEdit => widget.mode == CategoryEditMode.edit;
  bool get _isSubcategory => widget.mode == CategoryEditMode.createSubcategory;

  String get _title => switch (widget.mode) {
        CategoryEditMode.create => '添加分类',
        CategoryEditMode.createSubcategory => '添加子分类',
        CategoryEditMode.edit => '编辑分类',
      };

  @override
  void initState() {
    super.initState();
    _parentPathController.text = widget.parentPath ?? '';
    if (_isEdit) {
      final name = widget.categoryName ?? '';
      _nameController.text = name;
      final category = ref.read(homePageProvider.notifier).categoryOf(name);
      _savePathController.text = category?.savePath ?? '';
      final incomplete = category?.downloadPath;
      _incompletePathMode =
          incomplete?.mode ?? CategoryIncompletePathMode.followDefault;
      if (_incompletePathMode == CategoryIncompletePathMode.yes) {
        _downloadPathController.text = incomplete?.path ?? '';
      }
    }
    _nameController.addListener(_onNameChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDefaultSavePath();
    });
  }

  void _onNameChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadDefaultSavePath() async {
    final path =
        await ref.read(homePageProvider.notifier).fetchDefaultSavePath();
    if (!mounted) return;
    _defaultSavePath = path;
    setState(() => _ready = true);
  }

  /// 新建：`defaultSavePath/名称`；子分类：`defaultSavePath/父分类/名称`。
  String get _savePathHint {
    final base = (_defaultSavePath ?? '').replaceAll(RegExp(r'[/\\]+$'), '');
    if (base.isEmpty) return '';
    final name = _fullCategoryName(_nameController.text.trim());
    if (name.isEmpty) return '$base/';
    return '$base/$name';
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    _parentPathController.dispose();
    _savePathController.dispose();
    _downloadPathController.dispose();
    super.dispose();
  }

  String _fullCategoryName(String name) {
    if (!_isSubcategory) return name;
    final parent = widget.parentPath?.trim() ?? '';
    if (parent.isEmpty) return name;
    return '$parent/$name';
  }

  String? _validateName(String name) {
    if (name.isEmpty) return '请输入分类名称';
    if (name.contains('\\') ||
        name.startsWith('/') ||
        name.endsWith('/') ||
        name.contains('//')) {
      return '分类名称无效';
    }
    return null;
  }

  Future<void> _onConfirm() async {
    FocusScope.of(context).unfocus();
    final name = _nameController.text.trim();
    final nameError = _validateName(name);
    setState(() {
      _nameError = nameError;
      _submitError = null;
    });
    if (nameError != null) return;

    setState(() => _saving = true);
    final vm = ref.read(homePageProvider.notifier);
    final error = _isEdit
        ? await vm.editCategory(
            name: _fullCategoryName(name),
            savePath: _savePathController.text.trim(),
            incompletePathMode: _incompletePathMode,
            downloadPath: _downloadPathController.text,
          )
        : await vm.createCategory(
            name: _fullCategoryName(name),
            savePath: _savePathController.text.trim(),
            incompletePathMode: _incompletePathMode,
            downloadPath: _downloadPathController.text,
          );
    if (!mounted) return;
    if (error != null) {
      setState(() {
        _saving = false;
        _submitError = error;
      });
      return;
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dialogWidth = MediaQuery.sizeOf(context).width * 0.85;

    return BlurDialogScaffold(
      animation: widget.animation,
      onBarrierTap: _saving ? null : () => Navigator.of(context).pop(false),
      panelConstraints: BoxConstraints.tightFor(width: dialogWidth),
      panelPadding: const EdgeInsets.fromLTRB(24, 22, 24, 16),
      child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _title,
                style: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
              ),
              const SizedBox(height: 16),
              if (!_ready)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    ),
                  ),
                )
              else ...[
                if (_isSubcategory) ...[
                  TextField(
                    controller: _parentPathController,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: '父分类',
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                TextField(
                  controller: _nameController,
                  enabled: !_isEdit && !_saving,
                  autofocus: !_isEdit,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) {
                    setState(() {
                      if (_nameError != null) _nameError = null;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: '分类名称',
                    errorText: _nameError,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _savePathController,
                  enabled: !_saving,
                  minLines: 1,
                  maxLines: 3,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: '保存路径',
                    hintText: _isEdit && _savePathController.text.isNotEmpty
                        ? null
                        : _savePathHint,
                    hintMaxLines: 3,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintStyle: textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '对不完整的 Torrent 使用另一个路径',
                  style: textTheme.titleSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                SegmentedButton<CategoryIncompletePathMode>(
                  showSelectedIcon: false,
                  expandedInsets: EdgeInsets.zero,
                  segments: const [
                    ButtonSegment(
                      value: CategoryIncompletePathMode.followDefault,
                      label: Text('默认'),
                    ),
                    ButtonSegment(
                      value: CategoryIncompletePathMode.yes,
                      label: Text('是'),
                    ),
                    ButtonSegment(
                      value: CategoryIncompletePathMode.no,
                      label: Text('否'),
                    ),
                  ],
                  selected: {_incompletePathMode},
                  onSelectionChanged: _saving
                      ? null
                      : (value) {
                          setState(() {
                            _incompletePathMode = value.first;
                          });
                        },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _downloadPathController,
                  enabled: !_saving &&
                      _incompletePathMode == CategoryIncompletePathMode.yes,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _onConfirm(),
                  decoration: const InputDecoration(
                    labelText: '路径',
                  ),
                ),
                if (_submitError != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _submitError!,
                    style: textTheme.bodySmall?.copyWith(color: scheme.error),
                  ),
                ],
              ],
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:
                        _saving ? null : () => Navigator.of(context).pop(false),
                    child: const Text('取消'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: (_ready && !_saving) ? _onConfirm : null,
                    child: _saving
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: scheme.onPrimary,
                            ),
                          )
                        : const Text('确定'),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}
