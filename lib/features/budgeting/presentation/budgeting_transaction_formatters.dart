import 'package:flutter_foundation_kit/features/budgeting/application/budgeting_date_math.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/categories.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/currencies.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:intl/intl.dart';

String formatBudgetingPrimaryAction({
  required String action,
  required String amount,
  required String currencyCode,
}) {
  final parsed = double.tryParse(amount);
  if (parsed == null || parsed <= 0) {
    return action;
  }
  final cleanAmount = parsed % 1 == 0
      ? parsed.toStringAsFixed(0)
      : parsed.toStringAsFixed(2);
  return '$action $cleanAmount $currencyCode';
}

String formatBudgetingAccountTitle(Account account) {
  return '${account.name} • ${account.currency}';
}

String formatBudgetingCurrencyTitle(CurrencyOption currency) {
  return '${currency.flag} ${currency.code}';
}

String formatBudgetingExchangeTitle({
  required CurrencyOption enteredCurrency,
  required Account account,
}) {
  if (enteredCurrency.code == account.currency) {
    return 'Same as ${account.currency}';
  }
  return '${enteredCurrency.code} → ${account.currency}';
}

String formatBudgetingHomeMoney(double amount, CurrencyCode homeCurrency) {
  final option = budgetingCurrencyByCode(homeCurrency);
  final fractionDigits = (amount.abs() % 1 == 0) ? 0 : 2;
  final formatted = amount.toStringAsFixed(fractionDigits);
  return '${option.symbol}$formatted';
}

String formatBudgetingNativeMoney(double amount, CurrencyCode currency) {
  final option = budgetingCurrencyByCode(currency);
  final fractionDigits = (amount.abs() % 1 == 0) ? 0 : 2;
  final formatted = amount.toStringAsFixed(fractionDigits);
  return '${option.symbol}$formatted';
}

String formatTripDayLabel(Trip trip, DateTime now) {
  final start = budgetingDateOnly(trip.startDate);
  final today = budgetingDateOnly(now);
  if (today.isBefore(start)) {
    return 'Pre-trip';
  }
  final day = budgetingInclusiveDayCount(start: start, end: today);
  return 'Day $day';
}

String formatDaysLeftHeadline(int? daysLeft) {
  if (daysLeft == null) {
    return '∞ DAYS';
  }
  return '${daysLeft.abs()} DAYS';
}

String formatDaysLeftSubtitle(int? daysLeft) {
  if (daysLeft == null) {
    return 'Track an expense to see runway.';
  }
  if (daysLeft <= 0) {
    return "you're out of runway.";
  }
  return "before you're sleeping...";
}

String formatTripDateRange(Trip trip) {
  final start = DateFormat.yMMMd().format(trip.startDate);
  if (trip.endDate == null) {
    return '$start - open ended';
  }
  return '$start - ${DateFormat.yMMMd().format(trip.endDate!)}';
}

String formatBudgetingDateForRow(DateTime date) {
  return DateFormat.yMMMd().format(date);
}

String formatTransactionRowDetail({
  required Transaction transaction,
  required Account? account,
}) {
  final dateLabel = DateFormat.MMMd().format(transaction.occurredAt);
  switch (transaction.type) {
    case TransactionType.expense:
      final category = transaction.categoryId == null
          ? null
          : budgetingCategoryById(transaction.categoryId!);
      final categoryName = category?.name ?? 'Expense';
      final accountSuffix = account == null ? '' : ' · ${account.name}';
      return '$categoryName$accountSuffix · $dateLabel';
    case TransactionType.income:
      final accountSuffix = account == null ? '' : ' · ${account.name}';
      return 'Top up$accountSuffix · $dateLabel';
    case TransactionType.transfer:
      return 'Transfer · $dateLabel';
  }
}

String formatTransactionRowTitle(Transaction transaction) {
  if (transaction.note != null && transaction.note!.trim().isNotEmpty) {
    return transaction.note!;
  }
  switch (transaction.type) {
    case TransactionType.expense:
      final category = transaction.categoryId == null
          ? null
          : budgetingCategoryById(transaction.categoryId!);
      return category?.name ?? 'Expense';
    case TransactionType.income:
      return 'Top up';
    case TransactionType.transfer:
      return 'Transfer';
  }
}

String formatTransactionRowAmount({
  required Transaction transaction,
  required CurrencyCode homeCurrency,
}) {
  final sign = switch (transaction.type) {
    TransactionType.expense => '-',
    TransactionType.income => '+',
    TransactionType.transfer => '',
  };
  return '$sign${formatBudgetingHomeMoney(transaction.amountHome, homeCurrency)}';
}
