import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';

class AppKeyValueRow extends StatelessWidget {
  const AppKeyValueRow({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
    super.key,
  });

  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: labelStyle ?? context.mutedText.bodyMedium,
            ),
          ),
          Text(value, style: valueStyle ?? context.text.bodyMedium),
        ],
      ),
    );
  }
}
