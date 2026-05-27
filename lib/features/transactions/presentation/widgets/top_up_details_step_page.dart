import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/accounts/domain/account.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/transaction_formatters.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';

class TopUpDetailsStepPage extends StatelessWidget {
  const TopUpDetailsStepPage({
    required this.accounts,
    required this.selectedAccountId,
    required this.onAccountChanged,
    super.key,
  });

  final List<Account> accounts;
  final String? selectedAccountId;
  final ValueChanged<Account> onAccountChanged;

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
        ],
      ),
    );
  }
}
