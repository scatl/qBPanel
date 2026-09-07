import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/api/qb_api_capabilities.dart';
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
import 'package:qbpanel/l10n/context_l10n.dart';

class TorrentDetailPage extends ConsumerWidget {
  const TorrentDetailPage({super.key, required this.torrentHash});

  final String torrentHash;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(torrentDetailProvider(torrentHash));
    final vm = ref.read(torrentDetailProvider(torrentHash).notifier);
    final cap = ref.watch(qbApiCapabilitiesProvider);
    final showPeers = cap.hasTorrentPeers;
    final tabs = <Tab>[
      Tab(text: context.l10n.tabGeneral),
      if (showPeers) Tab(text: context.l10n.tabPeers),
      Tab(text: context.l10n.tabContent),
      Tab(text: context.l10n.tabTrackers),
      Tab(text: context.l10n.tabHttpSeeds),
    ];
    final views = <Widget>[
      TorrentGeneralTab(
        torrentHash: torrentHash,
        ui: ui,
        onRetry: vm.retry,
      ),
      if (showPeers) TorrentPeersTab(torrentHash: torrentHash),
      TorrentContentTab(torrentHash: torrentHash),
      TorrentTrackersTab(torrentHash: torrentHash),
      TorrentWebSeedsTab(torrentHash: torrentHash),
    ];
    final sortOf = <_DetailSortKind>[
      _DetailSortKind.none,
      if (showPeers) _DetailSortKind.peers,
      _DetailSortKind.content,
      _DetailSortKind.trackers,
      _DetailSortKind.none,
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (context) {
          final controller = DefaultTabController.of(context);
          return ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              final kind = sortOf[controller.index];
              return Scaffold(
                appBar: AppBar(
                  title: Text(context.l10n.torrentDetail),
                  actions: [
                    if (kind != _DetailSortKind.none)
                      IconButton(
                        tooltip: context.l10n.homeSort,
                        icon: const Icon(Icons.sort),
                        onPressed: () => _openSort(context, ref, kind),
                      ),
                  ],
                  bottom: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.center,
                    tabs: tabs,
                  ),
                ),
                body: TabBarView(children: views),
              );
            },
          );
        },
      ),
    );
  }

  void _openSort(BuildContext context, WidgetRef ref, _DetailSortKind kind) {
    switch (kind) {
      case _DetailSortKind.none:
        return;
      case _DetailSortKind.peers:
        final ui = ref.read(torrentPeersProvider(torrentHash));
        final vm = ref.read(torrentPeersProvider(torrentHash).notifier);
        DetailSortDialog.show<PeerSortKey>(
          context: context,
          title: context.l10n.sortPeersTitle,
          options: [
            for (final key in PeerSortKey.values)
              DetailSortOption(value: key, label: key.label(context.l10n)),
          ],
          selected: ui.sortKey,
          ascending: ui.sortAscending,
          onSelect: vm.setSort,
        );
      case _DetailSortKind.content:
        final ui = ref.read(torrentContentProvider(torrentHash));
        final vm = ref.read(torrentContentProvider(torrentHash).notifier);
        DetailSortDialog.show<ContentSortKey>(
          context: context,
          title: context.l10n.sortContent,
          options: [
            for (final key in ContentSortKey.values)
              DetailSortOption(value: key, label: key.label(context.l10n)),
          ],
          selected: ui.sortKey,
          ascending: ui.sortAscending,
          onSelect: vm.setSort,
        );
      case _DetailSortKind.trackers:
        final ui = ref.read(torrentTrackersProvider(torrentHash));
        final vm = ref.read(torrentTrackersProvider(torrentHash).notifier);
        DetailSortDialog.show<TrackerSortKey>(
          context: context,
          title: context.l10n.sortTrackers,
          options: [
            for (final key in TrackerSortKey.values)
              DetailSortOption(value: key, label: key.label(context.l10n)),
          ],
          selected: ui.sortKey,
          ascending: ui.sortAscending,
          onSelect: vm.setSort,
        );
    }
  }
}

enum _DetailSortKind { none, peers, content, trackers }
