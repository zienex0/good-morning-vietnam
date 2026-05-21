import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/template/data/template_repository.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_receipt.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_track.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'load_template_receipt_use_case.g.dart';

/// Loads a receipt preview for the given track and seat count.
///
/// Validates business rules before reaching the repository. Add orchestration
/// here (multi-repo calls, result mapping, pre-checks) before considering
/// changes to the controller or the repository.
class LoadTemplateReceiptUseCase {
  const LoadTemplateReceiptUseCase(this._repository);

  final TemplateRepository _repository;

  Future<Result<ProjectReceipt, Failure>> call({
    required ProjectTrack? track,
    required int seats,
  }) {
    if (seats < 1) {
      return Future.value(
        const Err(ValidationFailure('At least one seat is required.')),
      );
    }
    return _repository.fetchReceipt(track: track, seats: seats);
  }
}

@Riverpod(keepAlive: true)
LoadTemplateReceiptUseCase loadTemplateReceiptUseCase(
  LoadTemplateReceiptUseCaseRef ref,
) {
  return LoadTemplateReceiptUseCase(ref.watch(templateRepositoryProvider));
}
