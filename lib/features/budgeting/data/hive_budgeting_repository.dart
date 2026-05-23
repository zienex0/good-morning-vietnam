import 'dart:convert';

import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/hive_budgeting_boxes.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/mappers/account_mapper.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/mappers/transaction_mapper.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/mappers/trip_mapper.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';

class HiveBudgetingRepository implements BudgetingRepository {
  HiveBudgetingRepository({required this.boxes});

  final HiveBudgetingBoxes boxes;

  Trip _decodeTrip(String raw) =>
      tripFromJson(jsonDecode(raw) as Map<String, dynamic>);

  Account _decodeAccount(String raw) =>
      accountFromJson(jsonDecode(raw) as Map<String, dynamic>);

  Transaction _decodeTransaction(String raw) =>
      transactionFromJson(jsonDecode(raw) as Map<String, dynamic>);

  @override
  Future<Result<List<Trip>, Failure>> listTrips() async {
    final trips = boxes.trips.values.map(_decodeTrip).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Ok(trips);
  }

  @override
  Future<Result<Trip, Failure>> fetchTrip({required String tripId}) async {
    final raw = boxes.trips.get(tripId);
    if (raw == null) {
      return const Err(NotFoundFailure());
    }
    return Ok(_decodeTrip(raw));
  }

  @override
  Future<Result<Trip, Failure>> createTrip(Trip trip) async {
    await boxes.trips.put(trip.id, jsonEncode(tripToJson(trip)));
    return Ok(trip);
  }

  @override
  Future<Result<Trip, Failure>> updateTrip(Trip trip) async {
    if (!boxes.trips.containsKey(trip.id)) {
      return const Err(NotFoundFailure());
    }
    await boxes.trips.put(trip.id, jsonEncode(tripToJson(trip)));
    return Ok(trip);
  }

  @override
  Future<Result<void, Failure>> deleteTrip({required String tripId}) async {
    if (!boxes.trips.containsKey(tripId)) {
      return const Err(NotFoundFailure());
    }

    final accountIdsToRemove = <String>[];
    for (final raw in boxes.accounts.values) {
      final account = _decodeAccount(raw);
      if (account.tripId == tripId) {
        accountIdsToRemove.add(account.id);
      }
    }
    final transactionIdsToRemove = <String>[];
    for (final raw in boxes.transactions.values) {
      final transaction = _decodeTransaction(raw);
      if (transaction.tripId == tripId) {
        transactionIdsToRemove.add(transaction.id);
      }
    }

    await boxes.accounts.deleteAll(accountIdsToRemove);
    await boxes.transactions.deleteAll(transactionIdsToRemove);
    await boxes.trips.delete(tripId);

    if (boxes.settings.get(settingsActiveTripIdKey) == tripId) {
      await boxes.settings.delete(settingsActiveTripIdKey);
    }
    return const Ok(null);
  }

  @override
  Future<Result<List<Account>, Failure>> fetchAccounts({
    required String tripId,
    bool includeArchived = false,
  }) async {
    final accounts =
        boxes.accounts.values
            .map(_decodeAccount)
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
    final raw = boxes.accounts.get(accountId);
    if (raw == null) {
      return const Err(NotFoundFailure());
    }
    return Ok(_decodeAccount(raw));
  }

  @override
  Future<Result<Account, Failure>> createAccount(Account account) async {
    if (!boxes.trips.containsKey(account.tripId)) {
      return const Err(NotFoundFailure());
    }
    await boxes.accounts.put(account.id, jsonEncode(accountToJson(account)));
    return Ok(account);
  }

  @override
  Future<Result<Account, Failure>> updateAccount(Account account) async {
    if (!boxes.accounts.containsKey(account.id)) {
      return const Err(NotFoundFailure());
    }
    await boxes.accounts.put(account.id, jsonEncode(accountToJson(account)));
    return Ok(account);
  }

  @override
  Future<Result<void, Failure>> deleteAccount({
    required String accountId,
  }) async {
    if (!boxes.accounts.containsKey(accountId)) {
      return const Err(NotFoundFailure());
    }
    await boxes.accounts.delete(accountId);
    return const Ok(null);
  }

  @override
  Future<Result<void, Failure>> deleteAccountWithTransactions({
    required String accountId,
  }) async {
    if (!boxes.accounts.containsKey(accountId)) {
      return const Err(NotFoundFailure());
    }

    final transactionIdsToRemove = <dynamic>[];
    for (final key in boxes.transactions.keys) {
      final raw = boxes.transactions.get(key);
      if (raw == null) {
        continue;
      }
      try {
        final transaction = _decodeTransaction(raw);
        if (transaction.sourceAccountId == accountId ||
            transaction.destAccountId == accountId) {
          transactionIdsToRemove.add(key);
        }
      } on Object {
        transactionIdsToRemove.add(key);
      }
    }

    await boxes.transactions.deleteAll(transactionIdsToRemove);
    await boxes.accounts.delete(accountId);
    return const Ok(null);
  }

  @override
  Future<Result<List<Transaction>, Failure>> fetchTransactions({
    required String tripId,
  }) async {
    final invalidKeys = <dynamic>[];
    final transactions = <Transaction>[];
    for (final key in boxes.transactions.keys) {
      final raw = boxes.transactions.get(key);
      if (raw == null) {
        continue;
      }
      try {
        final transaction = _decodeTransaction(raw);
        if (transaction.tripId == tripId) {
          transactions.add(transaction);
        }
      } on Object {
        invalidKeys.add(key);
      }
    }
    if (invalidKeys.isNotEmpty) {
      await boxes.transactions.deleteAll(invalidKeys);
    }
    transactions.sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    return Ok(transactions);
  }

  @override
  Future<Result<Transaction, Failure>> fetchTransactionById({
    required String transactionId,
  }) async {
    final raw = boxes.transactions.get(transactionId);
    if (raw == null) {
      return const Err(NotFoundFailure());
    }
    try {
      return Ok(_decodeTransaction(raw));
    } on Object {
      await boxes.transactions.delete(transactionId);
      return const Err(NotFoundFailure());
    }
  }

  @override
  Future<Result<Transaction, Failure>> createTransaction(
    Transaction transaction,
  ) async {
    if (!boxes.trips.containsKey(transaction.tripId)) {
      return const Err(NotFoundFailure());
    }
    await boxes.transactions.put(
      transaction.id,
      jsonEncode(transactionToJson(transaction)),
    );
    return Ok(transaction);
  }

  @override
  String? getActiveTripId() => boxes.settings.get(settingsActiveTripIdKey);

  @override
  Future<void> setActiveTripId(String? tripId) async {
    if (tripId == null) {
      await boxes.settings.delete(settingsActiveTripIdKey);
    } else {
      await boxes.settings.put(settingsActiveTripIdKey, tripId);
    }
  }
}
