import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/transactions/application/budgeting_date_math.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';

typedef DailySpendPoint = ({DateTime date, double value});

/// Per-day (non-cumulative) expense spend for [trip] from its start through
/// [asOf], in home currency. Amortized expenses contribute their per-day slice.
class CalculateDailySpendUseCase {
  const CalculateDailySpendUseCase(this._convertToHomeCurrency);

  final ConvertToHomeCurrencyUseCase _convertToHomeCurrency;

  Future<Result<List<DailySpendPoint>, Failure>> call({
    required Trip trip,
    required List<Transaction> transactions,
    required DateTime asOf,
  }) async {
    final tripStart = budgetingDateOnly(trip.startDate);
    final today = budgetingDateOnly(asOf);

    final dailySpend = <DateTime, double>{};
    for (final transaction in transactions) {
      if (!transaction.isExpense) {
        continue;
      }
      final conversion = await _convertToHomeCurrency(
        amount: transaction.paidAmountPerDay,
        sourceCurrency: transaction.paidCurrency,
        homeCurrency: trip.homeCurrency,
        date: transaction.occurredAt,
      );
      final double amountHome;
      switch (conversion) {
        case Ok(value: final value):
          amountHome = value.amountHome;
        case Err(failure: final failure):
          return Err(failure);
      }

      final transactionDay = budgetingDateOnly(transaction.occurredAt);
      for (var offset = 0; offset < transaction.spreadDayCount; offset++) {
        final day = DateTime(
          transactionDay.year,
          transactionDay.month,
          transactionDay.day + offset,
        );
        if (day.isBefore(tripStart) || day.isAfter(today)) {
          continue;
        }
        dailySpend.update(
          day,
          (value) => value + amountHome,
          ifAbsent: () => amountHome,
        );
      }
    }

    final points = <DailySpendPoint>[];
    if (!today.isBefore(tripStart)) {
      final dayCount = budgetingInclusiveDayCount(start: tripStart, end: today);
      for (var index = 0; index < dayCount; index++) {
        final day = DateTime(
          tripStart.year,
          tripStart.month,
          tripStart.day + index,
        );
        points.add((date: day, value: dailySpend[day] ?? 0));
      }
    }
    return Ok(points);
  }
}
