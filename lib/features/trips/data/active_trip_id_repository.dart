import 'package:flutter_foundation_kit/core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

/// Persists the single "which trip is active" setting.
///
/// This is the one piece of trip data that is not a CRUD collection, so it owns
/// a tiny lazily-opened settings box directly via [openLocalHiveBox] rather
/// than going through [localRepository].
final activeTripIdRepositoryProvider = Provider<ActiveTripIdRepository>(
  (ref) => ActiveTripIdRepository(),
);

class ActiveTripIdRepository {
  static const String _boxName = 'settings';
  static const String _key = 'activeTripId';

  Future<Box<String>>? _cachedBox;
  Future<Box<String>> _box() => _cachedBox ??= openLocalHiveBox(_boxName);

  Future<String?> read() async => (await _box()).get(_key);

  Future<void> write(String? tripId) async {
    final box = await _box();
    if (tripId == null) {
      await box.delete(_key);
    } else {
      await box.put(_key, tripId);
    }
  }

  Stream<String?> watch() async* {
    final box = await _box();
    yield box.get(_key);
    yield* box.watch(key: _key).map((_) => box.get(_key));
  }
}
