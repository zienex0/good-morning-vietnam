import 'dart:async';

import 'package:flutter_foundation_kit/core/logging/logger.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/calculate_average_daily_spend_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/calculate_category_breakdown_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/calculate_daily_spend_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/calculate_days_left_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/calculate_total_accounts_balance_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/calculate_total_spend_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/change_trip_status_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/create_account_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/create_expense_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/create_top_up_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/create_transfer_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/create_trip_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/delete_account_with_transactions_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/delete_trip_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/edit_account_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/edit_trip_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/set_active_trip_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/account_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_id_generator.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/exchange_rate_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/hive_budgeting_boxes.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/transaction_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/trip_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/amortization.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budgeting_providers.g.dart';

// ---------------------------------------------------------------------------
// Dependency injection — the only long-lived singletons in the feature.
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
HiveBudgetingBoxes hiveBudgetingBoxes(Ref ref) {
  throw StateError(
    'hiveBudgetingBoxesProvider must be overridden in main() with '
    'an instance produced by openHiveBudgetingBoxes().',
  );
}

@Riverpod(keepAlive: true)
TripRepository tripRepository(Ref ref) {
  return HiveTripRepository(boxes: ref.watch(hiveBudgetingBoxesProvider));
}

@Riverpod(keepAlive: true)
AccountRepository accountRepository(Ref ref) {
  return HiveAccountRepository(boxes: ref.watch(hiveBudgetingBoxesProvider));
}

@Riverpod(keepAlive: true)
TransactionRepository transactionRepository(Ref ref) {
  return HiveTransactionRepository(
    boxes: ref.watch(hiveBudgetingBoxesProvider),
  );
}

@Riverpod(keepAlive: true)
ExchangeRateRepository exchangeRateRepository(Ref ref) {
  return const FrankfurterExchangeRateRepository();
}

@Riverpod(keepAlive: true)
BudgetingIdGenerator budgetingIdGenerator(Ref ref) {
  return const TimestampBudgetingIdGenerator();
}

// ---------------------------------------------------------------------------
// Reactive data — straight from the repository streams, so every write fans
// out to the UI automatically. No manual invalidation anywhere.
// ---------------------------------------------------------------------------

@riverpod
Stream<String?> activeTripId(Ref ref) {
  return ref.watch(tripRepositoryProvider).watchActiveTripId();
}

@riverpod
Stream<List<Trip>> trips(Ref ref) {
  return ref.watch(tripRepositoryProvider).watchTrips();
}

@riverpod
Future<Trip?> activeTrip(Ref ref) async {
  final id = ref.watch(activeTripIdProvider).value;
  if (id == null) {
    return null;
  }
  final allTrips = await ref.watch(tripsProvider.future);
  for (final trip in allTrips) {
    if (trip.id == id) {
      return trip;
    }
  }
  return null;
}

@riverpod
Stream<List<Account>> accounts(Ref ref) {
  final id = ref.watch(activeTripIdProvider).value;
  if (id == null) {
    return Stream.value(const <Account>[]);
  }
  return ref.watch(accountRepositoryProvider).watchAccounts(tripId: id);
}

@riverpod
Stream<List<Transaction>> transactions(Ref ref) {
  final id = ref.watch(activeTripIdProvider).value;
  if (id == null) {
    return Stream.value(const <Transaction>[]);
  }
  return ref.watch(transactionRepositoryProvider).watchTransactions(tripId: id);
}

// ---------------------------------------------------------------------------
// Per-screen views — assembled from use cases into plain records (no summary
// classes). Each recomputes when the data above changes.
// ---------------------------------------------------------------------------

typedef BudgetingHomeView = ({
  Trip trip,
  int? daysLeft,
  double averageDailySpend,
  double totalSpend,
  double totalBalance,
  int currentDay,
  List<DailySpendPoint> dailySpend,
  List<CategorySpend> categoryBreakdown,
  Map<String, Account> accountsById,
  List<Transaction> transactions,
});

typedef BudgetingAccountView = ({
  Account account,
  double localBalance,
  double homeBalance,
});

typedef BudgetingAccountsView = ({
  Trip trip,
  List<BudgetingAccountView> accounts,
});

