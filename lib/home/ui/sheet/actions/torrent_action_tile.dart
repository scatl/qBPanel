import 'package:flutter/material.dart';

class TorrentActionTile extends StatelessWidget {
  const TorrentActionTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.foreground,
    this.trailing,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? foreground;
  final Widget? trailing;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = enabled
        ? (foreground ?? scheme.onSurface)
        : scheme.onSurface.withValues(alpha: 0.38);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: color),
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
