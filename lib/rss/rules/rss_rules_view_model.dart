import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/entity/response/app_preferences_response.dart';
import 'package:qbpanel/api/entity/response/rss_rule_response.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/rss/rules/rss_rules_ui_state.dart';

final rssRulesProvider =
    NotifierProvider.autoDispose<RssRulesViewModel, RssRulesUiState>(
  RssRulesViewModel.new,
);

class RssRulesViewModel extends Notifier<RssRulesUiState> {
  @override
  RssRulesUiState build() {
    final ui = RssRulesUiState();
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

    List<RssAutoDownloadRule>? rules;
    String? error;
    var autoEnabled = state.autoDownloadingEnabled;

    await Future.wait([
      ref
          .read(apiClientProvider)
          .get(
            ApiPath.rss.rules,
            parser: parseRssRules,
          )
          .onSuccess((value) => rules = value)
          .onFail((e) {
            if (e.isCancel) return;
            error = e.message;
          }),
      ref
          .read(apiClientProvider)
          .get(
            ApiPath.application.preferences,
            parser: jsonParser(AppPreferencesResponse.fromJson),
          )
          .onSuccess((prefs) {
            autoEnabled = prefs.rssAutoDownloadingEnabled ?? true;
          }),
    ]);

    if (!ref.mounted) return;

    if (rules == null) {
      list.setError(
        error ?? ref.read(appLocalizationsProvider).loadFailed,
        keepItems: list.items.isNotEmpty,
      );
      state = state.copyWith(
        list: list,
        autoDownloadingEnabled: autoEnabled,
      );
      return;
    }

    list.setSuccess(data: rules!, append: false, hasMore: false);
    state = state.copyWith(
      list: list,
      autoDownloadingEnabled: autoEnabled,
    );
  }

  Future<String?> setEnabled(RssAutoDownloadRule rule, bool enabled) {
    return _setRule(rule.copyWith(enabled: enabled));
  }

  Future<String?> _setRule(RssAutoDownloadRule rule) async {
    if (state.busyRuleNames.contains(rule.name)) return null;

    state = state.copyWith(
      busyRuleNames: {...state.busyRuleNames, rule.name},
    );

    String? error;
    await ref
        .read(apiClientProvider)
        .post(
          ApiPath.rss.setRule,
          data: {
            'ruleName': rule.name,
            'ruleDef': jsonEncode(rule.toJson()),
          },
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });

    if (!ref.mounted) return error;

    final nextBusy = {...state.busyRuleNames}..remove(rule.name);
    state = state.copyWith(busyRuleNames: nextBusy);
    if (error != null) return error;
    await refresh();
    return null;
  }

  Future<String?> removeRule(String name) async {
    if (state.busyRuleNames.contains(name)) return null;

    state = state.copyWith(busyRuleNames: {...state.busyRuleNames, name});

    String? error;
    await ref
        .read(apiClientProvider)
        .post(
          ApiPath.rss.removeRule,
          data: {'ruleName': name},
          options: Options(contentType: Headers.formUrlEncodedContentType),
          parser: (_) {},
        )
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });

    if (!ref.mounted) return error;

    final nextBusy = {...state.busyRuleNames}..remove(name);
    state = state.copyWith(busyRuleNames: nextBusy);
    if (error != null) return error;
    await refresh();
    return null;
  }
}
