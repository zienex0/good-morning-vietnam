import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/result/failure_messages.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/budgeting_transaction_form_controller.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_mock_data.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_category_selector.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_transaction_amount_section.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_back_button.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_bottom_action_bar.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_key_value_row.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_sliver_page.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_snack_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BudgetingExpensePage extends ConsumerStatefulWidget {
  const BudgetingExpensePage({super.key});

  @override
  ConsumerState<BudgetingExpensePage> createState() =>
      BudgetingExpensePageState();
}

class BudgetingExpensePageState extends ConsumerState<BudgetingExpensePage> {
  final amountController = TextEditingController(text: '24');
  String selectedAccountId = mockDefaultAccountId;
  String enteredCurrency = mockBudgetingAccountById(
    mockDefaultAccountId,
  ).currency;
  String selectedCategoryId = mockDefaultCategoryId;

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(budgetingTransactionFormControllerProvider, (
      previous,
      next,
    ) {
      if (next case AsyncError(:final error)) {
        final failure = error is Failure ? error : UnknownFailure(error);
        AppSnackBars.error(context, failureMessage(failure));
      }
    });

    final account = mockBudgetingAccountById(selectedAccountId);
    final currency = mockBudgetingCurrencyByCode(enteredCurrency);
    final category = mockBudgetingCategoryById(selectedCategoryId);
    final formState = ref.watch(budgetingTransactionFormControllerProvider);
    final amount = double.tryParse(amountController.text) ?? 0;

    return AppSliverPage(
      title: 'Expense',
      leading: const AppBackButton(),
      bottomNavigationBar: AppBottomActionBar(
        child: FilledButton(
          onPressed: formState.isLoading || amount <= 0
              ? null
              : () async {
                  final created = await ref
                      .read(budgetingTransactionFormControllerProvider.notifier)
                      .createExpense(
                        tripId: mockTripId,
                        accountId: selectedAccountId,
                        categoryId: selectedCategoryId,
                        amount: amount,
                        amountCurrency: enteredCurrency,
                      );
                  if (!context.mounted || !created) {
                    return;
                  }
                  AppSnackBars.success(context, 'Expense saved.');
                  context.pop();
                },
          child: Text(
            formatBudgetingPrimaryAction(
              action: formState.isLoading ? 'Saving...' : 'Add expense',
              amount: amountController.text,
              currencyCode: enteredCurrency,
            ),
          ),
        ),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.pageWithinSectionGap,
            AppSpacing.page,
            AppSpacing.none,
          ),
          sliver: SliverList.list(
            children: [
              BudgetingTransactionAmountSection(
                controller: amountController,
                currencySymbol: currency.symbol,
                onChanged: (_) => setState(() {}),
              ),
              const Divider(),
              AppKeyValueRow(
                label: 'Paying with',
                value: formatBudgetingAccountTitle(account),
                trailing: const Icon(Icons.unfold_more, size: AppSizes.iconSm),
                onTap: () async {
                  final result = await context.push<String>(
                    Uri(
                      path: AppRoutes.selectAccount,
                      queryParameters: {
                        'selected': selectedAccountId,
                        'title': 'Payment source',
                      },
                    ).toString(),
                  );
                  if (result == null) {
                    return;
                  }
                  final previousAccount = account;
                  final selectedAccount = mockBudgetingAccountById(result);
                  setState(() {
                    selectedAccountId = result;
                    if (enteredCurrency == previousAccount.currency) {
                      enteredCurrency = selectedAccount.currency;
                    }
                  });
                },
              ),
              AppKeyValueRow(
                label: 'Exchange from',
                value: formatBudgetingExchangeTitle(
                  enteredCurrency: currency,
                  account: account,
                ),
                trailing: const Icon(Icons.unfold_more, size: AppSizes.iconSm),
                onTap: () async {
                  final result = await context.push<String>(
                    Uri(
                      path: AppRoutes.selectCurrency,
                      queryParameters: {
                        'selected': enteredCurrency,
                        'title': 'Exchange currency',
                      },
                    ).toString(),
                  );
                  if (result == null) {
                    return;
                  }
                  setState(() {
                    enteredCurrency = result;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Category', style: context.labelStrong),
              const SizedBox(height: AppSpacing.md),
              BudgetingCategorySelector(
                selectedCategoryId: category.id,
                onSelected: (value) => setState(() {
                  selectedCategoryId = value;
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
