import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/budgeting_trip_form_controller.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/currencies.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_mappers.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_trip_form.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_key_value_row.dart';
import 'package:flutter_foundation_kit/shared/widgets/section_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BudgetingSettingsTripSection extends ConsumerWidget {
  const BudgetingSettingsTripSection({required this.trip, super.key});

  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat.yMMMd();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(title: 'trip'),
        const SizedBox(height: AppSpacing.lg),
        AppKeyValueRow(
          label: 'name',
          value: trip.name,
          trailing: const Icon(Icons.edit, size: AppSizes.iconSm),
          onTap: () => _editName(context, ref, trip),
        ),
        AppKeyValueRow(
          label: 'home currency',
          value: formatBudgetingCurrencyTitle(
            budgetingCurrencyByCode(trip.homeCurrency),
          ),
          trailing: const Icon(Icons.unfold_more, size: AppSizes.iconSm),
          onTap: () => _editHomeCurrency(context, ref, trip),
        ),
        AppKeyValueRow(
          label: 'start date',
          value: dateFormat.format(trip.startDate),
          trailing: const Icon(Icons.event, size: AppSizes.iconSm),
          onTap: () => _editStartDate(context, ref, trip),
        ),
        AppKeyValueRow(
          label: 'end date',
          value: trip.endDate == null
              ? 'Open ended'
              : dateFormat.format(trip.endDate!),
          trailing: const Icon(Icons.event, size: AppSizes.iconSm),
          onTap: () => _editEndDate(context, ref, trip),
        ),
      ],
    );
  }

  Future<void> _editName(BuildContext context, WidgetRef ref, Trip trip) async {
    final controller = TextEditingController(text: trip.name);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Trip name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result == null || result.isEmpty) return;
    await ref
        .read(budgetingTripFormControllerProvider.notifier)
        .editTrip(trip.copyWith(name: result));
  }

  Future<void> _editHomeCurrency(
    BuildContext context,
    WidgetRef ref,
    Trip trip,
  ) async {
    final picked = await pushBudgetingCurrencyPicker(
      context,
      selected: trip.homeCurrency,
    );
    if (picked == null) return;
    await ref
        .read(budgetingTripFormControllerProvider.notifier)
        .editTrip(trip.copyWith(homeCurrency: picked));
  }

  Future<void> _editStartDate(
    BuildContext context,
    WidgetRef ref,
    Trip trip,
  ) async {
    final picked = await pickBudgetingDate(
      context,
      initialDate: trip.startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    var endDate = trip.endDate;
    if (endDate != null && endDate.isBefore(picked)) {
      endDate = null;
    }
    await ref
        .read(budgetingTripFormControllerProvider.notifier)
        .editTrip(trip.copyWith(startDate: picked, endDate: endDate));
  }

  Future<void> _editEndDate(
    BuildContext context,
    WidgetRef ref,
    Trip trip,
  ) async {
    final picked = await pickBudgetingDate(
      context,
      initialDate: trip.endDate ?? trip.startDate.add(const Duration(days: 14)),
      firstDate: trip.startDate,
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    await ref
        .read(budgetingTripFormControllerProvider.notifier)
        .editTrip(trip.copyWith(endDate: picked));
  }
}

class BudgetingSettingsBudgetSection extends ConsumerWidget {
  const BudgetingSettingsBudgetSection({required this.trip, super.key});

  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = trip.budgetTotal == null
        ? 'No cap'
        : formatBudgetingHomeMoney(trip.budgetTotal!, trip.homeCurrency);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(title: 'budget'),
        const SizedBox(height: AppSpacing.lg),
        AppKeyValueRow(
          label: 'total budget',
          value: value,
          trailing: const Icon(Icons.edit, size: AppSizes.iconSm),
          onTap: () => _editBudget(context, ref, trip),
        ),
      ],
    );
  }

  Future<void> _editBudget(
    BuildContext context,
    WidgetRef ref,
    Trip trip,
  ) async {
    final controller = TextEditingController(
      text: trip.budgetTotal?.toStringAsFixed(0) ?? '',
    );
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Trip budget (${trip.homeCurrency})'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Total budget'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop('CLEAR'),
            child: const Text('Clear'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result == null) return;
    if (result == 'CLEAR') {
      await ref
          .read(budgetingTripFormControllerProvider.notifier)
          .editTrip(trip.copyWith(budgetTotal: null));
      return;
    }
    final parsed = double.tryParse(result);
    if (parsed == null) return;
    await ref
        .read(budgetingTripFormControllerProvider.notifier)
        .editTrip(trip.copyWith(budgetTotal: parsed));
  }
}

class BudgetingSettingsDangerSection extends ConsumerWidget {
  const BudgetingSettingsDangerSection({required this.trip, super.key});

  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(title: 'danger zone'),
        const SizedBox(height: AppSpacing.lg),
        OutlinedButton.icon(
          onPressed: () => _changeStatus(context, ref, trip),
          icon: const Icon(Icons.flag_outlined),
          label: Text('status: ${budgetingTripStatusLabel(trip.status)}'),
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: () => _delete(context, ref, trip),
          icon: const Icon(Icons.delete_outline),
          label: const Text('delete trip'),
        ),
      ],
    );
  }

  Future<void> _changeStatus(
    BuildContext context,
    WidgetRef ref,
    Trip trip,
  ) async {
    final picked = await showModalBottomSheet<TripStatus>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final status in TripStatus.values)
              ListTile(
                leading: Icon(
                  status == trip.status
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                ),
                title: Text(budgetingTripStatusLabel(status)),
                onTap: () => Navigator.of(context).pop(status),
              ),
          ],
        ),
      ),
    );
    if (picked == null || picked == trip.status) return;
    await ref
        .read(budgetingTripFormControllerProvider.notifier)
        .changeStatus(tripId: trip.id, status: picked);
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Trip trip) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete "${trip.name}"?'),
        content: const Text(
          'This removes the trip, its accounts, and its transactions. '
          'There is no undo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final deleted = await ref
        .read(budgetingTripFormControllerProvider.notifier)
        .deleteTrip(tripId: trip.id);
    if (!context.mounted || !deleted) return;
    context.go(AppRoutes.onboarding);
  }
}
