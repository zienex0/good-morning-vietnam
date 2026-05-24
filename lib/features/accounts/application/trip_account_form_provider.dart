import 'dart:async';

import 'package:flutter_foundation_kit/core/logging/logger.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/accounts/application/trip_accounts_provider.dart';
import 'package:flutter_foundation_kit/features/accounts/application/use_cases/create_account_use_case.dart';
import 'package:flutter_foundation_kit/features/accounts/application/use_cases/delete_account_with_transactions_use_case.dart';
import 'package:flutter_foundation_kit/features/accounts/application/use_cases/edit_account_use_case.dart';
import 'package:flutter_foundation_kit/features/accounts/domain/account.dart';
import 'package:flutter_foundation_kit/features/transactions/application/transactions_provider.dart';
import 'package:flutter_foundation_kit/features/trips/application/trips_provider.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trip_account_form_provider.g.dart';

@riverpod
class AccountFormNotifier extends _$AccountFormNotifier {
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
          idGenerator: ref.read(accountIdGeneratorProvider),
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
