import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_metrics_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_accounts_sections.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_page_frame.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetingAccountsPage extends ConsumerWidget {
  const BudgetingAccountsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trip = ref.watch(activeTripProvider).valueOrNull;
    final balance = ref.watch(activeTripTotalBalanceProvider).valueOrNull ?? 0;
    final subtitle = trip == null
        ? null
        : '${formatBudgetingHomeMoney(balance, trip.homeCurrency)} total';
    return BudgetingPageFrame(
      title: 'Accounts',
      subtitle: subtitle,
      actions: const [BudgetingAddAccountButton()],
      children: const [BudgetingAccountsSummarySection()],
    );
  }
}
