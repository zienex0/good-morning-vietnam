import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetingAccountsSummaryProvider =
    FutureProvider.autoDispose<BudgetingAccountsSummary>((ref) async {
      final trip = await ref.watch(activeTripProvider.future);
      if (trip == null) {
        return const BudgetingAccountsSummary.empty();
      }

      final accounts = await ref.watch(accountsForActiveTripProvider.future);
      final transactions = await ref.watch(
        transactionsForActiveTripProvider.future,
      );
      final convertToHomeCurrency = ref.watch(
        convertToHomeCurrencyUseCaseProvider,
      );
      final accountSummaries = <BudgetingAccountSummary>[];

      for (final account in accounts) {
        final localBalance = account.balanceFrom(transactions);
        final conversion = await convertToHomeCurrency(
          amount: localBalance,
          sourceCurrency: account.currency,
          homeCurrency: trip.homeCurrency,
          date: DateTime.now(),
        );
        switch (conversion) {
          case Ok(value: final value):
            accountSummaries.add(
              BudgetingAccountSummary(
                account: account,
                localBalance: localBalance,
                homeBalance: value.amountHome,
              ),
            );
          case Err(failure: final failure):
            throw failure;
        }
      }

      accountSummaries.sort((a, b) => b.homeBalance.compareTo(a.homeBalance));

      return BudgetingAccountsSummary(trip: trip, accounts: accountSummaries);
    });

final budgetingAccountDetailSummaryProvider = FutureProvider.autoDispose
    .family<BudgetingAccountDetailSummary, String>((ref, accountId) async {
      final summary = await ref.watch(budgetingAccountsSummaryProvider.future);
      final transactions = await ref.watch(
        transactionsForActiveTripProvider.future,
      );

      BudgetingAccountSummary? accountSummary;
      for (final account in summary.accounts) {
        if (account.account.id == accountId) {
          accountSummary = account;
          break;
        }
      }

      if (summary.trip == null || accountSummary == null) {
        return const BudgetingAccountDetailSummary.empty();
      }

      final accountTransactions =
          transactions
              .where(
                (transaction) =>
                    transaction.sourceAccountId == accountId ||
                    transaction.destAccountId == accountId,
              )
              .toList()
            ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));

      final transactionGroups = <DateTime, List<Transaction>>{};
      for (final transaction in accountTransactions) {
        final day = DateTime(
          transaction.occurredAt.year,
          transaction.occurredAt.month,
          transaction.occurredAt.day,
        );
        transactionGroups.update(
          day,
          (value) => [...value, transaction],
          ifAbsent: () => [transaction],
        );
      }

      final groupedTransactions = [
        for (final entry in transactionGroups.entries)
          BudgetingAccountTransactionGroup(
            date: entry.key,
            transactions: entry.value,
          ),
      ]..sort((a, b) => b.date.compareTo(a.date));

      return BudgetingAccountDetailSummary(
        trip: summary.trip,
        account: accountSummary,
        transactionGroups: groupedTransactions,
      );
    });

class BudgetingAccountsSummary {
  const BudgetingAccountsSummary({required this.trip, required this.accounts});

  const BudgetingAccountsSummary.empty() : trip = null, accounts = const [];

  final Trip? trip;
  final List<BudgetingAccountSummary> accounts;
}

class BudgetingAccountSummary {
  const BudgetingAccountSummary({
    required this.account,
    required this.localBalance,
    required this.homeBalance,
  });

  final Account account;
  final double localBalance;
  final double homeBalance;
}

class BudgetingAccountDetailSummary {
  const BudgetingAccountDetailSummary({
    required this.trip,
    required this.account,
    required this.transactionGroups,
  });

  const BudgetingAccountDetailSummary.empty()
    : trip = null,
      account = null,
      transactionGroups = const [];

  final Trip? trip;
  final BudgetingAccountSummary? account;
  final List<BudgetingAccountTransactionGroup> transactionGroups;
}

class BudgetingAccountTransactionGroup {
  const BudgetingAccountTransactionGroup({
    required this.date,
    required this.transactions,
  });

  final DateTime date;
  final List<Transaction> transactions;
}

extension on Account {
  double balanceFrom(List<Transaction> transactions) {
    var balance = openingBalance;
    for (final transaction in transactions) {
      switch (transaction.type) {
        case TransactionType.expense:
          if (transaction.sourceAccountId == id) {
            balance -= transaction.accountAmount;
          }
        case TransactionType.income:
          if (transaction.destAccountId == id) {
            balance += transaction.accountAmount;
          }
        case TransactionType.transfer:
          if (transaction.sourceAccountId == id) {
            balance -= transaction.accountAmount;
          }
          if (transaction.destAccountId == id) {
            balance += transaction.destAmount ?? 0;
          }
      }
    }
    return balance;
  }
}
