import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/trips/data/trip_repository.dart';

class SetActiveTripUseCase {
  const SetActiveTripUseCase(this._repository);

  final TripRepository _repository;

  Future<Result<void, Failure>> call(String? tripId) async {
    if (tripId == null) {
      await _repository.setActiveTripId(null);
      return const Ok(null);
    }
    final tripResult = await _repository.fetchTrip(tripId: tripId);
    switch (tripResult) {
      case Ok():
        await _repository.setActiveTripId(tripId);
        return const Ok(null);
      case Err(failure: final failure):
        return Err(failure);
    }
  }
}
