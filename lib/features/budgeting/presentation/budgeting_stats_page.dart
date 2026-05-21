import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_page_frame.dart';
import 'package:flutter_foundation_kit/shared/widgets/section_header.dart';

class BudgetingStatsPage extends StatelessWidget {
  const BudgetingStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BudgetingPageFrame(
      title: 'Stats',
      subtitle: 'Coming soon',
      children: [
        AppSectionHeader(
          title: 'stats will live here',
          body:
              'Leaving this light until real spending summaries are wired in.',
        ),
        SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
