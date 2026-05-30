import 'package:flutter_foundation_kit/core/data/data.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/template/application/template_controller.dart';
import 'package:flutter_foundation_kit/features/template/data/template_repository.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_receipt.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_track.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory fake that isolates controller tests from Hive.
class _FakeTemplateRepository
    implements CrudRepository<ProjectReceipt, String> {
  final List<ProjectReceipt> stored = [];

  @override
  Future<Result<ProjectReceipt>> create(ProjectReceipt entity) async {
    stored.add(entity);
    return Ok(entity);
  }

  @override
  Stream<List<ProjectReceipt>> watchAll() => Stream.value(List.of(stored));

  @override
  Future<Result<ProjectReceipt>> fetchById(String id) async =>
      const Err(NotFoundFailure());

  @override
  Future<Result<ProjectReceipt>> update(ProjectReceipt entity) async =>
      Ok(entity);

  @override
  Future<Result<void>> deleteById(String id) async => const Ok(null);
}

ProviderContainer _container(_FakeTemplateRepository fakeRepo) =>
    ProviderContainer(
      overrides: [templateRepositoryProvider.overrideWithValue(fakeRepo)],
    );

void main() {
  group('beforeCreate validation', () {
    test('rejects a null track', () async {
      final repo = _FakeTemplateRepository();
      final container = _container(repo);
      addTearDown(container.dispose);
      final controller = container.read(templateControllerProvider.notifier);

      final result = await controller.create(
        const ProjectReceipt(track: null, seats: 3),
      );

      expect(result, isA<Err<ProjectReceipt>>());
      expect(repo.stored, isEmpty);
    });

    test('rejects zero seats', () async {
      final repo = _FakeTemplateRepository();
      final container = _container(repo);
      addTearDown(container.dispose);
      final controller = container.read(templateControllerProvider.notifier);

      final result = await controller.create(
        const ProjectReceipt(track: ProjectTrack.engineering, seats: 0),
      );

      expect(result, isA<Err<ProjectReceipt>>());
      expect(repo.stored, isEmpty);
    });

    test('rejects negative seats', () async {
      final repo = _FakeTemplateRepository();
      final container = _container(repo);
      addTearDown(container.dispose);
      final controller = container.read(templateControllerProvider.notifier);

      final result = await controller.create(
        const ProjectReceipt(track: ProjectTrack.design, seats: -1),
      );

      expect(result, isA<Err<ProjectReceipt>>());
    });
  });

  group('beforeCreate transformation', () {
    test('stamps confirmedAt before storing', () async {
      final repo = _FakeTemplateRepository();
      final container = _container(repo);
      addTearDown(container.dispose);
      final controller = container.read(templateControllerProvider.notifier);

      await controller.create(
        const ProjectReceipt(track: ProjectTrack.engineering, seats: 3),
      );

      expect(repo.stored, hasLength(1));
      expect(repo.stored.first.confirmedAt, isNotNull);
    });

    test('generates a non-empty id before storing', () async {
      final repo = _FakeTemplateRepository();
      final container = _container(repo);
      addTearDown(container.dispose);
      final controller = container.read(templateControllerProvider.notifier);

      await controller.create(
        const ProjectReceipt(track: ProjectTrack.growth, seats: 2),
      );

      expect(repo.stored.first.id, isNotEmpty);
    });

    test('preserves track and seat count from the draft', () async {
      final repo = _FakeTemplateRepository();
      final container = _container(repo);
      addTearDown(container.dispose);
      final controller = container.read(templateControllerProvider.notifier);

      await controller.create(
        const ProjectReceipt(track: ProjectTrack.design, seats: 5),
      );

      expect(repo.stored.first.track, ProjectTrack.design);
      expect(repo.stored.first.seats, 5);
    });
  });

  test('successful create returns Ok', () async {
    final repo = _FakeTemplateRepository();
    final container = _container(repo);
    addTearDown(container.dispose);
    final controller = container.read(templateControllerProvider.notifier);

    final result = await controller.create(
      const ProjectReceipt(track: ProjectTrack.engineering, seats: 3),
    );

    expect(result, isA<Ok<ProjectReceipt>>());
  });
}
