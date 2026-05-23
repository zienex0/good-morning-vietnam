import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/budgeting_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_account_formatters.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BudgetingAccountsPage extends ConsumerWidget {
  const BudgetingAccountsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncView = ref.watch(budgetingAccountsViewProvider);

    return AppAsyncValueView(
      value: asyncView,
      onRetry: () => ref.invalidate(budgetingAccountsViewProvider),
      data: (view) {
        return AppSliverPage(
          title: 'Accounts',
          subtitle: view == null
              ? 'No active trip yet'
              : 'Sorted by ${view.trip.homeCurrency} balance',
          actions: [
            TextButton(
              onPressed: () => context.push(AppRoutes.newAccount),
              child: const Text('Add'),
            ),
          ],
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.pageWithinSectionGap,
                AppSpacing.page,
                AppSpacing.pageBetweenSectionGap,
              ),
              sliver: SliverList.list(
                children: [
                  if (view == null)
                    AppCard(
                      child: Text(
                        'Create or select a trip before adding accounts.',
                        style: context.mutedText.bodyMedium,
                      ),
                    )
                  else if (view.accounts.isEmpty)
                    AppCard(
                      child: Text(
                        'No accounts yet.',
                        style: context.mutedText.bodyMedium,
                      ),
                    )
                  else
                    AppListSection(
                      children: [
                        for (final account in view.accounts)
                          AppTile(
                            title: account.account.name,
                            subtitle:
                                '${formatBudgetingAccountCurrency(account.account.currency)} · '
                                '${formatBudgetingAccountHomeBalance(amount: account.homeBalance, homeCurrency: view.trip.homeCurrency)}',
                            trailing: SizedBox(
                              width: 104,
                              child: Text(
                                formatBudgetingAccountLocalBalance(
                                  amount: account.localBalance,
                                  currency: account.account.currency,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: context.text.labelLarge,
                              ),
                            ),
                            onTap: () => context.push(
                              AppRoutes.accountDetailsFor(account.account.id),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