typedef BudgetingAccountDetailView = ({
  Trip trip,
  BudgetingAccountView account,
  List<Transaction> transactions,
});

@riverpod
Future<BudgetingHomeView?> budgetingHomeView(Ref ref) async {
  final trip = await ref.watch(activeTripProvider.future);
  if (trip == null) {
    return null;
  }
  final accounts = await ref.watch(accountsProvider.future);
  final transactions = await ref.watch(transactionsProvider.future);
  final convert = _convertUseCase(ref);
  final asOf = DateTime.now();

  final balanceUseCase = CalculateTotalAccountsBalanceUseCase(convert);
  final averageUseCase = CalculateAverageDailySpendUseCase(convert);

  final totalBalance = _orThrow(
    await balanceUseCase(
      trip: trip,
      accounts: accounts,
      transactions: transactions,
      asOf: asOf,
    ),
  );
  final totalSpend = _orThrow(
    await CalculateTotalSpendUseCase(convert)(
      trip: trip,
      transactions: transactions,
    ),
  );
  final averageDailySpend = _orThrow(
    await averageUseCase(trip: trip, transactions: transactions, asOf: asOf),
  );
  final daysLeft = _orThrow(
    await CalculateDaysLeftUseCase(
      calculateAverageDailySpend: averageUseCase,
      calculateTotalAccountsBalance: balanceUseCase,
    )(trip: trip, accounts: accounts, transactions: transactions, asOf: asOf),
  );
  final dailySpend = _orThrow(
    await CalculateDailySpendUseCase(convert)(
      trip: trip,
      transactions: transactions,
      asOf: asOf,
    ),
  );
  final categoryBreakdown = _orThrow(
    await CalculateCategoryBreakdownUseCase(convert)(
      trip: trip,
      transactions: transactions,
    ),
  );

  return (
    trip: trip,
    daysLeft: daysLeft,
    averageDailySpend: averageDailySpend,
    totalSpend: totalSpend,
    totalBalance: totalBalance,
    currentDay: trip.dayOfTrip(asOf),
    dailySpend: dailySpend,
    categoryBreakdown: categoryBreakdown,
    accountsById: {for (final account in accounts) account.id: account},
    transactions: transactions,
  );
}

@riverpod
Future<BudgetingAccountsView?> budgetingAccountsView(Ref ref) async {
  final trip = await ref.watch(activeTripProvider.future);
  if (trip == null) {
    return null;
  }
  final accounts = await ref.watch(accountsProvider.future);
  final transactions = await ref.watch(transactionsProvider.future);
  final convert = _convertUseCase(ref);
  final asOf = DateTime.now();

  final views = <BudgetingAccountView>[];
  for (final account in accounts) {
    final localBalance = account.balanceFrom(transactions);
    final conversion = _orThrow(
      await convert(
        amount: localBalance,
        sourceCurrency: account.currency,
        homeCurrency: trip.homeCurrency,
        date: asOf,
      ),
    );
    views.add((
      account: account,
      localBalance: localBalance,
      homeBalance: conversion.amountHome,
    ));
  }
  views.sort((a, b) => b.homeBalance.compareTo(a.homeBalance));

  return (trip: trip, accounts: views);
}

@riverpod
Future<BudgetingAccountDetailView?> budgetingAccountDetailView(
  Ref ref,
  String accountId,
) async {
  final accountsView = await ref.watch(budgetingAccountsViewProvider.future);
  if (accountsView == null) {
    return null;
  }
  final transactions = await ref.watch(transactionsProvider.future);

  BudgetingAccountView? match;
  for (final view in accountsView.accounts) {
    if (view.account.id == accountId) {
      match = view;
      break;
    }
  }
  if (match == null) {
    return null;
  }

  final accountTransactions = transactions
      .where(
        (transaction) =>
            transaction.sourceAccountId == accountId ||
            transaction.destAccountId == accountId,
      )
      .toList();

  return (
    trip: accountsView.trip,
    account: match,
    transactions: accountTransactions,
  );
}

// ---------------------------------------------------------------------------
// Mutations — one notifier per aggregate, each with isolated loading/error.
// Writes go through the repository streams, so no invalidation is needed.
// ---------------------------------------------------------------------------

