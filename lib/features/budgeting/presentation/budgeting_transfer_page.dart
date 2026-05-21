import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/result/failure_messages.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/budgeting_transaction_form_controller.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_mock_data.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_transaction_amount_section.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_transaction_summary_panel.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_back_button.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_bottom_action_bar.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_key_value_row.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_sliver_page.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_snack_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BudgetingTransferPage extends ConsumerStatefulWidget {
  const BudgetingTransferPage({super.key});

  @override
  ConsumerState<BudgetingTransferPage> createState() =>
      BudgetingTransferPageState();
}

class BudgetingTransferPageState extends ConsumerState<BudgetingTransferPage> {
  final amountController = TextEditingController(text: '50');
  String selectedCurrency = mockHomeCurrency;
  String sourceAccountId = mockDefaultAccountId;
  String destAccountId = mockDefaultTransferDestAccountId;

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

    final currency = mockBudgetingCurrencyByCode(selectedCurrency);
    final sourceAccount = mockBudgetingAccountById(sourceAccountId);
    final destAccount = mockBudgetingAccountById(destAccountId);
    final formState = ref.watch(budgetingTransactionFormControllerProvider);
    final amount = double.tryParse(amountController.text) ?? 0;

    return AppSliverPage(
      title: 'Transfer',
      leading: const AppBackButton(),
      bottomNavigationBar: AppBottomActionBar(
        child: FilledButton(
          onPressed: formState.isLoading || amount <= 0
              ? null
              : () async {
                  final created = await ref
                      .read(budgetingTransactionFormControllerProvider.notifier)
                      .createTransfer(
                        tripId: mockTripId,
                        sourceAccountId: sourceAccountId,
                        destAccountId: destAccountId,
                        amount: amount,
                      );
                  if (!context.mounted || !created) {
                    return;
                  }
                  AppSnackBars.success(context, 'Transfer saved.');
                  context.pop();
                },
          child: Text(
            formatBudgetingPrimaryAction(
              action: formState.isLoading ? 'Saving...' : 'Transfer',
              amount: amountController.text,
              currencyCode: selectedCurrency,
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
                label: 'Currency',
                value: formatBudgetingCurrencyTitle(currency),
                trailing: const Icon(Icons.unfold_more, size: AppSizes.iconSm),
                onTap: () async {
                  final result = await context.push<String>(
                    Uri(
                      path: AppRoutes.selectCurrency,
                      queryParameters: {'selected': selectedCurrency},
                    ).toString(),
                  );
                  if (result == null) {
                    return;
                  }
                  final matchingAccount = mockBudgetingFirstAccountForCurrency(
                    result,
                  );
                  final fallbackDest = mockBudgetingFirstAccountExcept(
                    matchingAccount.id,
                  );
                  setState(() {
                    selectedCurrency = result;
                    sourceAccountId = matchingAccount.id;
                    if (destAccountId == matchingAccount.id) {
                      destAccountId = fallbackDest.id;
                    }
                  });
                },
              ),
              AppKeyValueRow(
                label: 'From',
                value: formatBudgetingAccountTitle(sourceAccount),
                trailing: const Icon(Icons.unfold_more, size: AppSizes.iconSm),
                onTap: () async {
                  final result = await context.push<String>(
                    Uri(
                      path: AppRoutes.selectAccount,
                      queryParameters: {
                        'selected': sourceAccountId,
                        'excluded': destAccountId,
                        'title': 'Transfer from',
                      },
                    ).toString(),
                  );
                  if (result == null) {
                    return;
                  }
                  final selectedAccount = mockBudgetingAccountById(result);
                  setState(() {
                    sourceAccountId = result;
                    selectedCurrency = selectedAccount.currency;
                  });
                },
              ),
              AppKeyValueRow(
                label: 'To',
                value: formatBudgetingAccountTitle(destAccount),
                trailing: const Icon(Icons.unfold_more, size: AppSizes.iconSm),
                onTap: () async {
                  final result = await context.push<String>(
                    Uri(
                      path: AppRoutes.selectAccount,
                      queryParameters: {
                        'selected': destAccountId,
                        'excluded': sourceAccountId,
                        'title': 'Transfer to',
                      },
                    ).toString(),
                  );
                  if (result == null) {
                    return;
                  }
                  setState(() {
                    destAccountId = result;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              const BudgetingTransactionSummaryPanel(
                icon: Icons.swap_horiz,
                title: 'Move money',
                body: 'Records money moving between two trip accounts.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
