import 'package:flutter_foundation_kit/core/application/local_crud_notifier.dart';
import 'package:flutter_foundation_kit/core/data/repository_capabilities.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/accounts/data/account_repository.dart';
import 'package:flutter_foundation_kit/features/transactions/data/transaction_repository.dart';
import 'package:flutter_foundation_kit/features/trips/data/active_trip_id_repository.dart';
import 'package:flutter_foundation_kit/features/trips/data/trip_repository.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trips_controller.g.dart';

/// Owns the live list of trips plus every trip write.
///
/// Validation lives in [beforeCreate] / [beforeUpdate]; the new trip is made
/// active in [afterCreate]; the delete-trip cascade (accounts + transactions +
/// clearing the active trip) lives in [afterDelete]. No use cases needed.
@riverpod
class TripsController extends _$TripsController with LocalCrudNotifier<Trip> {
  @override
  CrudRepository<Trip, String> get repository =>
      ref.read(tripRepositoryProvider);

  @override
  Stream<List<Trip>> build() => watchAll();

  @override
  Future<Result<Trip>> beforeCreate(Trip draft) async {
    final normalized = _normalize(draft);
    final failure = _validate(normalized);
    if (failure != null) {
      return Err(failure);
    }
    final id = draft.id.isEmpty
        ? 'trip-${DateTime.now().microsecondsSinceEpoch}'
        : draft.id;
    return Ok(normalized.copyWith(id: id));
  }

  @override
  Future<Result<Trip>> beforeUpdate(Trip draft) async {
    final normalized = _normalize(draft);
    final failure = _validate(normalized);
    if (failure != null) {
      return Err(failure);
    }
    return Ok(normalized);
  }

  /// A freshly created trip becomes the active one.
  @override
  Future<void> afterCreate(Trip entity, Result<Trip> result) async {
    if (result is Ok<Trip>) {
      await ref.read(activeTripIdRepositoryProvider).write(entity.id);
    }
  }

  /// Removes everything that belongs to the trip and clears the active trip.
  @override
  Future<void> afterDelete(String id, Result<void> result) async {
    if (result is! Ok<void>) {
      return;
    }
    final accounts = ref.read(accountRepositoryProvider);
    for (final account in await accounts.watchAll().first) {
      if (account.tripId == id) {
        await accounts.deleteById(account.id);
      }
    }
    final transactions = ref.read(transactionRepositoryProvider);
    for (final transaction in await transactions.watchAll().first) {
      if (transaction.tripId == id) {
        await transactions.deleteById(transaction.id);
      }
    }
    final activeTripId = ref.read(activeTripIdRepositoryProvider);
    if (await activeTripId.read() == id) {
      await activeTripId.write(null);
    }
  }

  /// Updates only the trip's lifecycle status.
  Future<Result<Trip>> changeStatus(String tripId, TripStatus status) async {
    final current = await fetch(tripId);
    return switch (current) {
      Ok(value: final trip) => await save(trip.copyWith(status: status)),
      Err() => current,
    };
  }

  /// Marks [tripId] active (or clears it when null) after checking it exists.
  Future<Result<void>> activate(String? tripId) async {
    if (tripId == null) {
      await ref.read(activeTripIdRepositoryProvider).write(null);
      return const Ok(null);
    }
    final found = await fetch(tripId);
    if (found case Err(failure: final failure)) {
      return Err(failure);
    }
    await ref.read(activeTripIdRepositoryProvider).write(tripId);
    return const Ok(null);
  }

  Trip _normalize(Trip trip) => trip.copyWith(
    name: trip.name.trim(),
    homeCurrency: trip.homeCurrency.trim().toUpperCase(),
  );

  Failure? _validate(Trip trip) {
    if (trip.name.isEmpty) {
      return const ValidationFailure('Trip name is required.');
    }
    if (trip.homeCurrency.isEmpty) {
      return const ValidationFailure('Home currency is required.');
    }
    if (trip.endDate != null && trip.endDate!.isBefore(trip.startDate)) {
      return const ValidationFailure(
        'Trip end date cannot be before start date.',
      );
    }
    if (trip.budgetTotal != null && trip.budgetTotal! < 0) {
      return const ValidationFailure('Trip budget cannot be negative.');
    }
    return null;
  }
}
