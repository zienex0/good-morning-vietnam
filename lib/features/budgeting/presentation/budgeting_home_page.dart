import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/budgeting_home_summary.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_home_formatters.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetingHomePage extends ConsumerWidget {
  const BudgetingHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSummary = ref.watch(budgetingHomeSummaryProvider);

    return AppAsyncValueView(
      value: asyncSummary,
      onRetry: () => ref.invalidate(budgetingHomeSummaryProvider),
      data: (summary) {
        final trip = summary.trip;
        final currency = trip?.homeCurrency ?? 'USD';

        return AppSliverPage(
          title: trip?.name ?? 'Backpacker budget',
          subtitle: trip == null ? 'No active trip yet' : 'Survival dashboard',
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.pageWithinSectionGap,
                AppSpacing.page,
                AppSpacing.pageBetweenSectionGap,
              ),
              sliver: SliverList.list(
                children: [
                  if (!summary.hasActiveTrip)
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('No active trip', style: context.titleStrong),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Create or select a trip to see how long the money lasts.',
                            style: context.mutedText.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  else ...[
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatBudgetingDaysLeft(summary.daysLeft),
                            style: context.text.displayLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            formatBudgetingDaysLeftCaption(summary.daysLeft),
                            style: context.mutedText.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.pageWithinSectionGap),
                    AppCard(
                      child: Column(
                        children: [
                          AppKeyValueRow(
                            label: 'Average daily spend',
                            value: formatBudgetingMoney(
                              summary.averageDailySpend,
                              currency,
                            ),
                          ),
                          AppKeyValueRow(
                            label: 'Total spend',
                            value: formatBudgetingMoney(
                              summary.totalSpend,
                              currency,
                            ),
                          ),
                          AppKeyValueRow(
                            label: 'Total account balance',
                            value: formatBudgetingMoney(
                              summary.totalBalance,
                              currency,
                            ),
                            emphasized: true,
                          ),
                          AppKeyValueRow(
                            label: 'Current day of trip',
                            value: formatBudgetingCurrentDay(
                              summary.currentDay,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.pageBetweenSectionGap),
                    const AppSectionHeader(
                      title: 'Daily spend',
                      body: 'How much cash left the trip budget each day.',
                    ),
                    const SizedBox(height: AppSpacing.pageWithinSectionGap),
                    AppCard(
                      child: AppTrendChart(
                        points: [
                          for (final point in summary.dailySpend)
                            AppTrendPoint(date: point.date, value: point.value),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.pageBetweenSectionGap),
                    const AppSectionHeader(
                      title: 'Spend categories',
                      body: 'Where the money is actually going.',
                    ),
                    const SizedBox(height: AppSpacing.pageWithinSectionGap),
                    AppCard(
                      child: AppDonutChart(
                        values: [
                          for (final category in summary.categoryBreakdown)
                            AppChartDatum(
                              label: category.label,
                              value: category.value,
                              detail: formatBudgetingCategoryShare(
                                category.share,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.pageBetweenSectionGap),
                    const AppSectionHeader(title: 'Transactions'),
                    const SizedBox(height: AppSpacing.pageWithinSectionGap),
                    if (summary.transactionGroups.isEmpty)
                      AppCard(
                        child: Text(
                          'No transactions yet.',
                          style: context.mutedText.bodyMedium,
                        ),
                      )
                    else
                      for (final group in summary.transactionGroups) ...[
                        AppListSection(
                          header: formatFullDate(group.date),
                          children: [
                            for (final transaction in group.transactions)
                              AppTile(
                                title: formatBudgetingTransactionTitle(
                                  transaction,
                                ),
                                subtitle: formatBudgetingTransactionSubtitle(
                                  transaction,
                                  summary.accountsById,
                                ),
                                trailing: Text(
                                  formatBudgetingTransactionAmount(transaction),
                                  style: context.text.labelLarge,
                                ),
                                showChevron: false,
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
