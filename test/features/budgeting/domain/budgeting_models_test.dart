import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/amortization.dart';
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
        paidAmount: 90000,
        paidCurrency: 'VND',
        accountAmount: 13.5,
        accountCurrency: 'PLN',
        createdAt: DateTime(2026, 5, 20, 9, 2),
      );

      expect(transaction.isExpense, isTrue);
      expect(transaction.isTransfer, isFalse);
      expect(transaction.hasSeparateAccountAmount, isTrue);
    });

    test('models a transfer with source and destination accounts', () {
      final transaction = Transaction(
        id: 'transaction-2',
        tripId: 'trip-1',
        type: TransactionType.transfer,
        occurredAt: DateTime(2026, 5, 20, 10),
        sourceAccountId: 'account-1',
        destAccountId: 'account-2',
        paidAmount: 10000,
        paidCurrency: 'JPY',
        accountAmount: 10000,
        accountCurrency: 'JPY',
        destAmount: 10000,
        destCurrency: 'JPY',
        createdAt: DateTime(2026, 5, 20, 10, 1),
      );

      expect(transaction.categoryId, isNull);
      expect(transaction.isTransfer, isTrue);
    });

    test('a plain expense contributes its full amount to one day', () {
      final transaction = Transaction(
        id: 'transaction-3',
        tripId: 'trip-1',
        type: TransactionType.expense,
        occurredAt: DateTime(2026, 5, 9, 14),
        sourceAccountId: 'account-1',
        categoryId: 'food',
        paidAmount: 70,
        paidCurrency: 'USD',
        accountAmount: 70,
        accountCurrency: 'USD',
        createdAt: DateTime(2026, 5, 9),
      );

      expect(transaction.isAmortized, isFalse);
      expect(transaction.spreadDayCount, 1);
      expect(transaction.paidAmountOnDay(DateTime(2026, 5, 9)), 70);
      expect(transaction.paidAmountOnDay(DateTime(2026, 5, 10)), 0);
      expect(transaction.paidAmountThrough(DateTime(2026, 5, 8)), 0);
      expect(transaction.paidAmountThrough(DateTime(2026, 5, 9)), 70);
    });

    test('an amortized expense spreads evenly across its window', () {
      final transaction = Transaction(
        id: 'transaction-4',
        tripId: 'trip-1',
        type: TransactionType.expense,
        occurredAt: DateTime(2026, 5, 9, 14),
        sourceAccountId: 'account-1',
        categoryId: 'lodging',
        paidAmount: 70,
        paidCurrency: 'USD',
        accountAmount: 70,
        accountCurrency: 'USD',
        amortization: const Amortization(unit: AmortizationUnit.days, count: 7),
        createdAt: DateTime(2026, 5, 9),
      );

      expect(transaction.isAmortized, isTrue);
      expect(transaction.spreadDayCount, 7);
      expect(transaction.paidAmountPerDay, 10);
      expect(transaction.paidAmountOnDay(DateTime(2026, 5, 8)), 0);
      expect(transaction.paidAmountOnDay(DateTime(2026, 5, 9)), 10);
      expect(transaction.paidAmountOnDay(DateTime(2026, 5, 15)), 10);
      expect(transaction.paidAmountOnDay(DateTime(2026, 5, 16)), 0);
      expect(transaction.paidAmountThrough(DateTime(2026, 5, 8)), 0);
      expect(transaction.paidAmountThrough(DateTime(2026, 5, 9)), 10);
      expect(transaction.paidAmountThrough(DateTime(2026, 5, 12)), 40);
      expect(transaction.paidAmountThrough(DateTime(2026, 5, 30)), 70);
    });
  });

  group('Amortization', () {
    test('resolves days and weeks to a flat day count', () {
      const days = Amortization(unit: AmortizationUnit.days, count: 7);
      const weeks = Amortization(unit: AmortizationUnit.weeks, count: 2);

      expect(days.dayCountFrom(DateTime(2026, 5, 9)), 7);
      expect(weeks.dayCountFrom(DateTime(2026, 5, 9)), 14);
    });

    test('resolves months against the start date so length is calendar '
        'accurate', () {
      const oneMonth = Amortization(unit: AmortizationUnit.months, count: 1);
      const twoMonths = Amortization(unit: AmortizationUnit.months, count: 2);

      // March has 31 days.
      expect(oneMonth.dayCountFrom(DateTime(2026, 3, 15)), 31);
      // March (31) + April (30).
      expect(twoMonths.dayCountFrom(DateTime(2026, 3, 15)), 61);
    });
  });
}
