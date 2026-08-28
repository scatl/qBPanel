import 'package:flutter/material.dart';
import 'package:qbpanel/l10n/context_l10n.dart';
import 'package:qbpanel/widget/empty/empty_state.dart';
import 'package:qbpanel/widget/page_insets.dart';

/// 根据 [EmptyState] 展示加载 / 空数据 / 错误占位。
///
/// [state.showContent] 为 true 时返回 [SizedBox.shrink]；有内容时请用
/// [EmptyStateHost]，或自行分支。
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.state,
    this.onRetry,
    this.onEmptyAction,
    this.tone = EmptyStateTone.compact,
    this.padding,
  });

  final EmptyState state;
  final VoidCallback? onRetry;
  final VoidCallback? onEmptyAction;
  final EmptyStateTone tone;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    switch (state.kind) {
      case EmptyStateKind.loading:
        return const Center(child: CircularProgressIndicator());
      case EmptyStateKind.error:
        return _PlaceholderBody(
          tone: tone,
          padding: padding,
          icon: Icons.error_outline,
          useErrorColor: tone == EmptyStateTone.compact,
          title: state.errorMessage ?? l10n.loadFailed,
          actionText: state.errorActionText ?? l10n.actionRetry,
          onAction: onRetry,
        );
      case EmptyStateKind.empty:
        return _PlaceholderBody(
          tone: tone,
          padding: padding,
          icon: state.emptyIcon ?? Icons.inbox_outlined,
          useErrorColor: false,
          title: state.emptyTitle ?? l10n.emptyNoData,
          subtitle: state.emptySubtitle,
          actionText: state.emptyActionText,
          onAction: onEmptyAction,
        );
      case EmptyStateKind.content:
        return const SizedBox.shrink();
    }
  }
}

/// 无内容时展示 [EmptyStateView]，有内容时展示 [child] / [builder]。
///
/// 优先传 [state]（通常来自 UiState.emptyState）；也可传
/// [loading] / [error] / [isEmpty]，由 Host 内部拼成 [EmptyState]。
/// [emptyTitle] 等可在此覆盖，不必写进 ViewModel。
class EmptyStateHost extends StatelessWidget {
  const EmptyStateHost({
    super.key,
    this.state,
    this.loading = false,
    this.error,
    this.isEmpty = false,
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyIcon,
    this.emptyActionText,
    this.errorActionText,
    this.child,
    this.builder,
    this.onRetry,
    this.onEmptyAction,
    this.tone = EmptyStateTone.compact,
    this.padding,
  }) : assert(child != null || builder != null, 'child or builder required');

  /// 已拼好的状态；非 null 时忽略 [loading] / [error] / [isEmpty]。
  final EmptyState? state;

  final bool loading;
  final String? error;
  final bool isEmpty;

  final String? emptyTitle;
  final String? emptySubtitle;
  final IconData? emptyIcon;
  final String? emptyActionText;
  final String? errorActionText;

  final Widget? child;
  final WidgetBuilder? builder;
  final VoidCallback? onRetry;
  final VoidCallback? onEmptyAction;
  final EmptyStateTone tone;
  final EdgeInsetsGeometry? padding;

  EmptyState get _resolved {
    if (state != null) {
      final s = state!;
      return s.copyWith(
        emptyTitle: emptyTitle ?? s.emptyTitle,
        emptySubtitle: emptySubtitle ?? s.emptySubtitle,
        emptyIcon: emptyIcon ?? s.emptyIcon,
        emptyActionText: emptyActionText ?? s.emptyActionText,
        errorActionText: errorActionText ?? s.errorActionText,
      );
    }
    return EmptyState.fromLoad(
      loading: loading,
      isEmpty: isEmpty,
      error: error,
      emptyTitle: emptyTitle,
      emptySubtitle: emptySubtitle,
      emptyIcon: emptyIcon,
      emptyActionText: emptyActionText,
      errorActionText: errorActionText,
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolved = _resolved;
    if (resolved.showContent) {
      return builder?.call(context) ?? child!;
    }
    return EmptyStateView(
      state: resolved,
      onRetry: onRetry,
      onEmptyAction: onEmptyAction,
      tone: tone,
      padding: padding,
    );
  }
}

class _PlaceholderBody extends StatelessWidget {
  const _PlaceholderBody({
    required this.tone,
    required this.icon,
    required this.useErrorColor,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.padding,
  });

  final EmptyStateTone tone;
  final IconData icon;
  final bool useErrorColor;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final showAction =
        onAction != null && actionText != null && actionText!.isNotEmpty;

    final isPage = tone == EmptyStateTone.page;
    final iconSize = isPage ? 72.0 : (useErrorColor ? 40.0 : null);
    final iconColor = useErrorColor ? scheme.error : scheme.outline;
    final resolvedPadding = padding ??
        (isPage
            ? const EdgeInsets.symmetric(horizontal: 32)
            : PageInsets.content);

    final titleStyle = isPage
        ? textTheme.titleMedium
        : (useErrorColor
            ? textTheme.bodyMedium?.copyWith(color: scheme.error)
            : textTheme.bodyLarge);
    final subtitleStyle = isPage
        ? textTheme.bodyMedium?.copyWith(color: scheme.outline)
        : textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant);

    final resolvedIconColor = (!isPage && !useErrorColor)
        ? scheme.onSurfaceVariant
        : iconColor;

    return Center(
      child: Padding(
        padding: resolvedPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: iconSize, color: resolvedIconColor),
            SizedBox(height: isPage ? 16 : 12),
            Text(
              title,
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              SizedBox(height: isPage ? 8 : 4),
              Text(
                subtitle!,
                style: subtitleStyle,
                textAlign: TextAlign.center,
              ),
            ],
            if (showAction) ...[
              SizedBox(height: isPage ? 20 : 16),
              FilledButton(
                onPressed: onAction,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
