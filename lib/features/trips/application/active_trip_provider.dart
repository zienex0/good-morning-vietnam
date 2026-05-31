import 'package:flutter_foundation_kit/features/trips/application/trips_controller.dart';
import 'package:flutter_foundation_kit/features/trips/data/active_trip_id_repository.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_trip_provider.g.dart';

/// Id of the active trip, or null when none is selected.
@riverpod
Stream<String?> activeTripId(Ref ref) =>
    ref.watch(activeTripIdRepositoryProvider).watch();

/// The active trip resolved from [tripsControllerProvider], or null when none
/// is active.
@riverpod
Future<Trip?> activeTrip(Ref ref) async {
  final id = ref.watch(activeTripIdProvider).value;
  if (id == null) {
    return null;
  }
  final trips = await ref.watch(tripsControllerProvider.future);
  for (final trip in trips) {
    if (trip.id == id) {
      return trip;
    }
  }
  return null;
}
