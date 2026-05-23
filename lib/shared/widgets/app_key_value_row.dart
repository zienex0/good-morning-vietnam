import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';

class AppKeyValueRow extends StatelessWidget {
  const AppKeyValueRow({
    required this.label,
    required this.value,
    this.emphasized = false,
    super.key,
  });

  final String label;
  final String value;

  /// Renders the row as a summary line (e.g. a total) with stronger type.
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final labelStyle = emphasized
        ? context.text.titleMedium
        : context.mutedText.bodyMedium;
    final valueStyle = emphasized
        ? context.titleStrong
        : context.text.bodyMedium;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Expanded(child: Text(label, style: labelStyle)),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }
}
