import 'dart:async';

import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/load_transactions_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/load_trips_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_trip_providers.g.dart';

/// In-memory mirror of the persisted active trip id.
///
/// `build()` reads the current value from the repository on each
/// invalidation. Mutations go through `SetActiveTripUseCase` and then
/// invalidate this provider — see `BudgetingTripFormController` and the
/// drawer / onboarding handlers.
@Riverpod(keepAlive: true)
String? activeTripId(ActiveTripIdRef ref) {
  return ref.watch(budgetingRepositoryProvider).getActiveTripId();
}

@Riverpod(keepAlive: true)
Future<List<Trip>> tripsList(TripsListRef ref) async {
  final result = await ref.watch(loadTripsUseCaseProvider).call();
  switch (result) {
    case Ok(value: final value):
      return value;
    case Err(failure: final failure):
      throw failure;
  }
}

@Riverpod(keepAlive: true)
Future<Trip?> activeTrip(ActiveTripRef ref) async {
  final id = ref.watch(activeTripIdProvider);
  if (id == null) {
    return null;
  }
  final result = await ref
      .watch(budgetingRepositoryProvider)
      .fetchTrip(tripId: id);
  switch (result) {
    case Ok(value: final value):
      return value;
    case Err():
      return null;
  }
}

@Riverpod(keepAlive: true)
Future<List<Account>> accountsForActiveTrip(
  AccountsForActiveTripRef ref,
) async {
  final id = ref.watch(activeTripIdProvider);
  if (id == null) {
    return const [];
  }
  final result = await ref
      .watch(budgetingRepositoryProvider)
      .fetchAccounts(tripId: id);
  switch (result) {
    case Ok(value: final value):
      return value;
    case Err(failure: final failure):
      throw failure;
  }
}

@Riverpod(keepAlive: true)
Future<List<Transaction>> transactionsForActiveTrip(
  TransactionsForActiveTripRef ref,
) async {
  final id = ref.watch(activeTripIdProvider);
  if (id == null) {
    return const [];
  }
  final result = await ref
      .watch(loadTransactionsUseCaseProvider)
      .call(tripId: id);
  switch (result) {
    case Ok(value: final value):
      return value;
    case Err(failure: final failure):
      throw failure;
  }
}

/// Invalidate every provider that may change as a result of a mutation.
/// Form controllers call this in their success branch.
void invalidateBudgetingProviders(Ref ref) {
  ref.invalidate(tripsListProvider);
  ref.invalidate(activeTripProvider);
  ref.invalidate(accountsForActiveTripProvider);
  ref.invalidate(transactionsForActiveTripProvider);
}
