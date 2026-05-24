import 'package:flutter_foundation_kit/features/accounts/application/use_cases/calculate_total_accounts_balance_use_case.dart';
import 'package:flutter_foundation_kit/features/accounts/domain/account.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/amortization.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/budgeting_fixtures.dart';

void main() {
  test('calculates total account balance in home currency', () async {
    final trip = testTrip();
    const usdAccount = Account(
      id: 'usd',
      tripId: 'trip-1',
      name: 'USD cash',
      type: AccountType.cash,
      currency: 'USD',
      openingBalance: 100,
    );
    const jpyAccount = Account(
      id: 'jpy',
      tripId: 'trip-1',
      name: 'JPY cash',
      type: AccountType.cash,
      currency: 'JPY',
      openingBalance: 10000,
    );

    final total = expectOk(
      await const CalculateTotalAccountsBalanceUseCase(
        ConvertToHomeCurrencyUseCase(FakeExchangeRateRepository(rate: 0.006)),
      )(
        trip: trip,
        accounts: [usdAccount, jpyAccount],
        transactions: [
          testExpense(),
          testTopUp(
            destAccountId: 'jpy',
            accountAmount: 20,
            accountCurrency: 'JPY',
          ),
          testTransfer(accountAmount: 30, destAmount: 30, destCurrency: 'JPY'),
        ],
        asOf: DateTime(2026, 5, 21),
      ),
    );

    expect(total, closeTo(120.3, 0.001));
  });

  test(
    'amortized expense still deducts the full amount from balance',
    () async {
      final trip = testTrip();
      const account = Account(
        id: 'usd',
        tripId: 'trip-1',
        name: 'USD cash',
        type: AccountType.cash,
        currency: 'USD',
        openingBalance: 500,
      );

      final total = expectOk(
        await const CalculateTotalAccountsBalanceUseCase(
          ConvertToHomeCurrencyUseCase(FakeExchangeRateRepository(rate: 1)),
        )(
          trip: trip,
          accounts: [account],
          transactions: [
            testExpense(
              paidAmount: 70,
              amortization: const Amortization(
                unit: AmortizationUnit.days,
                count: 7,
              ),
            ),
          ],
          asOf: DateTime(2026, 5, 21),
        ),
      );

      expect(total, 430);
    },
  );

  test(
    'computes per-account balances on each side of a cross-currency transfer',
    () async {
      final trip = testTrip();
      const usdAccount = Account(
        id: 'usd',
        tripId: 'trip-1',
        name: 'USD card',
        type: AccountType.card,
        currency: 'USD',
        openingBalance: 500,
      );
      const jpyAccount = Account(
        id: 'jpy',
        tripId: 'trip-1',
        name: 'JPY cash',
        type: AccountType.cash,
        currency: 'JPY',
        openingBalance: 0,
      );
      final transfer = Transaction(
        id: 'txn-xc',
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

      final total = expectOk(
        await const CalculateTotalAccountsBalanceUseCase(
          ConvertToHomeCurrencyUseCase(
            PairExchangeRateRepository({'JPY:USD': 0.0062}),
          ),
        )(
          trip: trip,
          accounts: [usdAccount, jpyAccount],
          transactions: [transfer],
          asOf: DateTime(2026, 5, 18),
        ),
      );
      // 500 USD opening - 100 USD source side + 15800 * 0.0062 = 497.96
      expect(total, closeTo(497.96, 0.001));
    },
  );
}
