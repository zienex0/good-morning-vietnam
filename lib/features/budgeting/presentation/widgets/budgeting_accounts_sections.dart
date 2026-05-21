import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_mock_data.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_icon_text_tile.dart';
import 'package:flutter_foundation_kit/shared/widgets/section_header.dart';
import 'package:go_router/go_router.dart';

class BudgetingTopUpButton extends StatelessWidget {
  const BudgetingTopUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Top up',
      child: IconButton(
        onPressed: () => context.push(AppRoutes.topUp),
        icon: const Icon(Icons.add_card_outlined),
      ),
    );
  }
}

class BudgetingAccountsSummarySection extends StatelessWidget {
  const BudgetingAccountsSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(
          title: 'accounts',
          body: 'Mock balances in mixed currencies.',
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final account in mockAccounts) ...[
          BudgetingAccountTile(account: account),
          const Divider(),
        ],
      ],
    );
  }
}

class BudgetingAccountTile extends StatelessWidget {
  const BudgetingAccountTile({required this.account, super.key});

  final MockAccountRow account;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: AppIconTextTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.surfaceRaised,
          foregroundColor: AppColors.textPrimary,
          child: Icon(account.icon),
        ),
        title: account.name,
        subtitle: account.detail,
        trailing: Text(account.balance, style: context.text.bodyLarge),
      ),
    );
  }
}
