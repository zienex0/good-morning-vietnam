import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budgeting_repository.g.dart';

abstract interface class BudgetingRepository {
  Future<Result<List<Transaction>, Failure>> fetchTransactions({
    required String tripId,
  });

  Future<Result<Transaction, Failure>> fetchTransactionById({
    required String transactionId,
  });

  Future<Result<Transaction, Failure>> createTransaction(
    Transaction transaction,
  );

  Future<Result<List<Account>, Failure>> fetchAccounts({
    required String tripId,
    bool includeArchived = false,
  });

  Future<Result<Account, Failure>> fetchAccountById({
    required String accountId,
  });

  Future<Result<Trip, Failure>> fetchTrip({required String tripId});

  Future<Result<Trip, Failure>> createTrip(Trip trip);

  Future<Result<Trip, Failure>> updateTrip(Trip trip);
}

class FakeBudgetingRepository implements BudgetingRepository {
  FakeBudgetingRepository({
    Iterable<Trip> trips = const [],
    Iterable<Account> accounts = const [],
    Iterable<Transaction> transactions = const [],
  }) : _trips = {for (final trip in trips) trip.id: trip},
       _accounts = {for (final account in accounts) account.id: account},
       _transactions = {
         for (final transaction in transactions) transaction.id: transaction,
       };

  final Map<String, Trip> _trips;
  final Map<String, Account> _accounts;
  final Map<String, Transaction> _transactions;

  @override
  Future<Result<List<Transaction>, Failure>> fetchTransactions({
    required String tripId,
  }) async {
    final transactions =
        _transactions.values
            .where((transaction) => transaction.tripId == tripId)
            .toList()
          ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    return Ok(transactions);
  }

  @override
  Future<Result<Transaction, Failure>> fetchTransactionById({
    required String transactionId,
  }) async {
    final transaction = _transactions[transactionId];
    if (transaction == null) {
      return const Err(NotFoundFailure());
    }
    return Ok(transaction);
  }

  @override
  Future<Result<Transaction, Failure>> createTransaction(
    Transaction transaction,
  ) async {
    if (!_trips.containsKey(transaction.tripId)) {
      return const Err(NotFoundFailure());
    }
    _transactions[transaction.id] = transaction;
    return Ok(transaction);
  }

  @override
  Future<Result<List<Account>, Failure>> fetchAccounts({
    required String tripId,
    bool includeArchived = false,
  }) async {
    final accounts =
        _accounts.values
            .where((account) => account.tripId == tripId)
            .where((account) => includeArchived || !account.archived)
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));
    return Ok(accounts);
  }

  @override
  Future<Result<Account, Failure>> fetchAccountById({
    required String accountId,
  }) async {
    final account = _accounts[accountId];
    if (account == null) {
      return const Err(NotFoundFailure());
    }
    return Ok(account);
  }

  @override
  Future<Result<Trip, Failure>> fetchTrip({required String tripId}) async {
    final trip = _trips[tripId];
    if (trip == null) {
      return const Err(NotFoundFailure());
    }
    return Ok(trip);
  }

  @override
  Future<Result<Trip, Failure>> createTrip(Trip trip) async {
    _trips[trip.id] = trip;
    return Ok(trip);
  }

  @override
  Future<Result<Trip, Failure>> updateTrip(Trip trip) async {
    if (!_trips.containsKey(trip.id)) {
      return const Err(NotFoundFailure());
    }
    _trips[trip.id] = trip;
    return Ok(trip);
  }
}

@Riverpod(keepAlive: true)
BudgetingRepository budgetingRepository(BudgetingRepositoryRef ref) {
  return FakeBudgetingRepository(
    trips: [
      Trip(
        id: 'trip-japan-2026',
        name: 'Japan 2026',
        homeCurrency: 'USD',
        startDate: DateTime(2026, 5, 9),
        endDate: DateTime(2026, 6, 8),
        budgetTotal: 1500,
        status: TripStatus.active,
        createdAt: DateTime(2026, 4),
      ),
    ],
    accounts: const [
      Account(
        id: 'wallet-pln',
        tripId: 'trip-japan-2026',
        name: 'Default wallet',
        type: AccountType.ewallet,
        currency: 'PLN',
        openingBalance: 1250,
      ),
      Account(
        id: 'cash-jpy',
        tripId: 'trip-japan-2026',
        name: 'Cash JPY',
        type: AccountType.cash,
        currency: 'JPY',
        openingBalance: 32000,
      ),
      Account(
        id: 'revolut-usd',
        tripId: 'trip-japan-2026',
        name: 'Revolut',
        type: AccountType.card,
        currency: 'USD',
        openingBalance: 410,
      ),
      Account(
        id: 'chase-usd',
        tripId: 'trip-japan-2026',
        name: 'Chase debit',
        type: AccountType.bank,
        currency: 'USD',
        openingBalance: 217,
      ),
      Account(
        id: 'momo-vnd',
        tripId: 'trip-japan-2026',
        name: 'MoMo wallet',
        type: AccountType.ewallet,
        currency: 'VND',
        openingBalance: 1900000,
      ),
    ],
  );
}
