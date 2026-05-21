import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';

IconData budgetingAccountIcon(AccountType type) => switch (type) {
  AccountType.cash => Icons.payments_outlined,
  AccountType.card => Icons.credit_card_outlined,
  AccountType.bank => Icons.account_balance_outlined,
  AccountType.ewallet => Icons.account_balance_wallet_outlined,
  AccountType.custom => Icons.wallet_outlined,
};
