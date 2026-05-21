import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/template/application/use_cases/load_template_receipt_use_case.dart';
import 'package:flutter_foundation_kit/features/template/data/template_repository.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_receipt.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_track.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockTemplateRepository extends Mock implements TemplateRepository {}

void main() {
  late _MockTemplateRepository repo;
  late LoadTemplateReceiptUseCase useCase;

  setUpAll(() {
    registerFallbackValue<ProjectTrack?>(ProjectTrack.engineering);
  });

  setUp(() {
    repo = _MockTemplateRepository();
    useCase = LoadTemplateReceiptUseCase(repo);
  });

  test('returns a ValidationFailure without calling the repository when seats is zero', () async {
    final result = await useCase(track: ProjectTrack.engineering, seats: 0);

    expect(result, isA<Err<ProjectReceipt, Failure>>());
    verifyNever(
      () => repo.fetchReceipt(
        track: any(named: 'track'),
        seats: any(named: 'seats'),
      ),
    );
  });

  test('delegates to the repository and returns the receipt when seats is valid', () async {
    const receipt = ProjectReceipt(track: ProjectTrack.engineering, seats: 3);
    when(
      () => repo.fetchReceipt(track: ProjectTrack.engineering, seats: 3),
    ).thenAnswer((_) async => const Ok(receipt));

    final result = await useCase(track: ProjectTrack.engineering, seats: 3);

    expect(result, isA<Ok<ProjectReceipt, Failure>>());
    verify(
      () => repo.fetchReceipt(track: ProjectTrack.engineering, seats: 3),
    ).called(1);
  });
}
