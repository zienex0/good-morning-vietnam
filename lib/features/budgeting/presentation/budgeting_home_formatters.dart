import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/categories.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';

typedef BudgetingTransactionDayGroup = ({
  DateTime date,
  List<Transaction> transactions,
});

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

String formatBudgetingDaysLeft(int? daysLeft) {
  if (daysLeft == null) {
    return '--';
  }
  return daysLeft.toString();
}

String formatBudgetingDaysLeftCaption(int? daysLeft) {
  if (daysLeft == null) {
    return 'days left at the current spend rate';
  }
  if (daysLeft == 0) {
    return 'days left before tent mode';
  }
  if (daysLeft == 1) {
    return 'day left before tent mode';
  }
  return 'days left before tent mode';
}

String formatBudgetingCurrentDay(int currentDay) {
  if (currentDay <= 0) {
    return 'Not started';
  }
  return 'Day $currentDay';
}

String formatBudgetingCategoryShare(double share) {
  return formatPercent(share);
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
