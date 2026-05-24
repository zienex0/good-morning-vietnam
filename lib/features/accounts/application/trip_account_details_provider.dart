import 'package:flutter_foundation_kit/features/accounts/application/trip_accounts_provider.dart';
import 'package:flutter_foundation_kit/features/transactions/application/transactions_provider.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/trips/application/active_trip_provider.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trip_account_details_provider.g.dart';

/// One account with its balances and the transactions that touch it.
typedef AccountDetail = ({
  Trip trip,
  AccountBalance account,
  List<Transaction> transactions,
});

@riverpod
Future<AccountDetail?> tripAccountDetails(Ref ref, String accountId) async {
  final trip = await ref.watch(activeTripProvider.future);
  if (trip == null) {
    return null;
  }
  final accounts = await ref.watch(tripAccountsProvider.future);
  final transactions = await ref.watch(transactionsProvider.future);

  AccountBalance? match;
  for (final account in accounts) {
    if (account.account.id == accountId) {
      match = account;
      break;
    }
  }
  if (match == null) {
    return null;
  }

  final accountTransactions = transactions
      .where(
        (transaction) =>
            transaction.sourceAccountId == accountId ||
            transaction.destAccountId == accountId,
      )
      .toList();

  return (trip: trip, account: match, transactions: accountTransactions);
}
