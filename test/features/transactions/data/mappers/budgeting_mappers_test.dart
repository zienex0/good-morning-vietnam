import 'package:flutter_foundation_kit/features/accounts/data/mappers/account_mapper.dart';
import 'package:flutter_foundation_kit/features/accounts/domain/account.dart';
import 'package:flutter_foundation_kit/features/transactions/data/mappers/transaction_mapper.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/amortization.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/trips/data/mappers/trip_mapper.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('budgeting mappers', () {
    test('Trip round-trips through JSON', () {
      final trip = Trip(
        id: 'trip-1',
        name: 'Vietnam 2026',
        homeCurrency: 'USD',
        startDate: DateTime(2026, 9, 5),
        endDate: DateTime(2026, 10),
        budgetTotal: 2000,
        status: TripStatus.active,
        createdAt: DateTime(2026, 8),
      );
      final copy = tripFromJson(tripToJson(trip));
      expect(copy, trip);
    });

    test('Trip with no end date or budget round-trips', () {
      final trip = Trip(
        id: 'trip-open',
        name: 'Around the world',
        homeCurrency: 'EUR',
        startDate: DateTime(2026),
        status: TripStatus.planning,
        createdAt: DateTime(2025, 12),
      );
      final copy = tripFromJson(tripToJson(trip));
      expect(copy, trip);
      expect(copy.isOpenEnded, isTrue);
      expect(copy.budgetTotal, isNull);
    });

    test('Account round-trips through JSON', () {
      const account = Account(
        id: 'acct-1',
        tripId: 'trip-1',
        name: 'Cash USD',
        type: AccountType.cash,
        currency: 'USD',
        openingBalance: 250.5,
      );
      final copy = accountFromJson(accountToJson(account));
      expect(copy, account);
    });

    test('Transaction fact fields round-trip', () {
      final transaction = Transaction(
        id: 'txn-1',
        tripId: 'trip-1',
        type: TransactionType.expense,
        occurredAt: DateTime(2026, 5, 20),
        sourceAccountId: 'acct-1',
        categoryId: 'food',
        paidAmount: 90000,
        paidCurrency: 'VND',
        accountAmount: 13.5,
        accountCurrency: 'PLN',
        note: 'Hà Nội pho',
        createdAt: DateTime(2026, 5, 20, 12),
      );
      final copy = transactionFromJson(transactionToJson(transaction));
      expect(copy, transaction);
      expect(transactionToJson(transaction), containsPair('paidAmount', 90000));
      expect(transactionToJson(transaction), isNot(contains('amountHome')));
    });

    test('Cross-currency transfer round-trips with dest facts', () {
      final transaction = Transaction(
        id: 'txn-3',
        tripId: 'trip-1',
        type: TransactionType.transfer,
        occurredAt: DateTime(2026, 5, 18),
        sourceAccountId: 'usd',
        destAccountId: 'jpy',
        paidAmount: 100,
        paidCurrency: 'USD',
        accountAmount: 100,
        accountCurrency: 'USD',
        destAmount: 15800,
        destCurrency: 'JPY',
        createdAt: DateTime(2026, 5, 18),
      );
      final copy = transactionFromJson(transactionToJson(transaction));
      expect(copy, transaction);
      expect(copy.isCrossCurrencyTransfer, isTrue);
    });

    test('Simple expense round-trips', () {
      final transaction = Transaction(
        id: 'txn-2',
        tripId: 'trip-1',
        type: TransactionType.expense,
        occurredAt: DateTime(2026, 5, 21),
        sourceAccountId: 'acct-1',
        categoryId: 'transport',
        paidAmount: 8,
        paidCurrency: 'USD',
        accountAmount: 8,
        accountCurrency: 'USD',
        createdAt: DateTime(2026, 5, 21),
      );
      final copy = transactionFromJson(transactionToJson(transaction));
      expect(copy, transaction);
    });

    test('Amortized expense round-trips with its spread', () {
      final transaction = Transaction(
        id: 'txn-airbnb',
        tripId: 'trip-1',
        type: TransactionType.expense,
        occurredAt: DateTime(2026, 5, 20),
        sourceAccountId: 'acct-1',
        categoryId: 'lodging',
        paidAmount: 500,
        paidCurrency: 'PLN',
        accountAmount: 500,
        accountCurrency: 'PLN',
        amortization: const Amortization(unit: AmortizationUnit.days, count: 7),
        createdAt: DateTime(2026, 5, 20),
      );
      final copy = transactionFromJson(transactionToJson(transaction));
      expect(copy, transaction);
      expect(copy.amortization, isNotNull);
      expect(copy.spreadDayCount, 7);
    });

    test('Expense JSON without amortization loads as null', () {
      final json = <String, dynamic>{
        'id': 'txn-expense',
        'tripId': 'trip-1',
        'type': 'expense',
        'occurredAt': '2026-05-20T00:00:00.000',
        'sourceAccountId': 'acct-1',
        'destAccountId': null,
        'categoryId': 'food',
        'paidAmount': 12,
        'paidCurrency': 'USD',
        'accountAmount': 12,
        'accountCurrency': 'USD',
        'destAmount': null,
        'destCurrency': null,
        'note': null,
        'createdAt': '2026-05-20T00:00:00.000',
      };
      final restored = transactionFromJson(json);
      expect(restored.amortization, isNull);
      expect(restored.isAmortized, isFalse);
    });
  });
}
