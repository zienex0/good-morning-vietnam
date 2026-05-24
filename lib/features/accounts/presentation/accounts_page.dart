import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/accounts/application/trip_accounts_provider.dart';
import 'package:flutter_foundation_kit/features/accounts/presentation/account_formatters.dart';
import 'package:flutter_foundation_kit/features/trips/application/active_trip_provider.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccountsPage extends ConsumerWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripAsync = ref.watch(activeTripProvider);
    final accountsAsync = ref.watch(tripAccountsProvider);

    return AppAsyncValueView(
      value: tripAsync,
      onRetry: () => ref.invalidate(activeTripProvider),
      data: (trip) {
        final accounts = accountsAsync.value ?? const <AccountBalance>[];

        return AppSliverPage(
          title: 'Accounts',
          subtitle: trip == null
              ? 'No active trip yet'
              : 'Sorted by ${trip.homeCurrency} balance',
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
                  if (trip == null)
                    AppCard(
                      child: Text(
                        'Create or select a trip before adding accounts.',
                        style: context.mutedText.bodyMedium,
                      ),
                    )
                  else if (accounts.isEmpty)
                    AppCard(
                      child: Text(
                        'No accounts yet.',
                        style: context.mutedText.bodyMedium,
                      ),
                    )
                  else
                    AppListSection(
                      children: [
                        for (final account in accounts)
                          AppTile(
                            title: account.account.name,
                            subtitle:
                                '${formatBudgetingAccountCurrency(account.account.currency)} · '
                                '${formatBudgetingAccountHomeBalance(amount: account.homeBalance, homeCurrency: trip.homeCurrency)}',
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
