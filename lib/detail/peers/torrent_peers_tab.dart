import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qbpanel/detail/peers/dialog/peer_action_dialog.dart';
import 'package:qbpanel/detail/peers/dialog/peer_flags_help_dialog.dart';
import 'package:qbpanel/detail/peers/torrent_peers_view_model.dart';
import 'package:qbpanel/detail/peers/widget/torrent_peer_item.dart';
import 'package:qbpanel/widget/empty/empty_state_view.dart';
import 'package:qbpanel/widget/page_insets.dart';

class TorrentPeersTab extends ConsumerWidget {
  const TorrentPeersTab({super.key, required this.torrentHash});

  final String torrentHash;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(torrentPeersProvider(torrentHash));
    final vm = ref.read(torrentPeersProvider(torrentHash).notifier);

    final header = _PeersHeader(
      pollPaused: ui.pollPaused,
      onTogglePoll: vm.togglePoll,
    );

    final bottomSafe = MediaQuery.viewPaddingOf(context).bottom;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        Expanded(
          child: EmptyStateHost(
            state: ui.emptyState,
            onRetry: vm.retry,
            emptyTitle: '暂无用户',
            emptySubtitle: '当前没有连上的 Peer',
            emptyIcon: Icons.people_outline,
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 24 + bottomSafe),
              itemCount: ui.peers.length,
              itemBuilder: (context, index) {
                final peer = ui.peers[index];
                return TorrentPeerItem(
                  key: ValueKey(peer.id),
                  peer: peer,
                  onLongPress: () => PeerActionDialog.show(
                    context: context,
                    peer: peer,
                    viewModel: vm,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _PeersHeader extends StatelessWidget {
  const _PeersHeader({required this.pollPaused, required this.onTogglePoll});

  final bool pollPaused;
  final VoidCallback onTogglePoll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PageInsets.horizontal,
        4,
        PageInsets.horizontal,
        0,
      ),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: onTogglePoll,
            icon: Icon(pollPaused ? Icons.play_arrow : Icons.pause, size: 20),
            label: Text(pollPaused ? '开始刷新' : '暂停刷新'),
          ),
          const Spacer(),
          IconButton(
            tooltip: '标志说明',
            icon: const Icon(Icons.help_outline),
            onPressed: () => PeerFlagsHelpDialog.show(context),
          ),
        ],
      ),
    );
  }
}
