import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/accounts/data/account_repository.dart';
import 'package:flutter_foundation_kit/features/accounts/domain/account.dart';
import 'package:flutter_foundation_kit/features/transactions/data/transaction_id_generator.dart';
import 'package:flutter_foundation_kit/features/transactions/data/transaction_repository.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/categories.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/trips/data/trip_repository.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';

class SetAccountBalancesUseCase {
  const SetAccountBalancesUseCase({
    required TripRepository tripRepository,
    required AccountRepository accountRepository,
    required TransactionRepository transactionRepository,
    required TransactionIdGenerator idGenerator,
  }) : _tripRepository = tripRepository,
       _accountRepository = accountRepository,
       _transactionRepository = transactionRepository,
       _idGenerator = idGenerator;

  final TripRepository _tripRepository;
  final AccountRepository _accountRepository;
  final TransactionRepository _transactionRepository;
  final TransactionIdGenerator _idGenerator;

  Future<Result<List<Transaction>, Failure>> call({
    required String tripId,
    required Map<String, double> balancesByAccountId,
    required DateTime occurredAt,
    DateTime? createdAt,
  }) async {
    if (balancesByAccountId.isEmpty) {
      return const Ok([]);
    }
    for (final entry in balancesByAccountId.entries) {
      if (entry.value < 0) {
        return const Err(
          ValidationFailure('Account balance cannot be negative.'),
        );
      }
    }

    final tripResult = await _tripRepository.fetchTrip(tripId: tripId);
    final Trip trip;
    switch (tripResult) {
      case Ok(value: final value):
        trip = value;
      case Err(failure: final failure):
        return Err(failure);
    }

    final accountsResult = await _accountRepository.fetchAccounts(
      tripId: trip.id,
    );
    final List<Account> accounts;
    switch (accountsResult) {
      case Ok(value: final value):
        accounts = value;
      case Err(failure: final failure):
        return Err(failure);
    }

    final transactionsResult = await _transactionRepository.fetchTransactions(
      tripId: trip.id,
    );
    final List<Transaction> transactions;
    switch (transactionsResult) {
      case Ok(value: final value):
        transactions = value;
      case Err(failure: final failure):
        return Err(failure);
    }

    final accountsById = {for (final account in accounts) account.id: account};
    for (final accountId in balancesByAccountId.keys) {
      if (!accountsById.containsKey(accountId)) {
        return const Err(ValidationFailure('Account does not belong to trip.'));
      }
    }

    final createdTransactions = <Transaction>[];
    for (final entry in balancesByAccountId.entries) {
      final account = accountsById[entry.key]!;
      final currentBalance = account.balanceFrom(transactions);
      final balanceDelta = entry.value - currentBalance;
      if (balanceDelta.abs() < 0.000001) {
        continue;
      }

      final transaction = balanceDelta > 0
          ? Transaction(
              id: _idGenerator.newTransactionId(),
              tripId: trip.id,
              type: TransactionType.income,
              occurredAt: occurredAt,
              destAccountId: account.id,
              paidAmount: balanceDelta,
              paidCurrency: account.currency,
              accountAmount: balanceDelta,
              accountCurrency: account.currency,
              note: 'Set balance',
              createdAt: createdAt ?? DateTime.now(),
            )
          : Transaction(
              id: _idGenerator.newTransactionId(),
              tripId: trip.id,
              type: TransactionType.expense,
              occurredAt: occurredAt,
              sourceAccountId: account.id,
              categoryId: kBudgetingBalanceAdjustmentCategoryId,
              paidAmount: balanceDelta.abs(),
              paidCurrency: account.currency,
              accountAmount: balanceDelta.abs(),
              accountCurrency: account.currency,
              note: 'Set balance',
              createdAt: createdAt ?? DateTime.now(),
            );

      final createResult = await _transactionRepository.createTransaction(
        transaction,
      );
      switch (createResult) {
        case Ok(value: final value):
          createdTransactions.add(value);
        case Err(failure: final failure):
          return Err(failure);
      }
    }

    return Ok(createdTransactions);
  }
}
