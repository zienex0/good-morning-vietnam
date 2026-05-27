import 'dart:async';

import 'package:flutter_foundation_kit/core/logging/logger.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/accounts/application/trip_accounts_provider.dart';
import 'package:flutter_foundation_kit/features/transactions/application/transactions_provider.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/create_expense_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/create_top_up_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/create_transfer_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/set_account_balances_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/amortization.dart';
import 'package:flutter_foundation_kit/features/trips/application/trips_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_form_provider.g.dart';

@riverpod
class TransactionFormNotifier extends _$TransactionFormNotifier {
  @override
  FutureOr<void> build() {}

  ConvertToHomeCurrencyUseCase get _convert =>
      ConvertToHomeCurrencyUseCase(ref.read(exchangeRateRepositoryProvider));

  Future<bool> createTopUp({
    required String tripId,
    required String accountId,
    required double amount,
    String? paidCurrency,
  }) => _run(
    () =>
        CreateTopUpUseCase(
          tripRepository: ref.read(tripRepositoryProvider),
          accountRepository: ref.read(accountRepositoryProvider),
          transactionRepository: ref.read(transactionRepositoryProvider),
          convertToHomeCurrency: _convert,
          idGenerator: ref.read(transactionIdGeneratorProvider),
        ).call(
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
    () =>
        CreateExpenseUseCase(
          tripRepository: ref.read(tripRepositoryProvider),
          accountRepository: ref.read(accountRepositoryProvider),
          transactionRepository: ref.read(transactionRepositoryProvider),
          convertToHomeCurrency: _convert,
          idGenerator: ref.read(transactionIdGeneratorProvider),
        ).call(
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
    () =>
        CreateTransferUseCase(
          tripRepository: ref.read(tripRepositoryProvider),
          accountRepository: ref.read(accountRepositoryProvider),
          transactionRepository: ref.read(transactionRepositoryProvider),
          convertToHomeCurrency: _convert,
          idGenerator: ref.read(transactionIdGeneratorProvider),
        ).call(
          tripId: tripId,
          sourceAccountId: sourceAccountId,
          destAccountId: destAccountId,
          amount: amount,
          destAmount: destAmount,
          occurredAt: DateTime.now(),
        ),
    'Transfer creation failed',
  );

  Future<bool> setAccountBalances({
    required String tripId,
    required Map<String, double> balancesByAccountId,
  }) => _run(
    () =>
        SetAccountBalancesUseCase(
          tripRepository: ref.read(tripRepositoryProvider),
          accountRepository: ref.read(accountRepositoryProvider),
          transactionRepository: ref.read(transactionRepositoryProvider),
          idGenerator: ref.read(transactionIdGeneratorProvider),
        ).call(
          tripId: tripId,
          balancesByAccountId: balancesByAccountId,
          occurredAt: DateTime.now(),
        ),
    'Balance adjustment failed',
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
