import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_back_button.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_sliver_page.dart';
import 'package:go_router/go_router.dart';

class BudgetingTransactionEmptyShell extends StatelessWidget {
  const BudgetingTransactionEmptyShell({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppSliverPage(
      title: title,
      leading: const AppBackButton(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.page),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add an account before recording a transaction.',
                  style: context.mutedText.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: () => context.go(AppRoutes.newAccount),
                  icon: const Icon(Icons.add),
                  label: const Text('Add account'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
