import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/accounts/application/accounts_total_balance_provider.dart';
import 'package:flutter_foundation_kit/features/accounts/application/trip_accounts_provider.dart';
import 'package:flutter_foundation_kit/features/accounts/domain/account.dart';
import 'package:flutter_foundation_kit/features/transactions/application/transactions_provider.dart';
import 'package:flutter_foundation_kit/features/transactions/application/trip_spend_provider.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/calculate_category_breakdown_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/calculate_daily_spend_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/trips/application/active_trip_provider.dart';
import 'package:flutter_foundation_kit/features/trips/application/trip_days_left_provider.dart';
import 'package:flutter_foundation_kit/features/trips/presentation/trip_dashboard_formatters.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Survival dashboard for the active trip. It owns no providers of its own —
/// it composes the data each feature already exposes.
class TripDashboardPage extends ConsumerWidget {
  const TripDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripAsync = ref.watch(activeTripProvider);
    final accountsAsync = ref.watch(accountsProvider);
    final transactionsAsync = ref.watch(transactionsProvider);
    final totalBalanceAsync = ref.watch(accountsTotalBalanceProvider);
    final totalSpendAsync = ref.watch(totalSpendProvider);
    final averageDailyAsync = ref.watch(averageDailySpendProvider);
    final daysLeftAsync = ref.watch(tripDaysLeftProvider);
    final dailySpendAsync = ref.watch(dailySpendProvider);
    final categoryAsync = ref.watch(categoryBreakdownProvider);

    return AppAsyncValueView(
      value: tripAsync,
      onRetry: () => ref.invalidate(activeTripProvider),
      data: (trip) {
        if (trip == null) {
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

        final currency = trip.homeCurrency;
        final accounts = accountsAsync.value ?? const <Account>[];
        final transactions = transactionsAsync.value ?? const <Transaction>[];
        final totalBalance = totalBalanceAsync.value ?? 0;
        final totalSpend = totalSpendAsync.value ?? 0;
        final averageDailySpend = averageDailyAsync.value ?? 0;
        final daysLeft = daysLeftAsync.value;
        final dailySpend = dailySpendAsync.value ?? const <DailySpendPoint>[];
        final categoryBreakdown =
            categoryAsync.value ?? const <CategorySpend>[];
        final accountsById = {
          for (final account in accounts) account.id: account,
        };
        final transactionGroups = groupBudgetingTransactionsByDay(transactions);
        final currentDay = trip.dayOfTrip(DateTime.now());

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
                          formatBudgetingDaysLeft(daysLeft),
                          style: context.text.displayLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          formatBudgetingDaysLeftCaption(daysLeft),
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
                            averageDailySpend,
                            currency,
                          ),
                        ),
                        AppKeyValueRow(
                          label: 'Total spend',
                          value: formatBudgetingMoney(totalSpend, currency),
                        ),
                        AppKeyValueRow(
                          label: 'Total account balance',
                          value: formatBudgetingMoney(totalBalance, currency),
                          emphasized: true,
                        ),
                        AppKeyValueRow(
                          label: 'Current day of trip',
                          value: formatBudgetingCurrentDay(currentDay),
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
                        for (final point in dailySpend)
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
                        for (final category in categoryBreakdown)
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
                                accountsById,
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
