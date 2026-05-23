import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';

/// Sum of every account balance for [trip], each converted into the trip's
/// home currency as of [asOf].
class CalculateTotalAccountsBalanceUseCase {
  const CalculateTotalAccountsBalanceUseCase(this._convertToHomeCurrency);

  final ConvertToHomeCurrencyUseCase _convertToHomeCurrency;

  Future<Result<double, Failure>> call({
    required Trip trip,
    required List<Account> accounts,
    required List<Transaction> transactions,
    required DateTime asOf,
  }) async {
    final accountsById = {for (final account in accounts) account.id: account};
    final balances = {
      for (final account in accounts) account.id: account.openingBalance,
    };

    for (final transaction in transactions) {
      switch (transaction.type) {
        case TransactionType.expense:
          final sourceAccountId = transaction.sourceAccountId;
          if (sourceAccountId != null &&
              balances.containsKey(sourceAccountId)) {
            balances[sourceAccountId] =
                balances[sourceAccountId]! - transaction.accountAmount;
          }
        case TransactionType.income:
          final destAccountId = transaction.destAccountId;
          if (destAccountId != null && balances.containsKey(destAccountId)) {
            balances[destAccountId] =
                balances[destAccountId]! + transaction.accountAmount;
          }
        case TransactionType.transfer:
          final sourceAccountId = transaction.sourceAccountId;
          if (sourceAccountId != null &&
              balances.containsKey(sourceAccountId)) {
            balances[sourceAccountId] =
                balances[sourceAccountId]! - transaction.accountAmount;
          }
          final destAccountId = transaction.destAccountId;
          if (destAccountId != null && balances.containsKey(destAccountId)) {
            balances[destAccountId] =
                balances[destAccountId]! + transaction.destAmount!;
          }
      }
    }

    var total = 0.0;
    for (final entry in balances.entries) {
      final account = accountsById[entry.key]!;
      final conversionResult = await _convertToHomeCurrency(
        amount: entry.value,
        sourceCurrency: account.currency,
        homeCurrency: trip.homeCurrency,
        date: asOf,
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
