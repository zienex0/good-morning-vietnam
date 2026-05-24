import 'dart:async';

import 'package:flutter_foundation_kit/core/logging/logger.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/accounts/application/trip_accounts_provider.dart';
import 'package:flutter_foundation_kit/features/transactions/application/transactions_provider.dart';
import 'package:flutter_foundation_kit/features/trips/application/trips_provider.dart';
import 'package:flutter_foundation_kit/features/trips/application/use_cases/change_trip_status_use_case.dart';
import 'package:flutter_foundation_kit/features/trips/application/use_cases/create_trip_use_case.dart';
import 'package:flutter_foundation_kit/features/trips/application/use_cases/delete_trip_use_case.dart';
import 'package:flutter_foundation_kit/features/trips/application/use_cases/edit_trip_use_case.dart';
import 'package:flutter_foundation_kit/features/trips/application/use_cases/set_active_trip_use_case.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trip_form_provider.g.dart';

@riverpod
class TripFormNotifier extends _$TripFormNotifier {
  @override
  FutureOr<void> build() {}

  Future<Trip?> createTrip({
    required String name,
    required CurrencyCode homeCurrency,
    required DateTime startDate,
    DateTime? endDate,
    double? budgetTotal,
  }) async {
    state = const AsyncLoading<void>();
    final result =
        await CreateTripUseCase(
          repository: ref.read(tripRepositoryProvider),
          idGenerator: ref.read(tripIdGeneratorProvider),
        ).call(
          name: name,
          homeCurrency: homeCurrency,
          startDate: startDate,
          endDate: endDate,
          budgetTotal: budgetTotal,
          status: TripStatus.active,
        );
    switch (result) {
      case Ok(value: final trip):
        final activate = await SetActiveTripUseCase(
          ref.read(tripRepositoryProvider),
        ).call(trip.id);
        switch (activate) {
          case Ok():
            state = const AsyncData<void>(null);
            return trip;
          case Err(failure: final failure):
            _fail(failure, 'Could not activate created trip');
            return null;
        }
      case Err(failure: final failure):
        _fail(failure, 'Trip creation failed');
        return null;
    }
  }

  Future<bool> editTrip(Trip trip) => _run(
    () => EditTripUseCase(ref.read(tripRepositoryProvider)).call(trip),
    'Trip edit failed',
  );

  Future<bool> changeStatus({
    required String tripId,
    required TripStatus status,
  }) => _run(
    () => ChangeTripStatusUseCase(
      ref.read(tripRepositoryProvider),
    ).call(tripId: tripId, newStatus: status),
    'Trip status change failed',
  );

  Future<bool> deleteTrip({required String tripId}) => _run(
    () => DeleteTripUseCase(
      tripRepository: ref.read(tripRepositoryProvider),
      accountRepository: ref.read(accountRepositoryProvider),
      transactionRepository: ref.read(transactionRepositoryProvider),
    ).call(tripId: tripId),
    'Trip delete failed',
  );

  Future<bool> activateTrip(String tripId) => _run(
    () => SetActiveTripUseCase(ref.read(tripRepositoryProvider)).call(tripId),
    'Trip activation failed',
  );

  Future<bool> _run(
    Future<Result<Object?, Failure>> Function() action,
    String message,
  ) async {
    state = const AsyncLoading<void>();
    final result = await action();
    switch (result) {
      case Ok():
        state = const AsyncData<void>(null);
        return true;
      case Err(failure: final failure):
        _fail(failure, message);
        return false;
    }
  }

  void _fail(Failure failure, String message) {
    ref.read(loggerProvider).warn(message, error: failure);
    state = AsyncError<void>(failure, StackTrace.current);
  }
}
