import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/result/failure_messages.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/budgeting_trip_form_controller.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/currencies.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_mappers.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_trip_form.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_back_button.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_bottom_action_bar.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_key_value_row.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_sliver_page.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_snack_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BudgetingAccountFormPage extends ConsumerStatefulWidget {
  const BudgetingAccountFormPage({super.key});

  @override
  ConsumerState<BudgetingAccountFormPage> createState() =>
      BudgetingAccountFormPageState();
}

class BudgetingAccountFormPageState
    extends ConsumerState<BudgetingAccountFormPage> {
  final nameController = TextEditingController();
  final openingBalanceController = TextEditingController(text: '0');
  AccountType type = AccountType.cash;
  String? currency;

  @override
  void dispose() {
    nameController.dispose();
    openingBalanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(budgetingTripFormControllerProvider, (
      previous,
      next,
    ) {
      if (next case AsyncError(:final error)) {
        final failure = error is Failure ? error : UnknownFailure(error);
        AppSnackBars.error(context, failureMessage(failure));
      }
    });

    final formState = ref.watch(budgetingTripFormControllerProvider);
    final activeTrip = ref.watch(activeTripProvider).valueOrNull;
    final effectiveCurrency = currency ?? activeTrip?.homeCurrency ?? 'USD';
    final currencyOption = budgetingCurrencyByCode(effectiveCurrency);

    return AppSliverPage(
      title: 'New account',
      leading: const AppBackButton(),
      bottomNavigationBar: AppBottomActionBar(
        child: FilledButton(
          onPressed: formState.isLoading || activeTrip == null
              ? null
              : () => _submit(activeTrip.id),
          child: Text(formState.isLoading ? 'Saving...' : 'Add account'),
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
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Account name'),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppKeyValueRow(
                  label: 'Currency',
                  value: formatBudgetingCurrencyTitle(currencyOption),
                  trailing: const Icon(
                    Icons.unfold_more,
                    size: AppSizes.iconSm,
                  ),
                  onTap: () async {
                    final picked = await pushBudgetingCurrencyPicker(
                      context,
                      selected: effectiveCurrency,
                      title: 'Account currency',
                    );
                    if (picked == null || !mounted) return;
                    setState(() => currency = picked);
                  },
                ),
                AppKeyValueRow(
                  label: 'Type',
                  value: budgetingAccountTypeLabel(type),
                  trailing: const Icon(
                    Icons.unfold_more,
                    size: AppSizes.iconSm,
                  ),
                  onTap: _pickType,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  controller: openingBalanceController,
                  decoration: InputDecoration(
                    labelText: 'Opening balance',
                    prefixText: '${currencyOption.symbol} ',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickType() async {
    final picked = await showModalBottomSheet<AccountType>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final value in AccountType.values)
              ListTile(
                leading: Icon(budgetingAccountIcon(value)),
                title: Text(budgetingAccountTypeLabel(value)),
                onTap: () => Navigator.of(context).pop(value),
              ),
          ],
        ),
      ),
    );
    if (picked == null || !mounted) return;
    setState(() => type = picked);
  }

  Future<void> _submit(String tripId) async {
    final amount = double.tryParse(openingBalanceController.text.trim()) ?? 0;
    final activeTrip = ref.read(activeTripProvider).valueOrNull;
    final created = await ref
        .read(budgetingTripFormControllerProvider.notifier)
        .createAccount(
          tripId: tripId,
          name: nameController.text,
          type: type,
          currency: currency ?? activeTrip?.homeCurrency ?? 'USD',
          openingBalance: amount,
        );
    if (!mounted || created == null) return;
    AppSnackBars.success(context, 'Account added.');
    context.go(AppRoutes.accounts);
  }
}
