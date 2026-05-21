/// A typed result of an operation that can succeed with [S] or fail with [F].
///
/// Repositories return `Result<T, Failure>`. Controllers unwrap the value into
/// `AsyncValue<T>` with exhaustive switch expressions before the UI sees it.
sealed class Result<S, F extends Failure> {
  const Result();
}

final class Ok<S, F extends Failure> extends Result<S, F> {
  const Ok(this.value);
  final S value;
}

final class Err<S, F extends Failure> extends Result<S, F> {
  const Err(this.failure);
  final F failure;
}

sealed class Failure {
  const Failure();
}

final class NetworkFailure extends Failure {
  const NetworkFailure();
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure();
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure();
}

final class ValidationFailure extends Failure {
  const ValidationFailure(this.message);
  final String message;
}

final class UnknownFailure extends Failure {
  const UnknownFailure(this.error);
  final Object error;
}
