import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/routing/app_routes.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/core/result/failure_messages.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/trips/application/active_trip_provider.dart';
import 'package:flutter_foundation_kit/features/trips/application/trips_controller.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TripSettingsPage extends ConsumerWidget {
  const TripSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(tripsControllerProvider);
    final activeTripAsync = ref.watch(activeTripProvider);
    final formState = ref.watch(tripsControllerProvider);
    final trips = tripsAsync.value ?? const <Trip>[];
    final activeTrip = activeTripAsync.value;
    final isBusy = formState.isLoading;

    return AppAsyncValueView(
      value: tripsAsync,
      onRetry: () => ref.invalidate(tripsControllerProvider),
      data: (_) {
        return AppSliverPage(
          title: 'Trip settings',
          subtitle: activeTrip?.name ?? 'Choose a trip',
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.pageWithinSectionGap,
                AppSpacing.page,
                AppSpacing.pageBetweenSectionGap,
              ),
              sliver: SliverList.list(
                children: [
                  const AppSectionHeader(title: 'Active trip'),
                  const SizedBox(height: AppSpacing.md),
                  if (trips.isEmpty)
                    AppCard(
                      child: Text(
                        'Create a trip to start tracking travel spending.',
                        style: context.mutedText.bodyMedium,
                      ),
                    )
                  else
                    AppDropdown<String>(
                      value: activeTrip?.id,
                      placeholder: const Text('Choose trip'),
                      showNoneOption: false,
                      onChanged: (value) async {
                        if (isBusy || value == null) {
                          return;
                        }
                        final activated = await ref
                            .read(tripsControllerProvider.notifier)
                            .activate(value);
                        if (!context.mounted) {
                          return;
                        }
                        if (activated case Err(failure: final failure)) {
                          AppSnackBars.error(context, failureMessage(failure));
                        }
                      },
                      options: [
                        for (final trip in trips)
                          AppDropdownOption(
                            value: trip.id,
                            child: Text('${trip.name} · ${trip.homeCurrency}'),
                            selectedChild: Text(
                              '${trip.name} · ${trip.homeCurrency}',
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(height: AppSpacing.pageWithinSectionGap),
                  if (activeTrip != null) ...[
                    AppButton.secondary(
                      label: 'Edit selected trip',
                      expanded: true,
                      onPressed: isBusy
                          ? null
                          : () {
                              unawaited(
                                context.push(
                                  AppRoutes.editTripFor(activeTrip.id),
                                ),
                              );
                            },
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  AppButton.primary(
                    label: 'Create new trip',
                    expanded: true,
                    onPressed: isBusy
                        ? null
                        : () {
                            unawaited(context.push(AppRoutes.newTrip));
                          },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
