import 'package:flutter_foundation_kit/core/logging/logger.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Adds the standard write-side flow to an [AsyncNotifier].
///
/// [mutate] owns the repeated mechanics every mutating controller would
/// otherwise hand-roll: flip [state] to loading while preserving the previously
/// loaded value, run the `Result`-returning action, log failures, fold the
/// success value back into state, and keep the old value on error. It returns
/// the `Result` so callers can still branch on it (e.g. show a snackbar)
/// without re-reading [state].
mixin MutationNotifier<T> on AsyncNotifier<T> {
  /// Runs [action], folding its success value into the next state via
  /// [onSuccess]. On failure the previously loaded value is kept and, when
  /// [logMessage] is provided, the failure is logged through [loggerProvider].
  Future<Result<R>> mutate<R>(
    Future<Result<R>> Function() action, {
    required T Function(R value) onSuccess,
    String? logMessage,
  }) async {
    state = AsyncLoading<T>();

    final result = await action();

    switch (result) {
      case Ok(value: final value):
        state = AsyncData(onSuccess(value));
      case Err(failure: final failure):
        if (logMessage != null) {
          ref.read(loggerProvider).warn(logMessage, error: failure);
        }
        state = AsyncError<T>(failure, StackTrace.current);
    }

    return result;
  }
}
