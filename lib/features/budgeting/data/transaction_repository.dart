import 'dart:convert';

import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/hive_budgeting_boxes.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/mappers/transaction_mapper.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';

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
  HiveTransactionRepository({required this.boxes});

  final HiveBudgetingBoxes boxes;

  Transaction _decode(String raw) =>
      transactionFromJson(jsonDecode(raw) as Map<String, dynamic>);

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
        final transaction = _decode(raw);
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
  Stream<List<Transaction>> watchTransactions({required String tripId}) async* {
    Future<List<Transaction>> read() async {
      final result = await fetchTransactions(tripId: tripId);
      return switch (result) {
        Ok(value: final value) => value,
        Err(failure: final failure) => throw failure,
      };
    }

    yield await read();
    yield* boxes.transactions.watch().asyncMap((_) => read());
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
      return Ok(_decode(raw));
    } on Object {
      await boxes.transactions.delete(transactionId);
      return const Err(NotFoundFailure());
    }
  }

  @override
  Future<Result<Transaction, Failure>> createTransaction(
    Transaction transaction,
  ) async {
    await boxes.transactions.put(
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
    for (final key in boxes.transactions.keys) {
      final raw = boxes.transactions.get(key);
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
    await boxes.transactions.deleteAll(ids);
    return const Ok(null);
  }

  @override
  Future<Result<void, Failure>> deleteTransactionsForAccount({
    required String accountId,
  }) async {
    final ids = <dynamic>[];
    for (final key in boxes.transactions.keys) {
      final raw = boxes.transactions.get(key);
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
    await boxes.transactions.deleteAll(ids);
    return const Ok(null);
  }
}
