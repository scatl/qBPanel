import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:qbpanel/add/add_torrent_ui_state.dart';
import 'package:qbpanel/add/add_torrent_view_model.dart';
import 'package:qbpanel/add/ui/add_torrent_files_section.dart';
import 'package:qbpanel/add/ui/add_torrent_import_section.dart';
import 'package:qbpanel/add/ui/add_torrent_info_section.dart';
import 'package:qbpanel/add/ui/add_torrent_link_dialog.dart';
import 'package:qbpanel/add/ui/add_torrent_save_section.dart';
import 'package:qbpanel/add/ui/add_torrent_settings_section.dart';
import 'package:qbpanel/home/entity/torrent_category_node.dart';
import 'package:qbpanel/home/home_page_view_model.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';

class AddTorrentPage extends ConsumerStatefulWidget {
  const AddTorrentPage({
    super.key,
    this.initialUrl,
    this.initialTorrentPath,
  });

  /// 外部打开的磁力 / HTTP(S) 等。
  final String? initialUrl;

  /// 外部打开的 .torrent 临时文件路径。
  final String? initialTorrentPath;

  @override
  ConsumerState<AddTorrentPage> createState() => _AddTorrentPageState();
}

class _AddTorrentPageState extends ConsumerState<AddTorrentPage> {
  final _savePathController = TextEditingController();
  final _incompletePathController = TextEditingController();
  final _renameController = TextEditingController();
  final _dlLimitController = TextEditingController();
  final _upLimitController = TextEditingController();
  var _routeImportStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _importFromRouteArgs();
    });
  }

  @override
  void dispose() {
    _deleteTempTorrentIfNeeded();
    _savePathController.dispose();
    _incompletePathController.dispose();
    _renameController.dispose();
    _dlLimitController.dispose();
    _upLimitController.dispose();
    super.dispose();
  }

  Future<void> _importFromRouteArgs() async {
    if (_routeImportStarted) return;
    _routeImportStarted = true;

    final url = widget.initialUrl?.trim();
    if (url != null && url.isNotEmpty) {
      ref.read(addTorrentProvider.notifier).importMagnet(url);
      return;
    }

    final path = widget.initialTorrentPath?.trim();
    if (path == null || path.isEmpty) return;

    try {
      final file = File(path);
      if (!await file.exists()) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('无法读取种子文件')),
        );
        return;
      }
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      if (bytes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('无法读取种子文件')),
        );
        return;
      }
      final name = p.basename(path);
      ref.read(addTorrentProvider.notifier).importFile(
            name.isEmpty ? 'torrent.torrent' : name,
            bytes,
          );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('无法读取种子文件')),
      );
    }
  }

  void _deleteTempTorrentIfNeeded() {
    final path = widget.initialTorrentPath?.trim();
    if (path == null || path.isEmpty) return;
    if (!path.contains('${p.separator}inbound_torrents${p.separator}') &&
        !path.contains('/inbound_torrents/')) {
      return;
    }
    try {
      final file = File(path);
      if (file.existsSync()) file.deleteSync();
    } catch (_) {}
  }

  Future<void> _importMagnet() async {
    final url = await AddTorrentLinkDialog.show(
      context,
      initialUrl: ref.read(addTorrentProvider).sourceUrl,
    );
    if (!mounted || url == null) return;
    ref.read(addTorrentProvider.notifier).importMagnet(url);
  }

  Future<void> _importFile() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['torrent'],
    );
    if (!mounted || file == null) return;

    late final Uint8List bytes;
    try {
      bytes = await file.readAsBytes();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('无法读取所选文件')),
      );
      return;
    }
    if (!mounted) return;
    if (bytes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('无法读取所选文件')),
      );
      return;
    }

    final name = file.name.trim().isEmpty ? 'torrent.torrent' : file.name;
    ref.read(addTorrentProvider.notifier).importFile(name, bytes);
  }

  void _applyDefaultSavePathIfNeeded(AddTorrentUiState ui) {
    final path = ui.defaultSavePath;
    if (path == null || path.isEmpty) return;
    if (ui.managementMode != TorrentManagementMode.manual) return;
    if (_savePathController.text.isNotEmpty) return;
    _savePathController.text = path;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final ui = ref.read(addTorrentProvider);
    if (!ui.canSubmit) return;

    LoadingDialog.show(context, message: '添加中…');
    await Future<void>.delayed(Duration.zero);

    final error = await ref.read(addTorrentProvider.notifier).submit(
          savePath: _savePathController.text,
          incompletePath: _incompletePathController.text,
          rename: _renameController.text,
          dlLimitKib: _dlLimitController.text,
          upLimitKib: _upLimitController.text,
        );

    if (!mounted) return;
    LoadingDialog.dismiss(context);

    if (error == null) {
      context.pop();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('添加失败：$error')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(addTorrentProvider);
    final vm = ref.read(addTorrentProvider.notifier);
    final home = ref.watch(homePageProvider);
    final categories = _flattenCategories(home.categoryTree);
    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;

    ref.listen(addTorrentProvider, (prev, next) {
      _applyDefaultSavePathIfNeeded(next);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ui.torrentName == null || ui.torrentName!.isEmpty
              ? '添加种子'
              : ui.torrentName!,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addTorrent',
        tooltip: '添加种子',
        onPressed: ui.canSubmit ? _submit : null,
        child: const Icon(Icons.check),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 24 + bottomSafe),
        children: [
          AddTorrentImportSection(
            ui: ui,
            onImportMagnet: _importMagnet,
            onImportFile: _importFile,
          ),
          const SizedBox(height: 12),
          AddTorrentSaveSection(
            ui: ui,
            viewModel: vm,
            savePathController: _savePathController,
            incompletePathController: _incompletePathController,
          ),
          const SizedBox(height: 12),
          AddTorrentSettingsSection(
            ui: ui,
            viewModel: vm,
            renameController: _renameController,
            dlLimitController: _dlLimitController,
            upLimitController: _upLimitController,
            categories: categories,
            tags: home.tags,
          ),
          const SizedBox(height: 12),
          AddTorrentInfoSection(ui: ui),
          const SizedBox(height: 12),
          AddTorrentFilesSection(
            ui: ui,
            viewModel: vm,
            onRetry: vm.retryMetadata,
          )
        ],
      ),
    );
  }
}

List<String> _flattenCategories(List<TorrentCategoryNode> nodes) {
  final out = <String>[];
  void walk(List<TorrentCategoryNode> list) {
    for (final node in list) {
      out.add(node.fullPath);
      walk(node.children);
    }
  }

  walk(nodes);
  return out;
}
