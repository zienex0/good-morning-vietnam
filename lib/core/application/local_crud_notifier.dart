import 'package:flutter_foundation_kit/core/data/repository_capabilities.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';

/// Gives a controller a complete CRUD surface over a [CrudRepository] with no
/// per-operation use cases.
///
/// Mix it into a generated stream notifier whose state is the live collection,
/// and implement [repository]. The controller's `build()` is then a one-liner:
///
/// ```dart
/// @riverpod
/// class FriendsController extends _$FriendsController
///     with LocalCrudNotifier<Friend> {
///   @override
///   CrudRepository<Friend, String> get repository =>
///       ref.read(friendRepositoryProvider);
///
///   @override
///   Stream<List<Friend>> build() => watchAll();
/// }
/// ```
///
/// The list re-emits from the repository's watch stream after every write, so
/// mutations never touch state — they just return a [Result] the page can act
/// on.
///
/// ## Business logic hooks
///
/// Override [beforeCreate] / [beforeUpdate] to validate or normalise an entity
/// before it reaches the repository. Override [afterCreate] / [afterUpdate] /
/// [afterDelete] to run side effects after a write, or to compensate (roll
/// back) a write you made in a `before` hook when the primary write fails.
/// Both hook families have access to `ref` through the surrounding controller.
///
/// This means the vast majority of features — including multi-repository
/// operations that need rollback — can be expressed entirely in hooks without
/// a separate use-case class.
mixin LocalCrudNotifier<T> {
  /// The repository this controller drives. Implement with a `ref.read(...)` of
  /// the feature's `localRepository` provider.
  CrudRepository<T, String> get repository;

  // ---------------------------------------------------------------------------
  // Before hooks
  // ---------------------------------------------------------------------------

  /// Validates or normalises [entity] before [create] forwards it to the
  /// repository. Return an [Err] to abort the write. The default lets
  /// everything through.
  Future<Result<T>> beforeCreate(T entity) async => Ok(entity);

  /// Validates or normalises [entity] before [update] forwards it to the
  /// repository. Return an [Err] to abort the write. The default lets
  /// everything through.
  Future<Result<T>> beforeUpdate(T entity) async => Ok(entity);

  // ---------------------------------------------------------------------------
  // After hooks
  // ---------------------------------------------------------------------------

  /// Called after the repository [create] call completes, whether it succeeded
  /// or failed. [entity] is the value that was passed to the repository (the
  /// output of [beforeCreate]). Override to run follow-up writes or, when
  /// [result] is [Err], to undo a side effect from [beforeCreate].
  Future<void> afterCreate(T entity, Result<T> result) async {}

  /// Called after the repository [update] call completes. [entity] is the
  /// value that was passed to the repository (the output of [beforeUpdate]).
  /// Override to run follow-up writes or compensate on [Err].
  Future<void> afterUpdate(T entity, Result<T> result) async {}

  /// Called after the repository [deleteById] call completes. Override to
  /// cascade deletes or compensate when [result] is [Err].
  Future<void> afterDelete(String id, Result<void> result) async {}

  // ---------------------------------------------------------------------------
  // CRUD surface
  // ---------------------------------------------------------------------------

  /// The live collection — wire this from `build()`.
  Stream<List<T>> watchAll() => repository.watchAll();

  Future<Result<T>> fetch(String id) => repository.fetchById(id);

  Future<Result<T>> create(T entity) async {
    final checked = await beforeCreate(entity);
    if (checked case Ok(value: final validated)) {
      final result = await repository.create(validated);
      await afterCreate(validated, result);
      return result;
    }
    return checked;
  }

  /// Validates [entity] through [beforeUpdate] then persists it.
  ///
  /// Named `save` rather than `update` because the generated notifier base
  /// already defines an `update` method; this is the CRUD write entry point.
  Future<Result<T>> save(T entity) async {
    final checked = await beforeUpdate(entity);
    if (checked case Ok(value: final validated)) {
      final result = await repository.update(validated);
      await afterUpdate(validated, result);
      return result;
    }
    return checked;
  }

  Future<Result<void>> delete(String id) async {
    final result = await repository.deleteById(id);
    await afterDelete(id, result);
    return result;
  }
}
