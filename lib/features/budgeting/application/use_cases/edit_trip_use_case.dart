import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/create_trip_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_trip_use_case.g.dart';

class EditTripUseCase {
  const EditTripUseCase(this._repository);

  final BudgetingRepository _repository;

  Future<Result<Trip, Failure>> call(Trip trip) {
    final validationFailure = validateTripFields(
      name: trip.name,
      homeCurrency: trip.homeCurrency,
      startDate: trip.startDate,
      endDate: trip.endDate,
      budgetTotal: trip.budgetTotal,
    );
    if (validationFailure != null) {
      return Future.value(Err(validationFailure));
    }
    return _repository.updateTrip(
      trip.copyWith(
        name: trip.name.trim(),
        homeCurrency: trip.homeCurrency.trim().toUpperCase(),
      ),
    );
  }
}

@Riverpod(keepAlive: true)
EditTripUseCase editTripUseCase(EditTripUseCaseRef ref) {
  return EditTripUseCase(ref.watch(budgetingRepositoryProvider));
}
