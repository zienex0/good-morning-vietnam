import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/accounts/application/trip_accounts_provider.dart';
import 'package:flutter_foundation_kit/features/accounts/application/use_cases/calculate_total_accounts_balance_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/application/transactions_provider.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/trips/application/active_trip_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounts_total_balance_provider.g.dart';

/// Total of every account balance for the active trip, in home currency.
@riverpod
Future<double> accountsTotalBalance(Ref ref) async {
  final trip = await ref.watch(activeTripProvider.future);
  if (trip == null) {
    return 0;
  }
  final accounts = await ref.watch(accountsProvider.future);
  final transactions = await ref.watch(transactionsProvider.future);
  final convert = ConvertToHomeCurrencyUseCase(
    ref.watch(exchangeRateRepositoryProvider),
  );
  final result = await CalculateTotalAccountsBalanceUseCase(convert)(
    trip: trip,
    accounts: accounts,
    transactions: transactions,
    asOf: DateTime.now(),
  );
  return switch (result) {
    Ok(value: final value) => value,
    Err(failure: final failure) => throw failure,
  };
}
