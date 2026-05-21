import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/category.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Trip', () {
    test('can clear optional trip fields with copyWith', () {
      final trip = Trip(
        id: 'trip-1',
        name: 'Japan 2026',
        homeCurrency: 'USD',
        startDate: DateTime(2026, 5, 9),
        endDate: DateTime(2026, 6, 8),
        budgetTotal: 1500,
        status: TripStatus.planning,
        createdAt: DateTime(2026),
      );

      expect(
        trip.copyWith(endDate: null, budgetTotal: null),
        Trip(
          id: 'trip-1',
          name: 'Japan 2026',
          homeCurrency: 'USD',
          startDate: DateTime(2026, 5, 9),
          status: TripStatus.planning,
          createdAt: DateTime(2026),
        ),
      );
    });
  });

  group('Account', () {
    test('belongs to one trip and can be archived', () {
      const account = Account(
        id: 'account-1',
        tripId: 'trip-1',
        name: 'Cash JPY',
        type: AccountType.cash,
        currency: 'JPY',
        openingBalance: 32000,
      );

      expect(account.copyWith(archived: true).archived, isTrue);
    });
  });

  group('Category', () {
    test('knows whether it is a root category', () {
      const food = Category(id: 'category-1', name: 'Food');
      const ramen = Category(
        id: 'category-2',
        name: 'Ramen',
        parentId: 'category-1',
      );

      expect(food.isRoot, isTrue);
      expect(ramen.isRoot, isFalse);
    });
  });

  group('Transaction', () {
    test('models an expense with a source account and category', () {
      final transaction = Transaction(
        id: 'transaction-1',
        tripId: 'trip-1',
        type: TransactionType.expense,
        occurredAt: DateTime(2026, 5, 20, 9),
        sourceAccountId: 'account-1',
        categoryId: 'category-1',
        amount: 680,
        currency: 'JPY',
        amountHome: 4.2,
        fxRate: 0.0062,
        enteredAmount: 90000,
        enteredCurrency: 'VND',
        enteredFxRate: 0.00015,
        createdAt: DateTime(2026, 5, 20, 9, 2),
      );

      expect(transaction.isExpense, isTrue);
      expect(transaction.isTransfer, isFalse);
      expect(transaction.hasEnteredCurrency, isTrue);
    });

    test('models a transfer with source and destination accounts', () {
      final transaction = Transaction(
        id: 'transaction-2',
        tripId: 'trip-1',
        type: TransactionType.transfer,
        occurredAt: DateTime(2026, 5, 20, 10),
        sourceAccountId: 'account-1',
        destAccountId: 'account-2',
        amount: 10000,
        currency: 'JPY',
        amountHome: 62,
        fxRate: 0.0062,
        createdAt: DateTime(2026, 5, 20, 10, 1),
      );

      expect(transaction.categoryId, isNull);
      expect(transaction.isTransfer, isTrue);
    });
  });
}
