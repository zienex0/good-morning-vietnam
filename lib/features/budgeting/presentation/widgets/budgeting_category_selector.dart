import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/categories.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_mappers.dart';

class BudgetingCategorySelector extends StatelessWidget {
  const BudgetingCategorySelector({
    required this.selectedCategoryId,
    required this.onSelected,
    super.key,
  });

  final String selectedCategoryId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final category in kBudgetingDefaultCategories)
          ChoiceChip(
            selected: selectedCategoryId == category.id,
            avatar: Icon(
              budgetingCategoryIcon(category.id),
              size: AppSizes.iconSm,
            ),
            label: Text(category.name),
            onSelected: (_) => onSelected(category.id),
          ),
      ],
    );
  }
}
