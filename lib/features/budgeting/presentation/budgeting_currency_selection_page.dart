import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_selection_sections.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_bottom_action_bar.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_sliver_page.dart';
import 'package:go_router/go_router.dart';

class BudgetingCurrencySelectionPage extends StatefulWidget {
  const BudgetingCurrencySelectionPage({
    required this.selectedCurrency,
    this.title = 'Select currency',
    super.key,
  });

  final String selectedCurrency;
  final String title;

  @override
  State<BudgetingCurrencySelectionPage> createState() =>
      BudgetingCurrencySelectionPageState();
}

class BudgetingCurrencySelectionPageState
    extends State<BudgetingCurrencySelectionPage> {
  late String selectedCurrency = widget.selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return AppSliverPage(
      title: widget.title,
      leading: const BudgetingSelectionCloseButton(),
      bottomNavigationBar: AppBottomActionBar(
        child: FilledButton(
          onPressed: () => context.pop(selectedCurrency),
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
              BudgetingCurrencyChips(
                selectedCurrency: selectedCurrency,
                onSelected: (value) => setState(() {
                  selectedCurrency = value;
                }),
              ),
              const SizedBox(height: AppSpacing.xl),
              BudgetingCurrencyList(
                selectedCurrency: selectedCurrency,
                onSelected: (value) => setState(() {
                  selectedCurrency = value;
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
