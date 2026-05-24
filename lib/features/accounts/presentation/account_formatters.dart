import 'package:flutter_foundation_kit/features/transactions/presentation/transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/trips/domain/currencies.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';

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

String formatBudgetingCurrencyOption(CurrencyOption option) {
  return '${option.flag} ${option.code}';
}

String formatBudgetingCurrencyOptionDetail(CurrencyOption option) {
  return '${option.flag} ${option.code} - ${option.name}';
}
