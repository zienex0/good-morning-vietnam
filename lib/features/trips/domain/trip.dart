import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip.freezed.dart';

typedef CurrencyCode = String;

enum TripStatus { planning, active, ended }

@freezed
abstract class Trip with _$Trip {
  Trip._();

  @Assert(
    'endDate == null || !endDate.isBefore(startDate)',
    'endDate cannot be before startDate',
  )
  @Assert(
    'budgetTotal == null || budgetTotal >= 0',
    'budgetTotal cannot be negative',
  )
  factory Trip({
    required String id,
    required String name,
    required CurrencyCode homeCurrency,
    required DateTime startDate,
    DateTime? endDate,
    double? budgetTotal,
    required TripStatus status,
    required DateTime createdAt,
  }) = _Trip;

  bool get isOpenEnded => endDate == null;

  /// 1-based day index of the trip at [asOf]; 0 before the trip starts.
  int dayOfTrip(DateTime asOf) {
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final today = DateTime(asOf.year, asOf.month, asOf.day);
    if (today.isBefore(start)) {
      return 0;
    }
    return today.difference(start).inDays + 1;
  }
}
