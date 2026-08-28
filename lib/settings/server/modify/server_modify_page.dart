import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/settings/server/list/server_list_view_model.dart';
import 'package:qbpanel/settings/server/modify/server_modify_view_model.dart';
import 'package:qbpanel/widget/page_insets.dart';
import 'package:qbpanel/settings/widget/setting_subtitle.dart';
import 'package:qbpanel/widget/dialog/loading_dialog.dart';

/// 添加或编辑 qBittorrent 服务器。
class ServerModifyPage extends ConsumerStatefulWidget {
  const ServerModifyPage({super.key, this.serverId});

  /// 本地数据库服务器 id；`null` 表示添加，非空表示编辑
  final int? serverId;

  @override
  ConsumerState<ServerModifyPage> createState() => _ServerModifyPageState();
}

class _ServerModifyPageState extends ConsumerState<ServerModifyPage> {
  final _nameController = TextEditingController();
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _pathController = TextEditingController();
  final _apiKeyController = TextEditingController();

  bool _ready = false;
  bool get _isEdit => widget.serverId != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final vm = ref.read(serverModifyProvider.notifier);
    final id = widget.serverId;

    if (id == null) {
      vm.reset();
      if (mounted) setState(() => _ready = true);
      return;
    }

    final server = await vm.loadForEdit(id);
    if (!mounted) return;

    if (server == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.serverNotFound)),
      );
      context.pop();
      return;
    }

    _nameController.text = server.name;
    _hostController.text = server.host;
    _portController.text = '${server.port}';
    _pathController.text = server.path;
    _apiKeyController.text = server.apiKey;
    setState(() => _ready = true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _pathController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    FocusScope.of(context).unfocus();

    // 不要 await：show 的 Future 会等到 dismiss 才完成
    LoadingDialog.show(context, message: context.l10n.validating);
    await Future<void>.delayed(Duration.zero);

    final vm = ref.read(serverModifyProvider.notifier);
    final ok = await vm.save(
      serverId: widget.serverId,
      name: _nameController.text,
      host: _hostController.text,
      portText: _portController.text,
      path: _pathController.text,
      apiKey: _apiKeyController.text,
    );

    if (!mounted) return;
    LoadingDialog.dismiss(context);

    if (!ok) return;

    await ref.read(serverListProvider.notifier).refresh();
    if (!mounted) return;
    context.pop();
  }

  InputDecoration _decoration({
    required String hintText,
    required bool hasError,
  }) {
    return InputDecoration(
      hintText: hintText,
      // 非空即可触发主题 errorBorder，不在输入框下展示文案
      errorText: hasError ? '' : null,
      errorStyle: const TextStyle(height: 0, fontSize: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;
    final ui = ref.watch(serverModifyProvider);
    final vm = ref.read(serverModifyProvider.notifier);
    final subtitleColor = scheme.onSurfaceVariant.withAlpha(200);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? l10n.editServer : l10n.addServer),
      ),
      body: !_ready || ui.initializing
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.fromLTRB(
                PageInsets.horizontal,
                8,
                PageInsets.horizontal,
                24 + bottomSafe,
              ),
              children: [
                SettingSubtitle(
                  l10n.serverNameHint,
                  color: subtitleColor,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => vm.clearFieldError(name: true),
                  decoration: _decoration(
                    hintText: l10n.serverName,
                    hasError: ui.nameError,
                  ),
                ),
                const SizedBox(height: 16),
                SettingSubtitle(
                  l10n.hostHint,
                  color: subtitleColor,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _hostController,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => vm.clearFieldError(host: true),
                  decoration: _decoration(
                    hintText: l10n.host,
                    hasError: ui.hostError,
                  ),
                ),
                const SizedBox(height: 16),
                SettingSubtitle(
                  l10n.portHint,
                  color: subtitleColor,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _portController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(5),
                    const _PortRangeFormatter(),
                  ],
                  decoration: InputDecoration(
                    hintText: l10n.port,
                  ),
                ),
                const SizedBox(height: 16),
                SettingSubtitle(
                  l10n.pathHint,
                  color: subtitleColor,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _pathController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: l10n.path,
                  ),
                ),
                const SizedBox(height: 16),
                SettingSubtitle(
                  l10n.apiKeyHint,
                  color: subtitleColor,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _apiKeyController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => vm.clearFieldError(apiKey: true),
                  decoration: _decoration(
                    hintText: l10n.apiKey,
                    hasError: ui.apiKeyError,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.useHttps,
                      style: TextStyle(color: subtitleColor),
                    ),
                    Switch(
                      value: ui.useHttps,
                      onChanged: vm.setUseHttps,
                    ),
                  ],
                ),
                if (ui.formErrorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    ui.formErrorMessage!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.error,
                        ),
                  ),
                ],
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: 160,
                    child: FilledButton(
                      onPressed: _onSave,
                      child: Text(l10n.actionSave),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

/// 端口合法范围 1–65535；允许清空以便重新输入。
class _PortRangeFormatter extends TextInputFormatter {
  const _PortRangeFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;
    final port = int.tryParse(text);
    if (port == null || port < 1 || port > 65535) {
      return oldValue;
    }
    return newValue;
  }
}
