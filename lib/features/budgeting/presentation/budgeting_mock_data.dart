import 'package:flutter/material.dart';

// TODO: Delete these hardcoded mock values when offline storage is wired in.
const mockTripName = 'Japan 2026';
const mockHomeCurrency = 'USD';
const mockTripId = 'trip-japan-2026';
const mockDefaultAccountId = 'wallet-pln';
const mockDefaultTransferDestAccountId = 'cash-jpy';
const mockDefaultCategoryId = 'food';
const mockTripDates = 'May 9, 2026 - Jun 8, 2026';
const mockDaysLeft = '17 DAYS';
const mockDaysLeftSubtitle = "before you're sleeping...";
const mockBalanceHome = '\$847';
const mockAverageDailySpend = '\$49/day';
const mockTripDay = 'Day 12';
const mockBudgetProgress = 0.58;
const mockBudgetProgressLabel = '58% cooked';
const mockBudgetTotal = '\$1,500';

final mockSpendTrend = [
  (date: DateTime(2026, 5, 9), value: 34.0),
  (date: DateTime(2026, 5, 10), value: 71.0),
  (date: DateTime(2026, 5, 11), value: 96.0),
  (date: DateTime(2026, 5, 12), value: 141.0),
  (date: DateTime(2026, 5, 13), value: 210.0),
  (date: DateTime(2026, 5, 14), value: 246.0),
  (date: DateTime(2026, 5, 15), value: 292.0),
];

const mockTransactions = [
  MockTransactionRow(
    icon: Icons.local_cafe_outlined,
    title: 'Coffee',
    detail: 'Cash JPY · 2h ago',
    amount: '-\$4.20',
  ),
  MockTransactionRow(
    icon: Icons.ramen_dining_outlined,
    title: 'Ramen lunch',
    detail: 'Food · today',
    amount: '-\$12',
  ),
  MockTransactionRow(
    icon: Icons.bed_outlined,
    title: 'Hostel',
    detail: 'Lodging · yesterday',
    amount: '-\$28',
  ),
  MockTransactionRow(
    icon: Icons.add_card_outlined,
    title: 'Revolut top-up',
    detail: 'Top up · yesterday',
    amount: '+\$120',
    positive: true,
  ),
  MockTransactionRow(
    icon: Icons.train_outlined,
    title: 'Metro pass',
    detail: 'Transport · May 18',
    amount: '-\$9',
  ),
];

const mockAccounts = [
  MockAccountRow(
    icon: Icons.payments_outlined,
    name: 'Cash JPY',
    detail: 'JPY native',
    balance: 'JPY 32,000',
  ),
  MockAccountRow(
    icon: Icons.credit_card_outlined,
    name: 'Revolut',
    detail: 'Card',
    balance: '\$410',
  ),
  MockAccountRow(
    icon: Icons.account_balance_outlined,
    name: 'Chase debit',
    detail: 'Bank',
    balance: '\$217',
  ),
];

const mockBudgetingCurrencies = [
  MockCurrencyOption(
    code: 'USD',
    symbol: r'$',
    flag: '🇺🇸',
    name: 'US dollar',
  ),
  MockCurrencyOption(
    code: 'JPY',
    symbol: '¥',
    flag: '🇯🇵',
    name: 'Japanese yen',
  ),
  MockCurrencyOption(code: 'EUR', symbol: '€', flag: '🇪🇺', name: 'Euro'),
  MockCurrencyOption(
    code: 'PLN',
    symbol: 'zł',
    flag: '🇵🇱',
    name: 'Polish złoty',
  ),
  MockCurrencyOption(
    code: 'GBP',
    symbol: '£',
    flag: '🇬🇧',
    name: 'British pound',
  ),
  MockCurrencyOption(
    code: 'VND',
    symbol: '₫',
    flag: '🇻🇳',
    name: 'Vietnamese dong',
  ),
];

const mockBudgetingAccounts = [
  MockBudgetingAccountOption(
    id: 'wallet-pln',
    name: 'Default wallet',
    detail: 'Daily wallet',
    currency: 'PLN',
    balance: 'PLN 1,250',
    icon: Icons.account_balance_wallet_outlined,
  ),
  MockBudgetingAccountOption(
    id: 'cash-jpy',
    name: 'Cash JPY',
    detail: 'Cash envelope',
    currency: 'JPY',
    balance: 'JPY 32,000',
    icon: Icons.payments_outlined,
  ),
  MockBudgetingAccountOption(
    id: 'revolut-usd',
    name: 'Revolut',
    detail: 'Travel card',
    currency: 'USD',
    balance: r'$410',
    icon: Icons.credit_card_outlined,
  ),
  MockBudgetingAccountOption(
    id: 'chase-usd',
    name: 'Chase debit',
    detail: 'Bank account',
    currency: 'USD',
    balance: r'$217',
    icon: Icons.account_balance_outlined,
  ),
  MockBudgetingAccountOption(
    id: 'momo-vnd',
    name: 'MoMo wallet',
    detail: 'Mobile wallet',
    currency: 'VND',
    balance: '₫1,900,000',
    icon: Icons.account_balance_wallet_outlined,
  ),
];

