import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/trips/application/active_trip_provider.dart';
import 'package:flutter_foundation_kit/features/trips/application/trip_form_provider.dart';
import 'package:flutter_foundation_kit/features/trips/application/trips_provider.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';
import 'package:flutter_foundation_kit/features/trips/presentation/widgets/trip_currency_budget_step_page.dart';
import 'package:flutter_foundation_kit/features/trips/presentation/widgets/trip_dates_status_step_page.dart';
import 'package:flutter_foundation_kit/features/trips/presentation/widgets/trip_name_step_page.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_step_page_view.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TripFormPage extends ConsumerStatefulWidget {
  const TripFormPage({this.tripId, super.key});

  final String? tripId;

  @override
  ConsumerState<TripFormPage> createState() => TripFormPageState();
}

class TripFormPageState extends ConsumerState<TripFormPage> {
  final stepPageKey = GlobalKey<AppStepPageViewState>();
  final nameController = TextEditingController();
  final budgetController = TextEditingController();
  String? initializedTripId;
  bool initializedNewTrip = false;
  String selectedCurrency = 'USD';
  DateTime startDate = DateTime.now();
  DateTime? endDate;
  TripStatus selectedStatus = TripStatus.active;
  int currentPage = 0;

  bool get isEditing => widget.tripId != null;

  @override
  void dispose() {
    nameController.dispose();
    budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripsAsync = ref.watch(tripsProvider);
    final activeTrip = ref.watch(activeTripProvider).value;
    final formState = ref.watch(tripFormProvider);
    final isBusy = formState.isLoading;

    return AppAsyncValueView(
      value: tripsAsync,
      onRetry: () => ref.invalidate(tripsProvider),
      data: (trips) {
        Trip? trip;
        if (widget.tripId != null) {
          for (final candidate in trips) {
            if (candidate.id == widget.tripId) {
              trip = candidate;
            }
          }
        }

        if (isEditing && trip != null && initializedTripId != trip.id) {
          initializedTripId = trip.id;
          nameController.text = trip.name;
          budgetController.text = trip.budgetTotal?.toString() ?? '';
          selectedCurrency = trip.homeCurrency;
          startDate = trip.startDate;
          endDate = trip.endDate;
          selectedStatus = trip.status;
        }

        if (!isEditing && !initializedNewTrip) {
          final now = DateTime.now();
          initializedNewTrip = true;
          selectedCurrency = activeTrip?.homeCurrency ?? 'USD';
          startDate = DateTime(now.year, now.month, now.day);
          selectedStatus = TripStatus.active;
        }

        if (isEditing && trip == null) {
          return AppSliverPage(
            title: 'Edit trip',
            subtitle: 'Trip not found',
            leading: const AppBackButton(),
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
                    AppCard(
                      child: Text(
                        'This trip could not be found.',
                        style: context.mutedText.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return AppStepPageView(
          key: stepPageKey,
          initialPage: currentPage,
          leading: const AppBackButton(),
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (value) => setState(() => currentPage = value),
          titles: [
            Text(isEditing ? 'Trip name' : 'New trip'),
            const Text('Currency and budget'),
            const Text('Dates and status'),
          ],
          bottomNavigationBar: AppBottomActionBar(
            child: Row(
              children: [
                AppButton.text(
                  label: 'Back',
                  onPressed: isBusy ? null : handleBackPressed,
                ),
                const Spacer(),
                AppButton.primary(
                  label: currentPage == 2
                      ? (isEditing ? 'Save trip' : 'Create trip')
                      : 'Next',
                  loading: isBusy,
                  onPressed: () => handlePrimaryPressed(trip),
                ),
              ],
            ),
          ),
          pagesSlivers: [
            [
              TripNameStepPage(
                nameController: nameController,
                autofocus: !isEditing,
              ),
            ],
            [
              TripCurrencyBudgetStepPage(
                selectedCurrency: selectedCurrency,
                budgetController: budgetController,
                onCurrencyChanged: (value) {
                  setState(() => selectedCurrency = value);
                },
              ),
            ],
            [
              TripDatesStatusStepPage(
                startDate: startDate,
                endDate: endDate,
                selectedStatus: selectedStatus,
                onStartDateChanged: (value) {
                  setState(() {
                    startDate = value;
                    if (endDate != null && endDate!.isBefore(value)) {
                      endDate = null;
                    }
                  });
                },
                onEndDateChanged: (value) {
                  setState(() => endDate = value);
                },
                onStatusChanged: (value) {
                  setState(() => selectedStatus = value);
                },
              ),
            ],
          ],
        );
      },
    );
  }

  Future<void> handlePrimaryPressed(Trip? trip) async {
    if (!validateCurrentPage()) {
      return;
    }

    if (currentPage < 2) {
      await stepPageKey.currentState?.incrementPageIndex();
      return;
    }

    await saveTrip(trip);
  }

  Future<void> handleBackPressed() async {
    if (currentPage == 0) {
      context.pop();
      return;
    }
    await stepPageKey.currentState?.decrementPageIndex();
  }

  bool validateCurrentPage() {
    if (currentPage == 0 && nameController.text.trim().isEmpty) {
      AppSnackBars.error(context, 'Trip name is required.');
      return false;
    }

    if (currentPage == 1) {
      final budget = parseBudgetingAmountInput(budgetController.text);
      if (budget == null || budget < 0) {
        AppSnackBars.error(context, 'Enter a valid budget.');
        return false;
      }
    }

    if (currentPage == 2 && endDate != null && endDate!.isBefore(startDate)) {
      AppSnackBars.error(context, 'End date cannot be before start date.');
      return false;
    }

    return true;
  }

  Future<void> saveTrip(Trip? trip) async {
    final budget = parseBudgetingAmountInput(budgetController.text);
    if (budget == null) {
      AppSnackBars.error(context, 'Enter a valid budget.');
      return;
    }

    if (isEditing && trip != null) {
      final saved = await ref
          .read(tripFormProvider.notifier)
          .editTrip(
            trip.copyWith(
              name: nameController.text,
              homeCurrency: selectedCurrency,
              startDate: startDate,
              endDate: endDate,
              budgetTotal: budgetController.text.trim().isEmpty ? null : budget,
              status: selectedStatus,
            ),
          );
      if (!mounted) {
        return;
      }
      if (saved) {
        context.pop();
      } else {
        AppSnackBars.error(context, 'Could not save the trip.');
      }
      return;
    }

    final created = await ref
        .read(tripFormProvider.notifier)
        .createTrip(
          name: nameController.text,
          homeCurrency: selectedCurrency,
          startDate: startDate,
          endDate: endDate,
          budgetTotal: budgetController.text.trim().isEmpty ? null : budget,
          status: selectedStatus,
        );
    if (!mounted) {
      return;
    }
    if (created == null) {
      AppSnackBars.error(context, 'Could not create the trip.');
      return;
    }
    context.pop();
  }
}
