import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calculate_total_accounts_balance_use_case.g.dart';

class CalculateTotalAccountsBalanceUseCase {
  const CalculateTotalAccountsBalanceUseCase({
    required BudgetingRepository repository,
    required ConvertToHomeCurrencyUseCase convertToHomeCurrency,
  }) : _repository = repository,
       _convertToHomeCurrency = convertToHomeCurrency;

  final BudgetingRepository _repository;
  final ConvertToHomeCurrencyUseCase _convertToHomeCurrency;

  Future<Result<double, Failure>> call({
    required String tripId,
    required DateTime asOf,
  }) async {
    final tripResult = await _repository.fetchTrip(tripId: tripId);
    final Trip trip;
    switch (tripResult) {
      case Ok(value: final value):
        trip = value;
      case Err(failure: final failure):
        return Err(failure);
    }

    final accountsResult = await _repository.fetchAccounts(tripId: trip.id);
    final List<Account> accounts;
    switch (accountsResult) {
      case Ok(value: final value):
        accounts = value;
      case Err(failure: final failure):
        return Err(failure);
    }

    final transactionsResult = await _repository.fetchTransactions(
      tripId: trip.id,
    );
    final List<Transaction> transactions;
    switch (transactionsResult) {
      case Ok(value: final value):
        transactions = value;
      case Err(failure: final failure):
        return Err(failure);
    }

    final accountsById = {for (final account in accounts) account.id: account};
    final balances = {
      for (final account in accounts) account.id: account.openingBalance,
    };

    for (final transaction in transactions) {
      switch (transaction.type) {
        case TransactionType.expense:
          final sourceAccountId = transaction.sourceAccountId;
          if (sourceAccountId != null &&
              balances.containsKey(sourceAccountId)) {
            balances[sourceAccountId] =
                balances[sourceAccountId]! - transaction.accountAmount;
          }
        case TransactionType.income:
          final destAccountId = transaction.destAccountId;
          if (destAccountId != null && balances.containsKey(destAccountId)) {
            balances[destAccountId] =
                balances[destAccountId]! + transaction.accountAmount;
          }
        case TransactionType.transfer:
          final sourceAccountId = transaction.sourceAccountId;
          if (sourceAccountId != null &&
              balances.containsKey(sourceAccountId)) {
            balances[sourceAccountId] =
                balances[sourceAccountId]! - transaction.accountAmount;
          }
          final destAccountId = transaction.destAccountId;
          if (destAccountId != null && balances.containsKey(destAccountId)) {
            balances[destAccountId] =
                balances[destAccountId]! + transaction.destAmount!;
          }
      }
    }

    var total = 0.0;
    for (final entry in balances.entries) {
      final account = accountsById[entry.key]!;
      final conversionResult = await _convertToHomeCurrency(
        amount: entry.value,
        sourceCurrency: account.currency,
        homeCurrency: trip.homeCurrency,
        date: asOf,
      );
      switch (conversionResult) {
        case Ok(value: final conversion):
          total += conversion.amountHome;
        case Err(failure: final failure):
          return Err(failure);
      }
    }

    return Ok(total);
  }
}

@Riverpod(keepAlive: true)
CalculateTotalAccountsBalanceUseCase calculateTotalAccountsBalanceUseCase(
  CalculateTotalAccountsBalanceUseCaseRef ref,
) {
  return CalculateTotalAccountsBalanceUseCase(
    repository: ref.watch(budgetingRepositoryProvider),
    convertToHomeCurrency: ref.watch(convertToHomeCurrencyUseCaseProvider),
  );
}
