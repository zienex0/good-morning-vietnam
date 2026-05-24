import 'package:flutter_foundation_kit/features/accounts/application/accounts_total_balance_provider.dart';
import 'package:flutter_foundation_kit/features/transactions/application/trip_spend_provider.dart';
import 'package:flutter_foundation_kit/features/trips/application/use_cases/calculate_days_left_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trip_days_left_provider.g.dart';

/// Days the active trip's money lasts at the current average daily spend.
/// Composes the accounts balance and the transactions spend rate.
@riverpod
Future<int?> tripDaysLeft(Ref ref) async {
  final totalBalance = await ref.watch(accountsTotalBalanceProvider.future);
  final averageDailySpend = await ref.watch(averageDailySpendProvider.future);
  return const CalculateDaysLeftUseCase()(
    totalBalance: totalBalance,
    averageDailySpend: averageDailySpend,
  );
}
