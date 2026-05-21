import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_mock_data.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_trend_chart.dart';
import 'package:flutter_foundation_kit/shared/widgets/section_header.dart';
import 'package:go_router/go_router.dart';

class BudgetingHomeHero extends StatelessWidget {
  const BudgetingHomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(mockDaysLeft, style: context.headlineStrong),
        const SizedBox(height: AppSpacing.xs),
        Text(mockDaysLeftSubtitle, style: context.secondaryText.bodyLarge),
        const SizedBox(height: AppSpacing.xl),
        const BudgetingMetricStrip(),
        const SizedBox(height: AppSpacing.xl),
        const BudgetingProgressPanel(),
      ],
    );
  }
}

class BudgetingMetricStrip extends StatelessWidget {
  const BudgetingMetricStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        BudgetingMetricPill(
          icon: Icons.account_balance_wallet_outlined,
          label: mockBalanceHome,
        ),
        BudgetingMetricPill(
          icon: Icons.local_fire_department_outlined,
          label: mockAverageDailySpend,
        ),
        BudgetingMetricPill(
          icon: Icons.calendar_today_outlined,
          label: mockTripDay,
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

class BudgetingProgressPanel extends StatelessWidget {
  const BudgetingProgressPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ClipRRect(
          borderRadius: BorderRadius.all(AppRadii.pill),
          child: LinearProgressIndicator(
            minHeight: AppSpacing.md,
            value: mockBudgetProgress,
            backgroundColor: AppColors.surfaceStrong,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(mockBudgetProgressLabel, style: context.mutedText.bodyMedium),
      ],
    );
  }
}

class BudgetingHomeActions extends StatelessWidget {
  const BudgetingHomeActions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: AppSpacing.md,
      children: [
        Expanded(
          child: BudgetingActionButton(
            icon: Icons.remove_circle_outline,
            label: 'Expense',
            route: AppRoutes.expense,
          ),
        ),
        Expanded(
          child: BudgetingActionButton(
            icon: Icons.add_card_outlined,
            label: 'Top up',
            route: AppRoutes.topUp,
          ),
        ),
        Expanded(
          child: BudgetingActionButton(
            icon: Icons.swap_horiz,
            label: 'Transfer',
            route: AppRoutes.transfer,
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
    super.key,
  });

  final IconData icon;
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () => context.push(route),
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class BudgetingSpendTrendSection extends StatelessWidget {
  const BudgetingSpendTrendSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(
          title: 'whole trip spend',
          body: 'Mock cumulative spend trend.',
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTrendChart(points: mockSpendTrend),
      ],
    );
  }
}

class BudgetingTransactionsSection extends StatelessWidget {
  const BudgetingTransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(title: 'transactions'),
        const SizedBox(height: AppSpacing.md),
        for (final transaction in mockTransactions) ...[
          BudgetingTransactionTile(transaction: transaction),
          const Divider(),
        ],
      ],
    );
  }
}

class BudgetingTransactionTile extends StatelessWidget {
  const BudgetingTransactionTile({required this.transaction, super.key});

  final MockTransactionRow transaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.surfaceRaised,
            foregroundColor: AppColors.textPrimary,
            child: Icon(transaction.icon),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  transaction.detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.mutedText.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            transaction.amount,
            style: context.text.bodyLarge?.copyWith(
              color: transaction.positive
                  ? AppColors.success
                  : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
