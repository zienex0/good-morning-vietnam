import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/budgeting_date_math.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calculate_average_daily_spend_use_case.g.dart';

class CalculateAverageDailySpendUseCase {
  const CalculateAverageDailySpendUseCase(this._repository);

  final BudgetingRepository _repository;

  Future<Result<double, Failure>> call({
    required String tripId,
    required DateTime asOf,
  }) async {
    final tripResult = await _repository.fetchTrip(tripId: tripId);
    final Trip trip;
    switch (tripResult) {
      case Ok(value: final value):
        trip = value;
      case Err(failure: final failure):
        return Err(failure);
    }

    final startDate = budgetingDateOnly(trip.startDate);
    final asOfDate = budgetingDateOnly(asOf);
    if (asOfDate.isBefore(startDate)) {
      return const Err(
        ValidationFailure(
          'Average spend cannot be calculated before the trip.',
        ),
      );
    }

    final transactionsResult = await _repository.fetchTransactions(
      tripId: trip.id,
    );
    final List<Transaction> transactions;
    switch (transactionsResult) {
      case Ok(value: final value):
        transactions = value;
      case Err(failure: final failure):
        return Err(failure);
    }

    // Amortized expenses only count the slice that has accrued through asOf, so
    // a big upfront purchase does not spike the daily average.
    final totalSpend = transactions
        .where((transaction) => transaction.type == TransactionType.expense)
        .fold<double>(
          0,
          (sum, transaction) => sum + transaction.amountHomeThrough(asOfDate),
        );
    final dayCount = budgetingInclusiveDayCount(
      start: startDate,
      end: asOfDate,
    );

    return Ok(totalSpend / dayCount);
  }
}

@Riverpod(keepAlive: true)
CalculateAverageDailySpendUseCase calculateAverageDailySpendUseCase(
  CalculateAverageDailySpendUseCaseRef ref,
) {
  return CalculateAverageDailySpendUseCase(
    ref.watch(budgetingRepositoryProvider),
  );
}
