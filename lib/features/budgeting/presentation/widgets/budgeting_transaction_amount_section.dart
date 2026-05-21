import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/shared/widgets/currency_amount_field.dart';

class BudgetingTransactionAmountSection extends StatelessWidget {
  const BudgetingTransactionAmountSection({
    required this.controller,
    required this.currencySymbol,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String currencySymbol;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Center(
        child: CurrencyAmountField(
          controller: controller,
          currencySymbol: currencySymbol,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class BudgetingTransactionNote extends StatelessWidget {
  const BudgetingTransactionNote({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: context.mutedText.bodyMedium,
    );
  }
}
