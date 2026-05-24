import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/accounts/application/trip_accounts_provider.dart';
import 'package:flutter_foundation_kit/features/accounts/domain/account.dart';
import 'package:flutter_foundation_kit/features/transactions/application/transaction_form_provider.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/categories.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/trips/application/active_trip_provider.dart';
import 'package:flutter_foundation_kit/features/trips/domain/currencies.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ExpenseFormPage extends ConsumerStatefulWidget {
  const ExpenseFormPage({super.key});

  @override
  ConsumerState<ExpenseFormPage> createState() => ExpenseFormPageState();
}

class ExpenseFormPageState extends ConsumerState<ExpenseFormPage> {
  final amountController = TextEditingController();
  String? selectedAccountId;
  String selectedCurrency = 'USD';
  String selectedCategoryId = kBudgetingDefaultCategories.first.id;
  BudgetingAmortizationSelection selectedAmortization =
      BudgetingAmortizationSelection.none;

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripAsync = ref.watch(activeTripProvider);
    final accountsAsync = ref.watch(accountsProvider);
    final formState = ref.watch(transactionFormProvider);
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
        return AppSliverPage(
          title: 'Add expense',
          subtitle: trip?.name ?? 'No active trip',
          leading: const AppBackButton(),
          bottomNavigationBar: AppBottomActionBar(
            child: AppButton.primary(
              label: 'Save expense',
              expanded: true,
              loading: isBusy,
              onPressed: trip == null || selectedAccount == null
                  ? null
                  : () async {
                      final amount = parseBudgetingAmountInput(
                        amountController.text,
                      );
                      if (amount == null || amount <= 0) {
                        AppSnackBars.error(context, 'Enter a valid amount.');
                        return;
                      }

                      final saved = await ref
                          .read(transactionFormProvider.notifier)
                          .createExpense(
                            tripId: trip.id,
                            accountId: selectedAccount.id,
                            categoryId: selectedCategoryId,
                            amount: amount,
                            paidCurrency: selectedCurrency,
                            amortization: amortizationForBudgetingSelection(
                              selectedAmortization,
                            ),
                          );
                      if (!context.mounted) {
                        return;
                      }
                      if (saved) {
                        context.pop();
                      } else {
                        AppSnackBars.error(
                          context,
                          'Could not save the expense.',
                        );
                      }
                    },
            ),
          ),
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
                  if (accounts.isEmpty)
                    AppCard(
                      child: Text(
                        'Add an account before recording transactions.',
                        style: context.mutedText.bodyMedium,
                      ),
                    )
                  else ...[
                    const AppSectionHeader(title: 'Amount'),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: amountController,
                      autofocus: true,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: context.text.displaySmall,
                      decoration: InputDecoration(
                        hintText: '0',
                        suffixText: selectedCurrency,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.pageWithinSectionGap),
                    const AppSectionHeader(title: 'Account'),
                    const SizedBox(height: AppSpacing.md),
                    AppDropdown<String>(
                      value: selectedAccountId,
                      placeholder: const Text('Choose account'),
                      showNoneOption: false,
                      onChanged: (value) {
                        final account = accountsById[value];
                        if (account != null) {
                          setState(() {
                            selectedAccountId = account.id;
                            selectedCurrency = account.currency;
                          });
                        }
                      },
                      options: [
                        for (final account in accounts)
                          AppDropdownOption(
                            value: account.id,
                            child: Text(formatBudgetingAccountOption(account)),
                            selectedChild: Text(
                              formatBudgetingAccountOption(account),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.pageWithinSectionGap),
                    const AppSectionHeader(title: 'Currency'),
                    const SizedBox(height: AppSpacing.md),
                    AppDropdown<String>(
                      value: selectedCurrency,
                      showNoneOption: false,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedCurrency = value);
                        }
                      },
                      options: [
                        for (final option in kBudgetingCurrencyCatalog)
                          AppDropdownOption(
                            value: option.code,
                            child: Text(
                              formatBudgetingCurrencyOptionDetail(option),
                            ),
                            selectedChild: Text(
                              formatBudgetingCurrencyOption(option),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.pageWithinSectionGap),
                    const AppSectionHeader(title: 'Category'),
                    const SizedBox(height: AppSpacing.md),
                    AppDropdown<String>(
                      value: selectedCategoryId,
                      showNoneOption: false,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedCategoryId = value);
                        }
                      },
                      options: [
                        for (final category in kBudgetingDefaultCategories)
                          AppDropdownOption(
                            value: category.id,
                            child: Text(category.name),
                            selectedChild: Text(category.name),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.pageWithinSectionGap),
                    const AppSectionHeader(title: 'Amortization'),
                    const SizedBox(height: AppSpacing.md),
                    AppDropdown<BudgetingAmortizationSelection>(
                      value: selectedAmortization,
                      showNoneOption: false,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedAmortization = value);
                        }
                      },
                      options: [
                        for (final selection
                            in BudgetingAmortizationSelection.values)
                          AppDropdownOption(
                            value: selection,
                            child: Text(
                              formatBudgetingAmortizationSelection(selection),
                            ),
                            selectedChild: Text(
                              formatBudgetingAmortizationSelection(selection),
                            ),
                          ),
                      ],
                    ),
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
