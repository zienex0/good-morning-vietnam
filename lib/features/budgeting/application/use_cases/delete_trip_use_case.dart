import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_trip_use_case.g.dart';

class DeleteTripUseCase {
  const DeleteTripUseCase(this._repository);

  final BudgetingRepository _repository;

  Future<Result<void, Failure>> call({required String tripId}) {
    if (tripId.trim().isEmpty) {
      return Future.value(const Err(ValidationFailure('Trip id is required.')));
    }
    return _repository.deleteTrip(tripId: tripId);
  }
}

@Riverpod(keepAlive: true)
DeleteTripUseCase deleteTripUseCase(DeleteTripUseCaseRef ref) {
  return DeleteTripUseCase(ref.watch(budgetingRepositoryProvider));
}
