import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/transactions/presentation/transaction_formatters.dart';
import 'package:flutter_foundation_kit/features/trips/application/active_trip_provider.dart';
import 'package:flutter_foundation_kit/features/trips/application/trip_form_provider.dart';
import 'package:flutter_foundation_kit/features/trips/application/trips_provider.dart';
import 'package:flutter_foundation_kit/features/trips/domain/currencies.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripSettingsPage extends ConsumerStatefulWidget {
  const TripSettingsPage({super.key});

  @override
  ConsumerState<TripSettingsPage> createState() => TripSettingsPageState();
}

class TripSettingsPageState extends ConsumerState<TripSettingsPage> {
  final nameController = TextEditingController();
  final budgetController = TextEditingController();
  String? editingTripId;
  String selectedCurrency = 'USD';
  DateTime startDate = DateTime.now();
  DateTime? endDate;
  TripStatus selectedStatus = TripStatus.active;
  bool creatingTrip = false;

  @override
  void dispose() {
    nameController.dispose();
    budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripsAsync = ref.watch(tripsProvider);
    final activeTripAsync = ref.watch(activeTripProvider);
    final formState = ref.watch(tripFormProvider);
    final trips = tripsAsync.value ?? const <Trip>[];
    final activeTrip = activeTripAsync.value;
    Trip? selectedTrip;
    if (!creatingTrip) {
      selectedTrip = activeTrip;
      for (final trip in trips) {
        if (trip.id == editingTripId) {
          selectedTrip = trip;
        }
      }
    }
    final isBusy = formState.isLoading;

    if (!creatingTrip &&
        selectedTrip != null &&
        selectedTrip.id != editingTripId) {
      editingTripId = selectedTrip.id;
      nameController.text = selectedTrip.name;
      budgetController.text = selectedTrip.budgetTotal?.toString() ?? '';
      selectedCurrency = selectedTrip.homeCurrency;
      startDate = selectedTrip.startDate;
      endDate = selectedTrip.endDate;
      selectedStatus = selectedTrip.status;
    }

    return AppAsyncValueView(
      value: activeTripAsync,
      onRetry: () => ref.invalidate(activeTripProvider),
      data: (_) {
        return AppSliverPage(
          title: creatingTrip ? 'New trip' : 'Trip settings',
          subtitle: selectedTrip?.name ?? 'Create or select a trip',
          bottomNavigationBar: AppBottomActionBar(
            child: AppButton.primary(
              label: creatingTrip || selectedTrip == null
                  ? 'Create trip'
                  : 'Save changes',
              expanded: true,
              loading: isBusy,
              onPressed: () async {
                final budget = parseBudgetingAmountInput(budgetController.text);
                if (nameController.text.trim().isEmpty) {
                  AppSnackBars.error(context, 'Trip name is required.');
                  return;
                }
                if (budget == null || budget < 0) {
                  AppSnackBars.error(context, 'Enter a valid budget.');
                  return;
                }
                if (endDate != null && endDate!.isBefore(startDate)) {
                  AppSnackBars.error(
                    context,
                    'End date cannot be before start date.',
                  );
                  return;
                }

                if (creatingTrip || selectedTrip == null) {
                  final trip = await ref
                      .read(tripFormProvider.notifier)
                      .createTrip(
                        name: nameController.text,
                        homeCurrency: selectedCurrency,
                        startDate: startDate,
                        endDate: endDate,
                        budgetTotal: budgetController.text.trim().isEmpty
                            ? null
                            : budget,
                      );
                  if (!context.mounted) {
                    return;
                  }
                  if (trip == null) {
                    AppSnackBars.error(context, 'Could not create the trip.');
                    return;
                  }
                  setState(() {
                    creatingTrip = false;
                    editingTripId = trip.id;
                  });
                  AppSnackBars.success(context, 'Trip created.');
                  return;
                }

                final saved = await ref
                    .read(tripFormProvider.notifier)
                    .editTrip(
                      selectedTrip.copyWith(
                        name: nameController.text,
                        homeCurrency: selectedCurrency,
                        startDate: startDate,
                        endDate: endDate,
                        budgetTotal: budgetController.text.trim().isEmpty
                            ? null
                            : budget,
                        status: selectedStatus,
                      ),
                    );
                if (!context.mounted) {
                  return;
                }
                if (saved) {
                  AppSnackBars.success(context, 'Trip saved.');
                } else {
                  AppSnackBars.error(context, 'Could not save the trip.');
                }
              },
            ),
          ),
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
                  if (trips.isNotEmpty) ...[
                    const AppSectionHeader(title: 'Active trip'),
                    const SizedBox(height: AppSpacing.md),
                    AppDropdown<String>(
                      value: selectedTrip?.id,
                      placeholder: const Text('Choose trip'),
                      showNoneOption: false,
                      onChanged: (value) async {
                        if (value == null) {
                          return;
                        }
                        Trip? trip;
                        for (final candidate in trips) {
                          if (candidate.id == value) {
                            trip = candidate;
                          }
                        }
                        if (trip == null) {
                          return;
                        }
                        final chosenTrip = trip;
                        final activated = await ref
                            .read(tripFormProvider.notifier)
                            .activateTrip(chosenTrip.id);
                        if (!context.mounted) {
                          return;
                        }
                        if (!activated) {
                          AppSnackBars.error(context, 'Could not change trip.');
                          return;
                        }
                        setState(() {
                          creatingTrip = false;
                          editingTripId = chosenTrip.id;
                          nameController.text = chosenTrip.name;
                          budgetController.text =
                              chosenTrip.budgetTotal?.toString() ?? '';
                          selectedCurrency = chosenTrip.homeCurrency;
                          startDate = chosenTrip.startDate;
                          endDate = chosenTrip.endDate;
                          selectedStatus = chosenTrip.status;
                        });
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
                    const SizedBox(height: AppSpacing.md),
                  ],
                  AppButton.secondary(
                    label: 'Create new trip',
                    expanded: true,
                    onPressed: isBusy
                        ? null
                        : () {
                            final now = DateTime.now();
                            setState(() {
                              creatingTrip = true;
                              editingTripId = null;
                              nameController.clear();
                              budgetController.clear();
                              selectedCurrency =
                                  activeTrip?.homeCurrency ?? 'USD';
                              startDate = DateTime(
                                now.year,
                                now.month,
                                now.day,
                              );
                              endDate = null;
                              selectedStatus = TripStatus.active;
                            });
                          },
                  ),
                  const SizedBox(height: AppSpacing.pageBetweenSectionGap),
                  const AppSectionHeader(title: 'Details'),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: nameController,
                    autofocus: trips.isEmpty,
                    textCapitalization: TextCapitalization.words,
                    style: context.text.displaySmall,
                    decoration: const InputDecoration(
                      hintText: 'Trip name',
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageWithinSectionGap),
                  const AppSectionHeader(title: 'Currency'),
                  const SizedBox(height: AppSpacing.md),
                  AppDropdown<String>(
                    value: selectedCurrency,
                    showNoneOption: false,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedCurrency = value);
                      }
                    },
                    options: [
                      for (final option in kBudgetingCurrencyCatalog)
                        AppDropdownOption(
                          value: option.code,
                          child: Text(
                            formatBudgetingCurrencyOptionDetail(option),
                          ),
                          selectedChild: Text(
                            formatBudgetingCurrencyOption(option),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.pageWithinSectionGap),
                  const AppSectionHeader(title: 'Dates'),
                  const SizedBox(height: AppSpacing.md),
                  AppListSection(
                    children: [
                      AppTile(
                        title: 'Start',
                        subtitle: formatFullDate(startDate),
                        leading: const Icon(Icons.calendar_today_rounded),
                        showChevron: false,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: startDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => startDate = picked);
                          }
                        },
                      ),
                      AppTile(
                        title: 'End',
                        subtitle: endDate == null
                            ? 'Open ended'
                            : formatFullDate(endDate!),
                        leading: const Icon(Icons.event_available_rounded),
                        trailing: endDate == null
                            ? null
                            : IconButton(
                                tooltip: 'Clear end date',
                                onPressed: () => setState(() => endDate = null),
                                icon: const Icon(Icons.close_rounded),
                              ),
                        showChevron: false,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: endDate ?? startDate,
                            firstDate: startDate,
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => endDate = picked);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.pageWithinSectionGap),
                  const AppSectionHeader(title: 'Budget'),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: budgetController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: context.text.headlineMedium,
                    decoration: InputDecoration(
                      hintText: 'Optional',
                      suffixText: selectedCurrency,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageWithinSectionGap),
                  const AppSectionHeader(title: 'Status'),
                  const SizedBox(height: AppSpacing.md),
                  AppDropdown<TripStatus>(
                    value: selectedStatus,
                    showNoneOption: false,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedStatus = value);
                      }
                    },
                    options: [
                      for (final status in TripStatus.values)
                        AppDropdownOption(
                          value: status,
                          child: Text(switch (status) {
                            TripStatus.planning => 'Planning',
                            TripStatus.active => 'Active',
                            TripStatus.ended => 'Ended',
                          }),
                          selectedChild: Text(switch (status) {
                            TripStatus.planning => 'Planning',
                            TripStatus.active => 'Active',
                            TripStatus.ended => 'Ended',
                          }),
                        ),
                    ],
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
