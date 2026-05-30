import 'dart:convert';

import 'package:flutter_foundation_kit/core/data/repository_capabilities.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

typedef EntityPredicate<T> = bool Function(T entity);
typedef EntitySorter<T> = int Function(T a, T b);

/// Returns the stable storage id for an entity.
typedef EntityId<T> = String Function(T entity);

/// Serializes an entity to the JSON map stored in Hive.
typedef EntityToJson<T> = Map<String, dynamic> Function(T entity);

/// Reconstructs an entity from a stored JSON map.
typedef EntityFromJson<T> = T Function(Map<String, dynamic> json);

/// Shared Hive-backed local data source for feature repositories.
///
/// For the common case use [localRepository] — one declaration wires the box,
/// serialization, and provider with no subclass and no `main()` setup. Subclass
/// this directly only when a feature needs extra queries beyond the
/// [CrudRepository] surface.
///
/// Serialization is supplied as three functions ([id], [toJson], [fromJson])
/// rather than a separate codec class — pass them inline at the call site.
class HiveLocalRepository<T> implements CrudRepository<T, String> {
  /// Backed by an already-open [box]. Used by tests and callers that manage the
  /// box lifecycle themselves.
  HiveLocalRepository({
    required Box<String> box,
    required this.id,
    required this.toJson,
    required this.fromJson,
    this.sort,
    this.deleteInvalidEntries = false,
  }) : _openBox = (() async => box);

  /// Backed by a box opened lazily on first use (see [localRepository]).
  HiveLocalRepository.lazy({
    required Future<Box<String>> Function() openBox,
    required this.id,
    required this.toJson,
    required this.fromJson,
    this.sort,
    this.deleteInvalidEntries = false,
  }) : _openBox = openBox;

  final Future<Box<String>> Function() _openBox;

  /// Reads an entity's stable storage id.
  final EntityId<T> id;

  /// Serializes an entity for storage.
  final EntityToJson<T> toJson;

  /// Reconstructs an entity from storage.
  final EntityFromJson<T> fromJson;

  final EntitySorter<T>? sort;

  /// Deletes rows that fail to decode instead of returning [UnknownFailure].
  ///
  /// Useful for append-only local data where old malformed records should not
  /// permanently poison a screen.
  final bool deleteInvalidEntries;

  Future<Box<String>>? _cachedBox;
  Future<Box<String>> _box() => _cachedBox ??= _openBox();

  Future<Result<List<T>, Failure>> list({EntityPredicate<T>? where}) async {
    final box = await _box();
    final invalidKeys = <dynamic>[];
    final items = <T>[];

    for (final key in box.keys) {
      final raw = box.get(key);
      if (raw == null) {
        continue;
      }

      try {
        final item = _decode(raw);
        if (where == null || where(item)) {
          items.add(item);
        }
      } on Object catch (error) {
        if (!deleteInvalidEntries) {
          return Err(UnknownFailure(error));
        }
        invalidKeys.add(key);
      }
    }

    if (invalidKeys.isNotEmpty) {
      await box.deleteAll(invalidKeys);
    }

    final sorter = sort;
    if (sorter != null) {
      items.sort(sorter);
    }
    return Ok(items);
  }

  /// Emits the current collection, then re-emits on every box mutation.
  ///
  /// Decode failures surface as stream errors (Riverpod turns them into
  /// `AsyncError`) rather than a `Result` payload — the stream error channel is
  /// `AsyncValue`. Use [list] when you need a one-shot `Result` instead.
  Stream<List<T>> watch({EntityPredicate<T>? where}) async* {
    final box = await _box();
    yield await requireList(where: where);
    yield* box.watch().asyncMap((_) => requireList(where: where));
  }

  @override
  Stream<List<T>> watchAll() => watch();

