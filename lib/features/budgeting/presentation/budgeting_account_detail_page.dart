import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/budgeting_account_controller.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/budgeting_accounts_summary.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_account_formatters.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_home_formatters.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BudgetingAccountDetailPage extends ConsumerWidget {
  const BudgetingAccountDetailPage({required this.accountId, super.key});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSummary = ref.watch(
      budgetingAccountDetailSummaryProvider(accountId),
    );

    return AppAsyncValueView(
      value: asyncSummary,
      onRetry: () =>
          ref.invalidate(budgetingAccountDetailSummaryProvider(accountId)),
      data: (summary) {
        final trip = summary.trip;
        final account = summary.account;

        return AppSliverPage(
          title: account?.account.name ?? 'Account',
          subtitle: account == null
              ? 'Not found'
              : formatBudgetingAccountCurrency(account.account.currency),
          leading: const AppBackButton(),
          actions: [
            IconButton(
              tooltip: 'More',
              onPressed: account == null
                  ? null
                  : () {
                      unawaited(
                        AppActionSheet.show(
                          context,
                          title: account.account.name,
                          actions: [
                            AppAction(
                              label: 'Edit name',
                              icon: Icons.edit_outlined,
                              onPressed: () async {
                                String currentName = account.account.name;
                                final messenger = ScaffoldMessenger.of(context);

                                final edited = await AppBottomSheet.show<bool>(
                                  context,
                                  isScrollControlled: true,
                                  child: Builder(
                                    builder: (sheetContext) {
                                      return Padding(
                                        padding: const EdgeInsets.all(
                                          AppSpacing.lg,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            TextFormField(
                                              initialValue: currentName,
                                              autofocus: true,
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              decoration: const InputDecoration(
                                                labelText: 'Account name',
                                              ),
                                              onChanged: (value) =>
                                                  currentName = value,
                                            ),

                                            const SizedBox(
                                              height: AppSpacing.lg,
                                            ),
                                            AppButton.primary(
                                              label: 'Save',
                                              expanded: true,
                                              onPressed: () async {
                                                final navigator = Navigator.of(
                                                  sheetContext,
                                                );
                                                final saved = await ref
                                                    .read(
                                                      budgetingAccountControllerProvider
                                                          .notifier,
                                                    )
                                                    .editAccount(
                                                      accountId:
                                                          account.account.id,
                                                      name: currentName,
                                                    );
                                                if (saved) {
                                                  navigator.pop(true);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                                if (edited == true) {
                                  messenger
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      const SnackBar(
                                        content: Text('Account updated.'),
                                      ),
                                    );
                                }
                              },
                            ),
                            AppAction(
                              label: 'Delete account',
                              icon: Icons.delete_outline,
                              destructive: true,
                              onPressed: () async {
                                final router = GoRouter.of(context);
                                final confirmed = await AppDialog.confirm(
                                  context,
                                  title: 'Delete account?',
                                  message:
                                      'This removes the account and every transaction linked to it.',
                                  confirmLabel: 'Delete',
                                  destructive: true,
                                );
                                if (!confirmed) {
                                  return;
                                }

                                final deleted = await ref
                                    .read(
                                      budgetingAccountControllerProvider
                                          .notifier,
                                    )
                                    .deleteAccountWithTransactions(
                                      accountId: account.account.id,
                                    );
                                if (deleted) {
                                  router.go(AppRoutes.accounts);
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
              icon: const Icon(Icons.more_horiz),
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
                  if (trip == null || account == null)
                    AppCard(
                      child: Text(
                        'This account could not be found.',
                        style: context.mutedText.bodyMedium,
                      ),
                    )
                  else ...[
                    AppCard(
                      child: Column(
                        children: [
                          AppKeyValueRow(
                            label: 'Account',
                            value: account.account.name,
                          ),
                          AppKeyValueRow(
                            label: 'Currency',
                            value: formatBudgetingAccountCurrency(
                              account.account.currency,
                            ),
                          ),
                          AppKeyValueRow(
                            label: 'Balance',
                            value: formatBudgetingAccountLocalBalance(
                              amount: account.localBalance,
                              currency: account.account.currency,
                            ),
                            emphasized: true,
                          ),
                          AppKeyValueRow(
                            label: trip.homeCurrency,
                            value: formatBudgetingAccountHomeBalance(
                              amount: account.homeBalance,
                              homeCurrency: trip.homeCurrency,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.pageBetweenSectionGap),
                    const AppSectionHeader(title: 'Transactions'),
                    const SizedBox(height: AppSpacing.pageWithinSectionGap),
                    if (summary.transactionGroups.isEmpty)
                      AppCard(
                        child: Text(
                          'No transactions for this account yet.',
                          style: context.mutedText.bodyMedium,
                        ),
                      )
                    else
                      for (final group in summary.transactionGroups) ...[
                        AppListSection(
                          header: formatFullDate(group.date),
                          children: [
                            for (final transaction in group.transactions)
                              AppTile(
                                title: formatBudgetingTransactionTitle(
                                  transaction,
                                ),
                                subtitle: formatBudgetingTransactionSubtitle(
                                  transaction,
                                  {account.account.id: account.account},
                                ),
                                trailing: SizedBox(
                                  width: 112,
                                  child: Text(
                                    formatBudgetingTransactionAmount(
                                      transaction,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                    style: context.text.labelLarge,
                                  ),
                                ),
                                showChevron: false,
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
