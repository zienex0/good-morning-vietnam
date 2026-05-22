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

  Future<Result<double, Failure>> call({required String tripId}) async {
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

    final activeAccountIds = accounts.map((account) => account.id).toSet();
    var total = 0.0;

    for (final account in accounts) {
      final conversionResult = await _convertToHomeCurrency(
        amount: account.openingBalance,
        sourceCurrency: account.currency,
        homeCurrency: trip.homeCurrency,
        date: trip.startDate,
      );
      switch (conversionResult) {
        case Ok(value: final conversion):
          total += conversion.amountHome;
        case Err(failure: final failure):
          return Err(failure);
      }
    }

    for (final transaction in transactions) {
      switch (transaction.type) {
        case TransactionType.expense:
          if (activeAccountIds.contains(transaction.sourceAccountId)) {
            total -= transaction.amountHome;
          }
        case TransactionType.income:
          if (activeAccountIds.contains(transaction.destAccountId)) {
            total += transaction.amountHome;
          }
        case TransactionType.transfer:
          final sourceIsActive = activeAccountIds.contains(
            transaction.sourceAccountId,
          );
          final destinationIsActive = activeAccountIds.contains(
            transaction.destAccountId,
          );
          final destHome = transaction.destAmount == null ||
                  transaction.destFxRate == null
              ? transaction.amountHome
              : transaction.destAmount! * transaction.destFxRate!;
          if (sourceIsActive) {
            total -= transaction.amountHome;
          }
          if (destinationIsActive) {
            total += destHome;
          }
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
