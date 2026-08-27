import 'package:flutter/material.dart';
import 'package:qbpanel/api/entity/response/search_result_response.dart';
import 'package:qbpanel/detail/general/torrent_general_format.dart';
import 'package:qbpanel/util/byte_format.dart';
import 'package:qbpanel/widget/page_insets.dart';

class SearchResultItem extends StatelessWidget {
  const SearchResultItem({
    super.key,
    required this.result,
    this.onTap,
  });

  final SearchResultResponse result;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                result.fileName,
                style: textTheme.titleSmall
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  _MetaChip(
                    icon: Icons.storage_outlined,
                    label: _formatSize(result.fileSize),
                  ),
                  _MetaChip(
                    icon: Icons.arrow_upward_rounded,
                    label: '做种 ${_formatCount(result.nbSeeders)}',
                  ),
                  _MetaChip(
                    icon: Icons.arrow_downward_rounded,
                    label: '下载 ${_formatCount(result.nbLeechers)}',
                  ),
                  if ((result.engineName ?? '').isNotEmpty)
                    _MetaChip(
                      icon: Icons.travel_explore_outlined,
                      label: result.engineName!,
                    ),
                ],
              ),
              if (_hasPublishedDate(result.pubDate)) ...[
                const SizedBox(height: 8),
                Text(
                  formatUnixDate(result.pubDate!, unknown: ''),
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
    );
  }

  static String _formatSize(int bytes) {
    if (bytes < 0) return '未知大小';
    return formatBytes(bytes, fractionDigits: 2);
  }

  static String _formatCount(int value) {
    if (value < 0) return '—';
    return value.toString();
  }

  static bool _hasPublishedDate(int? pubDate) {
    return pubDate != null && pubDate > 0;
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: scheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
