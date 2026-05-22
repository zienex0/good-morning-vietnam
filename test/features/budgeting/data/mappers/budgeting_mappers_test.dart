import 'package:flutter_foundation_kit/features/budgeting/data/mappers/account_mapper.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/mappers/transaction_mapper.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/mappers/trip_mapper.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/amortization.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('budgeting mappers', () {
    test('Trip round-trips through JSON', () {
      final trip = Trip(
        id: 'trip-1',
        name: 'Vietnam 2026',
        homeCurrency: 'USD',
        startDate: DateTime(2026, 9, 5),
        endDate: DateTime(2026, 10, 1),
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
        startDate: DateTime(2026, 1, 1),
        status: TripStatus.planning,
        createdAt: DateTime(2025, 12, 1),
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

    test('Transaction with FX details round-trips', () {
      final transaction = Transaction(
        id: 'txn-1',
        tripId: 'trip-1',
        type: TransactionType.expense,
        occurredAt: DateTime(2026, 5, 20),
        sourceAccountId: 'acct-1',
        categoryId: 'food',
        amount: 13.5,
        currency: 'PLN',
        amountHome: 3.375,
        fxRate: 0.25,
        enteredAmount: 90000,
        enteredCurrency: 'VND',
        enteredFxRate: 0.00015,
        note: 'Hà Nội pho',
        createdAt: DateTime(2026, 5, 20, 12),
      );
      final copy = transactionFromJson(transactionToJson(transaction));
      expect(copy, transaction);
    });

    test('Cross-currency transfer round-trips with dest snapshot', () {
      final transaction = Transaction(
        id: 'txn-3',
        tripId: 'trip-1',
        type: TransactionType.transfer,
        occurredAt: DateTime(2026, 5, 18),
        sourceAccountId: 'usd',
        destAccountId: 'jpy',
        amount: 100,
        currency: 'USD',
        amountHome: 100,
        fxRate: 1,
        destAmount: 15800,
        destCurrency: 'JPY',
        destFxRate: 0.0062,
        createdAt: DateTime(2026, 5, 18),
      );
      final copy = transactionFromJson(transactionToJson(transaction));
      expect(copy, transaction);
      expect(copy.isCrossCurrencyTransfer, isTrue);
    });

    test('Legacy transfer JSON without dest fields backfills from source', () {
      final json = <String, dynamic>{
        'id': 'txn-legacy',
        'tripId': 'trip-1',
        'type': 'transfer',
        'occurredAt': '2026-05-18T00:00:00.000',
        'sourceAccountId': 'usd',
        'destAccountId': 'usd2',
        'categoryId': null,
        'amount': 50,
        'currency': 'USD',
        'amountHome': 50,
        'fxRate': 1,
        'enteredAmount': null,
        'enteredCurrency': null,
        'enteredFxRate': null,
        'note': null,
        'createdAt': '2026-05-18T00:00:00.000',
      };
      final restored = transactionFromJson(json);
      expect(restored.destAmount, 50);
      expect(restored.destCurrency, 'USD');
      expect(restored.destFxRate, 1);
    });

    test('Simple expense round-trips', () {
      final transaction = Transaction(
        id: 'txn-2',
        tripId: 'trip-1',
        type: TransactionType.expense,
        occurredAt: DateTime(2026, 5, 21),
        sourceAccountId: 'acct-1',
        categoryId: 'transport',
        amount: 8,
        currency: 'USD',
        amountHome: 8,
        fxRate: 1,
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
        amount: 500,
        currency: 'PLN',
        amountHome: 500,
        fxRate: 1,
        amortization: const Amortization(unit: AmortizationUnit.days, count: 7),
        createdAt: DateTime(2026, 5, 20),
      );
      final copy = transactionFromJson(transactionToJson(transaction));
      expect(copy, transaction);
      expect(copy.amortization, isNotNull);
      expect(copy.spreadDayCount, 7);
    });

    test('Legacy expense JSON without amortization loads as null', () {
      final json = <String, dynamic>{
        'id': 'txn-legacy-expense',
        'tripId': 'trip-1',
        'type': 'expense',
        'occurredAt': '2026-05-20T00:00:00.000',
        'sourceAccountId': 'acct-1',
        'destAccountId': null,
        'categoryId': 'food',
        'amount': 12,
        'currency': 'USD',
        'amountHome': 12,
        'fxRate': 1,
        'enteredAmount': null,
        'enteredCurrency': null,
        'enteredFxRate': null,
        'note': null,
        'createdAt': '2026-05-20T00:00:00.000',
      };
      final restored = transactionFromJson(json);
      expect(restored.amortization, isNull);
      expect(restored.isAmortized, isFalse);
    });
  });
}
