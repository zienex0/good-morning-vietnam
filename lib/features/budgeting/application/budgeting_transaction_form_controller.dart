import 'dart:async';

import 'package:flutter_foundation_kit/core/logging/logger.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/create_expense_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/create_top_up_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/create_transfer_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budgeting_transaction_form_controller.g.dart';

@riverpod
class BudgetingTransactionFormController
    extends _$BudgetingTransactionFormController {
  @override
  FutureOr<void> build() {}

  Future<bool> createTopUp({
    required String tripId,
    required String accountId,
    required double amount,
    String? amountCurrency,
  }) async {
    state = const AsyncLoading<void>();
    final result = await ref
        .read(createTopUpUseCaseProvider)
        .call(
          tripId: tripId,
          accountId: accountId,
          amount: amount,
          amountCurrency: amountCurrency,
          occurredAt: DateTime.now(),
        );
    return handleResult(result, 'Top-up creation failed');
  }

  Future<bool> createExpense({
    required String tripId,
    required String accountId,
    required String categoryId,
    required double amount,
    String? amountCurrency,
  }) async {
    state = const AsyncLoading<void>();
    final result = await ref
        .read(createExpenseUseCaseProvider)
        .call(
          tripId: tripId,
          accountId: accountId,
          categoryId: categoryId,
          amount: amount,
          amountCurrency: amountCurrency,
          occurredAt: DateTime.now(),
        );
    return handleResult(result, 'Expense creation failed');
  }

  Future<bool> createTransfer({
    required String tripId,
    required String sourceAccountId,
    required String destAccountId,
    required double amount,
  }) async {
    state = const AsyncLoading<void>();
    final result = await ref
        .read(createTransferUseCaseProvider)
        .call(
          tripId: tripId,
          sourceAccountId: sourceAccountId,
          destAccountId: destAccountId,
          amount: amount,
          occurredAt: DateTime.now(),
        );
    return handleResult(result, 'Transfer creation failed');
  }

  bool handleResult(Result<Object?, Failure> result, String logMessage) {
    switch (result) {
      case Ok<Object?, Failure>():
        invalidateBudgetingProviders(ref);
        state = const AsyncData<void>(null);
        return true;
      case Err<Object?, Failure>(failure: final failure):
        ref.read(loggerProvider).warn(logMessage, error: failure);
        state = AsyncError<void>(failure, StackTrace.current);
        return false;
    }
  }
}
