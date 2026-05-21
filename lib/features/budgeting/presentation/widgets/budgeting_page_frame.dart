import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_menu_button.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_sliver_page.dart';

class BudgetingPageFrame extends StatelessWidget {
  const BudgetingPageFrame({
    required this.title,
    required this.children,
    this.subtitle,
    this.actions = const [],
    super.key,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppSliverPage(
      includeScaffold: false,
      title: title,
      subtitle: subtitle,
      leading: const BudgetingMenuButton(),
      actions: actions,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.pageWithinSectionGap,
            AppSpacing.page,
            AppSpacing.pageBetweenSectionGap,
          ),
          sliver: SliverList.separated(
            itemBuilder: (context, index) => children[index],
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.pageWithinSectionGap),
            itemCount: children.length,
          ),
        ),
      ],
    );
  }
}
