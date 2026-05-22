import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/amortization.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';

IconData budgetingAccountIcon(AccountType type) => switch (type) {
  AccountType.cash => Icons.payments_outlined,
  AccountType.card => Icons.credit_card_outlined,
  AccountType.bank => Icons.account_balance_outlined,
  AccountType.ewallet => Icons.account_balance_wallet_outlined,
  AccountType.custom => Icons.wallet_outlined,
};

String budgetingAccountTypeLabel(AccountType type) => switch (type) {
  AccountType.cash => 'Cash',
  AccountType.card => 'Card',
  AccountType.bank => 'Bank',
  AccountType.ewallet => 'E-wallet',
  AccountType.custom => 'Custom',
};

IconData budgetingCategoryIcon(String? categoryId) {
  switch (categoryId) {
    case 'food':
      return Icons.ramen_dining_outlined;
    case 'coffee':
      return Icons.local_cafe_outlined;
    case 'transport':
      return Icons.train_outlined;
    case 'lodging':
      return Icons.bed_outlined;
    case 'shopping':
      return Icons.shopping_bag_outlined;
    case 'tickets':
      return Icons.confirmation_number_outlined;
    default:
      return Icons.category_outlined;
  }
}

IconData budgetingTransactionIcon(Transaction transaction) {
  switch (transaction.type) {
    case TransactionType.expense:
      return budgetingCategoryIcon(transaction.categoryId);
    case TransactionType.income:
      return Icons.add_card_outlined;
    case TransactionType.transfer:
      return Icons.swap_horiz;
  }
}

String budgetingTripStatusLabel(TripStatus status) => switch (status) {
  TripStatus.planning => 'planning',
  TripStatus.active => 'active',
  TripStatus.ended => 'ended',
};

String budgetingAmortizationUnitLabel(AmortizationUnit unit) => switch (unit) {
  AmortizationUnit.days => 'Days',
  AmortizationUnit.weeks => 'Weeks',
  AmortizationUnit.months => 'Months',
};
