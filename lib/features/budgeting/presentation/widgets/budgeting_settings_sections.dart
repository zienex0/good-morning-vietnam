import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_mock_data.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_key_value_row.dart';
import 'package:flutter_foundation_kit/shared/widgets/section_header.dart';

class BudgetingSettingsTripSection extends StatelessWidget {
  const BudgetingSettingsTripSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(title: 'trip'),
        SizedBox(height: AppSpacing.lg),
        AppKeyValueRow(label: 'name', value: mockTripName),
        AppKeyValueRow(label: 'home currency', value: mockHomeCurrency),
        AppKeyValueRow(label: 'dates', value: mockTripDates),
      ],
    );
  }
}

class BudgetingSettingsBudgetSection extends StatelessWidget {
  const BudgetingSettingsBudgetSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(title: 'budget'),
        SizedBox(height: AppSpacing.lg),
        AppKeyValueRow(label: 'total budget', value: mockBudgetTotal),
      ],
    );
  }
}

class BudgetingSettingsDangerSection extends StatelessWidget {
  const BudgetingSettingsDangerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(title: 'danger zone'),
        const SizedBox(height: AppSpacing.lg),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.flag_outlined),
          label: const Text('change trip status'),
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.delete_outline),
          label: const Text('delete trip'),
        ),
      ],
    );
  }
}
