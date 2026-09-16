import 'package:flutter/material.dart';
import 'package:qbpanel/detail/peers/model/peer_flags.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/adaptive_card_popup.dart';

abstract final class PeerFlagsHelpDialog {
  PeerFlagsHelpDialog._();

  static Future<void> show(BuildContext context) {
    return showAdaptiveCardPopup<void>(
      context: context,
      dialogConstraints: const BoxConstraints(minWidth: 220, maxWidth: 280),
      dialogPadding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      sheetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      builder: (_) => const _PeerFlagsHelpContent(),
    );
  }
}

class _PeerFlagsHelpContent extends StatelessWidget {
  const _PeerFlagsHelpContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.flagsHelp,
          style: textTheme.titleMedium?.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.42,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final flag in peerFlagLegend(l10n))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: flag.$1,
                            style: textTheme.bodySmall?.copyWith(
                              color: scheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: '  ${flag.$2}',
                            style: textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.actionGotIt),
          ),
        ),
      ],
    );
  }
}
