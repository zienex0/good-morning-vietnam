import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_home_sections.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_page_frame.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetingHomePage extends ConsumerWidget {
  const BudgetingHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trip = ref.watch(activeTripProvider).valueOrNull;
    if (trip == null) {
      return const BudgetingPageFrame(title: 'Loading...', children: []);
    }
    return BudgetingPageFrame(
      title: trip.name,
      children: [
        BudgetingHomeHero(trip: trip),
        const BudgetingHomeActions(),
        BudgetingSpendTrendSection(trip: trip),
        BudgetingTransactionsSection(trip: trip),
      ],
    );
  }
}
