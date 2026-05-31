import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/accounts/application/accounts_controller.dart';
import 'package:flutter_foundation_kit/features/accounts/application/trip_account_details_provider.dart';
import 'package:flutter_foundation_kit/features/accounts/presentation/account_formatters.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/transaction_formatters.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccountDetailPage extends ConsumerWidget {
  const AccountDetailPage({required this.accountId, super.key});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncView = ref.watch(tripAccountDetailsProvider(accountId));

    return AppAsyncValueView(
      value: asyncView,
      onRetry: () => ref.invalidate(tripAccountDetailsProvider(accountId)),
      data: (view) {
        final transactionGroups = view == null
            ? const <BudgetingTransactionDayGroup>[]
            : groupBudgetingTransactionsByDay(view.transactions);

        return AppSliverPage(
          title: view?.account.account.name ?? 'Account',
          subtitle: view == null
              ? 'Not found'
              : formatBudgetingAccountCurrency(view.account.account.currency),
          leading: const AppBackButton(),
          actions: [
            IconButton(
              tooltip: 'More',
              onPressed: view == null
                  ? null
                  : () {
                      unawaited(
                        AppActionSheet.show(
                          context,
                          title: view.account.account.name,
                          actions: [
                            AppAction(
                              label: 'Edit name',
                              icon: Icons.edit_outlined,
                              onPressed: () async {
                                String currentName = view.account.account.name;
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
                                                      accountsControllerProvider
                                                          .notifier,
                                                    )
                                                    .update(
                                                      view.account.account
                                                          .copyWith(
                                                            name: currentName,
                                                          ),
                                                    );
                                                if (saved is Ok) {
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
                                    .read(accountsControllerProvider.notifier)
                                    .delete(view.account.account.id);
                                if (deleted is Ok) {
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
                  if (view == null)
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
                            value: view.account.account.name,
                          ),
                          AppKeyValueRow(
                            label: 'Currency',
                            value: formatBudgetingAccountCurrency(
                              view.account.account.currency,
                            ),
                          ),
                          AppKeyValueRow(
                            label: 'Balance',
                            value: formatBudgetingAccountLocalBalance(
                              amount: view.account.localBalance,
                              currency: view.account.account.currency,
                            ),
                            emphasized: true,
                          ),
                          AppKeyValueRow(
                            label: view.trip.homeCurrency,
                            value: formatBudgetingAccountHomeBalance(
                              amount: view.account.homeBalance,
                              homeCurrency: view.trip.homeCurrency,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.pageBetweenSectionGap),
                    const AppSectionHeader(title: 'Transactions'),
                    const SizedBox(height: AppSpacing.pageWithinSectionGap),
                    if (transactionGroups.isEmpty)
                      AppCard(
                        child: Text(
                          'No transactions for this account yet.',
                          style: context.mutedText.bodyMedium,
                        ),
                      )
                    else
                      for (final group in transactionGroups) ...[
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
                                  {
                                    view.account.account.id:
                                        view.account.account,
                                  },
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
