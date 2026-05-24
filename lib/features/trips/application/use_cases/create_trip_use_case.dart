import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/trips/data/trip_id_generator.dart';
import 'package:flutter_foundation_kit/features/trips/data/trip_repository.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';

class CreateTripUseCase {
  const CreateTripUseCase({
    required TripRepository repository,
    required TripIdGenerator idGenerator,
  }) : _repository = repository,
       _idGenerator = idGenerator;

  final TripRepository _repository;
  final TripIdGenerator _idGenerator;

  Future<Result<Trip, Failure>> call({
    required String name,
    required CurrencyCode homeCurrency,
    required DateTime startDate,
    DateTime? endDate,
    double? budgetTotal,
    TripStatus status = TripStatus.planning,
    DateTime? createdAt,
  }) {
    final validationFailure = validateTripFields(
      name: name,
      homeCurrency: homeCurrency,
      startDate: startDate,
      endDate: endDate,
      budgetTotal: budgetTotal,
    );
    if (validationFailure != null) {
      return Future.value(Err(validationFailure));
    }

    final trip = Trip(
      id: _idGenerator.newTripId(),
      name: name.trim(),
      homeCurrency: homeCurrency.trim().toUpperCase(),
      startDate: startDate,
      endDate: endDate,
      budgetTotal: budgetTotal,
      status: status,
      createdAt: createdAt ?? DateTime.now(),
    );
    return _repository.createTrip(trip);
  }
}

ValidationFailure? validateTripFields({
  required String name,
  required CurrencyCode homeCurrency,
  required DateTime startDate,
  DateTime? endDate,
  double? budgetTotal,
}) {
  if (name.trim().isEmpty) {
    return const ValidationFailure('Trip name is required.');
  }
  if (homeCurrency.trim().isEmpty) {
    return const ValidationFailure('Home currency is required.');
  }
  if (endDate != null && endDate.isBefore(startDate)) {
    return const ValidationFailure(
      'Trip end date cannot be before start date.',
    );
  }
  if (budgetTotal != null && budgetTotal < 0) {
    return const ValidationFailure('Trip budget cannot be negative.');
  }
  return null;
}
