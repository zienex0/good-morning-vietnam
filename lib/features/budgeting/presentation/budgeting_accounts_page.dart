import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_mock_data.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_accounts_sections.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_page_frame.dart';

class BudgetingAccountsPage extends StatelessWidget {
  const BudgetingAccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BudgetingPageFrame(
      title: 'Accounts',
      subtitle: '$mockBalanceHome total',
      actions: [BudgetingTopUpButton()],
      children: [BudgetingAccountsSummarySection()],
    );
  }
}
