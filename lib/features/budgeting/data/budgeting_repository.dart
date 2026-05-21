import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/hive_budgeting_boxes.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/hive_budgeting_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budgeting_repository.g.dart';

abstract interface class BudgetingRepository {
  Future<Result<List<Trip>, Failure>> listTrips();

  Future<Result<Trip, Failure>> fetchTrip({required String tripId});

  Future<Result<Trip, Failure>> createTrip(Trip trip);

  Future<Result<Trip, Failure>> updateTrip(Trip trip);

  Future<Result<void, Failure>> deleteTrip({required String tripId});

  Future<Result<List<Account>, Failure>> fetchAccounts({
    required String tripId,
    bool includeArchived = false,
  });

  Future<Result<Account, Failure>> fetchAccountById({
    required String accountId,
  });

  Future<Result<Account, Failure>> createAccount(Account account);

  Future<Result<Account, Failure>> updateAccount(Account account);

  Future<Result<void, Failure>> deleteAccount({required String accountId});

  Future<Result<List<Transaction>, Failure>> fetchTransactions({
    required String tripId,
  });

  Future<Result<Transaction, Failure>> fetchTransactionById({
    required String transactionId,
  });

  Future<Result<Transaction, Failure>> createTransaction(
    Transaction transaction,
  );

  String? getActiveTripId();

  Future<void> setActiveTripId(String? tripId);
}

@Riverpod(keepAlive: true)
BudgetingRepository budgetingRepository(BudgetingRepositoryRef ref) {
  final boxes = ref.watch(hiveBudgetingBoxesProvider);
  return HiveBudgetingRepository(boxes: boxes);
}
