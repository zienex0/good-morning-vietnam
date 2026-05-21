import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/template/application/use_cases/watch_confirmed_count_use_case.dart';
import 'package:flutter_foundation_kit/features/template/data/template_repository.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_receipt.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_track.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockTemplateRepository extends Mock implements TemplateRepository {}

void main() {
  late _MockTemplateRepository repo;
  late WatchConfirmedCountUseCase useCase;

  setUpAll(() {
    registerFallbackValue(
      const ProjectReceipt(track: ProjectTrack.engineering, seats: 1),
    );
  });

  setUp(() {
    repo = _MockTemplateRepository();
    useCase = WatchConfirmedCountUseCase(repo);
  });

  test('delegates to the repository and returns the stream', () {
    final stream = Stream.value(3);
    when(() => repo.watchConfirmedCount()).thenReturn(stream);

    expect(useCase.call(), equals(stream));
    verify(() => repo.watchConfirmedCount()).called(1);
  });

  test('emits each value the repository stream produces', () async {
    when(() => repo.watchConfirmedCount())
        .thenReturn(Stream.fromIterable([0, 1, 2]));

    expect(useCase.call(), emitsInOrder([0, 1, 2]));
  });
}
