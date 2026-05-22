import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/result/failure_messages.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/budgeting_transaction_form_controller.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/amortization.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/categories.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/currencies.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_category_selector.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_transaction_amount_section.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_transaction_empty_shell.dart';
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
  String? selectedAccountId;
  String? enteredCurrency;
  String selectedCategoryId = kBudgetingDefaultCategories.first.id;
  Amortization? amortization;

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

    final tripId = ref.watch(activeTripIdProvider);
    final accounts =
        ref.watch(accountsForActiveTripProvider).valueOrNull ?? const [];
    if (accounts.isEmpty || tripId == null) {
      return const BudgetingTransactionEmptyShell(title: 'Expense');
    }

    selectedAccountId ??= accounts.first.id;
    final account = accounts.firstWhere(
      (account) => account.id == selectedAccountId,
      orElse: () => accounts.first,
    );
    selectedAccountId = account.id;
    enteredCurrency ??= account.currency;
    final currency = budgetingCurrencyByCode(enteredCurrency!);
    final formState = ref.watch(budgetingTransactionFormControllerProvider);
    final amount = double.tryParse(amountController.text) ?? 0;

    return AppSliverPage(
      title: 'Expense',
      leading: const AppBackButton(),
      bottomNavigationBar: AppBottomActionBar(
        child: FilledButton(
          onPressed: formState.isLoading || amount <= 0
              ? null
              : () => _submit(tripId, account, amount),
          child: Text(
            formatBudgetingPrimaryAction(
              action: formState.isLoading ? 'Saving...' : 'Add expense',
              amount: amountController.text,
              currencyCode: enteredCurrency!,
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
                onTap: () => _pickAccount(account, accounts),
              ),
              AppKeyValueRow(
                label: 'Exchange from',
                value: formatBudgetingExchangeTitle(
                  enteredCurrency: currency,
                  account: account,
                ),
                trailing: const Icon(Icons.unfold_more, size: AppSizes.iconSm),
                onTap: _pickCurrency,
              ),
              AppKeyValueRow(
                label: 'Spread over',
                value: formatAmortizationRowValue(amortization),
                trailing: const Icon(Icons.unfold_more, size: AppSizes.iconSm),
                onTap: _pickAmortization,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Category', style: context.labelStrong),
              const SizedBox(height: AppSpacing.md),
              BudgetingCategorySelector(
                selectedCategoryId: selectedCategoryId,
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

  Future<void> _submit(String tripId, Account account, double amount) async {
    final created = await ref
        .read(budgetingTransactionFormControllerProvider.notifier)
        .createExpense(
          tripId: tripId,
          accountId: account.id,
          categoryId: selectedCategoryId,
          amount: amount,
          amountCurrency: enteredCurrency,
          amortization: amortization,
        );
    if (!context.mounted || !created) return;
    AppSnackBars.success(context, 'Expense saved.');
    context.pop();
  }

  Future<void> _pickAccount(Account current, List<Account> accounts) async {
    final result = await context.push<String>(
      Uri(
        path: AppRoutes.selectAccount,
        queryParameters: {
          'selected': current.id,
          'title': 'Payment source',
        },
      ).toString(),
    );
    if (result == null || !mounted) return;
    final picked = accounts.firstWhere(
      (account) => account.id == result,
      orElse: () => current,
    );
    setState(() {
      selectedAccountId = picked.id;
      if (enteredCurrency == current.currency) {
        enteredCurrency = picked.currency;
      }
    });
  }

  Future<void> _pickCurrency() async {
    final result = await context.push<String>(
      Uri(
        path: AppRoutes.selectCurrency,
        queryParameters: {
          'selected': enteredCurrency!,
          'title': 'Exchange currency',
        },
      ).toString(),
    );
    if (result == null || !mounted) return;
    setState(() => enteredCurrency = result);
  }

  Future<void> _pickAmortization() async {
    final result = await context.push<String>(
      Uri(
        path: AppRoutes.selectAmortization,
        queryParameters: {
          'enabled': (amortization != null).toString(),
          if (amortization != null) 'unit': amortization!.unit.name,
          if (amortization != null) 'count': amortization!.count.toString(),
          'amount': amountController.text,
          'currency': enteredCurrency!,
        },
      ).toString(),
    );
    if (result == null || !mounted) return;
    setState(() => amortization = decodeAmortizationResult(result));
  }
}
