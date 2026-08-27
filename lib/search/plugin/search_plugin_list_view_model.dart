import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/entity/response/search_plugin_response.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/search/plugin/search_plugin_list_ui_state.dart';

final searchPluginListProvider =
    NotifierProvider.autoDispose<SearchPluginListViewModel, SearchPluginListUiState>(
  SearchPluginListViewModel.new,
);

class SearchPluginListViewModel extends Notifier<SearchPluginListUiState> {
  @override
  SearchPluginListUiState build() {
    final ui = SearchPluginListUiState();
    ui.list.beginInit();
    Future.microtask(refresh);
    return ui;
  }

  Future<void> refresh() async {
    final list = state.list;
    if (!list.initLoading) {
      list.beginRefresh();
      state = state.copyWith(list: list);
    }

    List<SearchPluginResponse>? plugins;
    String? error;

    await ref
        .read(apiClientProvider)
        .get(
          ApiPath.search.plugins,
          parser: parseSearchPluginList,
        )
        .onSuccess((value) => plugins = value)
        .onFail((e) => error = e.message);

    if (!ref.mounted) return;

    if (plugins == null) {
      list.setError(
        error ?? '加载失败',
        keepItems: list.items.isNotEmpty,
      );
      state = state.copyWith(list: list);
      return;
    }

    list.setSuccess(data: plugins!, append: false, hasMore: false);
    state = state.copyWith(list: list);
  }

  Future<String?> installPlugin(String rawSources) async {
    final sources = rawSources
        .split(RegExp(r'[\r\n|]+'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .join('|');
    if (sources.isEmpty) return '请输入插件 URL 或路径';

    String? error;
    await ref
        .read(apiClientProvider)
        .post<void>(
          ApiPath.search.installPlugin,
          data: {'sources': sources},
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) => error = e.message);

    if (!ref.mounted) return error;
    if (error != null) return error;

    await refresh();
    return null;
  }

  Future<String?> checkForUpdates() async {
    if (state.updating) return null;
    state = state.copyWith(updating: true);

    String? error;
    await ref
        .read(apiClientProvider)
        .post<void>(
          ApiPath.search.updatePlugins,
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) => error = e.message);

    if (!ref.mounted) return error;

    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!ref.mounted) return error;

    await refresh();
    state = state.copyWith(updating: false);
    return error;
  }

  Future<String?> setPluginEnabled(String name, bool enabled) async {
    if (state.busyPluginNames.contains(name)) return null;

    state = state.copyWith(busyPluginNames: {...state.busyPluginNames, name});

    String? error;
    await ref
        .read(apiClientProvider)
        .post<void>(
          ApiPath.search.enablePlugin,
          data: {
            'names': name,
            'enable': enabled ? 'true' : 'false',
          },
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) => error = e.message);

    if (!ref.mounted) return error;

    final nextBusy = {...state.busyPluginNames}..remove(name);
    state = state.copyWith(busyPluginNames: nextBusy);

    if (error != null) return error;

    await refresh();
    return null;
  }

  Future<String?> uninstallPlugin(String name) async {
    if (state.busyPluginNames.contains(name)) return null;

    state = state.copyWith(busyPluginNames: {...state.busyPluginNames, name});

    String? error;
    await ref
        .read(apiClientProvider)
        .post<void>(
          ApiPath.search.uninstallPlugin,
          data: {'names': name},
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) => error = e.message);

    if (!ref.mounted) return error;

    final nextBusy = {...state.busyPluginNames}..remove(name);
    state = state.copyWith(busyPluginNames: nextBusy);

    if (error != null) return error;

    await refresh();
    return null;
  }
}
