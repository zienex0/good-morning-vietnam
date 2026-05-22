import 'package:freezed_annotation/freezed_annotation.dart';

part 'amortization.freezed.dart';

enum AmortizationUnit { days, weeks, months }

/// How a single expense is spread across time so it contributes a per-day slice
/// to spend trends instead of one large spike on the purchase day.
@freezed
class Amortization with _$Amortization {
  const Amortization._();

  @Assert('count >= 1', 'amortization count must be at least 1')
  const factory Amortization({
    required AmortizationUnit unit,
    required int count,
  }) = _Amortization;

  /// Number of days the expense is spread across, resolved against [from] (the
  /// expense date) so calendar months keep their real length.
  int dayCountFrom(DateTime from) {
    switch (unit) {
      case AmortizationUnit.days:
        return count;
      case AmortizationUnit.weeks:
        return count * 7;
      case AmortizationUnit.months:
        final start = DateTime(from.year, from.month, from.day);
        final end = DateTime(from.year, from.month + count, from.day);
        return end.difference(start).inDays;
    }
  }
}
