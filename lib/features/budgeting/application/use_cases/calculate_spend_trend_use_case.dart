import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/budgeting_date_math.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calculate_spend_trend_use_case.g.dart';

typedef SpendTrendPoint = ({DateTime date, double value});

class CalculateSpendTrendUseCase {
  const CalculateSpendTrendUseCase({
    required BudgetingRepository repository,
    required ConvertToHomeCurrencyUseCase convertToHomeCurrency,
  }) : _repository = repository,
       _convertToHomeCurrency = convertToHomeCurrency;

  final BudgetingRepository _repository;
  final ConvertToHomeCurrencyUseCase _convertToHomeCurrency;

  Future<Result<List<SpendTrendPoint>, Failure>> call({
    required String tripId,
    required DateTime asOf,
  }) async {
    final tripResult = await _repository.fetchTrip(tripId: tripId);
    switch (tripResult) {
      case Ok(value: final trip):
        final start = budgetingDateOnly(trip.startDate);
        final end = budgetingDateOnly(asOf);
        if (end.isBefore(start)) {
          return const Ok([]);
        }

        final transactionsResult = await _repository.fetchTransactions(
          tripId: trip.id,
        );
        switch (transactionsResult) {
          case Ok(value: final transactions):
            final expensesByDay = <DateTime, double>{};
            for (final transaction in transactions) {
              if (transaction.type != TransactionType.expense) {
                continue;
              }
              final conversionResult = await _convertToHomeCurrency(
                amount: transaction.paidAmountPerDay,
                sourceCurrency: transaction.paidCurrency,
                homeCurrency: trip.homeCurrency,
                date: transaction.occurredAt,
              );
              final double perDay;
              switch (conversionResult) {
                case Ok(value: final conversion):
                  perDay = conversion.amountHome;
                case Err(failure: final failure):
                  return Err(failure);
              }

              final txStart = budgetingDateOnly(transaction.occurredAt);
              for (
                var offset = 0;
                offset < transaction.spreadDayCount;
                offset++
              ) {
                final day = DateTime(
                  txStart.year,
                  txStart.month,
                  txStart.day + offset,
                );
                if (day.isBefore(start) || day.isAfter(end)) {
                  continue;
                }
                expensesByDay.update(
                  day,
                  (value) => value + perDay,
                  ifAbsent: () => perDay,
                );
              }
            }

            final points = <SpendTrendPoint>[];
            var cumulative = 0.0;
            final dayCount = budgetingInclusiveDayCount(start: start, end: end);
            for (var i = 0; i < dayCount; i++) {
              final day = DateTime(start.year, start.month, start.day + i);
              cumulative += expensesByDay[day] ?? 0;
              points.add((date: day, value: cumulative));
            }
            return Ok(points);
          case Err(failure: final failure):
            return Err(failure);
        }
      case Err(failure: final failure):
        return Err(failure);
    }
  }
}

@Riverpod(keepAlive: true)
CalculateSpendTrendUseCase calculateSpendTrendUseCase(
  CalculateSpendTrendUseCaseRef ref,
) {
  return CalculateSpendTrendUseCase(
    repository: ref.watch(budgetingRepositoryProvider),
    convertToHomeCurrency: ref.watch(convertToHomeCurrencyUseCaseProvider),
  );
}
