import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_metrics_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_chart_data.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_mappers.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_trend_chart.dart';
import 'package:flutter_foundation_kit/shared/widgets/section_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BudgetingHomeHero extends ConsumerWidget {
  const BudgetingHomeHero({required this.trip, super.key});

  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysLeft = ref.watch(activeTripDaysLeftProvider).valueOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(formatDaysLeftHeadline(daysLeft), style: context.headlineStrong),
        const SizedBox(height: AppSpacing.xs),
        Text(
          formatDaysLeftSubtitle(daysLeft),
          style: context.secondaryText.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.xl),
        BudgetingMetricStrip(trip: trip),
        const SizedBox(height: AppSpacing.xl),
        BudgetingProgressPanel(trip: trip),
      ],
    );
  }
}

class BudgetingMetricStrip extends ConsumerWidget {
  const BudgetingMetricStrip({required this.trip, super.key});

  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(activeTripTotalBalanceProvider).valueOrNull ?? 0;
    final avgSpend =
        ref.watch(activeTripAverageDailySpendProvider).valueOrNull ?? 0;
    final dayLabel = formatTripDayLabel(trip, DateTime.now());
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        BudgetingMetricPill(
          icon: Icons.account_balance_wallet_outlined,
          label: formatBudgetingHomeMoney(balance, trip.homeCurrency),
        ),
        BudgetingMetricPill(
          icon: Icons.local_fire_department_outlined,
          label:
              '${formatBudgetingHomeMoney(avgSpend, trip.homeCurrency)}/day',
        ),
        BudgetingMetricPill(
          icon: Icons.calendar_today_outlined,
          label: dayLabel,
        ),
      ],
    );
  }
}

class BudgetingMetricPill extends StatelessWidget {
  const BudgetingMetricPill({
    required this.icon,
    required this.label,
    super.key,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: AppSizes.iconSm),
      label: Text(label),
    );
  }
}

class BudgetingProgressPanel extends ConsumerWidget {
  const BudgetingProgressPanel({required this.trip, super.key});

  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetTotal = trip.budgetTotal;
    if (budgetTotal == null || budgetTotal <= 0) {
      return const SizedBox.shrink();
    }
    final transactions =
        ref.watch(transactionsForActiveTripProvider).valueOrNull ?? const [];
    final spend = transactions
        .where((transaction) => transaction.type == TransactionType.expense)
        .fold<double>(0, (sum, transaction) => sum + transaction.amountHome);
    final progress = (spend / budgetTotal).clamp(0.0, 1.0);
    final percent = (progress * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(AppRadii.pill),
          child: LinearProgressIndicator(
            minHeight: AppSpacing.md,
            value: progress,
            backgroundColor: AppColors.surfaceStrong,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '$percent% of ${formatBudgetingHomeMoney(budgetTotal, trip.homeCurrency)}',
          style: context.mutedText.bodyMedium,
        ),
      ],
    );
  }
}

class BudgetingHomeActions extends ConsumerWidget {
  const BudgetingHomeActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasAccount =
        (ref.watch(accountsForActiveTripProvider).valueOrNull ?? const [])
            .isNotEmpty;
    return Row(
      spacing: AppSpacing.md,
      children: [
        Expanded(
          child: BudgetingActionButton(
            icon: Icons.remove_circle_outline,
            label: 'Expense',
            route: AppRoutes.expense,
            enabled: hasAccount,
          ),
        ),
        Expanded(
          child: BudgetingActionButton(
            icon: Icons.add_card_outlined,
            label: 'Top up',
            route: AppRoutes.topUp,
            enabled: hasAccount,
          ),
        ),
        Expanded(
          child: BudgetingActionButton(
            icon: Icons.swap_horiz,
            label: 'Transfer',
            route: AppRoutes.transfer,
            enabled: hasAccount,
          ),
        ),
      ],
    );
  }
}

class BudgetingActionButton extends StatelessWidget {
  const BudgetingActionButton({
    required this.icon,
    required this.label,
    required this.route,
    this.enabled = true,
    super.key,
  });

  final IconData icon;
  final String label;
  final String route;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: enabled ? () => context.push(route) : null,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class BudgetingSpendTrendSection extends ConsumerWidget {
  const BudgetingSpendTrendSection({required this.trip, super.key});

  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions =
        ref.watch(transactionsForActiveTripProvider).valueOrNull ?? const [];
    final points = cumulativeSpendTrend(
      trip: trip,
      transactions: transactions,
      asOf: DateTime.now(),
    );
    if (points.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(
          title: 'whole trip spend',
          body: 'Cumulative spend in home currency.',
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTrendChart(points: points),
      ],
    );
  }
}

class BudgetingTransactionsSection extends ConsumerWidget {
  const BudgetingTransactionsSection({required this.trip, super.key});

  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions =
        ref.watch(transactionsForActiveTripProvider).valueOrNull ?? const [];
    final accounts =
        ref.watch(accountsForActiveTripProvider).valueOrNull ?? const [];
    final recent = transactions.take(8).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(title: 'transactions'),
        const SizedBox(height: AppSpacing.md),
        if (recent.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text(
              'No transactions yet. Use the buttons above to add one.',
              style: context.mutedText.bodyMedium,
            ),
          )
        else
          for (final transaction in recent) ...[
            BudgetingTransactionTile(
              transaction: transaction,
              account: _accountFor(transaction, accounts),
              homeCurrency: trip.homeCurrency,
            ),
            const Divider(),
          ],
      ],
    );
  }

  Account? _accountFor(Transaction transaction, List<Account> accounts) {
    final id = transaction.sourceAccountId ?? transaction.destAccountId;
    if (id == null) return null;
    for (final account in accounts) {
      if (account.id == id) return account;
    }
    return null;
  }
}

class BudgetingTransactionTile extends StatelessWidget {
  const BudgetingTransactionTile({
    required this.transaction,
    required this.account,
    required this.homeCurrency,
    super.key,
  });

  final Transaction transaction;
  final Account? account;
  final String homeCurrency;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.surfaceRaised,
            foregroundColor: AppColors.textPrimary,
            child: Icon(budgetingTransactionIcon(transaction)),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatTransactionRowTitle(transaction),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  formatTransactionRowDetail(
                    transaction: transaction,
                    account: account,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.mutedText.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            formatTransactionRowAmount(
              transaction: transaction,
              homeCurrency: homeCurrency,
            ),
            style: context.text.bodyLarge?.copyWith(
              color: isIncome ? AppColors.success : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
