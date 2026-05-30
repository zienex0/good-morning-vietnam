/// A typed result of an operation that can succeed with [T] or fail with a
/// [Failure].
///
/// Repositories return `Result<T>`. Controllers unwrap the value into
/// `AsyncValue<T>` with exhaustive switch expressions before the UI sees it.
sealed class Result<T> {
  const Result();
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;
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

/// Raised when a write would collide with an entity that already exists,
/// e.g. creating a record whose id is already present.
final class ConflictFailure extends Failure {
  const ConflictFailure();
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
