import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_metrics_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/budgeting_date_math.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/categories.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetingHomeSummaryProvider =
    FutureProvider.autoDispose<BudgetingHomeSummary>((ref) async {
      final trip = await ref.watch(activeTripProvider.future);
      if (trip == null) {
        return const BudgetingHomeSummary.empty();
      }

      final asOf = DateTime.now();
      final transactions = await ref.watch(
        transactionsForActiveTripProvider.future,
      );
      final accounts = await ref.watch(accountsForActiveTripProvider.future);
      final totalBalance = await ref.watch(
        activeTripTotalBalanceProvider.future,
      );
      final totalSpend = await ref.watch(activeTripTotalSpendProvider.future);
      final averageDailySpend = await ref.watch(
        activeTripAverageDailySpendProvider.future,
      );
      final daysLeft = await ref.watch(activeTripDaysLeftProvider.future);
      final convertToHomeCurrency = ref.watch(
        convertToHomeCurrencyUseCaseProvider,
      );
      final dailySpend = <DateTime, double>{};
      final categorySpend = <String, double>{};
      final tripStart = budgetingDateOnly(trip.startDate);
      final today = budgetingDateOnly(asOf);

      for (final transaction in transactions) {
        if (!transaction.isExpense) {
          continue;
        }

        final categoryConversion = await convertToHomeCurrency(
          amount: transaction.paidAmount,
          sourceCurrency: transaction.paidCurrency,
          homeCurrency: trip.homeCurrency,
          date: transaction.occurredAt,
        );
        switch (categoryConversion) {
          case Ok(value: final conversion):
            categorySpend.update(
              transaction.categoryId ?? kBudgetingDefaultCategories.first.id,
              (value) => value + conversion.amountHome,
              ifAbsent: () => conversion.amountHome,
            );
          case Err(failure: final failure):
            throw failure;
        }

        final dailyConversion = await convertToHomeCurrency(
          amount: transaction.paidAmountPerDay,
          sourceCurrency: transaction.paidCurrency,
          homeCurrency: trip.homeCurrency,
          date: transaction.occurredAt,
        );
        final double dailyAmountHome;
        switch (dailyConversion) {
          case Ok(value: final conversion):
            dailyAmountHome = conversion.amountHome;
          case Err(failure: final failure):
            throw failure;
        }

        final transactionDay = budgetingDateOnly(transaction.occurredAt);
        for (var offset = 0; offset < transaction.spreadDayCount; offset++) {
          final day = DateTime(
            transactionDay.year,
            transactionDay.month,
            transactionDay.day + offset,
          );
          if (day.isBefore(tripStart) || day.isAfter(today)) {
            continue;
          }
          dailySpend.update(
            day,
            (value) => value + dailyAmountHome,
            ifAbsent: () => dailyAmountHome,
          );
        }
      }

      final dailyPoints = <BudgetingDailySpendPoint>[];
      if (!today.isBefore(tripStart)) {
        final dayCount = budgetingInclusiveDayCount(
          start: tripStart,
          end: today,
        );
        for (var index = 0; index < dayCount; index++) {
          final day = DateTime(
            tripStart.year,
            tripStart.month,
            tripStart.day + index,
          );
          dailyPoints.add(
            BudgetingDailySpendPoint(date: day, value: dailySpend[day] ?? 0),
          );
        }
      }

      final categoryTotal = categorySpend.values.fold<double>(
        0,
        (sum, value) => sum + value,
      );
      final categoryBreakdown = [
        for (final entry in categorySpend.entries)
          BudgetingCategorySpend(
            label: budgetingCategoryById(entry.key).name,
            value: entry.value,
            share: categoryTotal == 0 ? 0 : entry.value / categoryTotal,
          ),
      ]..sort((a, b) => b.value.compareTo(a.value));

      final transactionGroups = <DateTime, List<Transaction>>{};
      for (final transaction in transactions) {
        final day = budgetingDateOnly(transaction.occurredAt);
        transactionGroups.update(
          day,
          (value) => [...value, transaction],
          ifAbsent: () => [transaction],
        );
      }
      final groupedTransactions = [
        for (final entry in transactionGroups.entries)
          BudgetingTransactionGroup(date: entry.key, transactions: entry.value),
      ]..sort((a, b) => b.date.compareTo(a.date));

      final currentDay = today.isBefore(tripStart)
          ? 0
          : budgetingInclusiveDayCount(start: tripStart, end: today);

      return BudgetingHomeSummary(
        trip: trip,
        accountsById: {for (final account in accounts) account.id: account},
        daysLeft: daysLeft,
        averageDailySpend: averageDailySpend,
        totalSpend: totalSpend,
        totalBalance: totalBalance,
        currentDay: currentDay,
        dailySpend: dailyPoints,
        categoryBreakdown: categoryBreakdown,
        transactionGroups: groupedTransactions,
      );
    });

class BudgetingHomeSummary {
  const BudgetingHomeSummary({
    required this.trip,
    required this.accountsById,
    required this.daysLeft,
    required this.averageDailySpend,
    required this.totalSpend,
    required this.totalBalance,
    required this.currentDay,
    required this.dailySpend,
    required this.categoryBreakdown,
    required this.transactionGroups,
  });

  const BudgetingHomeSummary.empty()
    : trip = null,
      accountsById = const {},
      daysLeft = null,
      averageDailySpend = 0,
      totalSpend = 0,
      totalBalance = 0,
      currentDay = 0,
      dailySpend = const [],
      categoryBreakdown = const [],
      transactionGroups = const [];

  final Trip? trip;
  final Map<String, Account> accountsById;
  final int? daysLeft;
  final double averageDailySpend;
  final double totalSpend;
  final double totalBalance;
  final int currentDay;
  final List<BudgetingDailySpendPoint> dailySpend;
  final List<BudgetingCategorySpend> categoryBreakdown;
  final List<BudgetingTransactionGroup> transactionGroups;

  bool get hasActiveTrip => trip != null;
}

class BudgetingDailySpendPoint {
  const BudgetingDailySpendPoint({required this.date, required this.value});

  final DateTime date;
  final double value;
}

class BudgetingCategorySpend {
  const BudgetingCategorySpend({
    required this.label,
    required this.value,
    required this.share,
  });

  final String label;
  final double value;
  final double share;
}

class BudgetingTransactionGroup {
  const BudgetingTransactionGroup({
    required this.date,
    required this.transactions,
  });

  final DateTime date;
  final List<Transaction> transactions;
}
