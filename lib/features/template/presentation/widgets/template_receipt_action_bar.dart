import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/template/presentation/template_formatters.dart';

class TemplateReceiptActionBar extends StatelessWidget {
  const TemplateReceiptActionBar({
    required this.total,
    required this.isBusy,
    required this.onConfirm,
    super.key,
  });

  final int total;
  final bool isBusy;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total due', style: context.mutedText.labelLarge),
              Text(formatTemplateMoney(total), style: context.titleStrong),
            ],
          ),
        ),
        FilledButton(
          onPressed: isBusy ? null : onConfirm,
          child: Text(isBusy ? 'Saving...' : 'Confirm'),
        ),
      ],
    );
  }
}
