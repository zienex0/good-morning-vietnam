import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/calculate_average_daily_spend_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/calculate_total_accounts_balance_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calculate_days_left_use_case.g.dart';

class CalculateDaysLeftUseCase {
  const CalculateDaysLeftUseCase({
    required CalculateAverageDailySpendUseCase calculateAverageDailySpend,
    required CalculateTotalAccountsBalanceUseCase calculateTotalAccountsBalance,
  }) : _calculateAverageDailySpend = calculateAverageDailySpend,
       _calculateTotalAccountsBalance = calculateTotalAccountsBalance;

  final CalculateAverageDailySpendUseCase _calculateAverageDailySpend;
  final CalculateTotalAccountsBalanceUseCase _calculateTotalAccountsBalance;

  Future<Result<int?, Failure>> call({
    required String tripId,
    required DateTime asOf,
  }) async {
    final balanceResult = await _calculateTotalAccountsBalance(tripId: tripId);
    final double balance;
    switch (balanceResult) {
      case Ok(value: final value):
        balance = value;
      case Err(failure: final failure):
        return Err(failure);
    }

    final averageResult = await _calculateAverageDailySpend(
      tripId: tripId,
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

@Riverpod(keepAlive: true)
CalculateDaysLeftUseCase calculateDaysLeftUseCase(
  CalculateDaysLeftUseCaseRef ref,
) {
  return CalculateDaysLeftUseCase(
    calculateAverageDailySpend: ref.watch(
      calculateAverageDailySpendUseCaseProvider,
    ),
    calculateTotalAccountsBalance: ref.watch(
      calculateTotalAccountsBalanceUseCaseProvider,
    ),
  );
}
