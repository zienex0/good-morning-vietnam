import 'package:flutter_foundation_kit/features/budgeting/application/budgeting_date_math.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';

typedef SpendTrendPoint = ({DateTime date, double value});

List<SpendTrendPoint> cumulativeSpendTrend({
  required Trip trip,
  required List<Transaction> transactions,
  required DateTime asOf,
}) {
  final start = budgetingDateOnly(trip.startDate);
  final end = budgetingDateOnly(asOf);
  if (end.isBefore(start)) {
    return const [];
  }

  final expensesByDay = <DateTime, double>{};
  for (final transaction in transactions) {
    if (transaction.type != TransactionType.expense) {
      continue;
    }
    // Amortized expenses contribute a per-day slice across their spread window
    // instead of one spike on the purchase day.
    final txStart = budgetingDateOnly(transaction.occurredAt);
    final perDay = transaction.amountHomePerDay;
    for (var offset = 0; offset < transaction.spreadDayCount; offset++) {
      final day = DateTime(txStart.year, txStart.month, txStart.day + offset);
      if (day.isBefore(start) || day.isAfter(end)) {
        continue;
      }
      expensesByDay.update(
        day,
        (value) => value + perDay,
        ifAbsent: () => perDay,
      );
    }
  }

  final points = <SpendTrendPoint>[];
  var cumulative = 0.0;
  final dayCount = budgetingInclusiveDayCount(start: start, end: end);
  for (var i = 0; i < dayCount; i++) {
    final day = DateTime(start.year, start.month, start.day + i);
    cumulative += expensesByDay[day] ?? 0;
    points.add((date: day, value: cumulative));
  }
  return points;
}

/// Native-currency balance for [accountId].
///
/// Source-side transactions deduct `amount` (already in source currency by
/// construction). Transfers credit the destination using the stored
/// `destAmount` (in dest currency), so cross-currency transfers settle on
/// each side at the recorded rate.
double computeAccountBalance({
  required String accountId,
  required String accountCurrency,
  required double openingBalance,
  required List<Transaction> transactions,
}) {
  var balance = openingBalance;
  for (final transaction in transactions) {
    switch (transaction.type) {
      case TransactionType.expense:
        if (transaction.sourceAccountId == accountId) {
          balance -= transaction.amount;
        }
      case TransactionType.income:
        if (transaction.destAccountId == accountId) {
          balance += transaction.amount;
        }
      case TransactionType.transfer:
        if (transaction.sourceAccountId == accountId) {
          balance -= transaction.amount;
        } else if (transaction.destAccountId == accountId) {
          balance += transaction.destAmount ?? transaction.amount;
        }
    }
  }
  return balance;
}
