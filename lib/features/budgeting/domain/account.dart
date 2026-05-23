import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';

enum AccountType { cash, card, bank, ewallet, custom }

@freezed
abstract class Account with _$Account {
  const Account._();

  const factory Account({
    required String id,
    required String tripId,
    required String name,
    required AccountType type,
    required CurrencyCode currency,
    required double openingBalance,
    String? icon,
    @Default(false) bool archived,
  }) = _Account;

  /// Running balance in this account's own currency, derived from [transactions].
  double balanceFrom(List<Transaction> transactions) {
    var balance = openingBalance;
    for (final transaction in transactions) {
      switch (transaction.type) {
        case TransactionType.expense:
          if (transaction.sourceAccountId == id) {
            balance -= transaction.accountAmount;
          }
        case TransactionType.income:
          if (transaction.destAccountId == id) {
            balance += transaction.accountAmount;
          }
        case TransactionType.transfer:
          if (transaction.sourceAccountId == id) {
            balance -= transaction.accountAmount;
          }
          if (transaction.destAccountId == id) {
            balance += transaction.destAmount ?? 0;
          }
      }
    }
    return balance;
  }
}
