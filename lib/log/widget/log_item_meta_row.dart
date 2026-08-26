import 'package:flutter/material.dart';
import 'package:qbpanel/detail/general/torrent_general_format.dart';

/// 日志条目顶栏：ID、时间（固定位置）、右侧标签。
class LogItemMetaRow extends StatelessWidget {
  const LogItemMetaRow({
    super.key,
    required this.id,
    required this.timestamp,
    required this.trailing,
  });

  final int id;
  final int timestamp;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final metaStyle = textTheme.labelSmall?.copyWith(
      color: scheme.onSurfaceVariant,
    );

    return Row(
      children: [
        Text('#$id', style: metaStyle),
        const SizedBox(width: 12),
        Text(formatUnixDate(timestamp), style: metaStyle),
        const Spacer(),
        trailing,
      ],
    );
  }
}
