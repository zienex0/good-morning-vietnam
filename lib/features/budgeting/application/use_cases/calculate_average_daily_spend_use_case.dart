import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/budgeting_date_math.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calculate_average_daily_spend_use_case.g.dart';

class CalculateAverageDailySpendUseCase {
  const CalculateAverageDailySpendUseCase({
    required BudgetingRepository repository,
    required ConvertToHomeCurrencyUseCase convertToHomeCurrency,
  }) : _repository = repository,
       _convertToHomeCurrency = convertToHomeCurrency;

  final BudgetingRepository _repository;
  final ConvertToHomeCurrencyUseCase _convertToHomeCurrency;

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
    var totalSpend = 0.0;
    for (final transaction in transactions) {
      if (transaction.type != TransactionType.expense) {
        continue;
      }
      final accruedPaidAmount = transaction.paidAmountThrough(asOfDate);
      if (accruedPaidAmount == 0) {
        continue;
      }
      final conversionResult = await _convertToHomeCurrency(
        amount: accruedPaidAmount,
        sourceCurrency: transaction.paidCurrency,
        homeCurrency: trip.homeCurrency,
        date: transaction.occurredAt,
      );
      switch (conversionResult) {
        case Ok(value: final conversion):
          totalSpend += conversion.amountHome;
        case Err(failure: final failure):
          return Err(failure);
      }
    }
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
    repository: ref.watch(budgetingRepositoryProvider),
    convertToHomeCurrency: ref.watch(convertToHomeCurrencyUseCaseProvider),
  );
}
