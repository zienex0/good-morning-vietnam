import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';

String formatBudgetingDaysLeft(int? daysLeft) {
  if (daysLeft == null) {
    return '--';
  }
  return daysLeft.toString();
}

String formatBudgetingDaysLeftCaption(int? daysLeft) {
  if (daysLeft == null) {
    return 'days left at the current spend rate';
  }
  if (daysLeft == 0) {
    return 'days left before tent mode';
  }
  if (daysLeft == 1) {
    return 'day left before tent mode';
  }
  return 'days left before tent mode';
}

String formatBudgetingCurrentDay(int currentDay) {
  if (currentDay <= 0) {
    return 'Not started';
  }
  return 'Day $currentDay';
}

String formatBudgetingCategoryShare(double share) {
  return formatPercent(share);
}

String formatBudgetingTripStatus(TripStatus status) {
  return switch (status) {
    TripStatus.planning => 'Planning',
    TripStatus.active => 'Active',
    TripStatus.ended => 'Ended',
  };
}
