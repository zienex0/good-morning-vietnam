import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/transactions/application/budgeting_date_math.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';

/// Average per-day expense spend for [trip] up to [asOf], in home currency.
/// Amortized expenses only count the slice accrued through [asOf].
class CalculateAverageDailySpendUseCase {
  const CalculateAverageDailySpendUseCase(this._convertToHomeCurrency);

  final ConvertToHomeCurrencyUseCase _convertToHomeCurrency;

  Future<Result<double>> call({
    required Trip trip,
    required List<Transaction> transactions,
    required DateTime asOf,
  }) async {
    final startDate = budgetingDateOnly(trip.startDate);
    final asOfDate = budgetingDateOnly(asOf);
    if (asOfDate.isBefore(startDate)) {
      return const Err(
        ValidationFailure(
          'Average spend cannot be calculated before the trip.',
        ),
      );
    }

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
