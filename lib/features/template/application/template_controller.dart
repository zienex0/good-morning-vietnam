import 'package:flutter_foundation_kit/core/application/local_crud_notifier.dart';
import 'package:flutter_foundation_kit/core/data/repository_capabilities.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/template/data/template_repository.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_receipt.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'template_controller.g.dart';

/// Manages the persisted list of confirmed project receipts.
///
/// This controller is the canonical example of [LocalCrudNotifier] usage:
/// - [build] wires the live repository stream into the provider state.
/// - [beforeCreate] validates and transforms a draft receipt into a confirmed
///   one (adds timestamp + id) before it reaches the repository.
/// - The page holds form state (track, seats) locally; the controller only
///   knows about what has been confirmed and stored.
@riverpod
class TemplateController extends _$TemplateController
    with LocalCrudNotifier<ProjectReceipt> {
  static const int minSeats = 1;
  static const int maxSeats = 12;

  @override
  CrudRepository<ProjectReceipt, String> get repository =>
      ref.read(templateRepositoryProvider);

  @override
  Stream<List<ProjectReceipt>> build() => watchAll();

  /// Validates the draft and stamps it as confirmed before storing.
  ///
  /// Rejects a null track or fewer than [minSeats] seats. On success returns
  /// a [ProjectReceipt.confirmed] with a unique id and [DateTime.now()].
  @override
  Future<Result<ProjectReceipt>> beforeCreate(ProjectReceipt draft) async {
    if (draft.track == null) {
      return const Err(
        ValidationFailure('Select a project track before confirming.'),
      );
    }
    if (draft.seats < minSeats) {
      return const Err(ValidationFailure('At least one seat is required.'));
    }
    return Ok(
      ProjectReceipt.confirmed(track: draft.track, seats: draft.seats),
    );
  }
}
