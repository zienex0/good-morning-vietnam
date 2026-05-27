import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/accounts/domain/account.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/categories.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/widgets/expense_amortization_fields.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';

class ExpenseDetailsStepPage extends StatelessWidget {
  const ExpenseDetailsStepPage({
    required this.accounts,
    required this.selectedAccountId,
    required this.selectedCategoryId,
    required this.amortizesExpense,
    required this.amortizationDaysController,
    required this.onAccountChanged,
    required this.onCategoryChanged,
    required this.onAmortizationChanged,
    super.key,
  });

  final List<Account> accounts;
  final String? selectedAccountId;
  final String selectedCategoryId;
  final bool amortizesExpense;
  final TextEditingController amortizationDaysController;
  final ValueChanged<Account> onAccountChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<bool> onAmortizationChanged;

  @override
  Widget build(BuildContext context) {
    final accountsById = {for (final account in accounts) account.id: account};

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.pageWithinSectionGap,
        AppSpacing.page,
        AppSpacing.pageBetweenSectionGap,
      ),
      sliver: SliverList.list(
        children: [
          const AppSectionHeader(title: 'Account'),
          const SizedBox(height: AppSpacing.md),
          AppDropdown<String>(
            value: selectedAccountId,
            placeholder: const Text('Choose account'),
            showNoneOption: false,
            onChanged: (value) {
              final account = accountsById[value];
              if (account != null) {
                onAccountChanged(account);
              }
            },
            options: [
              for (final account in accounts)
                AppDropdownOption(
                  value: account.id,
                  child: Text(formatBudgetingAccountOption(account)),
                  selectedChild: Text(formatBudgetingAccountOption(account)),
                ),
            ],
          ),
          const AppSectionHeader(title: 'Category'),
          const SizedBox(height: AppSpacing.md),
          AppDropdown<String>(
            value: selectedCategoryId,
            showNoneOption: false,
            onChanged: (value) {
              if (value != null) {
                onCategoryChanged(value);
              }
            },
            options: [
              for (final category in kBudgetingDefaultCategories)
                AppDropdownOption(
                  value: category.id,
                  child: Text(category.name),
                  selectedChild: Text(category.name),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageWithinSectionGap),
          const AppSectionHeader(title: 'Amortization'),
          const SizedBox(height: AppSpacing.md),
          ExpenseAmortizationFields(
            enabled: amortizesExpense,
            daysController: amortizationDaysController,
            onEnabledChanged: onAmortizationChanged,
          ),
        ],
      ),
    );
  }
}
