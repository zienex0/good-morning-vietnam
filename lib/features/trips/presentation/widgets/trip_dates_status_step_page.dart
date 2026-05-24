import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';
import 'package:flutter_foundation_kit/features/trips/presentation/trip_dashboard_formatters.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';

class TripDatesStatusStepPage extends StatelessWidget {
  const TripDatesStatusStepPage({
    required this.startDate,
    required this.endDate,
    required this.selectedStatus,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onStatusChanged,
    super.key,
  });

  final DateTime startDate;
  final DateTime? endDate;
  final TripStatus selectedStatus;
  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;
  final ValueChanged<TripStatus> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.pageWithinSectionGap,
        AppSpacing.page,
        AppSpacing.pageBetweenSectionGap,
      ),
      sliver: SliverList.list(
        children: [
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
                    onStartDateChanged(picked);
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
                        onPressed: () => onEndDateChanged(null),
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
                    onEndDateChanged(picked);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageWithinSectionGap),
          const AppSectionHeader(title: 'Status'),
          const SizedBox(height: AppSpacing.md),
          AppDropdown<TripStatus>(
            value: selectedStatus,
            showNoneOption: false,
            onChanged: (value) {
              if (value != null) {
                onStatusChanged(value);
              }
            },
            options: [
              for (final status in TripStatus.values)
                AppDropdownOption(
                  value: status,
                  child: Text(formatBudgetingTripStatus(status)),
                  selectedChild: Text(formatBudgetingTripStatus(status)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
