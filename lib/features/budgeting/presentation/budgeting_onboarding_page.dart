import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/result/failure_messages.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/active_trip_providers.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/set_active_trip_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_transaction_mappers.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_icon_text_tile.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_sliver_page.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_snack_bar.dart';
import 'package:flutter_foundation_kit/shared/widgets/async_value_view.dart';
import 'package:flutter_foundation_kit/shared/widgets/section_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BudgetingOnboardingPage extends ConsumerWidget {
  const BudgetingOnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(tripsListProvider);

    return AppSliverPage(
      title: 'Pick a trip',
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.pageWithinSectionGap,
            AppSpacing.page,
            AppSpacing.pageBetweenSectionGap,
          ),
          sliver: SliverToBoxAdapter(
            child: AsyncValueView(
              value: tripsAsync,
              data: (trips) =>
                  BudgetingOnboardingBody(trips: trips),
            ),
          ),
        ),
      ],
    );
  }
}

class BudgetingOnboardingBody extends ConsumerWidget {
  const BudgetingOnboardingBody({required this.trips, super.key});

  final List<Trip> trips;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFirstLaunch = trips.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: isFirstLaunch ? 'welcome' : 'choose a trip',
          body: isFirstLaunch
              ? 'Create your first trip to start tracking spending offline.'
              : 'Tap a trip to make it active, or start a new one.',
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton.icon(
          onPressed: () => context.push(AppRoutes.newTrip),
          icon: const Icon(Icons.add),
          label: const Text('Start a new trip'),
        ),
        if (trips.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          for (final trip in trips) ...[
            BudgetingOnboardingTripTile(trip: trip),
            const Divider(),
          ],
        ],
      ],
    );
  }
}

class BudgetingOnboardingTripTile extends ConsumerWidget {
  const BudgetingOnboardingTripTile({required this.trip, super.key});

  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: AppIconTextTile(
        leading: const Icon(Icons.flight_takeoff_outlined),
        title: trip.name,
        subtitle:
            '${formatTripDateRange(trip)} · ${budgetingTripStatusLabel(trip.status)}',
        trailing: const Icon(Icons.chevron_right),
        onTap: () async {
          final result = await ref
              .read(setActiveTripUseCaseProvider)
              .call(trip.id);
          if (!context.mounted) return;
          switch (result) {
            case Ok():
              ref.invalidate(activeTripIdProvider);
              context.go(AppRoutes.home);
            case Err(failure: final failure):
              AppSnackBars.error(context, failureMessage(failure));
          }
        },
      ),
    );
  }
}
