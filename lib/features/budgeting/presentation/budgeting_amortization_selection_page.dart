import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/amortization.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_selection_sections.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_bottom_action_bar.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_sliver_page.dart';
import 'package:go_router/go_router.dart';

class BudgetingAmortizationSelectionPage extends StatefulWidget {
  const BudgetingAmortizationSelectionPage({
    required this.enabled,
    required this.unit,
    required this.count,
    this.amount,
    this.currency,
    super.key,
  });

  static const int minCount = 1;
  static const int maxCount = 365;

  final bool enabled;
  final AmortizationUnit unit;
  final int count;
  final double? amount;
  final String? currency;

  @override
  State<BudgetingAmortizationSelectionPage> createState() =>
      BudgetingAmortizationSelectionPageState();
}

class BudgetingAmortizationSelectionPageState
    extends State<BudgetingAmortizationSelectionPage> {
  late bool enabled = widget.enabled;
  late AmortizationUnit unit = widget.unit;
  late int count = widget.count.clamp(
    BudgetingAmortizationSelectionPage.minCount,
    BudgetingAmortizationSelectionPage.maxCount,
  );

  Amortization? get _selection =>
      enabled ? Amortization(unit: unit, count: count) : null;

  @override
  Widget build(BuildContext context) {
    final amount = widget.amount;
    final currency = widget.currency;
    final preview = (_selection != null && amount != null && currency != null)
        ? formatAmortizationPreview(
            amount: amount,
            currency: currency,
            amortization: _selection!,
          )
        : '';

    return AppSliverPage(
      title: 'Spread over time',
      leading: const BudgetingSelectionCloseButton(),
      bottomNavigationBar: AppBottomActionBar(
        child: FilledButton(
          onPressed: () => context.pop(encodeAmortizationResult(_selection)),
          child: const Text('Done'),
        ),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.pageWithinSectionGap,
            AppSpacing.page,
            AppSpacing.none,
          ),
          sliver: SliverList.list(
            children: [
              BudgetingAmortizationToggle(
                value: enabled,
                onChanged: (value) => setState(() => enabled = value),
              ),
              if (enabled) ...[
                const SizedBox(height: AppSpacing.lg),
                Text('Unit', style: context.labelStrong),
                const SizedBox(height: AppSpacing.md),
                BudgetingAmortizationUnitChips(
                  selectedUnit: unit,
                  onSelected: (value) => setState(() => unit = value),
                ),
                const SizedBox(height: AppSpacing.lg),
                BudgetingAmortizationCountStepper(
                  unit: unit,
                  count: count,
                  onDecrement:
                      count > BudgetingAmortizationSelectionPage.minCount
                      ? () => setState(() => count -= 1)
                      : null,
                  onIncrement:
                      count < BudgetingAmortizationSelectionPage.maxCount
                      ? () => setState(() => count += 1)
                      : null,
                ),
                if (preview.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(preview, style: context.mutedText.bodyMedium),
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }
}
