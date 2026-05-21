import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/result/failure_messages.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/budgeting_transaction_form_controller.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/currencies.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_transaction_amount_section.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_transaction_empty_shell.dart';
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
  final destAmountController = TextEditingController();
  String? sourceAccountId;
  String? destAccountId;

  @override
  void dispose() {
    amountController.dispose();
    destAmountController.dispose();
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
    if (accounts.length < 2 || tripId == null) {
      return const BudgetingTransactionEmptyShell(title: 'Transfer');
    }

    sourceAccountId ??= accounts.first.id;
    destAccountId ??=
        accounts.firstWhere((account) => account.id != sourceAccountId).id;

    final sourceAccount = accounts.firstWhere(
      (account) => account.id == sourceAccountId,
      orElse: () => accounts.first,
    );
    final destAccount = accounts.firstWhere(
      (account) => account.id == destAccountId,
      orElse: () => accounts.firstWhere(
        (account) => account.id != sourceAccount.id,
        orElse: () => accounts.first,
      ),
    );
    sourceAccountId = sourceAccount.id;
    destAccountId = destAccount.id;

    final currency = budgetingCurrencyByCode(sourceAccount.currency);
    final destCurrency = budgetingCurrencyByCode(destAccount.currency);
    final formState = ref.watch(budgetingTransactionFormControllerProvider);
    final amount = double.tryParse(amountController.text) ?? 0;
    final destAmountText = destAmountController.text.trim();
    final destAmount =
        destAmountText.isEmpty ? null : double.tryParse(destAmountText);
    final isCrossCurrency = sourceAccount.currency != destAccount.currency;

    return AppSliverPage(
      title: 'Transfer',
      leading: const AppBackButton(),
      bottomNavigationBar: AppBottomActionBar(
        child: FilledButton(
          onPressed: formState.isLoading || amount <= 0
              ? null
              : () => _submit(
                    tripId,
                    sourceAccount,
                    destAccount,
                    amount,
                    destAmount,
                  ),
          child: Text(
            formatBudgetingPrimaryAction(
              action: formState.isLoading ? 'Saving...' : 'Transfer',
              amount: amountController.text,
              currencyCode: sourceAccount.currency,
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
                label: 'From',
                value: formatBudgetingAccountTitle(sourceAccount),
                trailing: const Icon(Icons.unfold_more, size: AppSizes.iconSm),
                onTap: () => _pickSource(sourceAccount, destAccount, accounts),
              ),
              AppKeyValueRow(
                label: 'To',
                value: formatBudgetingAccountTitle(destAccount),
                trailing: const Icon(Icons.unfold_more, size: AppSizes.iconSm),
                onTap: () => _pickDest(sourceAccount, destAccount, accounts),
              ),
              if (isCrossCurrency) ...[
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  controller: destAmountController,
                  decoration: InputDecoration(
                    labelText:
                        'Received in ${destAccount.currency} (optional)',
                    hintText:
                        'Leave blank to use market rate at ${formatBudgetingCurrencyTitle(destCurrency)}',
                    prefixText: '${destCurrency.symbol} ',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => setState(() {}),
                ),
              ],
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

  Future<void> _submit(
    String tripId,
    Account source,
    Account dest,
    double amount,
    double? destAmount,
  ) async {
    final created = await ref
        .read(budgetingTransactionFormControllerProvider.notifier)
        .createTransfer(
          tripId: tripId,
          sourceAccountId: source.id,
          destAccountId: dest.id,
          amount: amount,
          destAmount: destAmount,
        );
    if (!context.mounted || !created) return;
    AppSnackBars.success(context, 'Transfer saved.');
    context.pop();
  }

  Future<void> _pickSource(
    Account source,
    Account dest,
    List<Account> accounts,
  ) async {
    final result = await context.push<String>(
      Uri(
        path: AppRoutes.selectAccount,
        queryParameters: {
          'selected': source.id,
          'excluded': dest.id,
          'title': 'Transfer from',
        },
      ).toString(),
    );
    if (result == null || !mounted) return;
    setState(() {
      sourceAccountId = result;
      if (result == destAccountId) {
        destAccountId = accounts
            .firstWhere(
              (account) => account.id != result,
              orElse: () => accounts.first,
            )
            .id;
      }
      destAmountController.clear();
    });
  }

  Future<void> _pickDest(
    Account source,
    Account dest,
    List<Account> accounts,
  ) async {
    final result = await context.push<String>(
      Uri(
        path: AppRoutes.selectAccount,
        queryParameters: {
          'selected': dest.id,
          'excluded': source.id,
          'title': 'Transfer to',
        },
      ).toString(),
    );
    if (result == null || !mounted) return;
    setState(() {
      destAccountId = result;
      destAmountController.clear();
    });
  }
}
