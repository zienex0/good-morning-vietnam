import 'package:flutter_foundation_kit/features/budgeting/domain/currencies.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_home_formatters.dart';

String formatBudgetingAccountCurrency(CurrencyCode currency) {
  final option = budgetingCurrencyByCode(currency);
  return '${option.flag} ${option.code}';
}

String formatBudgetingAccountHomeBalance({
  required double amount,
  required CurrencyCode homeCurrency,
}) {
  return '${formatBudgetingMoney(amount, homeCurrency)} in $homeCurrency';
}

String formatBudgetingAccountLocalBalance({
  required double amount,
  required CurrencyCode currency,
}) {
  return formatBudgetingMoney(amount, currency);
}

double? parseBudgetingAmountInput(String value) {
  final normalized = value.trim().replaceAll(',', '.');
  if (normalized.isEmpty) {
    return 0;
  }
  return double.tryParse(normalized);
}

String formatBudgetingCurrencyOption(CurrencyOption option) {
  return '${option.flag} ${option.code}';
}

String formatBudgetingCurrencyOptionDetail(CurrencyOption option) {
  return '${option.flag} ${option.code} - ${option.name}';
}
