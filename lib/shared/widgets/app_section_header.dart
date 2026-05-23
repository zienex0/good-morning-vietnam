import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    required this.title,
    this.eyebrow,
    this.body,
    this.trailing,
    super.key,
  });

  final String title;
  final String? eyebrow;
  final String? body;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (eyebrow != null) ...[
          Text(eyebrow!, style: context.labelStrong),
          const SizedBox(height: AppSpacing.sm),
        ],
        Row(
          children: [
            Expanded(child: Text(title, style: context.titleStrong)),
            ?trailing,
          ],
        ),
        if (body != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(body!, style: context.secondaryText.bodyLarge),
        ],
      ],
    );
  }
}
