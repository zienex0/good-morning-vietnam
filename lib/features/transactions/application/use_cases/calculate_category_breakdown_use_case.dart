import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/categories.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';

typedef CategorySpend = ({String label, double value, double share});

/// Expense spend grouped by category for [trip], in home currency, sorted from
/// largest to smallest with each slice's share of the total.
class CalculateCategoryBreakdownUseCase {
  const CalculateCategoryBreakdownUseCase(this._convertToHomeCurrency);

  final ConvertToHomeCurrencyUseCase _convertToHomeCurrency;

  Future<Result<List<CategorySpend>>> call({
    required Trip trip,
    required List<Transaction> transactions,
  }) async {
    final categorySpend = <String, double>{};
    for (final transaction in transactions) {
      if (!transaction.isExpense) {
        continue;
      }
      final conversion = await _convertToHomeCurrency(
        amount: transaction.paidAmount,
        sourceCurrency: transaction.paidCurrency,
        homeCurrency: trip.homeCurrency,
        date: transaction.occurredAt,
      );
      switch (conversion) {
        case Ok(value: final value):
          categorySpend.update(
            transaction.categoryId ?? kBudgetingDefaultCategories.first.id,
            (current) => current + value.amountHome,
            ifAbsent: () => value.amountHome,
          );
        case Err(failure: final failure):
          return Err(failure);
      }
    }

    final total = categorySpend.values.fold<double>(
      0,
      (sum, value) => sum + value,
    );
    final breakdown = [
      for (final entry in categorySpend.entries)
        (
          label: budgetingCategoryById(entry.key).name,
          value: entry.value,
          share: total == 0 ? 0.0 : entry.value / total,
        ),
    ]..sort((a, b) => b.value.compareTo(a.value));

    return Ok(breakdown);
  }
}
