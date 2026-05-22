import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_id_generator.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/exchange_rate_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:flutter_foundation_kit/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../application/use_cases/budgeting_use_cases_test.dart'
    show
        FakeBudgetingRepository,
        FakeExchangeRateRepository,
        FixedBudgetingIdGenerator,
        expectOk,
        testExpense,
        testTrip;

void main() {
  group('budgeting routing', () {
    testWidgets('new trip currency picker works before any trips exist', (
      tester,
    ) async {
      await pumpBudgetingApp(tester);

      await tester.tap(find.widgetWithText(FilledButton, 'Start a new trip'));
      await tester.pumpAndSettle();

      expect(find.text('New trip'), findsOneWidget);

      await tester.tap(find.text('Home currency'));
      await tester.pumpAndSettle();

      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Start a new trip'), findsNothing);

      await tester.tap(find.text('EUR').first);
      await tester.tap(find.widgetWithText(FilledButton, 'Done'));
      await tester.pumpAndSettle();

      expect(find.text('New trip'), findsOneWidget);
      expect(find.textContaining('EUR'), findsWidgets);
    });

    testWidgets('deleting the active trip lands on onboarding', (tester) async {
      final repository = await pumpBudgetingApp(
        tester,
        trips: [testTrip()],
        accounts: [cashAccount()],
        transactions: [testExpense(sourceAccountId: 'cash')],
        activeTripId: testTrip().id,
      );

      goTo(tester, AppRoutes.settings);
      await tester.pumpAndSettle();
      await tester.drag(
        find.byType(CustomScrollView).last,
        const Offset(0, -600),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(OutlinedButton, 'delete trip'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();

      expect(find.text('Start a new trip'), findsOneWidget);
      expect(find.text('Japan 2026'), findsNothing);
      expectErr(await repository.fetchTrip(tripId: testTrip().id));
      expect(
        expectOk(await repository.fetchAccounts(tripId: testTrip().id)),
        isEmpty,
      );
      expect(
        expectOk(await repository.fetchTransactions(tripId: testTrip().id)),
        isEmpty,
      );
    });

    testWidgets('settings can change trip dates without crashing', (
      tester,
    ) async {
      final repository = await pumpBudgetingApp(
        tester,
        trips: [testTrip()],
        accounts: [cashAccount()],
        activeTripId: testTrip().id,
      );

      goTo(tester, AppRoutes.settings);
      await tester.pumpAndSettle();

      await tester.tap(find.text('start date'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15').last);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('end date'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('20').last);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      final trip = expectOk(await repository.fetchTrip(tripId: testTrip().id));
      expect(trip.startDate, DateTime(2026, 5, 15));
      expect(trip.endDate, DateTime(2026, 6, 20));
    });

    testWidgets('settings can end a trip without crashing', (tester) async {
      final repository = await pumpBudgetingApp(
        tester,
        trips: [testTrip()],
        accounts: [cashAccount()],
        activeTripId: testTrip().id,
      );

      goTo(tester, AppRoutes.settings);
      await tester.pumpAndSettle();
      await tester.drag(
        find.byType(CustomScrollView).last,
        const Offset(0, -600),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(OutlinedButton, 'status: active'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ended'));
      await tester.pumpAndSettle();

      final trip = expectOk(await repository.fetchTrip(tripId: testTrip().id));
      expect(trip.status, TripStatus.ended);
    });

    testWidgets('expense add returns home with the updated balance', (
      tester,
    ) async {
      final repository = await pumpBudgetingApp(
        tester,
        trips: [testTrip()],
        accounts: [cashAccount(openingBalance: 100)],
        activeTripId: testTrip().id,
      );

      goTo(tester, AppRoutes.expense);
      await tester.pumpAndSettle();

      expect(firstTextField(tester).controller?.text, isEmpty);

      await tester.enterText(find.byType(TextField).first, '25');
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Add expense 25 USD'));
      await tester.pumpAndSettle();

      expect(find.text('Japan 2026'), findsOneWidget);
      expect(find.text('\$75'), findsOneWidget);
      final transactions = expectOk(
        await repository.fetchTransactions(tripId: testTrip().id),
      );
      expect(transactions.single.type, TransactionType.expense);
    });

    testWidgets('top up add returns home with the updated balance', (
      tester,
    ) async {
      final repository = await pumpBudgetingApp(
        tester,
        trips: [testTrip()],
        accounts: [cashAccount(openingBalance: 100)],
        activeTripId: testTrip().id,
      );

      goTo(tester, AppRoutes.topUp);
      await tester.pumpAndSettle();

      expect(firstTextField(tester).controller?.text, isEmpty);

      await tester.enterText(find.byType(TextField).first, '40');
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Add 40 USD'));
      await tester.pumpAndSettle();

      expect(find.text('Japan 2026'), findsOneWidget);
      expect(find.text('\$140'), findsOneWidget);
      final transactions = expectOk(
        await repository.fetchTransactions(tripId: testTrip().id),
      );
      expect(transactions.single.type, TransactionType.income);
    });

    testWidgets('transfer add returns home after recording the transfer', (
      tester,
    ) async {
      final repository = await pumpBudgetingApp(
        tester,
        trips: [testTrip()],
        accounts: [
          cashAccount(openingBalance: 100),
          savingsAccount(openingBalance: 50),
        ],
        activeTripId: testTrip().id,
      );

      goTo(tester, AppRoutes.transfer);
      await tester.pumpAndSettle();

      expect(firstTextField(tester).controller?.text, isEmpty);

      await tester.enterText(find.byType(TextField).first, '30');
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Transfer 30 USD'));
      await tester.pumpAndSettle();

      expect(find.text('Japan 2026'), findsOneWidget);
      expect(find.text('\$150'), findsOneWidget);
      final transactions = expectOk(
        await repository.fetchTransactions(tripId: testTrip().id),
      );
      expect(transactions.single.type, TransactionType.transfer);
    });
  });
}

Future<FakeBudgetingRepository> pumpBudgetingApp(
  WidgetTester tester, {
  List<Trip> trips = const [],
  List<Account> accounts = const [],
  List<Transaction> transactions = const [],
  String? activeTripId,
}) async {
  final repository = FakeBudgetingRepository(
    trips: trips,
    accounts: accounts,
    transactions: transactions,
  );
  await repository.setActiveTripId(activeTripId);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        budgetingRepositoryProvider.overrideWithValue(repository),
        budgetingIdGeneratorProvider.overrideWithValue(
          const FixedBudgetingIdGenerator(),
        ),
        exchangeRateRepositoryProvider.overrideWithValue(
          const FakeExchangeRateRepository(rate: 1),
        ),
      ],
      child: const MainApp(),
    ),
  );
  await tester.pumpAndSettle();
  return repository;
}

void goTo(WidgetTester tester, String route) {
  GoRouter.of(tester.element(find.byType(Scaffold).first)).go(route);
}

TextField firstTextField(WidgetTester tester) {
  return tester.widget<TextField>(find.byType(TextField).first);
}

void expectErr<T>(Result<T, Failure> result) {
  switch (result) {
    case Ok<T, Failure>():
      throw TestFailure('Expected Err, got Ok.');
    case Err<T, Failure>():
      return;
  }
}

Account cashAccount({double openingBalance = 0}) {
  return Account(
    id: 'cash',
    tripId: 'trip-1',
    name: 'Cash',
    type: AccountType.cash,
    currency: 'USD',
    openingBalance: openingBalance,
  );
}

Account savingsAccount({double openingBalance = 0}) {
  return Account(
    id: 'savings',
    tripId: 'trip-1',
    name: 'Savings',
    type: AccountType.bank,
    currency: 'USD',
    openingBalance: openingBalance,
  );
}
