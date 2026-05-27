import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/shared/widgets/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('inserts digits, decimal separator, and deletes text', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(AppPalette.light),
        home: Scaffold(
          body: SizedBox.expand(child: AppNumpad(controller: controller)),
        ),
      ),
    );

    await tester.tap(find.text('1'));
    await tester.tap(find.text('2'));
    await tester.tap(find.text(','));
    await tester.tap(find.text('3'));

    expect(controller.text, '12,3');

    await tester.tap(find.bySemanticsLabel('Delete'));

    expect(controller.text, '12,');
  });

  testWidgets('anchors keypad to the bottom of its box', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(AppPalette.light),
        home: Scaffold(
          body: SizedBox.expand(child: AppNumpad(controller: controller)),
        ),
      ),
    );

    expect(
      tester.getRect(find.byType(GridView)).bottom,
      tester.getSize(find.byType(Scaffold)).height,
    );
  });

  testWidgets('replaces the selected range', (tester) async {
    final controller = TextEditingController(text: '123')
      ..selection = const TextSelection(baseOffset: 1, extentOffset: 3);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(AppPalette.light),
        home: Scaffold(
          body: SizedBox.expand(child: AppNumpad(controller: controller)),
        ),
      ),
    );

    await tester.tap(find.text('9'));

    expect(controller.text, '19');
    expect(controller.selection.baseOffset, 2);
  });

  testWidgets('lays out inside a fill-remaining sliver', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(AppPalette.light),
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverList.list(children: const [Text('Amount')]),
              SliverFillRemaining(child: AppNumpad(controller: controller)),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(AppNumpad), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
