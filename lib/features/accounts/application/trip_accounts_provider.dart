import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/accounts/data/account_id_generator.dart';
import 'package:flutter_foundation_kit/features/accounts/data/account_repository.dart';
import 'package:flutter_foundation_kit/features/accounts/domain/account.dart';
import 'package:flutter_foundation_kit/features/transactions/application/transactions_provider.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/trips/application/active_trip_provider.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trip_accounts_provider.g.dart';

/// An account paired with its balance in its own and the trip's home currency.
typedef AccountBalance = ({
  Account account,
  double localBalance,
  double homeBalance,
});

@Riverpod(keepAlive: true)
Box<String> accountsBox(Ref ref) {
  throw StateError('accountsBoxProvider must be overridden in main().');
}

@Riverpod(keepAlive: true)
AccountRepository accountRepository(Ref ref) {
  return HiveAccountRepository(accountsBox: ref.watch(accountsBoxProvider));
}

@Riverpod(keepAlive: true)
AccountIdGenerator accountIdGenerator(Ref ref) =>
    const TimestampAccountIdGenerator();

/// Raw accounts for the active trip.
@riverpod
Stream<List<Account>> accounts(Ref ref) {
  final id = ref.watch(activeTripIdProvider).value;
  if (id == null) {
    return Stream.value(const <Account>[]);
  }
  return ref.watch(accountRepositoryProvider).watchAccounts(tripId: id);
}

/// Accounts for the active trip with their balances, sorted by home balance.
@riverpod
Future<List<AccountBalance>> tripAccounts(Ref ref) async {
  final trip = await ref.watch(activeTripProvider.future);
  if (trip == null) {
    return const [];
  }
  final accounts = await ref.watch(accountsProvider.future);
  final transactions = await ref.watch(transactionsProvider.future);
  final convert = ConvertToHomeCurrencyUseCase(
    ref.watch(exchangeRateRepositoryProvider),
  );

  final balances = <AccountBalance>[];
  for (final account in accounts) {
    final localBalance = account.balanceFrom(transactions);
    final conversion = await convert(
      amount: localBalance,
      sourceCurrency: account.currency,
      homeCurrency: trip.homeCurrency,
      date: DateTime.now(),
    );
    final homeBalance = switch (conversion) {
      Ok(value: final value) => value.amountHome,
      Err(failure: final failure) => throw failure,
    };
    balances.add((
      account: account,
      localBalance: localBalance,
      homeBalance: homeBalance,
    ));
  }
  balances.sort((a, b) => b.homeBalance.compareTo(a.homeBalance));
  return balances;
}
