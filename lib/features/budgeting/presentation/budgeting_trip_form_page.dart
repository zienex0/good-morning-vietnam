import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/result/failure_messages.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/budgeting_trip_form_controller.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_trip_form.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_back_button.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_bottom_action_bar.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_sliver_page.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_snack_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BudgetingTripFormPage extends ConsumerStatefulWidget {
  const BudgetingTripFormPage({super.key});

  @override
  ConsumerState<BudgetingTripFormPage> createState() =>
      BudgetingTripFormPageState();
}

class BudgetingTripFormPageState extends ConsumerState<BudgetingTripFormPage> {
  final nameController = TextEditingController();
  final budgetController = TextEditingController();
  String homeCurrency = 'USD';
  late DateTime startDate = DateTime.now();
  DateTime? endDate;

  @override
  void dispose() {
    nameController.dispose();
    budgetController.dispose();
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

    return AppSliverPage(
      title: 'New trip',
      leading: const AppBackButton(),
      bottomNavigationBar: AppBottomActionBar(
        child: FilledButton(
          onPressed: formState.isLoading ? null : _submit,
          child: Text(formState.isLoading ? 'Saving...' : 'Start trip'),
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
            child: BudgetingTripFormFields(
              nameController: nameController,
              homeCurrency: homeCurrency,
              startDate: startDate,
              endDate: endDate,
              budgetController: budgetController,
              onCurrencyTap: _pickCurrency,
              onStartDateTap: _pickStartDate,
              onEndDateTap: _pickEndDate,
              onClearEndDate: () => setState(() => endDate = null),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickCurrency() async {
    final result = await pushBudgetingCurrencyPicker(
      context,
      selected: homeCurrency,
    );
    if (result == null || !mounted) return;
    setState(() => homeCurrency = result);
  }

  Future<void> _pickStartDate() async {
    final picked = await pickBudgetingDate(
      context,
      initialDate: startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() {
      startDate = picked;
      if (endDate != null && endDate!.isBefore(picked)) {
        endDate = null;
      }
    });
  }

  Future<void> _pickEndDate() async {
    final picked = await pickBudgetingDate(
      context,
      initialDate: endDate ?? startDate.add(const Duration(days: 14)),
      firstDate: startDate,
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() => endDate = picked);
  }

  Future<void> _submit() async {
    final budgetText = budgetController.text.trim();
    final budget = budgetText.isEmpty ? null : double.tryParse(budgetText);
    final trip = await ref
        .read(budgetingTripFormControllerProvider.notifier)
        .createTrip(
          name: nameController.text,
          homeCurrency: homeCurrency,
          startDate: startDate,
          endDate: endDate,
          budgetTotal: budget,
        );
    if (!mounted || trip == null) return;
    AppSnackBars.success(context, 'Trip created.');
    context.go(AppRoutes.home);
  }
}
