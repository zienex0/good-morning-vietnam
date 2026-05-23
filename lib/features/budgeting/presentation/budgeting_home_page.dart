import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/budgeting_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_home_formatters.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetingHomePage extends ConsumerWidget {
  const BudgetingHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncView = ref.watch(budgetingHomeViewProvider);

    return AppAsyncValueView(
      value: asyncView,
      onRetry: () => ref.invalidate(budgetingHomeViewProvider),
      data: (view) {
        if (view == null) {
          return AppSliverPage(
            title: 'Backpacker budget',
            subtitle: 'No active trip yet',
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
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        final trip = view.trip;
        final currency = trip.homeCurrency;
        final transactionGroups = groupBudgetingTransactionsByDay(
          view.transactions,
        );

        return AppSliverPage(
          title: trip.name,
          subtitle: 'Survival dashboard',
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
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatBudgetingDaysLeft(view.daysLeft),
                          style: context.text.displayLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          formatBudgetingDaysLeftCaption(view.daysLeft),
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
                            view.averageDailySpend,
                            currency,
                          ),
                        ),
                        AppKeyValueRow(
                          label: 'Total spend',
                          value: formatBudgetingMoney(
                            view.totalSpend,
                            currency,
                          ),
                        ),
                        AppKeyValueRow(
                          label: 'Total account balance',
                          value: formatBudgetingMoney(
                            view.totalBalance,
                            currency,
                          ),
                          emphasized: true,
                        ),
                        AppKeyValueRow(
                          label: 'Current day of trip',
                          value: formatBudgetingCurrentDay(view.currentDay),
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
                        for (final point in view.dailySpend)
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
                        for (final category in view.categoryBreakdown)
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
                  if (transactionGroups.isEmpty)
                    AppCard(
                      child: Text(
                        'No transactions yet.',
                        style: context.mutedText.bodyMedium,
                      ),
                    )
                  else
                    for (final group in transactionGroups) ...[
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
                                view.accountsById,
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
              ),
            ),
          ],
        );
      },
    );
  }
}
