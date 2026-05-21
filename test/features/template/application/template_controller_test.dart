import 'package:flutter_foundation_kit/features/template/application/template_controller.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_track.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('starts with a useful sample state', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = await container.read(templateControllerProvider.future);

    expect(state.track, ProjectTrack.engineering);
    expect(state.seats, 3);
    expect(state.confirmedCount, 0);
    expect(state.receipt.total, 328);
  });

  test('updates track through an intent method', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(templateControllerProvider.notifier);

    await container.read(templateControllerProvider.future);
    await controller.setTrack(ProjectTrack.design);

    final state = container.read(templateControllerProvider).requireValue;
    expect(state.track, ProjectTrack.design);
  });

  test('increments seats through an intent method', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(templateControllerProvider.notifier);

    await container.read(templateControllerProvider.future);
    await controller.incrementSeats();

    expect(container.read(templateControllerProvider).requireValue.seats, 4);
  });

  test('clamps seats to the minimum supported bound', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(templateControllerProvider.notifier);

    await container.read(templateControllerProvider.future);
    await controller.setSeats(-10);

    expect(container.read(templateControllerProvider).requireValue.seats, 1);
  });

  test('clamps seats to the maximum supported bound', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(templateControllerProvider.notifier);

    await container.read(templateControllerProvider.future);
    await controller.setSeats(40);

    expect(container.read(templateControllerProvider).requireValue.seats, 12);
  });

  test('confirms the current receipt and keeps the receipt state intact', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(templateControllerProvider.notifier);

    await container.read(templateControllerProvider.future);
    await controller.confirmReceipt();

    final state = container.read(templateControllerProvider).requireValue;
    expect(state.receipt.total, 328);
  });

  test('confirmed count increments via the stream after each confirmation', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(templateControllerProvider.notifier);

    await container.read(templateControllerProvider.future);

    // Grab the first value from the stream (current count = 0).
    final countStream = container.read(templateConfirmedCountProvider.stream);

    await controller.confirmReceipt();

    expect(await countStream.first, 1);
  });
}
