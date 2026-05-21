import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:flutter_foundation_kit/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'features/budgeting/application/use_cases/budgeting_use_cases_test.dart'
    show FakeBudgetingRepository;

void main() {
  testWidgets('app opens the onboarding screen with no trips', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          budgetingRepositoryProvider.overrideWithValue(
            FakeBudgetingRepository(),
          ),
        ],
        child: const MainApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Start a new trip'), findsOneWidget);
  });

  testWidgets('app applies the foundation theme', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          budgetingRepositoryProvider.overrideWithValue(
            FakeBudgetingRepository(),
          ),
        ],
        child: const MainApp(),
      ),
    );
    await tester.pumpAndSettle();

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));

    expect(scaffold.backgroundColor, isNull);
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).scaffoldBackgroundColor,
      AppColors.canvas,
    );
  });
}
