import 'package:flutter_foundation_kit/core/logging/logger.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Adds the standard write-side flow to a generated `$AsyncNotifier<T>`
/// (anything a `@riverpod` async controller's `_$...` base extends).
///
/// [mutate] owns the repeated mechanics every mutating controller would
/// otherwise hand-roll: flip [state] to loading while preserving the previously
/// loaded value, run the `Result`-returning action, log failures, fold the
/// success value back into state, and keep the old value on error. It returns
/// the `Result` so callers can still branch on it (e.g. show a snackbar)
/// without re-reading [state].
mixin MutationNotifier<T> on $AsyncNotifier<T> {
  /// Runs [action], folding its success value into the next state via
  /// [onSuccess]. On failure the previously loaded value is kept and, when
  /// [logMessage] is provided, the failure is logged through [loggerProvider].
  Future<Result<R, Failure>> mutate<R>(
    Future<Result<R, Failure>> Function() action, {
    required T Function(R value) onSuccess,
    String? logMessage,
  }) async {
    final previous = state;
    state = AsyncLoading<T>().copyWithPrevious(previous);

    final result = await action();

    switch (result) {
      case Ok(value: final value):
        state = AsyncData(onSuccess(value));
      case Err(failure: final failure):
        if (logMessage != null) {
          ref.read(loggerProvider).warn(logMessage, error: failure);
        }
        state = AsyncError<T>(
          failure,
          StackTrace.current,
        ).copyWithPrevious(previous);
    }

    return result;
  }
}
