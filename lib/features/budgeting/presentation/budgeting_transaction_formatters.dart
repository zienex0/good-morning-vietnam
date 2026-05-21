import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_mock_data.dart';

String formatBudgetingPrimaryAction({
  required String action,
  required String amount,
  required String currencyCode,
}) {
  final parsed = double.tryParse(amount);
  if (parsed == null || parsed <= 0) {
    return action;
  }
  final cleanAmount = parsed % 1 == 0
      ? parsed.toStringAsFixed(0)
      : parsed.toStringAsFixed(2);
  return '$action $cleanAmount $currencyCode';
}

String formatBudgetingAccountTitle(MockBudgetingAccountOption account) {
  return '${account.name} • ${account.currency}';
}

String formatBudgetingCurrencyTitle(MockCurrencyOption currency) {
  return '${currency.flag} ${currency.code}';
}

String formatBudgetingExchangeTitle({
  required MockCurrencyOption enteredCurrency,
  required MockBudgetingAccountOption account,
}) {
  if (enteredCurrency.code == account.currency) {
    return 'Same as ${account.currency}';
  }
  return '${enteredCurrency.code} → ${account.currency}';
}
