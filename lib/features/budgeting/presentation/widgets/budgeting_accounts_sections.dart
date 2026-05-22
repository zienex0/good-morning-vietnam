import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_chart_data.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_mappers.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_icon_text_tile.dart';
import 'package:flutter_foundation_kit/shared/widgets/section_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BudgetingAddAccountButton extends StatelessWidget {
  const BudgetingAddAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Add account',
      child: IconButton(
        onPressed: () => context.push(AppRoutes.newAccount),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class BudgetingAccountsSummarySection extends ConsumerWidget {
  const BudgetingAccountsSummarySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts =
        ref.watch(accountsForActiveTripProvider).valueOrNull ?? const [];
    final transactions =
        ref.watch(transactionsForActiveTripProvider).valueOrNull ?? const [];

    if (accounts.isEmpty) {
      return const BudgetingAccountsEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(
          title: 'accounts',
          body: 'Balances are approximate in each account currency.',
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final account in accounts) ...[
          BudgetingAccountTile(
            account: account,
            transactions: transactions,
          ),
          const Divider(),
        ],
      ],
    );
  }
}

class BudgetingAccountsEmptyState extends StatelessWidget {
  const BudgetingAccountsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(
          title: 'no accounts yet',
          body: 'Add a cash, card, or e-wallet account to start tracking.',
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton.icon(
          onPressed: () => context.push(AppRoutes.newAccount),
          icon: const Icon(Icons.add),
          label: const Text('Add account'),
        ),
      ],
    );
  }
}

class BudgetingAccountTile extends StatelessWidget {
  const BudgetingAccountTile({
    required this.account,
    required this.transactions,
    super.key,
  });

  final Account account;
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    final balance = computeAccountBalance(
      accountId: account.id,
      accountCurrency: account.currency,
      openingBalance: account.openingBalance,
      transactions: transactions,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: AppIconTextTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.surfaceRaised,
          foregroundColor: AppColors.textPrimary,
          child: Icon(budgetingAccountIcon(account.type)),
        ),
        title: account.name,
        subtitle:
            '${budgetingAccountTypeLabel(account.type)} · ${account.currency}',
        trailing: Text(
          formatBudgetingNativeMoney(balance, account.currency),
          style: context.text.bodyLarge,
        ),
      ),
    );
  }
}
