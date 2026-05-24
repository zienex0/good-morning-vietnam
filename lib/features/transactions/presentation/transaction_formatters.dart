import 'package:flutter_foundation_kit/features/accounts/domain/account.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/amortization.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/categories.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/trips/domain/currencies.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';

typedef BudgetingTransactionDayGroup = ({
  DateTime date,
  List<Transaction> transactions,
});

enum BudgetingAmortizationSelection { none, daily, weekly, monthly, yearly }

/// Groups [transactions] by calendar day, most recent day first. Display-only
/// grouping for the transaction lists.
List<BudgetingTransactionDayGroup> groupBudgetingTransactionsByDay(
  List<Transaction> transactions,
) {
  final groups = <DateTime, List<Transaction>>{};
  for (final transaction in transactions) {
    final day = DateTime(
      transaction.occurredAt.year,
      transaction.occurredAt.month,
      transaction.occurredAt.day,
    );
    groups.update(
      day,
      (value) => [...value, transaction],
      ifAbsent: () => [transaction],
    );
  }
  return [
    for (final entry in groups.entries)
      (date: entry.key, transactions: entry.value),
  ]..sort((a, b) => b.date.compareTo(a.date));
}

String formatBudgetingMoney(
  double amount,
  CurrencyCode currency, {
  int decimalDigits = 0,
}) {
  return formatCurrency(amount, name: currency, decimalDigits: decimalDigits);
}

String formatBudgetingTransactionTitle(Transaction transaction) {
  return switch (transaction.type) {
    TransactionType.expense => budgetingCategoryById(
      transaction.categoryId ?? kBudgetingDefaultCategories.first.id,
    ).name,
    TransactionType.income => 'Top up',
    TransactionType.transfer => 'Transfer',
  };
}

String formatBudgetingTransactionSubtitle(
  Transaction transaction,
  Map<String, Account> accountsById,
) {
  final note = transaction.note?.trim();
  if (note != null && note.isNotEmpty) {
    return note;
  }

  final source = transaction.sourceAccountId == null
      ? null
      : accountsById[transaction.sourceAccountId!]?.name;
  final destination = transaction.destAccountId == null
      ? null
      : accountsById[transaction.destAccountId!]?.name;

  return switch (transaction.type) {
    TransactionType.expense => source ?? 'Expense',
    TransactionType.income => destination ?? 'Account top up',
    TransactionType.transfer =>
      '${source ?? 'Account'} to ${destination ?? 'account'}',
  };
}

String formatBudgetingTransactionAmount(Transaction transaction) {
  return switch (transaction.type) {
    TransactionType.expense =>
      '-${formatBudgetingMoney(transaction.paidAmount, transaction.paidCurrency)}',
    TransactionType.income =>
      '+${formatBudgetingMoney(transaction.paidAmount, transaction.paidCurrency)}',
    TransactionType.transfer =>
      '${formatBudgetingMoney(transaction.paidAmount, transaction.paidCurrency)}'
          ' to '
          '${formatBudgetingMoney(transaction.destAmount ?? 0, transaction.destCurrency ?? transaction.paidCurrency)}',
  };
}

String formatBudgetingAccountOption(Account account) {
  return '${account.name} · ${account.currency}';
}

String formatBudgetingCurrencyOption(CurrencyOption option) {
  return '${option.flag} ${option.code}';
}

String formatBudgetingCurrencyOptionDetail(CurrencyOption option) {
  return '${option.flag} ${option.code} - ${option.name}';
}

String formatBudgetingAmortizationSelection(
  BudgetingAmortizationSelection selection,
) {
  return switch (selection) {
    BudgetingAmortizationSelection.none => 'None',
    BudgetingAmortizationSelection.daily => 'Daily',
    BudgetingAmortizationSelection.weekly => 'Weekly',
    BudgetingAmortizationSelection.monthly => 'Monthly',
    BudgetingAmortizationSelection.yearly => 'Yearly',
  };
}

Amortization? amortizationForBudgetingSelection(
  BudgetingAmortizationSelection selection,
) {
  return switch (selection) {
    BudgetingAmortizationSelection.none => null,
    BudgetingAmortizationSelection.daily => const Amortization(
      unit: AmortizationUnit.days,
      count: 1,
    ),
    BudgetingAmortizationSelection.weekly => const Amortization(
      unit: AmortizationUnit.weeks,
      count: 1,
    ),
    BudgetingAmortizationSelection.monthly => const Amortization(
      unit: AmortizationUnit.months,
      count: 1,
    ),
    BudgetingAmortizationSelection.yearly => const Amortization(
      unit: AmortizationUnit.months,
      count: 12,
    ),
  };
}
