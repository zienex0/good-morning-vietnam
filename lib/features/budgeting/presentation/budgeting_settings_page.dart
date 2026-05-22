import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_page_frame.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/widgets/budgeting_settings_sections.dart';
import 'package:flutter_foundation_kit/shared/widgets/async_value_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetingSettingsPage extends ConsumerWidget {
  const BudgetingSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripAsync = ref.watch(activeTripProvider);

    return AsyncValueView(
      value: tripAsync,
      onRetry: () => ref.invalidate(activeTripProvider),
      data: (trip) {
        if (trip == null) {
          return const BudgetingPageFrame(title: 'Settings', children: []);
        }
        return BudgetingPageFrame(
          title: trip.name,
          subtitle: 'Settings',
          children: [
            BudgetingSettingsTripSection(trip: trip),
            BudgetingSettingsBudgetSection(trip: trip),
            BudgetingSettingsDangerSection(trip: trip),
          ],
        );
      },
    );
  }
}
