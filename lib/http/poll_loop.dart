import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 单次轮询凭证：取消、世代校验。
class PollTicket {
  PollTicket({
    required this.cancelToken,
    required this.generation,
    required bool Function() isActive,
  }) : _isActive = isActive;

  final CancelToken cancelToken;
  final int generation;
  final bool Function() _isActive;

  /// 是否仍是当前这一拍（未被更新一轮 / dispose / stop 作废）。
  bool get isActive => _isActive();

  bool _continuePolling = true;

  /// 本拍结束后不要再 schedule（例如参数无效、无服务器）。
  void stopPolling() => _continuePolling = false;

  bool get shouldContinuePolling => _continuePolling;
}

/// 上一拍结束再 delay 的轮询：cancel-and-restart、生命周期、固定间隔。
///
/// 在 [Notifier.build] 里构造并 [attach]；业务只实现 [onPoll]。
class PollLoop {
  PollLoop({
    required this.ref,
    required this.onPoll,
    this.interval = const Duration(milliseconds: 1500),
    this.canPoll,
  });

  final Ref ref;
  final Future<void> Function(PollTicket ticket) onPoll;
  final Duration interval;

  /// 返回 false 时不发起、不续约（如 peers 暂停、无活跃服务器）。
  final bool Function()? canPoll;

  Timer? _timer;
  CancelToken? _cancelToken;
  AppLifecycleListener? _lifecycle;
  int _generation = 0;
  bool _appPaused = false;
  bool _disposed = false;
  bool _attached = false;

  /// 挂 lifecycle / dispose；[startImmediately] 为 true 时 microtask 拉首拍。
  void attach({bool startImmediately = true}) {
    if (_attached) return;
    _attached = true;
    _lifecycle = AppLifecycleListener(
      onPause: _onAppPaused,
      onResume: _onAppResumed,
    );
    ref.onDispose(dispose);
    if (startImmediately) {
      Future.microtask(refreshNow);
    }
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _lifecycle?.dispose();
    _lifecycle = null;
    _invalidate();
  }

  /// 停表并作废在途，不自动再拉。
  void stop() {
    if (_disposed) return;
    _invalidate();
  }

  /// 取消在途（若有）并立刻拉一拍。
  ///
  /// [ignoreCanPoll] 为 true 时仍拉这一拍（如暂停刷新时操作后同步），
  /// 但本拍结束后的续约仍受 [canPoll] 约束。
  Future<void> refreshNow({bool ignoreCanPoll = false}) =>
      _run(ignoreCanPoll: ignoreCanPoll);

  void retry() {
    unawaited(refreshNow());
  }

  void _onAppPaused() {
    _appPaused = true;
    _invalidate();
  }

  void _onAppResumed() {
    _appPaused = false;
    unawaited(refreshNow());
  }

  Future<void> _run({bool ignoreCanPoll = false}) async {
    if (_disposed || _appPaused) return;
    if (!ignoreCanPoll && canPoll != null && !canPoll!()) return;

    _stopTimer();
    _cancelInFlight();
    final generation = ++_generation;
    final token = CancelToken();
    _cancelToken = token;
    final ticket = PollTicket(
      cancelToken: token,
      generation: generation,
      isActive: () => !_disposed && generation == _generation,
    );

    try {
      await onPoll(ticket);
    } finally {
      if (generation == _generation && ticket.shouldContinuePolling) {
        _scheduleNext();
      }
    }
  }

  void _scheduleNext() {
    _stopTimer();
    if (_disposed || _appPaused) return;
    if (canPoll != null && !canPoll!()) return;
    _timer = Timer(interval, () {
      unawaited(_run());
    });
  }

  void _invalidate() {
    _stopTimer();
    _cancelInFlight();
    _generation++;
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _cancelInFlight() {
    final token = _cancelToken;
    _cancelToken = null;
    if (token != null && !token.isCancelled) {
      token.cancel();
    }
  }
}
