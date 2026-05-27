import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/accounts/presentation/account_formatters.dart';
import 'package:flutter_foundation_kit/features/trips/domain/currencies.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';

class AccountDetailsStepPage extends StatelessWidget {
  const AccountDetailsStepPage({
    required this.selectedCurrency,
    required this.balanceController,
    required this.onCurrencyChanged,
    super.key,
  });

  final CurrencyCode selectedCurrency;
  final TextEditingController balanceController;
  final ValueChanged<CurrencyCode> onCurrencyChanged;

  @override
  Widget build(BuildContext context) {
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
            const AppSectionHeader(title: 'Starting balance'),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: balanceController,
              readOnly: true,
              showCursor: true,
              style: context.text.headlineMedium,
              decoration: InputDecoration(
                hintText: '0',
                suffixText: selectedCurrency,
              ),
            ),
            const SizedBox(height: AppSpacing.pageWithinSectionGap),
            const AppSectionHeader(title: 'Currency'),
            const SizedBox(height: AppSpacing.md),
            AppDropdown<CurrencyCode>(
              value: selectedCurrency,
              showNoneOption: false,
              onChanged: (value) {
                if (value != null) {
                  onCurrencyChanged(value);
                }
              },
              options: [
                for (final option in kBudgetingCurrencyCatalog)
                  AppDropdownOption(
                    value: option.code,
                    child: Text(formatBudgetingCurrencyOptionDetail(option)),
                    selectedChild: Text(formatBudgetingCurrencyOption(option)),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageWithinSectionGap),
            Expanded(child: AppNumpad(controller: balanceController)),
          ],
        ),
      ),
    );
  }
}
