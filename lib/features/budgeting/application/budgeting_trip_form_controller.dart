import 'package:flutter_foundation_kit/core/logging/logger.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/change_trip_status_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/create_account_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/create_trip_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/delete_trip_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/edit_trip_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/set_active_trip_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budgeting_trip_form_controller.g.dart';

@riverpod
class BudgetingTripFormController extends _$BudgetingTripFormController {
  @override
  AsyncValue<void> build() => const AsyncData<void>(null);

  Future<Trip?> createTrip({
    required String name,
    required CurrencyCode homeCurrency,
    required DateTime startDate,
    DateTime? endDate,
    double? budgetTotal,
  }) async {
    state = const AsyncLoading<void>();
    final result = await ref
        .read(createTripUseCaseProvider)
        .call(
          name: name,
          homeCurrency: homeCurrency,
          startDate: startDate,
          endDate: endDate,
          budgetTotal: budgetTotal,
          status: TripStatus.active,
        );
    switch (result) {
      case Ok(value: final trip):
        final activate = await ref
            .read(setActiveTripUseCaseProvider)
            .call(trip.id);
        switch (activate) {
          case Ok():
            invalidateBudgetingProviders(ref);
            ref.invalidate(activeTripIdProvider);
            state = const AsyncData<void>(null);
            return trip;
          case Err(failure: final failure):
            ref
                .read(loggerProvider)
                .warn('Could not activate created trip', error: failure);
            state = AsyncError<void>(failure, StackTrace.current);
            return null;
        }
      case Err(failure: final failure):
        ref.read(loggerProvider).warn('Trip creation failed', error: failure);
        state = AsyncError<void>(failure, StackTrace.current);
        return null;
    }
  }

  Future<bool> editTrip(Trip trip) async {
    state = const AsyncLoading<void>();
    final result = await ref.read(editTripUseCaseProvider).call(trip);
    return _handle(result, 'Trip edit failed');
  }

  Future<bool> changeStatus({
    required String tripId,
    required TripStatus status,
  }) async {
    state = const AsyncLoading<void>();
    final result = await ref
        .read(changeTripStatusUseCaseProvider)
        .call(tripId: tripId, newStatus: status);
    return _handle(result, 'Trip status change failed');
  }

  Future<bool> deleteTrip({required String tripId}) async {
    state = const AsyncLoading<void>();
    final result = await ref
        .read(deleteTripUseCaseProvider)
        .call(tripId: tripId);
    if (result is Ok) {
      ref.invalidate(activeTripIdProvider);
    }
    return _handle(result, 'Trip delete failed');
  }

  Future<bool> activateTrip(String tripId) async {
    state = const AsyncLoading<void>();
    final result = await ref.read(setActiveTripUseCaseProvider).call(tripId);
    if (result is Ok) {
      ref.invalidate(activeTripIdProvider);
    }
    return _handle(result, 'Trip activation failed');
  }

  Future<Account?> createAccount({
    required String tripId,
    required String name,
    required AccountType type,
    required CurrencyCode currency,
    required double openingBalance,
  }) async {
    state = const AsyncLoading<void>();
    final result = await ref
        .read(createAccountUseCaseProvider)
        .call(
          tripId: tripId,
          name: name,
          type: type,
          currency: currency,
          openingBalance: openingBalance,
        );
    switch (result) {
      case Ok(value: final account):
        invalidateBudgetingProviders(ref);
        state = const AsyncData<void>(null);
        return account;
      case Err(failure: final failure):
        ref
            .read(loggerProvider)
            .warn('Account creation failed', error: failure);
        state = AsyncError<void>(failure, StackTrace.current);
        return null;
    }
  }

  bool _handle(Result<Object?, Failure> result, String logMessage) {
    switch (result) {
      case Ok():
        invalidateBudgetingProviders(ref);
        state = const AsyncData<void>(null);
        return true;
      case Err(failure: final failure):
        ref.read(loggerProvider).warn(logMessage, error: failure);
        state = AsyncError<void>(failure, StackTrace.current);
        return false;
    }
  }
}
