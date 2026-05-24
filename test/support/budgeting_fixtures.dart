import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/accounts/data/account_id_generator.dart';
import 'package:flutter_foundation_kit/features/accounts/data/account_repository.dart';
import 'package:flutter_foundation_kit/features/accounts/domain/account.dart';
import 'package:flutter_foundation_kit/features/transactions/data/exchange_rate_repository.dart';
import 'package:flutter_foundation_kit/features/transactions/data/transaction_id_generator.dart';
import 'package:flutter_foundation_kit/features/transactions/data/transaction_repository.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/amortization.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/exchange_rate.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/trips/data/trip_id_generator.dart';
import 'package:flutter_foundation_kit/features/trips/data/trip_repository.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';
import 'package:flutter_test/flutter_test.dart';

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

class FakeTripIdGenerator implements TripIdGenerator {
  const FakeTripIdGenerator(this.id);
  final String id;
  @override
  String newTripId() => id;
}

class FakeAccountIdGenerator implements AccountIdGenerator {
  const FakeAccountIdGenerator(this.id);
  final String id;
  @override
  String newAccountId() => id;
}

class FakeTransactionIdGenerator implements TransactionIdGenerator {
  const FakeTransactionIdGenerator(this.id);
  final String id;
  @override
  String newTransactionId() => id;
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
