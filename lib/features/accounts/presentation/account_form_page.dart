import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/accounts/application/trip_account_form_provider.dart';
import 'package:flutter_foundation_kit/features/accounts/presentation/widgets/account_details_step_page.dart';
import 'package:flutter_foundation_kit/features/accounts/presentation/widgets/account_name_step_page.dart';
import 'package:flutter_foundation_kit/features/trips/application/active_trip_provider.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_step_page_view.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccountFormPage extends ConsumerStatefulWidget {
  const AccountFormPage({super.key});

  @override
  ConsumerState<AccountFormPage> createState() => AccountFormPageState();
}

class AccountFormPageState extends ConsumerState<AccountFormPage> {
  final stepPageKey = GlobalKey<AppStepPageViewState>();
  final nameController = TextEditingController();
  final balanceController = TextEditingController();
  bool initializedCurrency = false;
  String selectedCurrency = 'USD';
  int currentPage = 0;

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
        if (!initializedCurrency && trip != null) {
          initializedCurrency = true;
          selectedCurrency = trip.homeCurrency;
        }

        return AppStepPageView(
          key: stepPageKey,
          initialPage: currentPage,
          leading: const AppBackButton(),
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (value) => setState(() => currentPage = value),
          titles: const [Text('Account name'), Text('Account details')],
          bottomNavigationBar: AppBottomActionBar(
            child: Row(
              children: [
                AppButton.text(
                  label: 'Back',
                  onPressed: isBusy ? null : handleBackPressed,
                ),
                const Spacer(),
                AppButton.primary(
                  label: currentPage == 0 ? 'Next' : 'Add account',
                  loading: isBusy,
                  onPressed: trip == null
                      ? null
                      : () => handlePrimaryPressed(trip.id),
                ),
              ],
            ),
          ),
          pagesSlivers: [
            [
              AccountNameStepPage(
                nameController: nameController,
                autofocus: true,
              ),
            ],
            [
              AccountDetailsStepPage(
                selectedCurrency: selectedCurrency,
                balanceController: balanceController,
                onCurrencyChanged: (value) {
                  setState(() => selectedCurrency = value);
                },
              ),
            ],
          ],
        );
      },
    );
  }

  Future<void> handlePrimaryPressed(String tripId) async {
    if (!validateCurrentPage()) {
      return;
    }

    if (currentPage == 0) {
      await stepPageKey.currentState?.incrementPageIndex();
      return;
    }

    await saveAccount(tripId);
  }

  Future<void> handleBackPressed() async {
    if (currentPage == 0) {
      context.pop();
      return;
    }
    await stepPageKey.currentState?.decrementPageIndex();
  }

  bool validateCurrentPage() {
    if (currentPage == 0 && nameController.text.trim().isEmpty) {
      AppSnackBars.error(context, 'Account name is required.');
      return false;
    }

    if (currentPage == 1 &&
        parseBudgetingAmountInput(balanceController.text) == null) {
      AppSnackBars.error(context, 'Enter a valid balance.');
      return false;
    }

    return true;
  }

  Future<void> saveAccount(String tripId) async {
    final openingBalance = parseBudgetingAmountInput(balanceController.text);
    if (openingBalance == null) {
      AppSnackBars.error(context, 'Enter a valid balance.');
      return;
    }

    final account = await ref
        .read(accountFormProvider.notifier)
        .createAccount(
          tripId: tripId,
          name: nameController.text,
          currency: selectedCurrency,
          openingBalance: openingBalance,
        );
    if (!mounted) {
      return;
    }
    if (account != null) {
      context.pop();
    } else {
      AppSnackBars.error(context, 'Could not create the account.');
    }
  }
}
