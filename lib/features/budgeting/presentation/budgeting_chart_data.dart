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
    final day = budgetingDateOnly(transaction.occurredAt);
    if (day.isBefore(start) || day.isAfter(end)) {
      continue;
    }
    expensesByDay.update(
      day,
      (value) => value + transaction.amountHome,
      ifAbsent: () => transaction.amountHome,
    );
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

/// Approximate native-currency balance for [accountId].
///
/// Source-side transactions deduct the recorded amount (which is already in
/// the source account's currency by construction in the create-* use cases).
/// Cross-currency transfers can only credit the destination using the source
/// currency value — this is a known approximation until per-side amounts land.
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
        if (transaction.destAccountId == accountId &&
            transaction.currency == accountCurrency) {
          balance += transaction.amount;
        } else if (transaction.destAccountId == accountId) {
          balance += transaction.amount;
        }
      case TransactionType.transfer:
        if (transaction.sourceAccountId == accountId) {
          balance -= transaction.amount;
        } else if (transaction.destAccountId == accountId) {
          balance += transaction.amount;
        }
    }
  }
  return balance;
}
