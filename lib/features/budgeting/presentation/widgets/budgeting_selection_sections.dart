import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_mock_data.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_formatters.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_icon_text_tile.dart';
import 'package:go_router/go_router.dart';

class BudgetingCurrencyChips extends StatelessWidget {
  const BudgetingCurrencyChips({
    required this.selectedCurrency,
    required this.onSelected,
    super.key,
  });

  final String selectedCurrency;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final currency in mockBudgetingCurrencies) ...[
            ChoiceChip(
              selected: selectedCurrency == currency.code,
              avatar: Text(currency.flag),
              label: Text(currency.code),
              onSelected: (_) => onSelected(currency.code),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class BudgetingCurrencyList extends StatelessWidget {
  const BudgetingCurrencyList({
    required this.selectedCurrency,
    required this.onSelected,
    super.key,
  });

  final String selectedCurrency;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final currency in mockBudgetingCurrencies) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: AppIconTextTile(
              leading: Text(currency.flag, style: context.text.headlineSmall),
              title: currency.code,
              subtitle: currency.name,
              trailing: Icon(
                selectedCurrency == currency.code
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selectedCurrency == currency.code
                    ? AppColors.accent
                    : AppColors.textMuted,
              ),
              onTap: () => onSelected(currency.code),
            ),
          ),
          const Divider(),
        ],
      ],
    );
  }
}

class BudgetingAccountList extends StatelessWidget {
  const BudgetingAccountList({
    required this.selectedAccountId,
    required this.onSelected,
    this.excludedAccountId,
    super.key,
  });

  final String selectedAccountId;
  final String? excludedAccountId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final accounts = mockBudgetingAccounts
        .where((account) => account.id != excludedAccountId)
        .toList();

    return Column(
      children: [
        for (final account in accounts) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: AppIconTextTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.surfaceRaised,
                foregroundColor: AppColors.textPrimary,
                child: Icon(account.icon),
              ),
              title: formatBudgetingAccountTitle(account),
              subtitle: '${account.detail} • ${account.balance}',
              trailing: Icon(
                selectedAccountId == account.id
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selectedAccountId == account.id
                    ? AppColors.accent
                    : AppColors.textMuted,
              ),
              onTap: () => onSelected(account.id),
            ),
          ),
          const Divider(),
        ],
      ],
    );
  }
}

class BudgetingSelectionCloseButton extends StatelessWidget {
  const BudgetingSelectionCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: context.pop, icon: const Icon(Icons.close));
  }
}
