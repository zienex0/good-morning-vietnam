import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/accounts/application/trip_accounts_provider.dart';
import 'package:flutter_foundation_kit/core/result/failure_messages.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/transactions/application/transactions_controller.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/widgets/set_balance_account_step_page.dart';
import 'package:flutter_foundation_kit/features/trips/application/active_trip_provider.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_step_page_view.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SetBalanceFormPage extends ConsumerStatefulWidget {
  const SetBalanceFormPage({super.key});

  @override
  ConsumerState<SetBalanceFormPage> createState() => SetBalanceFormPageState();
}

class SetBalanceFormPageState extends ConsumerState<SetBalanceFormPage> {
  final stepPageKey = GlobalKey<AppStepPageViewState>();
  final balanceControllers = <String, TextEditingController>{};
  int currentPage = 0;

  @override
  void dispose() {
    for (final controller in balanceControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripAsync = ref.watch(activeTripProvider);
    final accountsAsync = ref.watch(tripAccountsProvider);
    final formState = ref.watch(transactionsControllerProvider);
    final isBusy = formState.isLoading;

    return AppAsyncValueView(
      value: accountsAsync,
      onRetry: () => ref.invalidate(tripAccountsProvider),
      data: (accounts) {
        syncBalanceControllers(accounts);
        final trip = tripAsync.value;

        if (accounts.isEmpty) {
          return AppSliverPage(
            title: 'Set balance',
            subtitle: trip?.name ?? 'No active trip',
            leading: const AppBackButton(),
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
                    AppCard(
                      child: Text(
                        'Add an account before setting balances.',
                        style: context.mutedText.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return AppStepPageView(
          key: stepPageKey,
          initialPage: currentPage,
          leading: const AppBackButton(),
          onPageChanged: (value) => setState(() => currentPage = value),
          titles: [for (final account in accounts) Text(account.account.name)],
          bottomNavigationBar: AppBottomActionBar(
            child: Row(
              children: [
                AppButton.text(
                  label: 'Back',
                  onPressed: isBusy ? null : handleBackPressed,
                ),
                const Spacer(),
                AppButton.primary(
                  label: currentPage == accounts.length - 1
                      ? 'Save balances'
                      : 'Next',
                  loading: isBusy,
                  onPressed: trip == null
                      ? null
                      : () => handlePrimaryPressed(
                          tripId: trip.id,
                          accounts: accounts,
                        ),
                ),
              ],
            ),
          ),
          pagesSlivers: [
            for (final account in accounts)
              [
                SetBalanceAccountStepPage(
                  accountBalance: account,
                  balanceController: balanceControllers[account.account.id]!,
                ),
              ],
          ],
        );
      },
    );
  }

  void syncBalanceControllers(List<AccountBalance> accounts) {
    final accountIds = {for (final account in accounts) account.account.id};
    final removedIds = balanceControllers.keys
        .where((accountId) => !accountIds.contains(accountId))
        .toList();
    for (final accountId in removedIds) {
      balanceControllers.remove(accountId)?.dispose();
    }

    for (final account in accounts) {
      balanceControllers.putIfAbsent(account.account.id, () {
        final text = formatBudgetingAmountInputValue(account.localBalance);
        return TextEditingController(text: text)
          ..selection = TextSelection(baseOffset: 0, extentOffset: text.length);
      });
    }
  }

  Future<void> handlePrimaryPressed({
    required String tripId,
    required List<AccountBalance> accounts,
  }) async {
    if (currentPage < accounts.length - 1) {
      await stepPageKey.currentState?.incrementPageIndex();
      return;
    }

    final balancesByAccountId = <String, double>{};
    for (final account in accounts) {
      final controller = balanceControllers[account.account.id];
      final amount = parseBudgetingAmountInput(controller?.text ?? '');
      if (amount == null || amount < 0) {
        AppSnackBars.error(context, 'Enter a valid balance.');
        return;
      }
      balancesByAccountId[account.account.id] = amount;
    }

    final saved = await ref
        .read(transactionsControllerProvider.notifier)
        .setAccountBalances(
          tripId: tripId,
          balancesByAccountId: balancesByAccountId,
        );
    if (!mounted) {
      return;
    }
    switch (saved) {
      case Ok():
        context.pop();
      case Err(failure: final failure):
        AppSnackBars.error(context, failureMessage(failure));
    }
  }

  Future<void> handleBackPressed() async {
    if (currentPage == 0) {
      context.pop();
      return;
    }
    await stepPageKey.currentState?.decrementPageIndex();
  }
}
