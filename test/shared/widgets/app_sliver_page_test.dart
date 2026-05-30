import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_sliver_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('bottom navigation bar does not cover final sliver content', (
    tester,
  ) async {
    const bottomBarKey = Key('bottomBar');
    const finalItemKey = Key('finalItem');

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(AppPalette.light),
        home: AppSliverPage(
          title: 'Page',
          bottomNavigationBar: const SizedBox(
            key: bottomBarKey,
            height: AppSpacing.xxxl + AppSpacing.xl,
            child: ColoredBox(color: Colors.white),
          ),
          slivers: [
            SliverList.list(
              children: [
                for (var index = 0; index < 24; index += 1)
                  const SizedBox(height: AppSpacing.xxxl),
                const Text(key: finalItemKey, 'Final item'),
              ],
            ),
          ],
        ),
      ),
    );

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -2400));
    await tester.pumpAndSettle();

    final finalItemBottom = tester.getRect(find.byKey(finalItemKey)).bottom;
    final bottomBarTop = tester.getRect(find.byKey(bottomBarKey)).top;

    expect(finalItemBottom, lessThanOrEqualTo(bottomBarTop));
  });
}
