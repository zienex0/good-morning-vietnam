import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/calculate_average_daily_spend_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/calculate_total_accounts_balance_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';

/// Estimated days the current balance lasts at the average daily spend.
/// Composes [CalculateTotalAccountsBalanceUseCase] and
/// [CalculateAverageDailySpendUseCase].
class CalculateDaysLeftUseCase {
  const CalculateDaysLeftUseCase({
    required CalculateAverageDailySpendUseCase calculateAverageDailySpend,
    required CalculateTotalAccountsBalanceUseCase calculateTotalAccountsBalance,
  }) : _calculateAverageDailySpend = calculateAverageDailySpend,
       _calculateTotalAccountsBalance = calculateTotalAccountsBalance;

  final CalculateAverageDailySpendUseCase _calculateAverageDailySpend;
  final CalculateTotalAccountsBalanceUseCase _calculateTotalAccountsBalance;

  Future<Result<int?, Failure>> call({
    required Trip trip,
    required List<Account> accounts,
    required List<Transaction> transactions,
    required DateTime asOf,
  }) async {
    final balanceResult = await _calculateTotalAccountsBalance(
      trip: trip,
      accounts: accounts,
      transactions: transactions,
      asOf: asOf,
    );
    final double balance;
    switch (balanceResult) {
      case Ok(value: final value):
        balance = value;
      case Err(failure: final failure):
        return Err(failure);
    }

    final averageResult = await _calculateAverageDailySpend(
      trip: trip,
      transactions: transactions,
      asOf: asOf,
    );
    final double averageDailySpend;
    switch (averageResult) {
      case Ok(value: final value):
        averageDailySpend = value;
      case Err(failure: final failure):
        return Err(failure);
    }

    if (averageDailySpend <= 0) {
      return const Ok(null);
    }
    if (balance <= 0) {
      return const Ok(0);
    }

    return Ok((balance / averageDailySpend).floor());
  }
}
