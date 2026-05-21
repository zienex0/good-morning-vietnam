import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/template/data/template_repository.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_receipt.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'confirm_template_receipt_use_case.g.dart';

/// Confirms a receipt, committing the current seat and track selection.
///
/// Validates business rules before reaching the repository. A receipt without
/// a track selected cannot be confirmed — the user must choose one first.
class ConfirmTemplateReceiptUseCase {
  const ConfirmTemplateReceiptUseCase(this._repository);

  final TemplateRepository _repository;

  Future<Result<void, Failure>> call(ProjectReceipt receipt) {
    if (receipt.track == null) {
      return Future.value(
        const Err(ValidationFailure('Select a project track before confirming.')),
      );
    }
    return _repository.confirmReceipt(receipt);
  }
}

@Riverpod(keepAlive: true)
ConfirmTemplateReceiptUseCase confirmTemplateReceiptUseCase(
  ConfirmTemplateReceiptUseCaseRef ref,
) {
  return ConfirmTemplateReceiptUseCase(ref.watch(templateRepositoryProvider));
}
