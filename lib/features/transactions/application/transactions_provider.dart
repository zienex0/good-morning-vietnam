import 'package:flutter_foundation_kit/features/transactions/data/exchange_rate_repository.dart';
import 'package:flutter_foundation_kit/features/transactions/data/transaction_id_generator.dart';
import 'package:flutter_foundation_kit/features/transactions/data/transaction_repository.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/trips/application/active_trip_provider.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_provider.g.dart';

@Riverpod(keepAlive: true)
Box<String> transactionsBox(Ref ref) {
  throw StateError('transactionsBoxProvider must be overridden in main().');
}

@Riverpod(keepAlive: true)
TransactionRepository transactionRepository(Ref ref) {
  return HiveTransactionRepository(
    transactionsBox: ref.watch(transactionsBoxProvider),
  );
}

@Riverpod(keepAlive: true)
TransactionIdGenerator transactionIdGenerator(Ref ref) =>
    const TimestampTransactionIdGenerator();

@Riverpod(keepAlive: true)
ExchangeRateRepository exchangeRateRepository(Ref ref) =>
    const FrankfurterExchangeRateRepository();

/// Live transactions for the active trip.
@riverpod
Stream<List<Transaction>> transactions(Ref ref) {
  final id = ref.watch(activeTripIdProvider).value;
  if (id == null) {
    return Stream.value(const <Transaction>[]);
  }
  return ref.watch(transactionRepositoryProvider).watchTransactions(tripId: id);
}
