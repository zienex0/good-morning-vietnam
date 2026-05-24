import 'package:flutter_foundation_kit/features/trips/application/use_cases/calculate_days_left_use_case.dart';
import 'package:flutter_foundation_kit/features/trips/application/use_cases/create_trip_use_case.dart';
import 'package:flutter_foundation_kit/features/trips/application/use_cases/edit_trip_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/budgeting_fixtures.dart';

void main() {
  test('creates and edits trips', () async {
    final tripRepository = FakeTripRepository();
    final created = expectOk(
      await CreateTripUseCase(
        repository: tripRepository,
        idGenerator: const FakeTripIdGenerator('trip-created'),
      )(
        name: ' Japan 2026 ',
        homeCurrency: 'usd',
        startDate: DateTime(2026, 5, 9),
        createdAt: DateTime(2026),
      ),
    );

    expect(created.id, 'trip-created');
    expect(created.name, 'Japan 2026');
    expect(created.homeCurrency, 'USD');

    final edited = expectOk(
      await EditTripUseCase(tripRepository)(
        created.copyWith(name: 'Japan + Korea 2026', budgetTotal: 1800),
      ),
    );

    expect(edited.name, 'Japan + Korea 2026');
    expect(edited.budgetTotal, 1800);
  });

  group('days left', () {
    const useCase = CalculateDaysLeftUseCase();

    test('floors balance over average daily spend', () {
      expect(useCase(totalBalance: 200, averageDailySpend: 100), 2);
    });

    test('returns null without a spend rate', () {
      expect(useCase(totalBalance: 200, averageDailySpend: 0), isNull);
    });

    test('returns zero once the money is gone', () {
      expect(useCase(totalBalance: 0, averageDailySpend: 50), 0);
    });
  });
}
