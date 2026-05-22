import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/amortization.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/currencies.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_mappers.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_counter_stepper.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_icon_text_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BudgetingCurrencyChips extends StatelessWidget {
  const BudgetingCurrencyChips({
    required this.selectedCurrency,
    required this.onSelected,
    super.key,
  });

  final String selectedCurrency;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final currency in kBudgetingCurrencyCatalog) ...[
            ChoiceChip(
              selected: selectedCurrency == currency.code,
              avatar: Text(currency.flag),
              label: Text(currency.code),
              onSelected: (_) => onSelected(currency.code),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class BudgetingCurrencyList extends StatelessWidget {
  const BudgetingCurrencyList({
    required this.selectedCurrency,
    required this.onSelected,
    super.key,
  });

  final String selectedCurrency;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final currency in kBudgetingCurrencyCatalog) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: AppIconTextTile(
              leading: Text(currency.flag, style: context.text.headlineSmall),
              title: currency.code,
              subtitle: currency.name,
              trailing: Icon(
                selectedCurrency == currency.code
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selectedCurrency == currency.code
                    ? AppColors.accent
                    : AppColors.textMuted,
              ),
              onTap: () => onSelected(currency.code),
            ),
          ),
          const Divider(),
        ],
      ],
    );
  }
}

class BudgetingAccountList extends ConsumerWidget {
  const BudgetingAccountList({
    required this.selectedAccountId,
    required this.onSelected,
    this.excludedAccountId,
    super.key,
  });

  final String selectedAccountId;
  final String? excludedAccountId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsForActiveTripProvider).valueOrNull ??
        const <Account>[];
    final visible = accounts
        .where((account) => account.id != excludedAccountId)
        .toList();

    if (visible.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Text(
          'No accounts in this trip yet.',
          style: context.mutedText.bodyMedium,
        ),
      );
    }

    return Column(
      children: [
        for (final account in visible) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: AppIconTextTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.surfaceRaised,
                foregroundColor: AppColors.textPrimary,
                child: Icon(budgetingAccountIcon(account.type)),
              ),
              title: formatBudgetingAccountTitle(account),
              subtitle: budgetingAccountTypeLabel(account.type),
              trailing: Icon(
                selectedAccountId == account.id
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selectedAccountId == account.id
                    ? AppColors.accent
                    : AppColors.textMuted,
              ),
              onTap: () => onSelected(account.id),
            ),
          ),
          const Divider(),
        ],
      ],
    );
  }
}

class BudgetingSelectionCloseButton extends StatelessWidget {
  const BudgetingSelectionCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: context.pop, icon: const Icon(Icons.close));
  }
}

class BudgetingAmortizationToggle extends StatelessWidget {
  const BudgetingAmortizationToggle({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Spread this expense', style: context.text.titleSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Divide it evenly across several days so daily spend stays '
                'smooth.',
                style: context.mutedText.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

class BudgetingAmortizationUnitChips extends StatelessWidget {
  const BudgetingAmortizationUnitChips({
    required this.selectedUnit,
    required this.onSelected,
    super.key,
  });

  final AmortizationUnit selectedUnit;
  final ValueChanged<AmortizationUnit> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final unit in AmortizationUnit.values) ...[
          ChoiceChip(
            selected: selectedUnit == unit,
            label: Text(budgetingAmortizationUnitLabel(unit)),
            onSelected: (_) => onSelected(unit),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ],
    );
  }
}

class BudgetingAmortizationCountStepper extends StatelessWidget {
  const BudgetingAmortizationCountStepper({
    required this.unit,
    required this.count,
    required this.onDecrement,
    required this.onIncrement,
    super.key,
  });

  final AmortizationUnit unit;
  final int count;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  @override
  Widget build(BuildContext context) {
    return AppCounterStepper(
      label: budgetingAmortizationUnitLabel(unit),
      value: count,
      onDecrement: onDecrement,
      onIncrement: onIncrement,
    );
  }
}
