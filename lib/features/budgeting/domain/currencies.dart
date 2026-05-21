import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';

class CurrencyOption {
  const CurrencyOption({
    required this.code,
    required this.symbol,
    required this.flag,
    required this.name,
  });

  final CurrencyCode code;
  final String symbol;
  final String flag;
  final String name;
}

const List<CurrencyOption> kBudgetingCurrencyCatalog = [
  CurrencyOption(code: 'USD', symbol: r'$', flag: '🇺🇸', name: 'US dollar'),
  CurrencyOption(code: 'EUR', symbol: '€', flag: '🇪🇺', name: 'Euro'),
  CurrencyOption(code: 'GBP', symbol: '£', flag: '🇬🇧', name: 'British pound'),
  CurrencyOption(code: 'JPY', symbol: '¥', flag: '🇯🇵', name: 'Japanese yen'),
  CurrencyOption(code: 'PLN', symbol: 'zł', flag: '🇵🇱', name: 'Polish złoty'),
  CurrencyOption(code: 'VND', symbol: '₫', flag: '🇻🇳', name: 'Vietnamese dong'),
  CurrencyOption(code: 'THB', symbol: '฿', flag: '🇹🇭', name: 'Thai baht'),
  CurrencyOption(code: 'KRW', symbol: '₩', flag: '🇰🇷', name: 'South Korean won'),
];

CurrencyOption budgetingCurrencyByCode(CurrencyCode code) {
  final upper = code.trim().toUpperCase();
  return kBudgetingCurrencyCatalog.firstWhere(
    (option) => option.code == upper,
    orElse: () => CurrencyOption(
      code: upper,
      symbol: upper,
      flag: '🏳️',
      name: upper,
    ),
  );
}
