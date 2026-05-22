import 'dart:io';

import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/hive_budgeting_boxes.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/hive_budgeting_repository.dart';
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
    'deleteTrip removes the trip, accounts, transactions, and active id',
    () async {
      final boxes = await openHiveBudgetingBoxes();
      final repository = HiveBudgetingRepository(boxes: boxes);
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

      expectOk(await repository.createTrip(trip));
      expectOk(await repository.createTrip(otherTrip));
      expectOk(await repository.createAccount(cash));
      expectOk(await repository.createAccount(archived));
      expectOk(await repository.createAccount(otherAccount));
      expectOk(
        await repository.createTransaction(
          testExpense(id: 'expense-1', sourceAccountId: cash.id),
        ),
      );
      await repository.setActiveTripId(trip.id);

      expectOk(await repository.deleteTrip(tripId: trip.id));

      expect(
        await repository.fetchTrip(tripId: trip.id),
        isA<Err<Trip, Failure>>(),
      );
      expectOk(await repository.fetchTrip(tripId: otherTrip.id));
      expect(
        expectOk(
          await repository.fetchAccounts(
            tripId: trip.id,
            includeArchived: true,
          ),
        ),
        isEmpty,
      );
      expect(expectOk(await repository.fetchAccounts(tripId: otherTrip.id)), [
        otherAccount,
      ]);
      expect(
        expectOk(await repository.fetchTransactions(tripId: trip.id)),
        isEmpty,
      );
      expect(
        await repository.fetchAccountById(accountId: cash.id),
        isA<Err<Account, Failure>>(),
      );
      expect(repository.getActiveTripId(), isNull);
    },
  );
}
