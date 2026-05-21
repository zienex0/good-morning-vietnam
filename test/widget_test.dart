import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app opens the budgeting home route', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MainApp()));
    await tester.pumpAndSettle();

    expect(find.text('Japan 2026'), findsOneWidget);
    expect(find.text('Expense'), findsOneWidget);
  });

  testWidgets('app applies the foundation theme', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MainApp()));
    await tester.pumpAndSettle();

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));

    expect(scaffold.backgroundColor, isNull);
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).scaffoldBackgroundColor,
      AppColors.canvas,
    );
  });
}
