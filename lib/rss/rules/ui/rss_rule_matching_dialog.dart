import 'package:flutter/material.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/dialog/blur_dialog_scaffold.dart';

abstract final class RssRuleMatchingDialog {
  RssRuleMatchingDialog._();

  static Future<void> show(
    BuildContext context, {
    required Map<String, List<String>> matching,
  }) {
    return showGeneralDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: BlurDialogMotion.duration,
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return _RssRuleMatchingBody(
          animation: animation,
          matching: matching,
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) => child,
    );
  }
}

class _RssRuleMatchingBody extends StatelessWidget {
  const _RssRuleMatchingBody({
    required this.animation,
    required this.matching,
  });

  final Animation<double> animation;
  final Map<String, List<String>> matching;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.sizeOf(context);
    final entries = matching.entries
        .where((e) => e.value.isNotEmpty)
        .toList();

    return BlurDialogScaffold(
      animation: animation,
      onBarrierTap: () => Navigator.of(context).pop(),
      panelConstraints: BoxConstraints(
        maxWidth: size.width * 0.9,
        maxHeight: size.height * 0.7,
      ),
      panelPadding: const EdgeInsets.fromLTRB(24, 22, 24, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.rssRuleMatchingArticles,
            style: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: entries.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      l10n.rssRuleNoMatchingArticles,
                      style: textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              entry.key,
                              style: textTheme.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            for (final title in entry.value)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  title,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.actionOk),
            ),
          ),
        ],
      ),
    );
  }
}
