import 'dart:io';

import 'package:flutter_foundation_kit/core/data/data.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

void main() {
  late Directory tempDir;
  late Box<String> box;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp(
      'hive_local_repository_test_',
    );
    Hive.init(tempDir.path);
    box = await Hive.openBox<String>('items');
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  test('create, list, update, and delete round-trip through json', () async {
    final repo = _TestRepository(box);

    expectOk(await repo.create(const _TestItem(id: 'a', value: 2)));
    expectOk(await repo.create(const _TestItem(id: 'b', value: 1)));

    expect(expectOk(await repo.list()), const [
      _TestItem(id: 'b', value: 1),
      _TestItem(id: 'a', value: 2),
    ]);

    expectOk(await repo.update(const _TestItem(id: 'a', value: 3)));
    expect(
      expectOk(await repo.fetchById('a')),
      const _TestItem(id: 'a', value: 3),
    );

    expectOk(await repo.deleteById('a'));
    expect(await repo.fetchById('a'), isA<Err<_TestItem>>());
  });

  test('create rejects a duplicate id with ConflictFailure', () async {
    final repo = _TestRepository(box);
    expectOk(await repo.create(const _TestItem(id: 'a', value: 1)));

    final result = await repo.create(const _TestItem(id: 'a', value: 2));

    expect(result, isA<Err<_TestItem>>());
    expect((result as Err<_TestItem>).failure, isA<ConflictFailure>());
    // The original row is untouched by the rejected create.
    expect(
      expectOk(await repo.fetchById('a')),
      const _TestItem(id: 'a', value: 1),
    );
  });

  test('deleteWhere removes matching decoded entities', () async {
    final repo = _TestRepository(box);
    expectOk(await repo.create(const _TestItem(id: 'a', value: 1)));
    expectOk(await repo.create(const _TestItem(id: 'b', value: 2)));
    expectOk(await repo.create(const _TestItem(id: 'c', value: 3)));

    expectOk(await repo.deleteWhere((item) => item.value.isOdd));

    expect(expectOk(await repo.list()), const [_TestItem(id: 'b', value: 2)]);
  });

  test('invalid entries can be deleted instead of poisoning reads', () async {
    final repo = _TestRepository(box, deleteInvalidEntries: true);
    expectOk(await repo.create(const _TestItem(id: 'a', value: 1)));
    await box.put('bad', '{not-json');

    expect(expectOk(await repo.list()), const [_TestItem(id: 'a', value: 1)]);
    expect(box.containsKey('bad'), isFalse);
  });
}

T expectOk<T>(Result<T> result) {
  return switch (result) {
    Ok(value: final value) => value,
    Err(failure: final failure) => fail('Expected Ok, got $failure'),
  };
}

class _TestRepository extends HiveLocalRepository<_TestItem> {
  _TestRepository(Box<String> box, {super.deleteInvalidEntries})
    : super(
        box: box,
        id: (item) => item.id,
        toJson: (item) => {'id': item.id, 'value': item.value},
        fromJson: (json) =>
            _TestItem(id: json['id'] as String, value: json['value'] as int),
        sort: (a, b) => a.value.compareTo(b.value),
      );
}

class _TestItem {
  const _TestItem({required this.id, required this.value});

  final String id;
  final int value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _TestItem && other.id == id && other.value == value;

  @override
  int get hashCode => Object.hash(id, value);

  @override
  String toString() => '_TestItem(id: $id, value: $value)';
}
