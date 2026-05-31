import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/accounts/application/trip_accounts_provider.dart';
import 'package:flutter_foundation_kit/features/accounts/domain/account.dart';
import 'package:flutter_foundation_kit/core/result/failure_messages.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/transactions/application/transactions_controller.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/trips/application/active_trip_provider.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TransferFormPage extends ConsumerStatefulWidget {
  const TransferFormPage({super.key});

  @override
  ConsumerState<TransferFormPage> createState() => TransferFormPageState();
}

class TransferFormPageState extends ConsumerState<TransferFormPage> {
  final amountController = TextEditingController();
  final receivedAmountController = TextEditingController();
  late TextEditingController activeAmountController;
  String? sourceAccountId;
  String? destinationAccountId;

  @override
  void initState() {
    super.initState();
    activeAmountController = amountController;
  }

  @override
  void dispose() {
    amountController.dispose();
    receivedAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripAsync = ref.watch(activeTripProvider);
    final accountsAsync = ref.watch(accountsControllerProvider);
    final formState = ref.watch(transactionsControllerProvider);
    final accounts = accountsAsync.value ?? const <Account>[];

    if (sourceAccountId == null && accounts.isNotEmpty) {
      sourceAccountId = accounts.first.id;
    }
    if (destinationAccountId == null && accounts.length > 1) {
      destinationAccountId = accounts[1].id;
    }

    final accountsById = {for (final account in accounts) account.id: account};
    final sourceAccount = accountsById[sourceAccountId];
    final destinationAccount = accountsById[destinationAccountId];
    final isBusy = formState.isLoading;
    final isCrossCurrency =
        sourceAccount != null &&
        destinationAccount != null &&
        sourceAccount.currency != destinationAccount.currency;
    if (!isCrossCurrency &&
        activeAmountController == receivedAmountController) {
      activeAmountController = amountController;
    }

    return AppAsyncValueView(
      value: tripAsync,
      onRetry: () => ref.invalidate(activeTripProvider),
      data: (trip) {
        return AppSliverPage(
          title: 'Add transfer',
          subtitle: trip?.name ?? 'No active trip',
          leading: const AppBackButton(),
          bottomNavigationBar: AppBottomActionBar(
            child: AppButton.primary(
              label: 'Save transfer',
              expanded: true,
              loading: isBusy,
              onPressed:
                  trip == null ||
                      sourceAccount == null ||
                      destinationAccount == null
                  ? null
                  : () async {
                      final amount = parseBudgetingAmountInput(
                        amountController.text,
                      );
                      final receivedAmount = parseBudgetingAmountInput(
                        receivedAmountController.text,
                      );
                      if (amount == null || amount <= 0) {
                        AppSnackBars.error(context, 'Enter a valid amount.');
                        return;
                      }
                      if (sourceAccount.id == destinationAccount.id) {
                        AppSnackBars.error(
                          context,
                          'Choose two different accounts.',
                        );
                        return;
                      }
                      if (isCrossCurrency &&
                          receivedAmountController.text.trim().isNotEmpty &&
                          (receivedAmount == null || receivedAmount <= 0)) {
                        AppSnackBars.error(
                          context,
                          'Enter a valid received amount.',
                        );
                        return;
                      }

                      final saved = await ref
                          .read(transactionsControllerProvider.notifier)
                          .createTransfer(
                            tripId: trip.id,
                            sourceAccountId: sourceAccount.id,
                            destAccountId: destinationAccount.id,
                            amount: amount,
                            destAmount:
                                isCrossCurrency &&
                                    receivedAmountController.text
                                        .trim()
                                        .isNotEmpty
                                ? receivedAmount
                                : null,
                          );
                      if (!context.mounted) {
                        return;
                      }
                      switch (saved) {
                        case Ok():
                          context.pop();
                        case Err(failure: final failure):
                          AppSnackBars.error(
                            context,
                            failureMessage(failure),
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
                AppSpacing.none,
              ),
              sliver: SliverList.list(
                children: [
                  if (accounts.length < 2)
                    AppCard(
                      child: Text(
                        'Add at least two accounts before transferring.',
                        style: context.mutedText.bodyMedium,
                      ),
                    )
                  else ...[
                    AppCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              sourceAccount == null
                                  ? 'From account'
                                  : formatBudgetingAccountOption(sourceAccount),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.labelLarge,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                            ),
                            child: Icon(Icons.arrow_forward_rounded),
                          ),
                          Expanded(
                            child: Text(
                              destinationAccount == null
                                  ? 'To account'
                                  : formatBudgetingAccountOption(
                                      destinationAccount,
                                    ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: context.text.labelLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.pageWithinSectionGap),
                    const AppSectionHeader(title: 'Amount'),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: amountController,
                      readOnly: true,
                      showCursor: true,
                      style: context.text.displaySmall,
                      onTap: () {
                        setState(
                          () => activeAmountController = amountController,
                        );
                      },
                      decoration: InputDecoration(
                        labelText: 'From amount',
                        hintText: '0',
                        suffixText: sourceAccount?.currency ?? '',
                      ),
                    ),
                    if (isCrossCurrency) ...[
                      const SizedBox(height: AppSpacing.md),
                      TextField(
                        controller: receivedAmountController,
                        readOnly: true,
                        showCursor: true,
                        style: context.text.displaySmall,
                        onTap: () {
                          setState(
                            () => activeAmountController =
                                receivedAmountController,
                          );
                        },
                        decoration: InputDecoration(
                          labelText: 'Received amount',
                          hintText: '0',
                          suffixText: destinationAccount.currency,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.pageWithinSectionGap),
                    const AppSectionHeader(title: 'From account'),
                    const SizedBox(height: AppSpacing.md),
                    AppDropdown<String>(
                      value: sourceAccountId,
                      placeholder: const Text('Choose source account'),
                      showNoneOption: false,
                      onChanged: (value) {
                        setState(() => sourceAccountId = value);
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
                    const AppSectionHeader(title: 'To account'),
                    const SizedBox(height: AppSpacing.md),
                    AppDropdown<String>(
                      value: destinationAccountId,
                      placeholder: const Text('Choose destination account'),
                      showNoneOption: false,
                      onChanged: (value) {
                        setState(() => destinationAccountId = value);
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
                  ],
                ],
              ),
            ),
            if (accounts.length >= 2)
              SliverFillRemaining(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.page,
                  ),
                  child: AppNumpad(controller: activeAmountController),
                ),
              ),
          ],
        );
      },
    );
  }
}
