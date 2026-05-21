import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';

class CurrencyAmountField extends StatelessWidget {
  const CurrencyAmountField({
    required this.controller,
    required this.currencySymbol,
    this.autofocus = true,
    this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String currencySymbol;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final amountStyle = context.text.displayLarge?.copyWith(
      color: AppColors.textPrimary,
      fontSize: 76,
      fontWeight: FontWeight.w800,
      height: 1,
    );
    final symbolStyle = context.text.headlineMedium?.copyWith(
      color: AppColors.textSecondary,
      fontWeight: FontWeight.w500,
      height: 1,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(currencySymbol, style: symbolStyle),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: IntrinsicWidth(
            child: TextField(
              autofocus: autofocus,
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: const [CurrencyAmountInputFormatter()],
              textAlign: TextAlign.center,
              style: amountStyle,
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                filled: false,
                isCollapsed: true,
                hintText: '0',
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class CurrencyAmountInputFormatter extends TextInputFormatter {
  const CurrencyAmountInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) {
      return newValue;
    }
    if (!RegExp(r'^\d*\.?\d{0,2}$').hasMatch(text)) {
      return oldValue;
    }
    return newValue;
  }
}
