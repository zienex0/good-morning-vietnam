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
    return formatBudgetingTransactionSubtitleDetail(transaction, note);
  }

  final source = transaction.sourceAccountId == null
      ? null
      : accountsById[transaction.sourceAccountId!]?.name;
  final destination = transaction.destAccountId == null
      ? null
      : accountsById[transaction.destAccountId!]?.name;

  final subtitle = switch (transaction.type) {
    TransactionType.expense => source ?? 'Expense',
    TransactionType.income => destination ?? 'Account top up',
    TransactionType.transfer =>
      '${source ?? 'Account'} to ${destination ?? 'account'}',
  };
  return formatBudgetingTransactionSubtitleDetail(transaction, subtitle);
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

String formatBudgetingTransactionSubtitleDetail(
  Transaction transaction,
  String detail,
) {
  final amortization = transaction.amortization;
  if (amortization == null) {
    return detail;
  }
  return '$detail · ${formatBudgetingAmortization(amortization, transaction.occurredAt)}';
}

String formatBudgetingAmortization(
  Amortization amortization,
  DateTime occurredAt,
) {
  return 'Amortized over ${formatBudgetingDayCount(amortization.dayCountFrom(occurredAt))}';
}

String formatBudgetingDayCount(int days) {
  return days == 1 ? '1 day' : '$days days';
}

int? parseBudgetingAmortizationDaysInput(String input) {
  final value = int.tryParse(input.trim());
  if (value == null || value < 1) {
    return null;
  }
  return value;
}

Amortization? amortizationForBudgetingDayCount(int? dayCount) {
  if (dayCount == null) {
    return null;
  }
  return Amortization(unit: AmortizationUnit.days, count: dayCount);
}
