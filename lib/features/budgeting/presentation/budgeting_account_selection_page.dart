import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_selection_sections.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_bottom_action_bar.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_sliver_page.dart';
import 'package:go_router/go_router.dart';

class BudgetingAccountSelectionPage extends StatefulWidget {
  const BudgetingAccountSelectionPage({
    required this.title,
    required this.selectedAccountId,
    this.excludedAccountId,
    super.key,
  });

  final String title;
  final String selectedAccountId;
  final String? excludedAccountId;

  @override
  State<BudgetingAccountSelectionPage> createState() =>
      BudgetingAccountSelectionPageState();
}

class BudgetingAccountSelectionPageState
    extends State<BudgetingAccountSelectionPage> {
  late String selectedAccountId = widget.selectedAccountId;

  @override
  Widget build(BuildContext context) {
    return AppSliverPage(
      title: widget.title,
      leading: const BudgetingSelectionCloseButton(),
      bottomNavigationBar: AppBottomActionBar(
        child: FilledButton(
          onPressed: () => context.pop(selectedAccountId),
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
              BudgetingAccountList(
                selectedAccountId: selectedAccountId,
                excludedAccountId: widget.excludedAccountId,
                onSelected: (value) => setState(() {
                  selectedAccountId = value;
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
