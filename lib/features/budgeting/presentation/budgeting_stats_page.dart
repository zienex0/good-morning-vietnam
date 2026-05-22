import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_metrics_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_page_frame.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_key_value_row.dart';
import 'package:flutter_foundation_kit/shared/widgets/async_value_view.dart';
import 'package:flutter_foundation_kit/shared/widgets/section_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetingStatsPage extends ConsumerWidget {
  const BudgetingStatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripAsync = ref.watch(activeTripProvider);

    return AsyncValueView(
      value: tripAsync,
      onRetry: () => ref.invalidate(activeTripProvider),
      data: (trip) {
        final transactions =
            ref.watch(transactionsForActiveTripProvider).valueOrNull ??
            const [];
        final balance =
            ref.watch(activeTripTotalBalanceProvider).valueOrNull ?? 0;
        final totalSpend =
            ref.watch(activeTripTotalSpendProvider).valueOrNull ?? 0;
        final avgSpend =
            ref.watch(activeTripAverageDailySpendProvider).valueOrNull ?? 0;

        if (trip == null) {
          return const BudgetingPageFrame(title: 'Stats', children: []);
        }

        final expenses = transactions
            .where((transaction) => transaction.isExpense)
            .length;

        return BudgetingPageFrame(
          title: 'Stats',
          subtitle: trip.name,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppSectionHeader(title: 'totals'),
                const SizedBox(height: AppSpacing.lg),
                AppKeyValueRow(
                  label: 'total spend',
                  value: formatBudgetingHomeMoney(
                    totalSpend,
                    trip.homeCurrency,
                  ),
                ),
                AppKeyValueRow(
                  label: 'average / day',
                  value:
                      '${formatBudgetingHomeMoney(avgSpend, trip.homeCurrency)}/day',
                ),
                AppKeyValueRow(
                  label: 'remaining balance',
                  value: formatBudgetingHomeMoney(balance, trip.homeCurrency),
                ),
                AppKeyValueRow(label: 'expenses recorded', value: '$expenses'),
                AppKeyValueRow(
                  label: 'transactions total',
                  value: '${transactions.length}',
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
