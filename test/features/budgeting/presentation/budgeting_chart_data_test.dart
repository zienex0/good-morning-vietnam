import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_chart_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Transaction expense({
    required double paidAmount,
    required double accountAmount,
  }) {
    return Transaction(
      id: 'txn-expense',
      tripId: 'trip-1',
      type: TransactionType.expense,
      occurredAt: DateTime(2026, 5, 9),
      sourceAccountId: 'usd',
      categoryId: 'food',
      paidAmount: paidAmount,
      paidCurrency: 'VND',
      accountAmount: accountAmount,
      accountCurrency: 'USD',
      createdAt: DateTime(2026),
    );
  }

  Transaction transfer() {
    return Transaction(
      id: 'txn-transfer',
      tripId: 'trip-1',
      type: TransactionType.transfer,
      occurredAt: DateTime(2026, 5, 10),
      sourceAccountId: 'usd',
      destAccountId: 'vnd',
      paidAmount: 20,
      paidCurrency: 'USD',
      accountAmount: 20,
      accountCurrency: 'USD',
      destAmount: 500000,
      destCurrency: 'VND',
      createdAt: DateTime(2026),
    );
  }

  test('account balances use account-side facts, not paid receipt facts', () {
    final balance = computeAccountBalance(
      accountId: 'usd',
      openingBalance: 100,
      transactions: [expense(paidAmount: 22000, accountAmount: 0.84)],
    );

    expect(balance, 99.16);
  });

  test('transfers credit the destination-side fact', () {
    final balance = computeAccountBalance(
      accountId: 'vnd',
      openingBalance: 0,
      transactions: [transfer()],
    );

    expect(balance, 500000);
  });
}
