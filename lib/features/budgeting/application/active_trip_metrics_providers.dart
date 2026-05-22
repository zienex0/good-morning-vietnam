import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/calculate_average_daily_spend_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/calculate_days_left_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/calculate_spend_trend_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/calculate_total_accounts_balance_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/calculate_total_spend_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_trip_metrics_providers.g.dart';

@Riverpod(keepAlive: true)
Future<double> activeTripTotalBalance(ActiveTripTotalBalanceRef ref) async {
  final id = ref.watch(activeTripIdProvider);
  if (id == null) {
    return 0;
  }
  ref.watch(activeTripProvider);
  ref.watch(transactionsForActiveTripProvider);
  ref.watch(accountsForActiveTripProvider);
  final result = await ref
      .watch(calculateTotalAccountsBalanceUseCaseProvider)
      .call(tripId: id, asOf: DateTime.now());
  switch (result) {
    case Ok(value: final value):
      return value;
    case Err(failure: final failure):
      throw failure;
  }
}

@Riverpod(keepAlive: true)
Future<double> activeTripTotalSpend(ActiveTripTotalSpendRef ref) async {
  final id = ref.watch(activeTripIdProvider);
  if (id == null) {
    return 0;
  }
  ref.watch(activeTripProvider);
  ref.watch(transactionsForActiveTripProvider);
  final result = await ref
      .watch(calculateTotalSpendUseCaseProvider)
      .call(tripId: id);
  switch (result) {
    case Ok(value: final value):
      return value;
    case Err(failure: final failure):
      throw failure;
  }
}

@Riverpod(keepAlive: true)
Future<double> activeTripAverageDailySpend(
  ActiveTripAverageDailySpendRef ref,
) async {
  final id = ref.watch(activeTripIdProvider);
  if (id == null) {
    return 0;
  }
  ref.watch(activeTripProvider);
  ref.watch(transactionsForActiveTripProvider);
  final result = await ref
      .watch(calculateAverageDailySpendUseCaseProvider)
      .call(tripId: id, asOf: DateTime.now());
  switch (result) {
    case Ok(value: final value):
      return value;
    case Err(failure: final failure):
      throw failure;
  }
}

@Riverpod(keepAlive: true)
Future<List<SpendTrendPoint>> activeTripSpendTrend(
  ActiveTripSpendTrendRef ref,
) async {
  final id = ref.watch(activeTripIdProvider);
  if (id == null) {
    return const [];
  }
  ref.watch(activeTripProvider);
  ref.watch(transactionsForActiveTripProvider);
  final result = await ref
      .watch(calculateSpendTrendUseCaseProvider)
      .call(tripId: id, asOf: DateTime.now());
  switch (result) {
    case Ok(value: final value):
      return value;
    case Err(failure: final failure):
      throw failure;
  }
}

@Riverpod(keepAlive: true)
Future<int?> activeTripDaysLeft(ActiveTripDaysLeftRef ref) async {
  final id = ref.watch(activeTripIdProvider);
  if (id == null) {
    return null;
  }
  ref.watch(activeTripProvider);
  ref.watch(transactionsForActiveTripProvider);
  ref.watch(accountsForActiveTripProvider);
  final result = await ref
      .watch(calculateDaysLeftUseCaseProvider)
      .call(tripId: id, asOf: DateTime.now());
  switch (result) {
    case Ok(value: final value):
      return value;
    case Err(failure: final failure):
      throw failure;
  }
}
