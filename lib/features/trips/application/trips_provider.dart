import 'package:flutter_foundation_kit/features/trips/data/trip_id_generator.dart';
import 'package:flutter_foundation_kit/features/trips/data/trip_repository.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trips_provider.g.dart';

@Riverpod(keepAlive: true)
Box<String> tripsBox(Ref ref) {
  throw StateError('tripsBoxProvider must be overridden in main().');
}

@Riverpod(keepAlive: true)
Box<String> settingsBox(Ref ref) {
  throw StateError('settingsBoxProvider must be overridden in main().');
}

@Riverpod(keepAlive: true)
TripRepository tripRepository(Ref ref) {
  return HiveTripRepository(
    tripsBox: ref.watch(tripsBoxProvider),
    settingsBox: ref.watch(settingsBoxProvider),
  );
}

@Riverpod(keepAlive: true)
TripIdGenerator tripIdGenerator(Ref ref) => const TimestampTripIdGenerator();

/// Live list of all trips.
@riverpod
Stream<List<Trip>> trips(Ref ref) =>
    ref.watch(tripRepositoryProvider).watchTrips();
