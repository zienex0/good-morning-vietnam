import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/result/failure_messages.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/accounts/application/trip_accounts_provider.dart';
import 'package:flutter_foundation_kit/features/accounts/domain/account.dart';
import 'package:flutter_foundation_kit/features/transactions/application/transactions_controller.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/categories.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/widgets/expense_details_step_page.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/widgets/transaction_amount_step_page.dart';
import 'package:flutter_foundation_kit/features/trips/application/active_trip_provider.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_step_page_view.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ExpenseFormPage extends ConsumerStatefulWidget {
  const ExpenseFormPage({super.key});

  @override
  ConsumerState<ExpenseFormPage> createState() => ExpenseFormPageState();
}

class ExpenseFormPageState extends ConsumerState<ExpenseFormPage> {
  final stepPageKey = GlobalKey<AppStepPageViewState>();
  final amountController = TextEditingController();
  final amortizationDaysController = TextEditingController(text: '7');
  String? selectedAccountId;
  String selectedCurrency = 'USD';
  String selectedCategoryId = kBudgetingDefaultCategories.first.id;
  bool amortizesExpense = false;
  int currentPage = 0;

  @override
  void dispose() {
    amountController.dispose();
    amortizationDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripAsync = ref.watch(activeTripProvider);
    final accountsAsync = ref.watch(accountsProvider);
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
            title: 'Add expense',
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
          titles: const [Text('Expense amount'), Text('Expense details')],
          bottomNavigationBar: AppBottomActionBar(
            child: Row(
              children: [
                AppButton.text(
                  label: 'Back',
                  onPressed: isBusy ? null : handleBackPressed,
                ),
                const Spacer(),
                AppButton.primary(
                  label: currentPage == 0 ? 'Next' : 'Save expense',
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
                  TransactionType.expense,
                ),
                currency: selectedCurrency,
                onCurrencyChanged: (value) {
                  setState(() => selectedCurrency = value);
                },
              ),
            ],
            [
              ExpenseDetailsStepPage(
                accounts: accounts,
                selectedAccountId: selectedAccountId,
                selectedCategoryId: selectedCategoryId,
                amortizesExpense: amortizesExpense,
                amortizationDaysController: amortizationDaysController,
                onAccountChanged: (account) {
                  setState(() => selectedAccountId = account.id);
                },
                onCategoryChanged: (value) {
                  setState(() => selectedCategoryId = value);
                },
                onAmortizationChanged: (value) {
                  setState(() => amortizesExpense = value);
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

    final amortizationDayCount = parseBudgetingAmortizationDaysInput(
      amortizationDaysController.text,
    );
    if (amortizesExpense && amortizationDayCount == null) {
      AppSnackBars.error(context, 'Enter at least 1 amortization day.');
      return;
    }

    final saved = await ref
        .read(transactionsControllerProvider.notifier)
        .createExpense(
          tripId: tripId,
          accountId: selectedAccount.id,
          categoryId: selectedCategoryId,
          amount: amount,
          paidCurrency: selectedCurrency,
          amortization: amortizationForBudgetingDayCount(
            amortizesExpense ? amortizationDayCount : null,
          ),
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
