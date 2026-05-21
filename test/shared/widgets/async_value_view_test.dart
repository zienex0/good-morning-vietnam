import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/shared/widgets/async_value_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders loading state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const AsyncValueView<String>(
          value: AsyncLoading(),
          data: Text.new,
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders data state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const AsyncValueView<String>(
          value: AsyncData('Ready'),
          data: Text.new,
        ),
      ),
    );

    expect(find.text('Ready'), findsOneWidget);
  });

  testWidgets('renders retryable error state', (tester) async {
    var retryCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: AsyncValueView<String>(
          value: AsyncError(Exception('Nope'), StackTrace.empty),
          data: Text.new,
          onRetry: () => retryCount += 1,
        ),
      ),
    );

    expect(find.textContaining('Nope'), findsOneWidget);

    await tester.tap(find.text('Try again'));
    await tester.pump();

    expect(retryCount, 1);
  });
}
