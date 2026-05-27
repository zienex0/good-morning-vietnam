import 'package:flutter_foundation_kit/features/accounts/domain/account.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/amortization.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/transaction_formatters.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/budgeting_fixtures.dart';

void main() {
  group('transaction formatters', () {
    test('parses exact amortization days', () {
      expect(parseBudgetingAmortizationDaysInput('14'), 14);
      expect(parseBudgetingAmortizationDaysInput(' 3 '), 3);
      expect(parseBudgetingAmortizationDaysInput('0'), isNull);
      expect(parseBudgetingAmortizationDaysInput(''), isNull);
    });

    test('creates day-based amortization from an exact day count', () {
      final amortization = amortizationForBudgetingDayCount(14);

      expect(amortization, isNotNull);
      expect(amortization!.unit, AmortizationUnit.days);
      expect(amortization.count, 14);
      expect(amortizationForBudgetingDayCount(null), isNull);
    });

    test('formats amortization as resolved days', () {
      expect(
        formatBudgetingAmortization(
          const Amortization(unit: AmortizationUnit.weeks, count: 2),
          DateTime(2026, 5, 9),
        ),
        'Amortized over 14 days',
      );
    });

    test('formats amount input seeds without floating-point dust', () {
      expect(formatBudgetingAmountInputValue(0), '0');
      expect(formatBudgetingAmountInputValue(7.105427357601002e-15), '0');
      expect(formatBudgetingAmountInputValue(10.0000000001), '10');
      expect(formatBudgetingAmountInputValue(10.5), '10.5');
      expect(formatBudgetingAmountInputValue(10.55), '10.55');
    });

    test('formats amount input text as currency', () {
      expect(formatBudgetingAmountInputMoney('', 'PLN'), '');
      expect(formatBudgetingAmountInputMoney('0', 'PLN'), 'zł0');
      expect(formatBudgetingAmountInputMoney('10', 'USD'), r'$10');
      expect(formatBudgetingAmountInputMoney('10,5', 'EUR'), '€10.5');
      expect(formatBudgetingAmountInputMoney('10.55', 'EUR'), '€10.55');
    });

    test('adds amortization detail to transaction subtitles', () {
      const account = Account(
        id: 'usd',
        tripId: 'trip-1',
        name: 'Cash USD',
        type: AccountType.cash,
        currency: 'USD',
        openingBalance: 100,
      );
      final transaction = testExpense(
        amortization: const Amortization(unit: AmortizationUnit.days, count: 7),
      );

      expect(
        formatBudgetingTransactionSubtitle(transaction, {account.id: account}),
        'Cash USD · Amortized over 7 days',
      );
    });
  });
}
