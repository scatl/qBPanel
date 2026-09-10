import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/api_path.dart';
import 'package:qbpanel/api/entity/response/rss_items_response.dart';
import 'package:qbpanel/api/entity/response/rss_rule_response.dart';
import 'package:qbpanel/home/entity/torrent_category_node.dart';
import 'package:qbpanel/home/home_page_view_model.dart';
import 'package:qbpanel/http/api_client.dart';
import 'package:qbpanel/l10n/app_locale.dart';
import 'package:qbpanel/rss/rules/rss_rule_edit_ui_state.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';

final rssRuleEditProvider = NotifierProvider.autoDispose
    .family<RssRuleEditViewModel, RssRuleEditUiState, String>(
  RssRuleEditViewModel.new,
);

class RssRuleEditViewModel extends Notifier<RssRuleEditUiState> {
  RssRuleEditViewModel(this.initialName);

  final String initialName;

  @override
  RssRuleEditUiState build() {
    Future.microtask(load);
    return RssRuleEditUiState(
      originalName: initialName,
      rule: RssAutoDownloadRule(name: initialName),
    );
  }

  void setRule(RssAutoDownloadRule rule) {
    state = state.copyWith(rule: rule);
  }

  void toggleFeed(String url, bool selected) {
    final next = [...state.rule.affectedFeeds];
    if (selected) {
      if (!next.contains(url)) next.add(url);
    } else {
      next.remove(url);
    }
    state = state.copyWith(rule: state.rule.copyWith(affectedFeeds: next));
  }

  void setAllFeeds(bool selected) {
    final urls = [
      for (final feed in state.feeds)
        if (feed.url.isNotEmpty) feed.url,
    ];
    state = state.copyWith(
      rule: state.rule.copyWith(
        affectedFeeds: selected ? urls : const [],
      ),
    );
  }

  Future<void> load() async {
    state = state.copyWith(emptyState: const EmptyState.loading());

    List<RssAutoDownloadRule>? rules;
    List<RssTreeNode>? roots;
    String? error;

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
            error ??= e.message;
          }),
      ref
          .read(apiClientProvider)
          .get(
            ApiPath.rss.items,
            parser: RssItemsParser.parse,
          )
          .onSuccess((value) => roots = value)
          .onFail((e) {
            if (e.isCancel) return;
            error ??= e.message;
          }),
    ]);

    if (!ref.mounted) return;

    if (rules == null || roots == null) {
      state = state.copyWith(
        emptyState: EmptyState.error(
          error ?? ref.read(appLocalizationsProvider).loadFailed,
        ),
      );
      return;
    }

    final name = initialName.trim();
    RssAutoDownloadRule rule = RssAutoDownloadRule(name: name);
    if (name.isNotEmpty) {
      final found = rules!.where((r) => r.name == name).firstOrNull;
      if (found == null) {
        state = state.copyWith(
          emptyState: EmptyState.empty(
            title: ref.read(appLocalizationsProvider).rssRuleNotFound,
            icon: Icons.rule_outlined,
          ),
        );
        return;
      }
      rule = found;
    }

    final feeds = [
      for (final root in roots!) ...root.allFeeds,
    ];
    final categories = _flattenCategories(
      ref.read(homePageProvider).categoryTree,
    );

    state = state.copyWith(
      emptyState: const EmptyState.content(),
      originalName: name,
      rule: rule,
      feeds: feeds,
      categories: categories,
    );
  }

  /// 成功返回 `null`。
  Future<String?> save({
    required String name,
    required String mustContain,
    required String mustNotContain,
    required String episodeFilter,
    required int ignoreDays,
    required String savePath,
  }) async {
    final l10n = ref.read(appLocalizationsProvider);
    final trimmed = name.trim();
    if (trimmed.isEmpty) return l10n.rssRuleNameRequired;
    if (state.saving) return null;

    final rule = state.rule.copyWith(
      name: trimmed,
      mustContain: mustContain,
      mustNotContain: mustNotContain,
      episodeFilter: episodeFilter,
      ignoreDays: ignoreDays < 0 ? 0 : ignoreDays,
      savePath: savePath.trim(),
    );

    state = state.copyWith(saving: true, rule: rule);

    String? error;
    final original = state.originalName;
    if (original.isNotEmpty && original != trimmed) {
      await ref
          .read(apiClientProvider)
          .post(
            ApiPath.rss.renameRule,
            data: {
              'ruleName': original,
              'newRuleName': trimmed,
            },
            options: Options(contentType: Headers.formUrlEncodedContentType),
            parser: (_) {},
          )
          .onFail((e) {
            if (e.isCancel) return;
            error = e.message;
          });
      if (error != null) {
        state = state.copyWith(saving: false);
        return error;
      }
    }

    await ref
        .read(apiClientProvider)
        .post(
          ApiPath.rss.setRule,
          data: {
            'ruleName': trimmed,
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
    state = state.copyWith(
      saving: false,
      originalName: error == null ? trimmed : original,
      rule: rule,
    );
    return error;
  }

  Future<String?> loadMatchingArticles() async {
    final name = state.originalName.trim();
    if (name.isEmpty) {
      return ref.read(appLocalizationsProvider).rssRuleSaveBeforeMatch;
    }
    if (state.matchingLoading) return null;

    state = state.copyWith(matchingLoading: true, matching: const {});
    Map<String, List<String>>? matching;
    String? error;
    await ref
        .read(apiClientProvider)
        .get(
          ApiPath.rss.matchingArticles,
          queryParameters: {'ruleName': name},
          parser: parseRssMatchingArticles,
        )
        .onSuccess((value) => matching = value)
        .onFail((e) {
          if (e.isCancel) return;
          error = e.message;
        });

    if (!ref.mounted) return error;
    state = state.copyWith(
      matchingLoading: false,
      matching: matching ?? const {},
    );
    return error;
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
