import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/widgets/transaction_amount_field.dart';
import 'package:flutter_foundation_kit/features/trips/domain/currencies.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';

class TransactionAmountStepPage extends StatelessWidget {
  const TransactionAmountStepPage({
    required this.amountController,
    required this.currency,
    required this.onCurrencyChanged,
    this.amountPrefix,
    super.key,
  });

  final TextEditingController amountController;
  final String currency;
  final ValueChanged<String> onCurrencyChanged;
  final String? amountPrefix;

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
            TransactionAmountField(
              amountController: amountController,
              amountPrefix: amountPrefix,
              currency: currency,
            ),
            const SizedBox(height: AppSpacing.pageWithinSectionGap),
            AppDropdown<String>(
              value: currency,
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
            Expanded(child: AppNumpad(controller: amountController)),
          ],
        ),
      ),
    );
  }
}
