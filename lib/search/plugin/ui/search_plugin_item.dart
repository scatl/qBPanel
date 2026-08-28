import 'package:flutter/material.dart';
import 'package:qbpanel/api/entity/response/search_plugin_response.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/page_insets.dart';

class SearchPluginItem extends StatelessWidget {
  const SearchPluginItem({
    super.key,
    required this.plugin,
    required this.busy,
    required this.onEnabledChanged,
    required this.onDelete,
  });

  final SearchPluginResponse plugin;
  final bool busy;
  final ValueChanged<bool> onEnabledChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final title = plugin.fullName.isNotEmpty ? plugin.fullName : plugin.name;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PageInsets.horizontal,
        vertical: 6,
      ),
      child: Material(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.pluginVersion(
                        plugin.version.isEmpty ? '—' : plugin.version,
                      ),
                      style: textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    if (plugin.url.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        plugin.url,
                        style: textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Switch(
                value: plugin.enabled,
                onChanged: busy ? null : onEnabledChanged,
              ),
              IconButton(
                tooltip: l10n.deletePlugin,
                onPressed: busy ? null : onDelete,
                icon: Icon(
                  Icons.delete_outline,
                  color: scheme.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
