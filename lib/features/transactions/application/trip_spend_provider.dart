import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/transactions/application/transactions_provider.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/calculate_average_daily_spend_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/calculate_category_breakdown_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/calculate_daily_spend_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/calculate_total_spend_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/trips/application/active_trip_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trip_spend_provider.g.dart';

/// Total expense spend for the active trip, in home currency.
@riverpod
Future<double> totalSpend(Ref ref) async {
  final trip = await ref.watch(activeTripProvider.future);
  if (trip == null) {
    return 0;
  }
  final transactions = await ref.watch(transactionsProvider.future);
  return _orThrow(
    await CalculateTotalSpendUseCase(_convert(ref))(
      trip: trip,
      transactions: transactions,
    ),
  );
}

/// Average per-day spend for the active trip so far, in home currency.
@riverpod
Future<double> averageDailySpend(Ref ref) async {
  final trip = await ref.watch(activeTripProvider.future);
  if (trip == null) {
    return 0;
  }
  final transactions = await ref.watch(transactionsProvider.future);
  return _orThrow(
    await CalculateAverageDailySpendUseCase(_convert(ref))(
      trip: trip,
      transactions: transactions,
      asOf: DateTime.now(),
    ),
  );
}

/// Per-day spend points for the active trip's chart, in home currency.
@riverpod
Future<List<DailySpendPoint>> dailySpend(Ref ref) async {
  final trip = await ref.watch(activeTripProvider.future);
  if (trip == null) {
    return const [];
  }
  final transactions = await ref.watch(transactionsProvider.future);
  return _orThrow(
    await CalculateDailySpendUseCase(_convert(ref))(
      trip: trip,
      transactions: transactions,
      asOf: DateTime.now(),
    ),
  );
}

/// Spend grouped by category for the active trip, in home currency.
@riverpod
Future<List<CategorySpend>> categoryBreakdown(Ref ref) async {
  final trip = await ref.watch(activeTripProvider.future);
  if (trip == null) {
    return const [];
  }
  final transactions = await ref.watch(transactionsProvider.future);
  return _orThrow(
    await CalculateCategoryBreakdownUseCase(_convert(ref))(
      trip: trip,
      transactions: transactions,
    ),
  );
}

ConvertToHomeCurrencyUseCase _convert(Ref ref) =>
    ConvertToHomeCurrencyUseCase(ref.watch(exchangeRateRepositoryProvider));

T _orThrow<T>(Result<T, Failure> result) => switch (result) {
  Ok(value: final value) => value,
  Err(failure: final failure) => throw failure,
};
