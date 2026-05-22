import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';

/// Native-currency balance for [accountId].
///
/// Source-side transactions deduct `accountAmount`. Transfers credit the
/// destination using the stored `destAmount` in the destination currency.
double computeAccountBalance({
  required String accountId,
  required double openingBalance,
  required List<Transaction> transactions,
}) {
  var balance = openingBalance;
  for (final transaction in transactions) {
    switch (transaction.type) {
      case TransactionType.expense:
        if (transaction.sourceAccountId == accountId) {
          balance -= transaction.accountAmount;
        }
      case TransactionType.income:
        if (transaction.destAccountId == accountId) {
          balance += transaction.accountAmount;
        }
      case TransactionType.transfer:
        if (transaction.sourceAccountId == accountId) {
          balance -= transaction.accountAmount;
        } else if (transaction.destAccountId == accountId) {
          balance += transaction.destAmount!;
        }
    }
  }
  return balance;
}
