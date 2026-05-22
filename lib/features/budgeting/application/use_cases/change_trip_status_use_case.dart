import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_trip_status_use_case.g.dart';

class ChangeTripStatusUseCase {
  const ChangeTripStatusUseCase(this._repository);

  final BudgetingRepository _repository;

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

@Riverpod(keepAlive: true)
ChangeTripStatusUseCase changeTripStatusUseCase(
  ChangeTripStatusUseCaseRef ref,
) {
  return ChangeTripStatusUseCase(ref.watch(budgetingRepositoryProvider));
}
