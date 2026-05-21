import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_mock_data.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_home_sections.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_page_frame.dart';

class BudgetingHomePage extends StatelessWidget {
  const BudgetingHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BudgetingPageFrame(
      title: mockTripName,
      children: [
        BudgetingHomeHero(),
        BudgetingHomeActions(),
        BudgetingSpendTrendSection(),
        BudgetingTransactionsSection(),
      ],
    );
  }
}