const mockBudgetingCategories = [
  MockBudgetingCategoryOption(
    id: 'food',
    name: 'Food',
    icon: Icons.ramen_dining_outlined,
  ),
  MockBudgetingCategoryOption(
    id: 'coffee',
    name: 'Coffee',
    icon: Icons.local_cafe_outlined,
  ),
  MockBudgetingCategoryOption(
    id: 'transport',
    name: 'Transport',
    icon: Icons.train_outlined,
  ),
  MockBudgetingCategoryOption(
    id: 'lodging',
    name: 'Lodging',
    icon: Icons.bed_outlined,
  ),
  MockBudgetingCategoryOption(
    id: 'shopping',
    name: 'Shopping',
    icon: Icons.shopping_bag_outlined,
  ),
  MockBudgetingCategoryOption(
    id: 'tickets',
    name: 'Tickets',
    icon: Icons.confirmation_number_outlined,
  ),
];

const mockDrawerTrips = [
  MockDrawerTrip(name: 'Japan 2026', status: '17 days', selected: true),
  MockDrawerTrip(name: 'Vietnam 2026', status: 'planning'),
  MockDrawerTrip(name: 'Thailand 2025', status: 'ended'),
  MockDrawerTrip(name: 'Peru 2024', status: 'ended'),
];

class MockTransactionRow {
  const MockTransactionRow({
    required this.icon,
    required this.title,
    required this.detail,
    required this.amount,
    this.positive = false,
  });

  final IconData icon;
  final String title;
  final String detail;
  final String amount;
  final bool positive;
}

class MockAccountRow {
  const MockAccountRow({
    required this.icon,
    required this.name,
    required this.detail,
    required this.balance,
  });

  final IconData icon;
  final String name;
  final String detail;
  final String balance;
}

class MockCurrencyOption {
  const MockCurrencyOption({
    required this.code,
    required this.symbol,
    required this.flag,
    required this.name,
  });

  final String code;
  final String symbol;
  final String flag;
  final String name;
}

class MockBudgetingAccountOption {
  const MockBudgetingAccountOption({
    required this.id,
    required this.name,
    required this.detail,
    required this.currency,
    required this.balance,
    required this.icon,
  });

  final String id;
  final String name;
  final String detail;
  final String currency;
  final String balance;
  final IconData icon;
}

class MockBudgetingCategoryOption {
  const MockBudgetingCategoryOption({
    required this.id,
    required this.name,
    required this.icon,
  });

  final String id;
  final String name;
  final IconData icon;
}

class MockDrawerTrip {
  const MockDrawerTrip({
    required this.name,
    required this.status,
    this.selected = false,
  });

  final String name;
  final String status;
  final bool selected;
}

MockCurrencyOption mockBudgetingCurrencyByCode(String code) {
  return mockBudgetingCurrencies.firstWhere(
    (currency) => currency.code == code,
    orElse: () => mockBudgetingCurrencies.first,
  );
}

MockBudgetingAccountOption mockBudgetingAccountById(String id) {
  return mockBudgetingAccounts.firstWhere(
    (account) => account.id == id,
    orElse: () => mockBudgetingAccounts.first,
  );
}

MockBudgetingCategoryOption mockBudgetingCategoryById(String id) {
  return mockBudgetingCategories.firstWhere(
    (category) => category.id == id,
    orElse: () => mockBudgetingCategories.first,
  );
}

MockBudgetingAccountOption mockBudgetingFirstAccountForCurrency(
  String currency,
) {
  return mockBudgetingAccounts.firstWhere(
    (account) => account.currency == currency,
    orElse: () => mockBudgetingAccounts.first,
  );
}

MockBudgetingAccountOption mockBudgetingFirstAccountExcept(String accountId) {
  return mockBudgetingAccounts.firstWhere(
    (account) => account.id != accountId,
    orElse: () => mockBudgetingAccounts.first,
  );
}
