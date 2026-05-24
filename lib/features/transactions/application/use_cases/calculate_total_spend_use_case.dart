import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';

/// Total expense spend for [trip], converted into the trip's home currency.
class CalculateTotalSpendUseCase {
  const CalculateTotalSpendUseCase(this._convertToHomeCurrency);

  final ConvertToHomeCurrencyUseCase _convertToHomeCurrency;

  Future<Result<double, Failure>> call({
    required Trip trip,
    required List<Transaction> transactions,
  }) async {
    var total = 0.0;
    for (final transaction in transactions) {
      if (transaction.type != TransactionType.expense) {
        continue;
      }
      final conversionResult = await _convertToHomeCurrency(
        amount: transaction.paidAmount,
        sourceCurrency: transaction.paidCurrency,
        homeCurrency: trip.homeCurrency,
        date: transaction.occurredAt,
      );
      switch (conversionResult) {
        case Ok(value: final conversion):
          total += conversion.amountHome;
        case Err(failure: final failure):
          return Err(failure);
      }
    }
    return Ok(total);
  }
}
