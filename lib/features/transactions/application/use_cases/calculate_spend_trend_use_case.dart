import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/transactions/application/budgeting_date_math.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';

typedef SpendTrendPoint = ({DateTime date, double value});

/// Cumulative expense spend per day for [trip] up to [asOf], in home currency.
class CalculateSpendTrendUseCase {
  const CalculateSpendTrendUseCase(this._convertToHomeCurrency);

  final ConvertToHomeCurrencyUseCase _convertToHomeCurrency;

  Future<Result<List<SpendTrendPoint>, Failure>> call({
    required Trip trip,
    required List<Transaction> transactions,
    required DateTime asOf,
  }) async {
    final start = budgetingDateOnly(trip.startDate);
    final end = budgetingDateOnly(asOf);
    if (end.isBefore(start)) {
      return const Ok([]);
    }

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
      for (var offset = 0; offset < transaction.spreadDayCount; offset++) {
        final day = DateTime(txStart.year, txStart.month, txStart.day + offset);
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
  }
}
