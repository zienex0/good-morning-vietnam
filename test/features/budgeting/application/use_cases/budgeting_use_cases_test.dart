import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/calculate_average_daily_spend_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/calculate_days_left_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/calculate_spend_trend_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/calculate_total_accounts_balance_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/calculate_total_spend_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/create_expense_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/create_top_up_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/create_transfer_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/create_trip_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/edit_trip_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/account_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_id_generator.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/exchange_rate_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/transaction_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/trip_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/amortization.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/exchange_rate.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('budgeting use cases', () {
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
        idGenerator: const FixedBudgetingIdGenerator(
          fixedTransactionId: 'txn-1',
        ),
      );

      final result = await useCase(
        tripId: trip.id,
        accountId: account.id,
        categoryId: 'food',
        amount: 680,
        occurredAt: DateTime(2026, 5, 20),
        createdAt: DateTime(2026, 5, 20, 9),
      );

      final transaction = expectOk(result);
      expect(transaction.type, TransactionType.expense);
      expect(transaction.paidAmount, 680);
      expect(transaction.paidCurrency, 'JPY');
      expect(transaction.accountAmount, 680);
      expect(transaction.accountCurrency, 'JPY');
    });

    test(
      'converts an entered receipt currency into the payment account currency',
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
          idGenerator: const FixedBudgetingIdGenerator(
            fixedTransactionId: 'txn-foreign-receipt',
          ),
        );

        final result = await useCase(
          tripId: trip.id,
          accountId: account.id,
          categoryId: 'toys',
          amount: 90000,
          paidCurrency: 'VND',
          occurredAt: DateTime(2026, 5, 21),
        );

        final transaction = expectOk(result);
        expect(transaction.paidAmount, 90000);
        expect(transaction.paidCurrency, 'VND');
        expect(transaction.accountAmount, closeTo(13.5, 0.001));
        expect(transaction.accountCurrency, 'PLN');
      },
    );

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
        idGenerator: const FixedBudgetingIdGenerator(
          fixedTransactionId: 'txn-2',
        ),
      );

      final result = await useCase(
        tripId: trip.id,
        accountId: account.id,
        amount: 10000,
        occurredAt: DateTime(2026, 5, 21),
      );

      final transaction = expectOk(result);
      expect(transaction.type, TransactionType.income);
      expect(transaction.sourceAccountId, isNull);
      expect(transaction.destAccountId, account.id);
      expect(transaction.paidAmount, 10000);
      expect(transaction.paidCurrency, 'JPY');
      expect(transaction.accountAmount, 10000);
      expect(transaction.accountCurrency, 'JPY');
    });

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
            testTransfer(
              accountAmount: 30,
              destAmount: 30,
              destCurrency: 'JPY',
            ),
          ],
          asOf: DateTime(2026, 5, 21),
        ),
      );

      expect(total, closeTo(120.3, 0.001));
    });

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

    test(
      'spend trend converts the paid amount across amortized days',
      () async {
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
        idGenerator: const FixedBudgetingIdGenerator(
          fixedTransactionId: 'txn-airbnb',
        ),
      );

      final transaction = expectOk(
        await useCase(
          tripId: trip.id,
          accountId: account.id,
          categoryId: 'lodging',
          amount: 500,
          occurredAt: DateTime(2026, 5, 20),
          amortization: const Amortization(
            unit: AmortizationUnit.days,
            count: 7,
          ),
        ),
      );

      expect(transaction.isAmortized, isTrue);
      expect(transaction.spreadDayCount, 7);
      expect(transaction.paidAmount, 500);
    });

    test('average daily spend uses only the elapsed slice of a spread '
        'expense', () async {
      final trip = testTrip();

      final average = expectOk(
        await const CalculateAverageDailySpendUseCase(
          ConvertToHomeCurrencyUseCase(FakeExchangeRateRepository(rate: 1)),
        )(
          trip: trip,
          // 70 spread over 7 days from the trip start day.
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

      // One day elapsed: 10 accrued / 1 day, not the full 70.
      expect(average, 10);
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

    test('calculates days left from balance and average spend', () async {
      final trip = testTrip();
      const account = Account(
        id: 'usd',
        tripId: 'trip-1',
        name: 'USD cash',
        type: AccountType.cash,
        currency: 'USD',
        openingBalance: 200,
      );
      const convert = ConvertToHomeCurrencyUseCase(
        FakeExchangeRateRepository(rate: 1),
      );

      final daysLeft = expectOk(
        await const CalculateDaysLeftUseCase(
          calculateAverageDailySpend: CalculateAverageDailySpendUseCase(
            convert,
          ),
          calculateTotalAccountsBalance: CalculateTotalAccountsBalanceUseCase(
            convert,
          ),
        )(
          trip: trip,
          accounts: [account],
          transactions: [
            testExpense(paidAmount: 100, occurredAt: DateTime(2026, 5, 10)),
          ],
          asOf: DateTime(2026, 5, 10),
        ),
      );

      expect(daysLeft, 2);
    });

    test(
      'records a cross-currency transfer with the user-supplied received amount',
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
          idGenerator: const FixedBudgetingIdGenerator(
            fixedTransactionId: 'txn-xfer',
          ),
        );

        final result = await useCase(
          tripId: trip.id,
          sourceAccountId: 'usd',
          destAccountId: 'jpy',
          amount: 100,
          destAmount: 15800,
          occurredAt: DateTime(2026, 5, 18),
        );

        final transaction = expectOk(result);
        expect(transaction.paidAmount, 100);
        expect(transaction.paidCurrency, 'USD');
        expect(transaction.accountAmount, 100);
        expect(transaction.accountCurrency, 'USD');
        expect(transaction.destAmount, 15800);
        expect(transaction.destCurrency, 'JPY');
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

    test('creates and edits trips', () async {
      final tripRepository = FakeTripRepository();
      final created = expectOk(
        await CreateTripUseCase(
          repository: tripRepository,
          idGenerator: const FixedBudgetingIdGenerator(
            fixedTripId: 'trip-created',
          ),
        )(
          name: ' Japan 2026 ',
          homeCurrency: 'usd',
          startDate: DateTime(2026, 5, 9),
          createdAt: DateTime(2026),
        ),
      );

      expect(created.id, 'trip-created');
      expect(created.name, 'Japan 2026');
      expect(created.homeCurrency, 'USD');

      final edited = expectOk(
        await EditTripUseCase(tripRepository)(
          created.copyWith(name: 'Japan + Korea 2026', budgetTotal: 1800),
        ),
      );

      expect(edited.name, 'Japan + Korea 2026');
      expect(edited.budgetTotal, 1800);
    });
  });
}

Trip testTrip() {
  return Trip(
    id: 'trip-1',
    name: 'Japan 2026',
    homeCurrency: 'USD',
    startDate: DateTime(2026, 5, 9),
    endDate: DateTime(2026, 6, 8),
    budgetTotal: 1500,
    status: TripStatus.active,
    createdAt: DateTime(2026),
  );
}

Transaction testExpense({
  String id = 'txn-1',
  String sourceAccountId = 'usd',
  double paidAmount = 10,
  String paidCurrency = 'USD',
  double? accountAmount,
  String accountCurrency = 'USD',
  DateTime? occurredAt,
  Amortization? amortization,
}) {
  return Transaction(
    id: id,
    tripId: 'trip-1',
    type: TransactionType.expense,
    occurredAt: occurredAt ?? DateTime(2026, 5, 9),
    sourceAccountId: sourceAccountId,
    categoryId: 'food',
    paidAmount: paidAmount,
    paidCurrency: paidCurrency,
    accountAmount: accountAmount ?? paidAmount,
    accountCurrency: accountCurrency,
    amortization: amortization,
    createdAt: DateTime(2026),
  );
}

Transaction testTopUp({
  String id = 'txn-top-up',
  String destAccountId = 'usd',
  double paidAmount = 10,
  String paidCurrency = 'USD',
  double? accountAmount,
  String accountCurrency = 'USD',
}) {
  return Transaction(
    id: id,
    tripId: 'trip-1',
    type: TransactionType.income,
    occurredAt: DateTime(2026, 5, 9),
    destAccountId: destAccountId,
    paidAmount: paidAmount,
    paidCurrency: paidCurrency,
    accountAmount: accountAmount ?? paidAmount,
    accountCurrency: accountCurrency,
    createdAt: DateTime(2026),
  );
}

Transaction testTransfer({
  double paidAmount = 10,
  String paidCurrency = 'USD',
  double? accountAmount,
  String accountCurrency = 'USD',
  double? destAmount,
  String destCurrency = 'USD',
}) {
  return Transaction(
    id: 'txn-transfer',
    tripId: 'trip-1',
    type: TransactionType.transfer,
    occurredAt: DateTime(2026, 5, 9),
    sourceAccountId: 'usd',
    destAccountId: 'jpy',
    paidAmount: paidAmount,
    paidCurrency: paidCurrency,
    accountAmount: accountAmount ?? paidAmount,
    accountCurrency: accountCurrency,
    destAmount: destAmount ?? paidAmount,
    destCurrency: destCurrency,
    createdAt: DateTime(2026),
  );
}

T expectOk<T>(Result<T, Failure> result) {
  return switch (result) {
    Ok(value: final value) => value,
    Err(failure: final failure) => throw TestFailure(
      'Expected Ok, got $failure',
    ),
  };
}

class FakeExchangeRateRepository implements ExchangeRateRepository {
  const FakeExchangeRateRepository({required this.rate});

  final double rate;

  @override
  Future<Result<ExchangeRate, Failure>> fetchRate({
    required CurrencyCode base,
    required CurrencyCode quote,
    required DateTime date,
  }) async {
    return Ok(ExchangeRate(base: base, quote: quote, rate: rate, date: date));
  }
}

class PairExchangeRateRepository implements ExchangeRateRepository {
  const PairExchangeRateRepository(this.rates);

  final Map<String, double> rates;

  @override
  Future<Result<ExchangeRate, Failure>> fetchRate({
    required CurrencyCode base,
    required CurrencyCode quote,
    required DateTime date,
  }) async {
    final rate = rates['$base:$quote'];
    if (rate == null) {
      return const Err(NotFoundFailure());
    }
    return Ok(ExchangeRate(base: base, quote: quote, rate: rate, date: date));
  }
}

class FixedBudgetingIdGenerator implements BudgetingIdGenerator {
  const FixedBudgetingIdGenerator({
    this.fixedTransactionId = 'txn-fixed',
    this.fixedTripId = 'trip-fixed',
    this.fixedAccountId = 'acct-fixed',
  });

  final String fixedTransactionId;
  final String fixedTripId;
  final String fixedAccountId;

  @override
  String transactionId() => fixedTransactionId;

  @override
  String tripId() => fixedTripId;

  @override
  String accountId() => fixedAccountId;
}

class FakeTripRepository implements TripRepository {
  FakeTripRepository({Iterable<Trip> trips = const []})
    : _trips = {for (final trip in trips) trip.id: trip};

  final Map<String, Trip> _trips;
  String? _activeTripId;

  List<Trip> _sorted() =>
      _trips.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  @override
  Future<Result<List<Trip>, Failure>> listTrips() async => Ok(_sorted());

  @override
  Stream<List<Trip>> watchTrips() async* {
    yield _sorted();
  }

  @override
  Future<Result<Trip, Failure>> fetchTrip({required String tripId}) async {
    final trip = _trips[tripId];
    if (trip == null) return const Err(NotFoundFailure());
    return Ok(trip);
  }

  @override
  Future<Result<Trip, Failure>> createTrip(Trip trip) async {
    _trips[trip.id] = trip;
    return Ok(trip);
  }

  @override
  Future<Result<Trip, Failure>> updateTrip(Trip trip) async {
    if (!_trips.containsKey(trip.id)) return const Err(NotFoundFailure());
    _trips[trip.id] = trip;
    return Ok(trip);
  }

  @override
  Future<Result<void, Failure>> deleteTrip({required String tripId}) async {
    if (!_trips.containsKey(tripId)) return const Err(NotFoundFailure());
    _trips.remove(tripId);
    return const Ok(null);
  }

  @override
  String? getActiveTripId() => _activeTripId;

  @override
  Future<void> setActiveTripId(String? tripId) async {
    _activeTripId = tripId;
  }

  @override
  Stream<String?> watchActiveTripId() async* {
    yield _activeTripId;
  }
}

class FakeAccountRepository implements AccountRepository {
  FakeAccountRepository({Iterable<Account> accounts = const []})
    : _accounts = {for (final account in accounts) account.id: account};

  final Map<String, Account> _accounts;

  List<Account> _forTrip(String tripId, {required bool includeArchived}) =>
      _accounts.values
          .where((account) => account.tripId == tripId)
          .where((account) => includeArchived || !account.archived)
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));

  @override
  Future<Result<List<Account>, Failure>> fetchAccounts({
    required String tripId,
    bool includeArchived = false,
  }) async => Ok(_forTrip(tripId, includeArchived: includeArchived));

  @override
  Stream<List<Account>> watchAccounts({
    required String tripId,
    bool includeArchived = false,
  }) async* {
    yield _forTrip(tripId, includeArchived: includeArchived);
  }

  @override
  Future<Result<Account, Failure>> fetchAccountById({
    required String accountId,
  }) async {
    final account = _accounts[accountId];
    if (account == null) return const Err(NotFoundFailure());
    return Ok(account);
  }

  @override
  Future<Result<Account, Failure>> createAccount(Account account) async {
    _accounts[account.id] = account;
    return Ok(account);
  }

  @override
  Future<Result<Account, Failure>> updateAccount(Account account) async {
    if (!_accounts.containsKey(account.id)) return const Err(NotFoundFailure());
    _accounts[account.id] = account;
    return Ok(account);
  }

  @override
  Future<Result<void, Failure>> deleteAccount({
    required String accountId,
  }) async {
    if (!_accounts.containsKey(accountId)) return const Err(NotFoundFailure());
    _accounts.remove(accountId);
    return const Ok(null);
  }

  @override
  Future<Result<void, Failure>> deleteAccountsForTrip({
    required String tripId,
  }) async {
    _accounts.removeWhere((_, account) => account.tripId == tripId);
    return const Ok(null);
  }
}

