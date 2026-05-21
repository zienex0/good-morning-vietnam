import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/template/application/use_cases/confirm_template_receipt_use_case.dart';
import 'package:flutter_foundation_kit/features/template/data/template_repository.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_receipt.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_track.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockTemplateRepository extends Mock implements TemplateRepository {}

void main() {
  late _MockTemplateRepository repo;
  late ConfirmTemplateReceiptUseCase useCase;

  setUpAll(() {
    registerFallbackValue(
      const ProjectReceipt(track: ProjectTrack.engineering, seats: 1),
    );
  });

  setUp(() {
    repo = _MockTemplateRepository();
    useCase = ConfirmTemplateReceiptUseCase(repo);
  });

  test('returns a ValidationFailure without calling the repository when track is null', () async {
    const receipt = ProjectReceipt(track: null, seats: 3);

    final result = await useCase(receipt);

    expect(result, isA<Err<void, Failure>>());
    verifyNever(() => repo.confirmReceipt(any()));
  });

  test('delegates to the repository when the receipt has a track selected', () async {
    const receipt = ProjectReceipt(track: ProjectTrack.engineering, seats: 3);
    when(() => repo.confirmReceipt(receipt)).thenAnswer((_) async => const Ok(null));

    final result = await useCase(receipt);

    expect(result, isA<Ok<void, Failure>>());
    verify(() => repo.confirmReceipt(receipt)).called(1);
  });
}
