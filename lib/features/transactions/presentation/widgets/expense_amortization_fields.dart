import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';

class ExpenseAmortizationFields extends StatelessWidget {
  const ExpenseAmortizationFields({
    required this.enabled,
    required this.daysController,
    required this.onEnabledChanged,
    super.key,
  });

  final bool enabled;
  final TextEditingController daysController;
  final ValueChanged<bool> onEnabledChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amortize expense', style: context.text.titleSmall),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Spread this expense across an exact number of days.',
                      style: context.mutedText.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Switch(value: enabled, onChanged: onEnabledChanged),
            ],
          ),
        ),
        if (enabled) ...[
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: daysController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Amortization days',
              hintText: '7',
              suffixText: 'days',
            ),
          ),
        ],
      ],
    );
  }
}