@riverpod
class BudgetingTripNotifier extends _$BudgetingTripNotifier {
  @override
  FutureOr<void> build() {}

  Future<Trip?> createTrip({
    required String name,
    required CurrencyCode homeCurrency,
    required DateTime startDate,
    DateTime? endDate,
    double? budgetTotal,
  }) async {
    state = const AsyncLoading<void>();
    final result =
        await CreateTripUseCase(
          repository: ref.read(tripRepositoryProvider),
          idGenerator: ref.read(budgetingIdGeneratorProvider),
        ).call(
          name: name,
          homeCurrency: homeCurrency,
          startDate: startDate,
          endDate: endDate,
          budgetTotal: budgetTotal,
          status: TripStatus.active,
        );
    switch (result) {
      case Ok(value: final trip):
        final activate = await SetActiveTripUseCase(
          ref.read(tripRepositoryProvider),
        ).call(trip.id);
        switch (activate) {
          case Ok():
            state = const AsyncData<void>(null);
            return trip;
          case Err(failure: final failure):
            _fail(failure, 'Could not activate created trip');
            return null;
        }
      case Err(failure: final failure):
        _fail(failure, 'Trip creation failed');
        return null;
    }
  }

  Future<bool> editTrip(Trip trip) => _run(
    () => EditTripUseCase(ref.read(tripRepositoryProvider)).call(trip),
    'Trip edit failed',
  );

  Future<bool> changeStatus({
    required String tripId,
    required TripStatus status,
  }) => _run(
    () => ChangeTripStatusUseCase(
      ref.read(tripRepositoryProvider),
    ).call(tripId: tripId, newStatus: status),
    'Trip status change failed',
  );

  Future<bool> deleteTrip({required String tripId}) => _run(
    () => DeleteTripUseCase(
      tripRepository: ref.read(tripRepositoryProvider),
      accountRepository: ref.read(accountRepositoryProvider),
      transactionRepository: ref.read(transactionRepositoryProvider),
    ).call(tripId: tripId),
    'Trip delete failed',
  );

  Future<bool> activateTrip(String tripId) => _run(
    () => SetActiveTripUseCase(ref.read(tripRepositoryProvider)).call(tripId),
    'Trip activation failed',
  );

  Future<bool> _run(
    Future<Result<Object?, Failure>> Function() action,
    String message,
  ) async {
    state = const AsyncLoading<void>();
    final result = await action();
    switch (result) {
      case Ok():
        state = const AsyncData<void>(null);
        return true;
      case Err(failure: final failure):
        _fail(failure, message);
        return false;
    }
  }

  void _fail(Failure failure, String message) {
    ref.read(loggerProvider).warn(message, error: failure);
    state = AsyncError<void>(failure, StackTrace.current);
  }
}

@riverpod
class BudgetingAccountNotifier extends _$BudgetingAccountNotifier {
  @override
  FutureOr<void> build() {}

  Future<Account?> createAccount({
    required String tripId,
    required String name,
    required CurrencyCode currency,
    required double openingBalance,
    AccountType type = AccountType.cash,
  }) async {
    state = const AsyncLoading<void>();
    final result =
        await CreateAccountUseCase(
          accountRepository: ref.read(accountRepositoryProvider),
          tripRepository: ref.read(tripRepositoryProvider),
          idGenerator: ref.read(budgetingIdGeneratorProvider),
        ).call(
          tripId: tripId,
          name: name,
          type: type,
          currency: currency,
          openingBalance: openingBalance,
        );
    switch (result) {
      case Ok(value: final account):
        state = const AsyncData<void>(null);
        return account;
      case Err(failure: final failure):
        _fail(failure, 'Account creation failed');
        return null;
    }
  }

  Future<bool> editAccount({required String accountId, required String name}) =>
      _run(
        () => EditAccountUseCase(
          ref.read(accountRepositoryProvider),
        ).call(accountId: accountId, name: name),
        'Account edit failed',
      );

  Future<bool> deleteAccountWithTransactions({required String accountId}) =>
      _run(
        () => DeleteAccountWithTransactionsUseCase(
          accountRepository: ref.read(accountRepositoryProvider),
          transactionRepository: ref.read(transactionRepositoryProvider),
        ).call(accountId: accountId),
        'Account delete failed',
      );

