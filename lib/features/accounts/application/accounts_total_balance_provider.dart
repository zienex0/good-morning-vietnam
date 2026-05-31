import 'package:flutter_foundation_kit/features/accounts/application/trip_accounts_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounts_total_balance_provider.g.dart';

/// Total of every account balance for the active trip, in home currency.
///
/// [tripAccountsProvider] already converts each account into home currency, so
/// the total is just their sum.
@riverpod
Future<double> accountsTotalBalance(Ref ref) async {
  final accounts = await ref.watch(tripAccountsProvider.future);
  return accounts.fold<double>(0, (sum, entry) => sum + entry.homeBalance);
}
