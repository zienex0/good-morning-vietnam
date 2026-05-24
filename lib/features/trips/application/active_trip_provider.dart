import 'package:flutter_foundation_kit/features/trips/application/trips_provider.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_trip_provider.g.dart';

/// Id of the active trip, or null when none is selected.
@riverpod
Stream<String?> activeTripId(Ref ref) =>
    ref.watch(tripRepositoryProvider).watchActiveTripId();

/// The active trip resolved from [tripsProvider], or null when none is active.
@riverpod
Future<Trip?> activeTrip(Ref ref) async {
  final id = ref.watch(activeTripIdProvider).value;
  if (id == null) {
    return null;
  }
  final allTrips = await ref.watch(tripsProvider.future);
  for (final trip in allTrips) {
    if (trip.id == id) {
      return trip;
    }
  }
  return null;
}
