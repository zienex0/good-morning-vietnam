import 'package:flutter_foundation_kit/features/budgeting/domain/amortization.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:flutter_foundation_kit/features/budgeting/presentation/budgeting_chart_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final trip = Trip(
    id: 'trip-1',
    name: 'Vietnam 2026',
    homeCurrency: 'USD',
    startDate: DateTime(2026, 5, 9),
    status: TripStatus.active,
    createdAt: DateTime(2026),
  );

  Transaction expense({
    required double amountHome,
    required DateTime occurredAt,
    Amortization? amortization,
  }) {
    return Transaction(
      id: 'txn-${occurredAt.day}-${amortization?.count ?? 0}',
      tripId: 'trip-1',
      type: TransactionType.expense,
      occurredAt: occurredAt,
      sourceAccountId: 'usd',
      categoryId: 'lodging',
      amount: amountHome,
      currency: 'USD',
      amountHome: amountHome,
      fxRate: 1,
      amortization: amortization,
      createdAt: DateTime(2026),
    );
  }

  test('a plain expense spikes the cumulative trend on its day', () {
    final points = cumulativeSpendTrend(
      trip: trip,
      transactions: [expense(amountHome: 70, occurredAt: DateTime(2026, 5, 9))],
      asOf: DateTime(2026, 5, 11),
    );

    expect(points.map((point) => point.value).toList(), [70, 70, 70]);
  });

  test('an amortized expense ramps the cumulative trend day by day', () {
    final points = cumulativeSpendTrend(
      trip: trip,
      transactions: [
        expense(
          amountHome: 70,
          occurredAt: DateTime(2026, 5, 9),
          amortization: const Amortization(
            unit: AmortizationUnit.days,
            count: 7,
          ),
        ),
      ],
      asOf: DateTime(2026, 5, 11),
    );

    // 70 spread over 7 days => 10/day, so the cumulative line steps by 10.
    expect(points.map((point) => point.value).toList(), [10, 20, 30]);
  });
}
