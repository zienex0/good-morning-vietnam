import 'package:flutter_foundation_kit/features/accounts/domain/account.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/calculate_average_daily_spend_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/calculate_spend_trend_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/calculate_total_spend_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/create_expense_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/create_top_up_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/create_transfer_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/set_account_balances_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/amortization.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/categories.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/budgeting_fixtures.dart';

void main() {
  test('creates an expense with immutable paid and account facts', () async {
    final trip = testTrip();
    const account = Account(
      id: 'account-1',
      tripId: 'trip-1',
      name: 'Cash JPY',
      type: AccountType.cash,
      currency: 'JPY',
      openingBalance: 0,
    );
    final useCase = CreateExpenseUseCase(
      tripRepository: FakeTripRepository(trips: [trip]),
      accountRepository: FakeAccountRepository(accounts: [account]),
      transactionRepository: FakeTransactionRepository(),
      convertToHomeCurrency: const ConvertToHomeCurrencyUseCase(
        FakeExchangeRateRepository(rate: 0.0062),
      ),
      idGenerator: const FakeTransactionIdGenerator('txn-1'),
    );

    final transaction = expectOk(
      await useCase(
        tripId: trip.id,
        accountId: account.id,
        categoryId: 'food',
        amount: 680,
        occurredAt: DateTime(2026, 5, 20),
        createdAt: DateTime(2026, 5, 20, 9),
      ),
    );

    expect(transaction.type, TransactionType.expense);
    expect(transaction.paidAmount, 680);
    expect(transaction.paidCurrency, 'JPY');
    expect(transaction.accountAmount, 680);
    expect(transaction.accountCurrency, 'JPY');
  });

  test(
    'converts an entered receipt currency into the account currency',
    () async {
      final trip = testTrip();
      const account = Account(
        id: 'account-1',
        tripId: 'trip-1',
        name: 'Default wallet',
        type: AccountType.ewallet,
        currency: 'PLN',
        openingBalance: 0,
      );
      final useCase = CreateExpenseUseCase(
        tripRepository: FakeTripRepository(trips: [trip]),
        accountRepository: FakeAccountRepository(accounts: [account]),
        transactionRepository: FakeTransactionRepository(),
        convertToHomeCurrency: const ConvertToHomeCurrencyUseCase(
          PairExchangeRateRepository({'VND:PLN': 0.00015}),
        ),
        idGenerator: const FakeTransactionIdGenerator('txn-foreign-receipt'),
      );

      final transaction = expectOk(
        await useCase(
          tripId: trip.id,
          accountId: account.id,
          categoryId: 'toys',
          amount: 90000,
          paidCurrency: 'VND',
          occurredAt: DateTime(2026, 5, 21),
        ),
      );

      expect(transaction.paidAmount, 90000);
      expect(transaction.paidCurrency, 'VND');
      expect(transaction.accountAmount, closeTo(13.5, 0.001));
      expect(transaction.accountCurrency, 'PLN');
    },
  );

  test('persists amortization on a spread expense', () async {
    final trip = testTrip();
    const account = Account(
      id: 'account-1',
      tripId: 'trip-1',
      name: 'USD cash',
      type: AccountType.cash,
      currency: 'USD',
      openingBalance: 0,
    );
    final useCase = CreateExpenseUseCase(
      tripRepository: FakeTripRepository(trips: [trip]),
      accountRepository: FakeAccountRepository(accounts: [account]),
      transactionRepository: FakeTransactionRepository(),
      convertToHomeCurrency: const ConvertToHomeCurrencyUseCase(
        FakeExchangeRateRepository(rate: 1),
      ),
      idGenerator: const FakeTransactionIdGenerator('txn-airbnb'),
    );

    final transaction = expectOk(
      await useCase(
        tripId: trip.id,
        accountId: account.id,
        categoryId: 'lodging',
        amount: 500,
        occurredAt: DateTime(2026, 5, 20),
        amortization: const Amortization(unit: AmortizationUnit.days, count: 7),
      ),
    );

    expect(transaction.isAmortized, isTrue);
    expect(transaction.spreadDayCount, 7);
    expect(transaction.paidAmount, 500);
  });

  test('creates a top-up for the selected account', () async {
    final trip = testTrip();
    const account = Account(
      id: 'account-1',
      tripId: 'trip-1',
      name: 'Revolut JPY',
      type: AccountType.card,
      currency: 'JPY',
      openingBalance: 0,
    );
    final useCase = CreateTopUpUseCase(
      tripRepository: FakeTripRepository(trips: [trip]),
      accountRepository: FakeAccountRepository(accounts: [account]),
      transactionRepository: FakeTransactionRepository(),
      convertToHomeCurrency: const ConvertToHomeCurrencyUseCase(
        FakeExchangeRateRepository(rate: 0.006),
      ),
      idGenerator: const FakeTransactionIdGenerator('txn-2'),
    );

    final transaction = expectOk(
      await useCase(
        tripId: trip.id,
        accountId: account.id,
        amount: 10000,
        occurredAt: DateTime(2026, 5, 21),
      ),
    );

    expect(transaction.type, TransactionType.income);
    expect(transaction.sourceAccountId, isNull);
    expect(transaction.destAccountId, account.id);
    expect(transaction.paidAmount, 10000);
    expect(transaction.accountAmount, 10000);
  });

  test('sets a higher account balance with an income transaction', () async {
    final trip = testTrip();
    const account = Account(
      id: 'account-1',
      tripId: 'trip-1',
      name: 'USD cash',
      type: AccountType.cash,
      currency: 'USD',
      openingBalance: 50,
    );
    final repository = FakeTransactionRepository(
      transactions: [testExpense(sourceAccountId: account.id)],
    );
    final useCase = SetAccountBalancesUseCase(
      tripRepository: FakeTripRepository(trips: [trip]),
      accountRepository: FakeAccountRepository(accounts: [account]),
      transactionRepository: repository,
      idGenerator: const FakeTransactionIdGenerator('txn-adjustment'),
    );

    final transactions = expectOk(
      await useCase(
        tripId: trip.id,
        balancesByAccountId: {account.id: 75},
        occurredAt: DateTime(2026, 5, 22),
      ),
    );

    expect(transactions, hasLength(1));
    expect(transactions.single.type, TransactionType.income);
    expect(transactions.single.destAccountId, account.id);
    expect(transactions.single.accountAmount, 35);
    expect(
      account.balanceFrom(
        expectOk(await repository.fetchTransactions(tripId: trip.id)),
      ),
      75,
    );
  });

  test('sets a lower account balance with an adjustment expense', () async {
    final trip = testTrip();
    const account = Account(
      id: 'account-1',
      tripId: 'trip-1',
      name: 'USD cash',
      type: AccountType.cash,
      currency: 'USD',
      openingBalance: 50,
    );
    final repository = FakeTransactionRepository();
    final useCase = SetAccountBalancesUseCase(
      tripRepository: FakeTripRepository(trips: [trip]),
      accountRepository: FakeAccountRepository(accounts: [account]),
      transactionRepository: repository,
      idGenerator: const FakeTransactionIdGenerator('txn-adjustment'),
    );

    final transactions = expectOk(
      await useCase(
        tripId: trip.id,
        balancesByAccountId: {account.id: 20},
        occurredAt: DateTime(2026, 5, 22),
      ),
    );

    expect(transactions, hasLength(1));
    expect(transactions.single.type, TransactionType.expense);
    expect(transactions.single.sourceAccountId, account.id);
    expect(
      transactions.single.categoryId,
      kBudgetingBalanceAdjustmentCategoryId,
    );
    expect(transactions.single.accountAmount, 30);
    expect(
      account.balanceFrom(
        expectOk(await repository.fetchTransactions(tripId: trip.id)),
      ),
      20,
    );
  });

  test(
    'does not create a transaction when the account balance is unchanged',
    () async {
      final trip = testTrip();
      const account = Account(
        id: 'account-1',
        tripId: 'trip-1',
        name: 'USD cash',
        type: AccountType.cash,
        currency: 'USD',
        openingBalance: 50,
      );
      final repository = FakeTransactionRepository();
      final useCase = SetAccountBalancesUseCase(
        tripRepository: FakeTripRepository(trips: [trip]),
        accountRepository: FakeAccountRepository(accounts: [account]),
        transactionRepository: repository,
        idGenerator: const FakeTransactionIdGenerator('txn-adjustment'),
      );

      final transactions = expectOk(
        await useCase(
          tripId: trip.id,
          balancesByAccountId: {account.id: 50},
          occurredAt: DateTime(2026, 5, 22),
        ),
      );

      expect(transactions, isEmpty);
      expect(
        expectOk(await repository.fetchTransactions(tripId: trip.id)),
        isEmpty,
      );
    },
  );

  test(
    'records a cross-currency transfer with the supplied received amount',
    () async {
      final trip = testTrip();
      const usdAccount = Account(
        id: 'usd',
        tripId: 'trip-1',
        name: 'Revolut USD',
        type: AccountType.card,
        currency: 'USD',
        openingBalance: 500,
      );
      const jpyAccount = Account(
        id: 'jpy',
        tripId: 'trip-1',
        name: 'Cash JPY',
        type: AccountType.cash,
        currency: 'JPY',
        openingBalance: 0,
      );
      final useCase = CreateTransferUseCase(
        tripRepository: FakeTripRepository(trips: [trip]),
        accountRepository: FakeAccountRepository(
          accounts: [usdAccount, jpyAccount],
        ),
        transactionRepository: FakeTransactionRepository(),
        convertToHomeCurrency: const ConvertToHomeCurrencyUseCase(
          PairExchangeRateRepository({}),
        ),
        idGenerator: const FakeTransactionIdGenerator('txn-xfer'),
      );

      final transaction = expectOk(
        await useCase(
          tripId: trip.id,
          sourceAccountId: 'usd',
          destAccountId: 'jpy',
          amount: 100,
          destAmount: 15800,
          occurredAt: DateTime(2026, 5, 18),
        ),
      );

      expect(transaction.paidAmount, 100);
      expect(transaction.paidCurrency, 'USD');
      expect(transaction.destAmount, 15800);
      expect(transaction.destCurrency, 'JPY');
    },
  );

  test(
    'converts spend metrics from paid facts into the trip currency',
    () async {
      final trip = testTrip();
      final total = expectOk(
        await const CalculateTotalSpendUseCase(
          ConvertToHomeCurrencyUseCase(
            PairExchangeRateRepository({'VND:USD': 0.000038}),
          ),
        )(
          trip: trip,
          transactions: [
            testExpense(
              paidAmount: 22000,
              paidCurrency: 'VND',
              accountAmount: 0.84,
            ),
          ],
        ),
      );

      expect(total, closeTo(0.836, 0.001));
    },
  );

  test('calculates average daily spend for elapsed trip days', () async {
    final trip = testTrip();
    final average = expectOk(
      await const CalculateAverageDailySpendUseCase(
        ConvertToHomeCurrencyUseCase(FakeExchangeRateRepository(rate: 1)),
      )(
        trip: trip,
        transactions: [
          testExpense(paidAmount: 40),
          testExpense(
            id: 'txn-2',
            paidAmount: 60,
            occurredAt: DateTime(2026, 5, 12),
          ),
        ],
        asOf: DateTime(2026, 5, 12, 23),
      ),
    );

    expect(average, 25);
  });

  test(
    'average daily spend uses only the elapsed slice of a spread expense',
    () async {
      final trip = testTrip();
      final average = expectOk(
        await const CalculateAverageDailySpendUseCase(
          ConvertToHomeCurrencyUseCase(FakeExchangeRateRepository(rate: 1)),
        )(
          trip: trip,
          transactions: [
            testExpense(
              paidAmount: 70,
              amortization: const Amortization(
                unit: AmortizationUnit.days,
                count: 7,
              ),
            ),
          ],
          asOf: DateTime(2026, 5, 9, 23),
        ),
      );

      expect(average, 10);
    },
  );

  test('spend trend converts the paid amount across amortized days', () async {
    final trip = testTrip();
    final points = expectOk(
      await const CalculateSpendTrendUseCase(
        ConvertToHomeCurrencyUseCase(
          PairExchangeRateRepository({'VND:USD': 0.000038}),
        ),
      )(
        trip: trip,
        transactions: [
          testExpense(
            paidAmount: 70000,
            paidCurrency: 'VND',
            accountAmount: 2.66,
            amortization: const Amortization(
              unit: AmortizationUnit.days,
              count: 7,
            ),
          ),
        ],
        asOf: DateTime(2026, 5, 11),
      ),
    );

    expect(points.map((point) => point.value).toList(), [
      closeTo(0.38, 0.001),
      closeTo(0.76, 0.001),
      closeTo(1.14, 0.001),
    ]);
  });
}