  Future<bool> _run(
    Future<Result<Object?, Failure>> Function() action,
    String message,
  ) async {
    state = const AsyncLoading<void>();
    final result = await action();
    switch (result) {
      case Ok():
        state = const AsyncData<void>(null);
        return true;
      case Err(failure: final failure):
        _fail(failure, message);
        return false;
    }
  }

  void _fail(Failure failure, String message) {
    ref.read(loggerProvider).warn(message, error: failure);
    state = AsyncError<void>(failure, StackTrace.current);
  }
}

@riverpod
class BudgetingTransactionNotifier extends _$BudgetingTransactionNotifier {
  @override
  FutureOr<void> build() {}

  CreateExpenseUseCase get _createExpense => CreateExpenseUseCase(
    tripRepository: ref.read(tripRepositoryProvider),
    accountRepository: ref.read(accountRepositoryProvider),
    transactionRepository: ref.read(transactionRepositoryProvider),
    convertToHomeCurrency: _convertUseCase(ref),
    idGenerator: ref.read(budgetingIdGeneratorProvider),
  );

  CreateTransferUseCase get _createTransfer => CreateTransferUseCase(
    tripRepository: ref.read(tripRepositoryProvider),
    accountRepository: ref.read(accountRepositoryProvider),
    transactionRepository: ref.read(transactionRepositoryProvider),
    convertToHomeCurrency: _convertUseCase(ref),
    idGenerator: ref.read(budgetingIdGeneratorProvider),
  );

  CreateTopUpUseCase get _createTopUp => CreateTopUpUseCase(
    tripRepository: ref.read(tripRepositoryProvider),
    accountRepository: ref.read(accountRepositoryProvider),
    transactionRepository: ref.read(transactionRepositoryProvider),
    convertToHomeCurrency: _convertUseCase(ref),
    idGenerator: ref.read(budgetingIdGeneratorProvider),
  );

  Future<bool> createTopUp({
    required String tripId,
    required String accountId,
    required double amount,
    String? paidCurrency,
  }) => _run(
    () => _createTopUp.call(
      tripId: tripId,
      accountId: accountId,
      amount: amount,
      paidCurrency: paidCurrency,
      occurredAt: DateTime.now(),
    ),
    'Top-up creation failed',
  );

  Future<bool> createExpense({
    required String tripId,
    required String accountId,
    required String categoryId,
    required double amount,
    String? paidCurrency,
    Amortization? amortization,
  }) => _run(
    () => _createExpense.call(
      tripId: tripId,
      accountId: accountId,
      categoryId: categoryId,
      amount: amount,
      paidCurrency: paidCurrency,
      amortization: amortization,
      occurredAt: DateTime.now(),
    ),
    'Expense creation failed',
  );

  Future<bool> createTransfer({
    required String tripId,
    required String sourceAccountId,
    required String destAccountId,
    required double amount,
    double? destAmount,
  }) => _run(
    () => _createTransfer.call(
      tripId: tripId,
      sourceAccountId: sourceAccountId,
      destAccountId: destAccountId,
      amount: amount,
      destAmount: destAmount,
      occurredAt: DateTime.now(),
    ),
    'Transfer creation failed',
  );

  Future<bool> _run(
    Future<Result<Object?, Failure>> Function() action,
    String message,
  ) async {
    state = const AsyncLoading<void>();
    final result = await action();
    switch (result) {
      case Ok():
        state = const AsyncData<void>(null);
        return true;
      case Err(failure: final failure):
        _fail(failure, message);
        return false;
    }
  }

  void _fail(Failure failure, String message) {
    ref.read(loggerProvider).warn(message, error: failure);
    state = AsyncError<void>(failure, StackTrace.current);
  }
}

ConvertToHomeCurrencyUseCase _convertUseCase(Ref ref) {
  return ConvertToHomeCurrencyUseCase(
    ref.watch(exchangeRateRepositoryProvider),
  );
}

T _orThrow<T>(Result<T, Failure> result) {
  return switch (result) {
    Ok(value: final value) => value,
    Err(failure: final failure) => throw failure,
  };
}
