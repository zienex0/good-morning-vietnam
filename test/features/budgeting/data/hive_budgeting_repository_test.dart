import 'dart:io';

import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/delete_trip_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/account_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/hive_budgeting_boxes.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/transaction_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/trip_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../application/use_cases/budgeting_use_cases_test.dart'
    show expectOk, testExpense, testTrip;

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp(
      'hive_budgeting_repository_test_',
    );
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  test(
    'DeleteTripUseCase removes the trip, accounts, transactions, and active id',
    () async {
      final boxes = await openHiveBudgetingBoxes();
      final tripRepository = HiveTripRepository(boxes: boxes);
      final accountRepository = HiveAccountRepository(boxes: boxes);
      final transactionRepository = HiveTransactionRepository(boxes: boxes);

      final trip = testTrip();
      final otherTrip = testTrip().copyWith(
        id: 'trip-2',
        name: 'Taiwan 2026',
        createdAt: DateTime(2026, 1, 2),
      );
      final cash = Account(
        id: 'cash',
        tripId: trip.id,
        name: 'Cash',
        type: AccountType.cash,
        currency: 'USD',
        openingBalance: 100,
      );
      final archived = cash.copyWith(id: 'old-cash', archived: true);
      final otherAccount = cash.copyWith(
        id: 'other-cash',
        tripId: otherTrip.id,
      );

      expectOk(await tripRepository.createTrip(trip));
      expectOk(await tripRepository.createTrip(otherTrip));
      expectOk(await accountRepository.createAccount(cash));
      expectOk(await accountRepository.createAccount(archived));
      expectOk(await accountRepository.createAccount(otherAccount));
      expectOk(
        await transactionRepository.createTransaction(
          testExpense(id: 'expense-1', sourceAccountId: cash.id),
        ),
      );
      await tripRepository.setActiveTripId(trip.id);

      expectOk(
        await DeleteTripUseCase(
          tripRepository: tripRepository,
          accountRepository: accountRepository,
          transactionRepository: transactionRepository,
        ).call(tripId: trip.id),
      );

      expect(
        await tripRepository.fetchTrip(tripId: trip.id),
        isA<Err<Trip, Failure>>(),
      );
      expectOk(await tripRepository.fetchTrip(tripId: otherTrip.id));
      expect(
        expectOk(
          await accountRepository.fetchAccounts(
            tripId: trip.id,
            includeArchived: true,
          ),
        ),
        isEmpty,
      );
      expect(
        expectOk(await accountRepository.fetchAccounts(tripId: otherTrip.id)),
        [otherAccount],
      );
      expect(
        expectOk(
          await transactionRepository.fetchTransactions(tripId: trip.id),
        ),
        isEmpty,
      );
      expect(
        await accountRepository.fetchAccountById(accountId: cash.id),
        isA<Err<Account, Failure>>(),
      );
      expect(tripRepository.getActiveTripId(), isNull);
    },
  );
}