  @override
  Future<Result<T, Failure>> fetchById(String id) async {
    final box = await _box();
    final raw = box.get(id);
    if (raw == null) {
      return const Err(NotFoundFailure());
    }

    try {
      return Ok(_decode(raw));
    } on Object catch (error) {
      if (deleteInvalidEntries) {
        await box.delete(id);
        return const Err(NotFoundFailure());
      }
      return Err(UnknownFailure(error));
    }
  }

  @override
  Future<Result<T, Failure>> create(T entity) async {
    final box = await _box();
    final entityId = id(entity);
    if (box.containsKey(entityId)) {
      return const Err(ConflictFailure());
    }

    await box.put(entityId, _encode(entity));
    return Ok(entity);
  }

  @override
  Future<Result<T, Failure>> update(T entity) async {
    final box = await _box();
    final entityId = id(entity);
    if (!box.containsKey(entityId)) {
      return const Err(NotFoundFailure());
    }

    await box.put(entityId, _encode(entity));
    return Ok(entity);
  }

  @override
  Future<Result<void, Failure>> deleteById(String id) async {
    final box = await _box();
    if (!box.containsKey(id)) {
      return const Err(NotFoundFailure());
    }

    await box.delete(id);
    return const Ok(null);
  }

  Future<Result<void, Failure>> deleteWhere(EntityPredicate<T> where) async {
    final box = await _box();
    final ids = <dynamic>[];

    for (final key in box.keys) {
      final raw = box.get(key);
      if (raw == null) {
        continue;
      }

      try {
        if (where(_decode(raw))) {
          ids.add(key);
        }
      } on Object catch (error) {
        if (!deleteInvalidEntries) {
          return Err(UnknownFailure(error));
        }
        ids.add(key);
      }
    }

    await box.deleteAll(ids);
    return const Ok(null);
  }

  Future<List<T>> requireList({EntityPredicate<T>? where}) async {
    final result = await list(where: where);
    return switch (result) {
      Ok(value: final value) => value,
      Err(failure: final failure) => throw failure,
    };
  }

  String _encode(T entity) => jsonEncode(toJson(entity));

  T _decode(String raw) => fromJson(jsonDecode(raw) as Map<String, dynamic>);
}

Future<void>? _hiveInitialized;

/// Opens or retrieves a named Hive box, initializing Flutter Hive once.
///
/// Use this when subclassing [HiveLocalRepository] with the lazy constructor
/// to get the same singleton-init guarantee that [localRepository] provides.
Future<Box<String>> openLocalHiveBox(String name) async {
  _hiveInitialized ??= Hive.initFlutter();
  await _hiveInitialized;
  if (Hive.isBoxOpen(name)) {
    return Hive.box<String>(name);
  }
  return Hive.openBox<String>(name);
}

/// Wires a complete Hive-backed repository from a box name and three
/// serialization functions — no subclass, no codec class, no manual box
/// registration, no `main()` setup. The box opens lazily on first use and
/// `Hive.initFlutter()` runs once automatically.
///
/// Returns the [CrudRepository] surface (not the concrete Hive type), so a
/// controller depends on the interface and tests can override the provider with
/// a lightweight fake.
///
/// ```dart
/// final friendRepositoryProvider = localRepository<Friend>(
///   box: 'friends',
///   id: (friend) => friend.id,
///   toJson: (friend) => friend.toJson(),
///   fromJson: Friend.fromJson,
///   sort: (a, b) => b.addedAt.compareTo(a.addedAt),
/// );
/// ```
Provider<CrudRepository<T, String>> localRepository<T>({
  required String box,
  required EntityId<T> id,
  required EntityToJson<T> toJson,
  required EntityFromJson<T> fromJson,
  EntitySorter<T>? sort,
  bool deleteInvalidEntries = false,
}) {
  return Provider<CrudRepository<T, String>>(
    (ref) => HiveLocalRepository<T>.lazy(
      openBox: () => openLocalHiveBox(box),
      id: id,
      toJson: toJson,
      fromJson: fromJson,
      sort: sort,
      deleteInvalidEntries: deleteInvalidEntries,
    ),
  );
}
