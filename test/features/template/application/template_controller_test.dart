import 'package:flutter_foundation_kit/features/template/application/template_providers.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_track.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('starts with a useful sample state', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final subscription = container.listen(
      templateControllerProvider,
      (previous, next) {},
    );
    addTearDown(subscription.close);

    final state = await container.read(templateControllerProvider.future);

    expect(state.track, ProjectTrack.engineering);
    expect(state.seats, 3);
    expect(state.receipt.total, 328);
  });

  test('updates track through an intent method', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final subscription = container.listen(
      templateControllerProvider,
      (previous, next) {},
    );
    addTearDown(subscription.close);
    final controller = container.read(templateControllerProvider.notifier);

    await container.read(templateControllerProvider.future);
    await controller.setTrack(ProjectTrack.design);

    final state = await container.read(templateControllerProvider.future);
    expect(state.track, ProjectTrack.design);
  });

  test('increments seats through an intent method', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final subscription = container.listen(
      templateControllerProvider,
      (previous, next) {},
    );
    addTearDown(subscription.close);
    final controller = container.read(templateControllerProvider.notifier);

    await container.read(templateControllerProvider.future);
    await controller.incrementSeats();

    final state = await container.read(templateControllerProvider.future);
    expect(state.seats, 4);
  });

  test('clamps seats to the minimum supported bound', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final subscription = container.listen(
      templateControllerProvider,
      (previous, next) {},
    );
    addTearDown(subscription.close);
    final controller = container.read(templateControllerProvider.notifier);

    await container.read(templateControllerProvider.future);
    await controller.setSeats(-10);

    final state = await container.read(templateControllerProvider.future);
    expect(state.seats, 1);
  });

  test('clamps seats to the maximum supported bound', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final subscription = container.listen(
      templateControllerProvider,
      (previous, next) {},
    );
    addTearDown(subscription.close);
    final controller = container.read(templateControllerProvider.notifier);

    await container.read(templateControllerProvider.future);
    await controller.setSeats(40);

    final state = await container.read(templateControllerProvider.future);
    expect(state.seats, 12);
  });

  test(
    'confirms the current receipt and keeps the receipt state intact',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final subscription = container.listen(
        templateControllerProvider,
        (previous, next) {},
      );
      addTearDown(subscription.close);
      final controller = container.read(templateControllerProvider.notifier);

      await container.read(templateControllerProvider.future);
      await controller.confirmReceipt();

      final state = await container.read(templateControllerProvider.future);
      expect(state.receipt.total, 328);
    },
  );

  test(
    'confirmed count increments via the stream after each confirmation',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final controllerSubscription = container.listen(
        templateControllerProvider,
        (previous, next) {},
      );
      addTearDown(controllerSubscription.close);
      final controller = container.read(templateControllerProvider.notifier);

      await container.read(templateControllerProvider.future);

      final values = <int>[];
      final subscription = container.listen<AsyncValue<int>>(
        templateConfirmedCountProvider,
        (previous, next) => next.whenData(values.add),
        fireImmediately: true,
      );

      await controller.confirmReceipt();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(values, contains(1));
      addTearDown(subscription.close);
    },
  );
}
