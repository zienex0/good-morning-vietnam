import 'package:flutter_foundation_kit/core/result/result.dart';

/// Repository capability for watching an unscoped collection.
///
/// One-shot reads return `Result<T>`; watch streams surface failures as stream
/// errors so Riverpod converts them to `AsyncValue.error` (an `AsyncError`).
/// Do not wrap stream payloads in `Result` — the error channel is `AsyncValue`.
abstract interface class WatchAll<T> {
  Stream<List<T>> watchAll();
}

/// Repository capability for watching a collection inside a parent scope.
///
/// Same error contract as [WatchAll]: failures surface as stream errors, not as
/// `Result` payloads.
abstract interface class WatchScoped<T, Scope> {
  Stream<List<T>> watchByScope(Scope scope);
}

/// Repository capability for fetching one entity by id.
abstract interface class FetchById<T, Id> {
  Future<Result<T>> fetchById(Id id);
}

/// Repository capability for creating an entity from an input object.
abstract interface class CreateEntity<T, Input> {
  Future<Result<T>> create(Input input);
}

/// Repository capability for updating an entity from an input object.
abstract interface class UpdateEntity<T, Input> {
  Future<Result<T>> update(Input input);
}

/// Repository capability for deleting one entity by id.
abstract interface class DeleteById<Id> {
  Future<Result<void>> deleteById(Id id);
}

/// The full create/read/update/delete surface a [HiveLocalRepository] exposes.
///
/// CRUD feature controllers depend on this (via `LocalCrudNotifier`) instead of
/// a hand-written per-feature repository interface. Declare a narrower
/// capability interface only when a feature genuinely needs a subset.
abstract interface class CrudRepository<T, Id>
    implements
        WatchAll<T>,
        FetchById<T, Id>,
        CreateEntity<T, T>,
        UpdateEntity<T, T>,
        DeleteById<Id> {}
