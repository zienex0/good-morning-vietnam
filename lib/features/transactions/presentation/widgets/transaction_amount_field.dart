import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/transaction_formatters.dart';

class TransactionAmountField extends StatelessWidget {
  const TransactionAmountField({
    required this.amountController,
    required this.currency,
    this.amountPrefix,
    this.labelText,
    super.key,
  });

  final TextEditingController amountController;
  final String currency;
  final String? amountPrefix;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: amountController,
      builder: (context, value, child) {
        final displayValue = formatBudgetingAmountInputMoney(
          value.text,
          currency,
        );

        return InputDecorator(
          isEmpty: displayValue.isEmpty,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: formatBudgetingMoney(0, currency),
            prefixIcon: amountPrefix == null
                ? null
                : SizedBox(
                    width: AppSpacing.xl,
                    child: Center(
                      child: Text(
                        amountPrefix!,
                        style: context.text.displaySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
            prefixIconConstraints: const BoxConstraints.tightFor(
              width: AppSpacing.xl,
            ),
          ),
          child: Text(
            displayValue,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.displaySmall,
          ),
        );
      },
    );
  }
}
