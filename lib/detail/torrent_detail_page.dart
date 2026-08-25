import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/detail/content/torrent_content_sort.dart';
import 'package:qbpanel/detail/content/torrent_content_view_model.dart';
import 'package:qbpanel/detail/content/torrent_content_tab.dart';
import 'package:qbpanel/detail/general/torrent_general_tab.dart';
import 'package:qbpanel/detail/peers/model/torrent_peer_sort.dart';
import 'package:qbpanel/detail/peers/torrent_peers_tab.dart';
import 'package:qbpanel/detail/peers/torrent_peers_view_model.dart';
import 'package:qbpanel/detail/torrent_detail_view_model.dart';
import 'package:qbpanel/detail/trackers/torrent_tracker_sort.dart';
import 'package:qbpanel/detail/trackers/torrent_trackers_tab.dart';
import 'package:qbpanel/detail/trackers/torrent_trackers_view_model.dart';
import 'package:qbpanel/detail/webseeds/torrent_webseeds_tab.dart';
import 'package:qbpanel/detail/widget/detail_sort_dialog.dart';

class TorrentDetailPage extends ConsumerWidget {
  const TorrentDetailPage({super.key, required this.torrentHash});

  final String torrentHash;

  static const _peersTabIndex = 1;
  static const _contentTabIndex = 2;
  static const _trackersTabIndex = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(torrentDetailProvider(torrentHash));
    final vm = ref.read(torrentDetailProvider(torrentHash).notifier);

    return DefaultTabController(
      length: 5,
      child: Builder(
        builder: (context) {
          final tabs = DefaultTabController.of(context);
          return ListenableBuilder(
            listenable: tabs,
            builder: (context, _) {
              final showSort =
                  tabs.index == _peersTabIndex ||
                  tabs.index == _contentTabIndex ||
                  tabs.index == _trackersTabIndex;
              return Scaffold(
                appBar: AppBar(
                  title: const Text('种子详情'),
                  actions: [
                    if (showSort)
                      IconButton(
                        tooltip: '排序',
                        icon: const Icon(Icons.sort),
                        onPressed: () => _openSort(context, ref, tabs.index),
                      ),
                  ],
                  bottom: const TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.center,
                    tabs: [
                      Tab(text: '普通'),
                      Tab(text: '用户'),
                      Tab(text: '内容'),
                      Tab(text: 'Tracker'),
                      Tab(text: 'HTTP 源'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    TorrentGeneralTab(
                      torrentHash: torrentHash,
                      ui: ui,
                      onRetry: vm.retry,
                    ),
                    TorrentPeersTab(torrentHash: torrentHash),
                    TorrentContentTab(torrentHash: torrentHash),
                    TorrentTrackersTab(torrentHash: torrentHash),
                    TorrentWebSeedsTab(torrentHash: torrentHash),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openSort(BuildContext context, WidgetRef ref, int tabIndex) {
    if (tabIndex == _peersTabIndex) {
      final ui = ref.read(torrentPeersProvider(torrentHash));
      final vm = ref.read(torrentPeersProvider(torrentHash).notifier);
      DetailSortDialog.show<PeerSortKey>(
        context: context,
        title: '用户排序',
        options: [
          for (final key in PeerSortKey.values)
            DetailSortOption(value: key, label: key.label),
        ],
        selected: ui.sortKey,
        ascending: ui.sortAscending,
        onSelect: vm.setSort,
      );
      return;
    }
    if (tabIndex == _contentTabIndex) {
      final ui = ref.read(torrentContentProvider(torrentHash));
      final vm = ref.read(torrentContentProvider(torrentHash).notifier);
      DetailSortDialog.show<ContentSortKey>(
        context: context,
        title: '内容排序',
        options: [
          for (final key in ContentSortKey.values)
            DetailSortOption(value: key, label: key.label),
        ],
        selected: ui.sortKey,
        ascending: ui.sortAscending,
        onSelect: vm.setSort,
      );
      return;
    }
    if (tabIndex == _trackersTabIndex) {
      final ui = ref.read(torrentTrackersProvider(torrentHash));
      final vm = ref.read(torrentTrackersProvider(torrentHash).notifier);
      DetailSortDialog.show<TrackerSortKey>(
        context: context,
        title: 'Tracker 排序',
        options: [
          for (final key in TrackerSortKey.values)
            DetailSortOption(value: key, label: key.label),
        ],
        selected: ui.sortKey,
        ascending: ui.sortAscending,
        onSelect: vm.setSort,
      );
    }
  }
}
