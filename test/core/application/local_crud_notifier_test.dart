import 'package:flutter_foundation_kit/core/application/local_crud_notifier.dart';
import 'package:flutter_foundation_kit/core/data/data.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

class _Item {
  const _Item(this.id, this.value);
  final String id;
  final int value;
}

class _FakeRepo implements CrudRepository<_Item, String> {
  final List<_Item> created = [];
  final List<_Item> updated = [];
  final List<String> deleted = [];

  @override
  Future<Result<_Item, Failure>> create(_Item input) async {
    created.add(input);
    return Ok(input);
  }

  @override
  Future<Result<_Item, Failure>> update(_Item input) async {
    updated.add(input);
    return Ok(input);
  }

  @override
  Future<Result<void, Failure>> deleteById(String id) async {
    deleted.add(id);
    return const Ok(null);
  }

  @override
  Future<Result<_Item, Failure>> fetchById(String id) async =>
      const Err(NotFoundFailure());

  @override
  Stream<List<_Item>> watchAll() => const Stream<List<_Item>>.empty();
}

class _FailingRepo extends _FakeRepo {
  @override
  Future<Result<_Item, Failure>> create(_Item input) async =>
      const Err(ValidationFailure('repo rejected'));

  @override
  Future<Result<void, Failure>> deleteById(String id) async =>
      const Err(ValidationFailure('delete rejected'));
}

// The mixin has no `on` clause, so it composes onto a plain host for testing.
class _Store with LocalCrudNotifier<_Item> {
  _Store(
    this.repository, {
    this.allowCreate = true,
    this.afterCreateCallback,
    this.afterUpdateCallback,
    this.afterDeleteCallback,
  });

  @override
  final CrudRepository<_Item, String> repository;
  final bool allowCreate;

  final void Function(_Item entity, Result<_Item, Failure> result)? afterCreateCallback;
  final void Function(_Item entity, Result<_Item, Failure> result)? afterUpdateCallback;
  final void Function(String id, Result<void, Failure> result)? afterDeleteCallback;

  @override
  Future<Result<_Item, Failure>> beforeCreate(_Item entity) async =>
      allowCreate ? Ok(entity) : const Err(ValidationFailure('blocked'));

  @override
  Future<void> afterCreate(_Item entity, Result<_Item, Failure> result) async =>
      afterCreateCallback?.call(entity, result);

  @override
  Future<void> afterUpdate(_Item entity, Result<_Item, Failure> result) async =>
      afterUpdateCallback?.call(entity, result);

  @override
  Future<void> afterDelete(String id, Result<void, Failure> result) async =>
      afterDeleteCallback?.call(id, result);
}

void main() {
  group('create', () {
    test('runs beforeCreate then forwards to the repository', () async {
      final repo = _FakeRepo();
      final store = _Store(repo);

      final result = await store.create(const _Item('a', 1));

      expect(result, isA<Ok<_Item, Failure>>());
      expect(repo.created, hasLength(1));
    });

    test('short-circuits when beforeCreate fails', () async {
      final repo = _FakeRepo();
      final store = _Store(repo, allowCreate: false);

      final result = await store.create(const _Item('a', 1));

      expect(result, isA<Err<_Item, Failure>>());
      expect(repo.created, isEmpty);
    });

    test('afterCreate fires with the entity and success result', () async {
      final repo = _FakeRepo();
      _Item? capturedEntity;
      Result<_Item, Failure>? capturedResult;
      final store = _Store(
        repo,
        afterCreateCallback: (e, r) {
          capturedEntity = e;
          capturedResult = r;
        },
      );

      await store.create(const _Item('a', 1));

      expect(capturedEntity?.id, 'a');
      expect(capturedResult, isA<Ok<_Item, Failure>>());
    });

    test('afterCreate fires with Err when repository rejects', () async {
      final repo = _FailingRepo();
      Result<_Item, Failure>? capturedResult;
      final store = _Store(
        repo,
        afterCreateCallback: (_, r) => capturedResult = r,
      );

      await store.create(const _Item('a', 1));

      expect(capturedResult, isA<Err<_Item, Failure>>());
    });

    test('afterCreate does not fire when beforeCreate short-circuits', () async {
      final repo = _FakeRepo();
      var afterFired = false;
      final store = _Store(
        repo,
        allowCreate: false,
        afterCreateCallback: (_, __) => afterFired = true,
      );

      await store.create(const _Item('a', 1));

      expect(afterFired, isFalse);
    });
  });

  group('update', () {
    test('afterUpdate fires with the entity and result', () async {
      final repo = _FakeRepo();
      _Item? capturedEntity;
      Result<_Item, Failure>? capturedResult;
      final store = _Store(
        repo,
        afterUpdateCallback: (e, r) {
          capturedEntity = e;
          capturedResult = r;
        },
      );

      await store.update(const _Item('b', 2));

      expect(capturedEntity?.id, 'b');
      expect(capturedResult, isA<Ok<_Item, Failure>>());
    });
  });

  group('delete', () {
    test('forwards to the repository', () async {
      final repo = _FakeRepo();
      final store = _Store(repo);

      await store.delete('a');

      expect(repo.deleted, ['a']);
    });

    test('afterDelete fires with the id and success result', () async {
      final repo = _FakeRepo();
      String? capturedId;
      Result<void, Failure>? capturedResult;
      final store = _Store(
        repo,
        afterDeleteCallback: (id, r) {
          capturedId = id;
          capturedResult = r;
        },
      );

      await store.delete('x');

      expect(capturedId, 'x');
      expect(capturedResult, isA<Ok<void, Failure>>());
    });

    test('afterDelete fires with Err when repository rejects', () async {
      final repo = _FailingRepo();
      Result<void, Failure>? capturedResult;
      final store = _Store(
        repo,
        afterDeleteCallback: (_, r) => capturedResult = r,
      );

      await store.delete('x');

      expect(capturedResult, isA<Err<void, Failure>>());
    });
  });
}
