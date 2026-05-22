import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_metrics_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_mappers.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_icon_text_tile.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_key_value_row.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_trend_chart.dart';
import 'package:flutter_foundation_kit/shared/widgets/empty_state.dart';
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(formatDaysLeftHeadline(daysLeft), style: context.displayStrong),
        Text(
          formatDaysLeftSubtitle(daysLeft),
          style: context.secondaryText.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.pageBetweenSectionGap),
        BudgetingMetricStrip(trip: trip),
        const SizedBox(height: AppSpacing.pageBetweenSectionGap),
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
    return Column(
      children: [
        AppKeyValueRow(
          label: 'Balance',
          value: formatBudgetingHomeMoney(balance, trip.homeCurrency),
        ),
        AppKeyValueRow(
          label: 'Avg daily spend',
          value: formatBudgetingHomeMoney(avgSpend, trip.homeCurrency),
        ),
        AppKeyValueRow(label: 'Currently at', value: dayLabel),
      ],
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
    final spend = ref.watch(activeTripTotalSpendProvider).valueOrNull ?? 0;
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
  const BudgetingSpendTrendSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(activeTripSpendTrendProvider).valueOrNull ?? [];
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
  const BudgetingTransactionsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions =
        ref.watch(transactionsForActiveTripProvider).valueOrNull ?? const [];
    final accounts =
        ref.watch(accountsForActiveTripProvider).valueOrNull ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (transactions.isEmpty)
          const EmptyState(
            icon: Icons.close,
            title: 'No transactions yet',
            description: 'List of transactions will appear here',
          )
        else
          for (final transaction in transactions) ...[
            BudgetingTransactionTile(
              transaction: transaction,
              account: _accountFor(transaction, accounts),
            ),
            const SizedBox(height: AppSpacing.pageWithinSectionGap),
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
    super.key,
  });

  final Transaction transaction;
  final Account? account;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final accountAmount = formatTransactionRowAccountAmount(transaction);
    return AppIconTextTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.surfaceRaised,
        foregroundColor: AppColors.textPrimary,
        child: Icon(budgetingTransactionIcon(transaction)),
      ),
      title: formatTransactionRowTitle(transaction),
      subtitle: formatTransactionRowDetail(
        transaction: transaction,
        account: account,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            formatTransactionRowAmount(transaction: transaction),
            style: context.text.bodyLarge?.copyWith(
              color: isIncome ? AppColors.success : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (accountAmount != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(accountAmount, style: context.mutedText.bodySmall),
          ],
        ],
      ),
    );
  }
}
