import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_mock_data.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_page_frame.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_settings_sections.dart';

class BudgetingSettingsPage extends StatelessWidget {
  const BudgetingSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BudgetingPageFrame(
      title: mockTripName,
      subtitle: 'Settings',
      children: [
        BudgetingSettingsTripSection(),
        BudgetingSettingsBudgetSection(),
        BudgetingSettingsDangerSection(),
      ],
    );
  }
}
