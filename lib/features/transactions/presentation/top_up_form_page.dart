import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/accounts/application/trip_accounts_provider.dart';
import 'package:flutter_foundation_kit/features/accounts/domain/account.dart';
import 'package:flutter_foundation_kit/core/result/failure_messages.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/transactions/application/transactions_controller.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/widgets/top_up_details_step_page.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/widgets/transaction_amount_step_page.dart';
import 'package:flutter_foundation_kit/features/trips/application/active_trip_provider.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_step_page_view.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TopUpFormPage extends ConsumerStatefulWidget {
  const TopUpFormPage({super.key});

  @override
  ConsumerState<TopUpFormPage> createState() => TopUpFormPageState();
}

class TopUpFormPageState extends ConsumerState<TopUpFormPage> {
  final stepPageKey = GlobalKey<AppStepPageViewState>();
  final amountController = TextEditingController();
  String? selectedAccountId;
  String selectedCurrency = 'USD';
  int currentPage = 0;

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripAsync = ref.watch(activeTripProvider);
    final accountsAsync = ref.watch(accountsControllerProvider);
    final formState = ref.watch(transactionsControllerProvider);
    final accounts = accountsAsync.value ?? const <Account>[];

    if (selectedAccountId == null && accounts.isNotEmpty) {
      selectedAccountId = accounts.first.id;
      selectedCurrency = accounts.first.currency;
    }

    final accountsById = {for (final account in accounts) account.id: account};
    final selectedAccount = accountsById[selectedAccountId];
    final isBusy = formState.isLoading;

    return AppAsyncValueView(
      value: tripAsync,
      onRetry: () => ref.invalidate(activeTripProvider),
      data: (trip) {
        if (accounts.isEmpty) {
          return AppSliverPage(
            title: 'Add top up',
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
                        'Add an account before recording transactions.',
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
          physics: const NeverScrollableScrollPhysics(),
          pageScrollPhysics: const [NeverScrollableScrollPhysics(), null],
          onPageChanged: (value) => setState(() => currentPage = value),
          titles: const [Text('Top up amount'), Text('Top up details')],
          bottomNavigationBar: AppBottomActionBar(
            child: Row(
              children: [
                AppButton.text(
                  label: 'Back',
                  onPressed: isBusy ? null : handleBackPressed,
                ),
                const Spacer(),
                AppButton.primary(
                  label: currentPage == 0 ? 'Next' : 'Save top up',
                  loading: isBusy,
                  onPressed: trip == null || selectedAccount == null
                      ? null
                      : () => handlePrimaryPressed(
                          tripId: trip.id,
                          selectedAccount: selectedAccount,
                        ),
                ),
              ],
            ),
          ),
          pagesSlivers: [
            [
              TransactionAmountStepPage(
                amountController: amountController,
                amountPrefix: formatBudgetingTransactionInputSign(
                  TransactionType.income,
                ),
                currency: selectedCurrency,
                onCurrencyChanged: (value) {
                  setState(() => selectedCurrency = value);
                },
              ),
            ],
            [
              TopUpDetailsStepPage(
                accounts: accounts,
                selectedAccountId: selectedAccountId,
                onAccountChanged: (account) {
                  setState(() => selectedAccountId = account.id);
                },
              ),
            ],
          ],
        );
      },
    );
  }

  Future<void> handlePrimaryPressed({
    required String tripId,
    required Account selectedAccount,
  }) async {
    final amount = parseBudgetingAmountInput(amountController.text);
    if (amount == null || amount <= 0) {
      AppSnackBars.error(context, 'Enter a valid amount.');
      return;
    }

    if (currentPage == 0) {
      await stepPageKey.currentState?.incrementPageIndex();
      return;
    }

    final saved = await ref
        .read(transactionsControllerProvider.notifier)
        .createTopUp(
          tripId: tripId,
          accountId: selectedAccount.id,
          amount: amount,
          paidCurrency: selectedCurrency,
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
