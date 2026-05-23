import 'package:flutter_foundation_kit/core/logging/logger.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/create_account_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/delete_account_with_transactions_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/edit_account_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budgeting_account_controller.g.dart';

@riverpod
class BudgetingAccountController extends _$BudgetingAccountController {
  @override
  AsyncValue<void> build() => const AsyncData<void>(null);

  Future<Account?> createAccount({
    required String tripId,
    required String name,
    required CurrencyCode currency,
    required double openingBalance,
  }) async {
    state = const AsyncLoading<void>();
    final result = await ref
        .read(createAccountUseCaseProvider)
        .call(
          tripId: tripId,
          name: name,
          type: AccountType.cash,
          currency: currency,
          openingBalance: openingBalance,
        );
    switch (result) {
      case Ok(value: final account):
        invalidateBudgetingProviders(ref);
        state = const AsyncData<void>(null);
        return account;
      case Err(failure: final failure):
        ref
            .read(loggerProvider)
            .warn('Account creation failed', error: failure);
        state = AsyncError<void>(failure, StackTrace.current);
        return null;
    }
  }

  Future<bool> editAccount({
    required String accountId,
    required String name,
  }) async {
    state = const AsyncLoading<void>();
    final result = await ref
        .read(editAccountUseCaseProvider)
        .call(accountId: accountId, name: name);
    return _handle(result, 'Account edit failed');
  }

  Future<bool> deleteAccountWithTransactions({
    required String accountId,
  }) async {
    state = const AsyncLoading<void>();
    final result = await ref
        .read(deleteAccountWithTransactionsUseCaseProvider)
        .call(accountId: accountId);
    return _handle(result, 'Account delete failed');
  }

  bool _handle(Result<Object?, Failure> result, String logMessage) {
    switch (result) {
      case Ok():
        invalidateBudgetingProviders(ref);
        state = const AsyncData<void>(null);
        return true;
      case Err(failure: final failure):
        ref.read(loggerProvider).warn(logMessage, error: failure);
        state = AsyncError<void>(failure, StackTrace.current);
        return false;
    }
  }
}
