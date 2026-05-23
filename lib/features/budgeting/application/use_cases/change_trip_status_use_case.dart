import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/trip_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';

class ChangeTripStatusUseCase {
  const ChangeTripStatusUseCase(this._repository);

  final TripRepository _repository;

  Future<Result<Trip, Failure>> call({
    required String tripId,
    required TripStatus newStatus,
  }) async {
    final tripResult = await _repository.fetchTrip(tripId: tripId);
    final Trip trip;
    switch (tripResult) {
      case Ok(value: final value):
        trip = value;
      case Err(failure: final failure):
        return Err(failure);
    }
    return _repository.updateTrip(trip.copyWith(status: newStatus));
  }
}
