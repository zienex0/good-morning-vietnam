import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/accounts/application/trip_account_form_provider.dart';
import 'package:flutter_foundation_kit/features/accounts/presentation/account_formatters.dart';
import 'package:flutter_foundation_kit/features/trips/application/active_trip_provider.dart';
import 'package:flutter_foundation_kit/features/trips/domain/currencies.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccountFormPage extends ConsumerStatefulWidget {
  const AccountFormPage({super.key});

  @override
  ConsumerState<AccountFormPage> createState() => AccountFormPageState();
}

class AccountFormPageState extends ConsumerState<AccountFormPage> {
  final nameController = TextEditingController();
  final balanceController = TextEditingController();
  String selectedCurrency = 'USD';

  @override
  void dispose() {
    nameController.dispose();
    balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripAsync = ref.watch(activeTripProvider);
    final formState = ref.watch(accountFormProvider);
    final isBusy = formState.isLoading;

    return AppAsyncValueView(
      value: tripAsync,
      onRetry: () => ref.invalidate(activeTripProvider),
      data: (trip) {
        return AppSliverPage(
          title: 'Add account',
          subtitle: trip?.name ?? 'No active trip',
          leading: const AppBackButton(),
          bottomNavigationBar: AppBottomActionBar(
            child: AppButton.primary(
              label: 'Add',
              expanded: true,
              loading: isBusy,
              onPressed: trip == null
                  ? null
                  : () async {
                      final openingBalance = parseBudgetingAmountInput(
                        balanceController.text,
                      );
                      if (openingBalance == null) {
                        AppSnackBars.error(context, 'Enter a valid balance.');
                        return;
                      }

                      final account = await ref
                          .read(accountFormProvider.notifier)
                          .createAccount(
                            tripId: trip.id,
                            name: nameController.text,
                            currency: selectedCurrency,
                            openingBalance: openingBalance,
                          );
                      if (account != null && context.mounted) {
                        context.pop();
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
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    style: context.text.displaySmall,
                    decoration: const InputDecoration(
                      hintText: 'Account name',
                      border: InputBorder.none,
                    ),
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
                  const AppSectionHeader(title: 'Starting balance'),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: balanceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: context.text.headlineMedium,
                    decoration: InputDecoration(
                      hintText: '0',
                      suffixText: selectedCurrency,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
