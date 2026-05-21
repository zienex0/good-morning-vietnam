import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/currencies.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_formatters.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_key_value_row.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BudgetingTripFormFields extends StatelessWidget {
  const BudgetingTripFormFields({
    required this.nameController,
    required this.homeCurrency,
    required this.startDate,
    required this.endDate,
    required this.budgetController,
    required this.onCurrencyTap,
    required this.onStartDateTap,
    required this.onEndDateTap,
    required this.onClearEndDate,
    super.key,
  });

  final TextEditingController nameController;
  final CurrencyCode homeCurrency;
  final DateTime startDate;
  final DateTime? endDate;
  final TextEditingController budgetController;
  final VoidCallback onCurrencyTap;
  final VoidCallback onStartDateTap;
  final VoidCallback onEndDateTap;
  final VoidCallback onClearEndDate;

  @override
  Widget build(BuildContext context) {
    final currency = budgetingCurrencyByCode(homeCurrency);
    final dateFormat = DateFormat.yMMMd();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Trip name'),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppKeyValueRow(
          label: 'Home currency',
          value: formatBudgetingCurrencyTitle(currency),
          trailing: const Icon(Icons.unfold_more, size: AppSizes.iconSm),
          onTap: onCurrencyTap,
        ),
        AppKeyValueRow(
          label: 'Start date',
          value: dateFormat.format(startDate),
          trailing: const Icon(Icons.event, size: AppSizes.iconSm),
          onTap: onStartDateTap,
        ),
        AppKeyValueRow(
          label: 'End date',
          value: endDate == null ? 'Open ended' : dateFormat.format(endDate!),
          trailing: endDate == null
              ? const Icon(Icons.event, size: AppSizes.iconSm)
              : IconButton(
                  onPressed: onClearEndDate,
                  icon: const Icon(Icons.close, size: AppSizes.iconSm),
                ),
          onTap: onEndDateTap,
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: budgetController,
          decoration: InputDecoration(
            labelText: 'Total budget (${currency.code})',
            hintText: 'Optional',
            prefixText: '${currency.symbol} ',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    );
  }
}

Future<String?> pushBudgetingCurrencyPicker(
  BuildContext context, {
  required String selected,
  String title = 'Home currency',
}) {
  return context.push<String>(
    Uri(
      path: AppRoutes.selectCurrency,
      queryParameters: {'selected': selected, 'title': title},
    ).toString(),
  );
}

Future<DateTime?> pickBudgetingDate(
  BuildContext context, {
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );
}
