import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'set_active_trip_use_case.g.dart';

class SetActiveTripUseCase {
  const SetActiveTripUseCase(this._repository);

  final BudgetingRepository _repository;

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

@Riverpod(keepAlive: true)
SetActiveTripUseCase setActiveTripUseCase(SetActiveTripUseCaseRef ref) {
  return SetActiveTripUseCase(ref.watch(budgetingRepositoryProvider));
}
