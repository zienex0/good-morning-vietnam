import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app opens the trip dashboard home route', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MainApp()));
    await tester.pumpAndSettle();

    expect(find.text('Backpacker budget'), findsOneWidget);
    expect(find.text('No active trip'), findsOneWidget);
  });

  testWidgets('app applies the foundation theme', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MainApp()));
    await tester.pumpAndSettle();

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);

    expect(scaffold.backgroundColor, isNull);
    expect(
      Theme.of(
        tester.element(find.byType(Scaffold).first),
      ).scaffoldBackgroundColor,
      AppPalette.light.canvas,
    );
  });
}