class FakeTransactionRepository implements TransactionRepository {
  FakeTransactionRepository({Iterable<Transaction> transactions = const []})
    : _transactions = {
        for (final transaction in transactions) transaction.id: transaction,
      };

  final Map<String, Transaction> _transactions;

  List<Transaction> _forTrip(String tripId) =>
      _transactions.values
          .where((transaction) => transaction.tripId == tripId)
          .toList()
        ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));

  @override
  Future<Result<List<Transaction>, Failure>> fetchTransactions({
    required String tripId,
  }) async => Ok(_forTrip(tripId));

  @override
  Stream<List<Transaction>> watchTransactions({required String tripId}) async* {
    yield _forTrip(tripId);
  }

  @override
  Future<Result<Transaction, Failure>> fetchTransactionById({
    required String transactionId,
  }) async {
    final transaction = _transactions[transactionId];
    if (transaction == null) return const Err(NotFoundFailure());
    return Ok(transaction);
  }

  @override
  Future<Result<Transaction, Failure>> createTransaction(
    Transaction transaction,
  ) async {
    _transactions[transaction.id] = transaction;
    return Ok(transaction);
  }

  @override
  Future<Result<void, Failure>> deleteTransactionsForTrip({
    required String tripId,
  }) async {
    _transactions.removeWhere((_, transaction) => transaction.tripId == tripId);
    return const Ok(null);
  }

  @override
  Future<Result<void, Failure>> deleteTransactionsForAccount({
    required String accountId,
  }) async {
    _transactions.removeWhere(
      (_, transaction) =>
          transaction.sourceAccountId == accountId ||
          transaction.destAccountId == accountId,
    );
    return const Ok(null);
  }
}
