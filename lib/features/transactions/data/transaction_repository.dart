import 'dart:convert';

import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/transactions/data/mappers/transaction_mapper.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/transaction.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

abstract interface class TransactionRepository {
  Future<Result<List<Transaction>, Failure>> fetchTransactions({
    required String tripId,
  });

  Stream<List<Transaction>> watchTransactions({required String tripId});

  Future<Result<Transaction, Failure>> fetchTransactionById({
    required String transactionId,
  });

  Future<Result<Transaction, Failure>> createTransaction(
    Transaction transaction,
  );

  /// Removes every transaction belonging to [tripId] (delete-trip cascade).
  Future<Result<void, Failure>> deleteTransactionsForTrip({
    required String tripId,
  });

  /// Removes every transaction that touches [accountId] (delete-account
  /// cascade).
  Future<Result<void, Failure>> deleteTransactionsForAccount({
    required String accountId,
  });
}

class HiveTransactionRepository implements TransactionRepository {
  HiveTransactionRepository({required this.transactionsBox});

  final Box<String> transactionsBox;

  Transaction _decode(String raw) =>
      transactionFromJson(jsonDecode(raw) as Map<String, dynamic>);

  @override
  Future<Result<List<Transaction>, Failure>> fetchTransactions({
    required String tripId,
  }) async {
    final invalidKeys = <dynamic>[];
    final transactions = <Transaction>[];
    for (final key in transactionsBox.keys) {
      final raw = transactionsBox.get(key);
      if (raw == null) {
        continue;
      }
      try {
        final transaction = _decode(raw);
        if (transaction.tripId == tripId) {
          transactions.add(transaction);
        }
      } on Object {
        invalidKeys.add(key);
      }
    }
    if (invalidKeys.isNotEmpty) {
      await transactionsBox.deleteAll(invalidKeys);
    }
    transactions.sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    return Ok(transactions);
  }

  @override
  Stream<List<Transaction>> watchTransactions({required String tripId}) async* {
    Future<List<Transaction>> read() async {
      final result = await fetchTransactions(tripId: tripId);
      return switch (result) {
        Ok(value: final value) => value,
        Err(failure: final failure) => throw failure,
      };
    }

    yield await read();
    yield* transactionsBox.watch().asyncMap((_) => read());
  }

  @override
  Future<Result<Transaction, Failure>> fetchTransactionById({
    required String transactionId,
  }) async {
    final raw = transactionsBox.get(transactionId);
    if (raw == null) {
      return const Err(NotFoundFailure());
    }
    try {
      return Ok(_decode(raw));
    } on Object {
      await transactionsBox.delete(transactionId);
      return const Err(NotFoundFailure());
    }
  }

  @override
  Future<Result<Transaction, Failure>> createTransaction(
    Transaction transaction,
  ) async {
    await transactionsBox.put(
      transaction.id,
      jsonEncode(transactionToJson(transaction)),
    );
    return Ok(transaction);
  }

  @override
  Future<Result<void, Failure>> deleteTransactionsForTrip({
    required String tripId,
  }) async {
    final ids = <dynamic>[];
    for (final key in transactionsBox.keys) {
      final raw = transactionsBox.get(key);
      if (raw == null) {
        continue;
      }
      try {
        if (_decode(raw).tripId == tripId) {
          ids.add(key);
        }
      } on Object {
        ids.add(key);
      }
    }
    await transactionsBox.deleteAll(ids);
    return const Ok(null);
  }

  @override
  Future<Result<void, Failure>> deleteTransactionsForAccount({
    required String accountId,
  }) async {
    final ids = <dynamic>[];
    for (final key in transactionsBox.keys) {
      final raw = transactionsBox.get(key);
      if (raw == null) {
        continue;
      }
      try {
        final transaction = _decode(raw);
        if (transaction.sourceAccountId == accountId ||
            transaction.destAccountId == accountId) {
          ids.add(key);
        }
      } on Object {
        ids.add(key);
      }
    }
    await transactionsBox.deleteAll(ids);
    return const Ok(null);
  }
}
