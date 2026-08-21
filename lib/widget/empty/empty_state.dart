import 'package:flutter/material.dart';

/// 占位阶段：内容 / 加载 / 空数据 / 错误。
enum EmptyStateKind { content, loading, empty, error }

/// 空态 / 加载 / 异常占位描述。
///
/// 可嵌进 UiState（替代分散的 `loading` / `error` / `loadError`），
/// Page 再交给 [EmptyStateHost]；空数据文案/图标也可在 Host 上覆盖。
///
/// ```dart
/// // UiState
/// final EmptyState emptyState;
///
/// // ViewModel
/// state = state.copyWith(emptyState: const EmptyState.loading());
/// state = state.copyWith(emptyState: EmptyState.error(message));
/// state = state.copyWith(emptyState: const EmptyState.content());
/// state = state.copyWith(
///   peers: list,
///   emptyState: EmptyState(isEmpty: list.isEmpty),
/// );
/// ```
class EmptyState {
  const EmptyState({
    this.loading = false,
    this.isEmpty = false,
    this.errorMessage,
    this.emptyTitle = '暂无数据',
    this.emptySubtitle,
    this.emptyIcon,
    this.emptyActionText,
    this.errorActionText = '重试',
  });

  /// 首屏加载中。
  const EmptyState.loading()
      : loading = true,
        isEmpty = true,
        errorMessage = null,
        emptyTitle = '暂无数据',
        emptySubtitle = null,
        emptyIcon = null,
        emptyActionText = null,
        errorActionText = '重试';

  /// 有业务内容（不展示占位）。
  const EmptyState.content()
      : loading = false,
        isEmpty = false,
        errorMessage = null,
        emptyTitle = '暂无数据',
        emptySubtitle = null,
        emptyIcon = null,
        emptyActionText = null,
        errorActionText = '重试';

  /// 仅错误占位（无数据）。
  factory EmptyState.error(
    String message, {
    String errorActionText = '重试',
  }) {
    return EmptyState(
      isEmpty: true,
      errorMessage: message,
      errorActionText: errorActionText,
    );
  }

  /// 仅空数据占位（非加载、非错误）。
  factory EmptyState.empty({
    String title = '暂无数据',
    String? subtitle,
    IconData? icon,
    String? actionText,
  }) {
    return EmptyState(
      isEmpty: true,
      emptyTitle: title,
      emptySubtitle: subtitle,
      emptyIcon: icon,
      emptyActionText: actionText,
    );
  }

  /// 由加载标志 + 是否无内容推导（Page / Host 便捷入口）。
  factory EmptyState.fromLoad({
    required bool loading,
    required bool isEmpty,
    String? error,
    String emptyTitle = '暂无数据',
    String? emptySubtitle,
    IconData? emptyIcon,
    String? emptyActionText,
    String errorActionText = '重试',
  }) {
    return EmptyState(
      loading: loading,
      isEmpty: isEmpty,
      errorMessage: error,
      emptyTitle: emptyTitle,
      emptySubtitle: emptySubtitle,
      emptyIcon: emptyIcon,
      emptyActionText: emptyActionText,
      errorActionText: errorActionText,
    );
  }

  /// 设置页等：加载中 / 失败 / 可展示表单。
  factory EmptyState.fromReady({
    required bool loading,
    String? error,
  }) {
    if (loading) return const EmptyState.loading();
    if (error != null && error.trim().isNotEmpty) {
      return EmptyState.error(error);
    }
    return const EmptyState.content();
  }

  /// 列表成功后的占位：有数据 → content，无数据 → empty。
  factory EmptyState.fromItems(Iterable<Object?> items) {
    return items.isEmpty
        ? const EmptyState(isEmpty: true)
        : const EmptyState.content();
  }

  /// 首屏加载中。
  final bool loading;

  /// 是否无业务内容可展示。
  final bool isEmpty;

  /// 非空表示加载失败 / 网络异常等。
  final String? errorMessage;

  /// 空数据标题（非错误态）。
  final String emptyTitle;

  /// 空数据副标题（非错误态）。
  final String? emptySubtitle;

  /// 空数据图标；默认由 [EmptyStateView] 按视觉风格兜底。
  final IconData? emptyIcon;

  /// 空数据按钮文案；与 [EmptyStateView.onEmptyAction] 同时有值才显示。
  final String? emptyActionText;

  /// 错误态按钮文案。
  final String errorActionText;

  bool get hasError =>
      errorMessage != null && errorMessage!.trim().isNotEmpty;

  /// 当前占位阶段。
  EmptyStateKind get kind {
    if (showContent) return EmptyStateKind.content;
    if (showLoading) return EmptyStateKind.loading;
    if (showError) return EmptyStateKind.error;
    return EmptyStateKind.empty;
  }

  /// 首屏转圈：加载中且无数据、无错误。
  bool get showLoading => loading && isEmpty && !hasError;

  /// 异常占位：无数据且有错误。
  bool get showError => isEmpty && hasError;

  /// 空数据占位：无数据、非加载、无错误。
  bool get showEmpty => isEmpty && !loading && !hasError;

  /// 需要展示占位而非业务内容。
  bool get showPlaceholder => showLoading || showError || showEmpty;

  /// 有业务内容可展示。
  bool get showContent => !isEmpty;

  /// 设置页「可编辑」等：非加载且无错误。
  bool get ready => !loading && !hasError;

  EmptyState copyWith({
    bool? loading,
    bool? isEmpty,
    String? errorMessage,
    bool clearError = false,
    String? emptyTitle,
    String? emptySubtitle,
    bool clearEmptySubtitle = false,
    IconData? emptyIcon,
    bool clearEmptyIcon = false,
    String? emptyActionText,
    bool clearEmptyActionText = false,
    String? errorActionText,
  }) {
    return EmptyState(
      loading: loading ?? this.loading,
      isEmpty: isEmpty ?? this.isEmpty,
      errorMessage:
          clearError ? null : (errorMessage ?? this.errorMessage),
      emptyTitle: emptyTitle ?? this.emptyTitle,
      emptySubtitle: clearEmptySubtitle
          ? null
          : (emptySubtitle ?? this.emptySubtitle),
      emptyIcon: clearEmptyIcon ? null : (emptyIcon ?? this.emptyIcon),
      emptyActionText: clearEmptyActionText
          ? null
          : (emptyActionText ?? this.emptyActionText),
      errorActionText: errorActionText ?? this.errorActionText,
    );
  }
}

/// 空态视觉风格。
enum EmptyStateTone {
  /// 列表页大图标（对齐 [PagedRefreshList]）。
  page,

  /// 详情 Tab / 设置页等紧凑样式。
  compact,
}
