import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/accounts/application/trip_accounts_provider.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/widgets/transaction_amount_field.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';

class SetBalanceAccountStepPage extends StatelessWidget {
  const SetBalanceAccountStepPage({
    required this.accountBalance,
    required this.balanceController,
    super.key,
  });

  final AccountBalance accountBalance;
  final TextEditingController balanceController;

  @override
  Widget build(BuildContext context) {
    final account = accountBalance.account;

    return SliverFillRemaining(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.pageWithinSectionGap,
          AppSpacing.page,
          AppSpacing.none,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(account.name, style: context.titleStrong),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    formatBudgetingAccountOption(account),
                    style: context.mutedText.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.pageWithinSectionGap),
            TransactionAmountField(
              amountController: balanceController,
              currency: account.currency,
              labelText: 'New account balance',
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Original amount: ${formatBudgetingMoney(accountBalance.localBalance, account.currency)}',
              style: context.mutedText.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.pageWithinSectionGap),
            Expanded(child: AppNumpad(controller: balanceController)),
          ],
        ),
      ),
    );
  }
}
