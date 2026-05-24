import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/trips/application/use_cases/create_trip_use_case.dart';
import 'package:flutter_foundation_kit/features/trips/data/trip_repository.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';

class EditTripUseCase {
  const EditTripUseCase(this._repository);

  final TripRepository _repository;

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
