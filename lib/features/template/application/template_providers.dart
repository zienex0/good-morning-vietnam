import 'package:flutter_foundation_kit/core/logging/logger.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/template/application/template_state.dart';
import 'package:flutter_foundation_kit/features/template/application/use_cases/confirm_template_receipt_use_case.dart';
import 'package:flutter_foundation_kit/features/template/application/use_cases/load_template_receipt_use_case.dart';
import 'package:flutter_foundation_kit/features/template/data/template_repository.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_track.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'template_providers.g.dart';

@Riverpod(keepAlive: true)
TemplateRepository templateRepository(Ref ref) {
  final repo = FakeTemplateRepository();
  ref.onDispose(repo.dispose);
  return repo;
}

/// Streams the running count of confirmed receipts for this session, straight
/// from the repository. Updates automatically after each [confirmReceipt] call
/// without any local state tracking.
@riverpod
Stream<int> templateConfirmedCount(Ref ref) {
  return ref.watch(templateRepositoryProvider).watchConfirmedCount();
}

@riverpod
class TemplateController extends _$TemplateController {
  static const int minSeats = 1;
  static const int maxSeats = 12;

  TemplateRepository get _repository => ref.read(templateRepositoryProvider);

  @override
  Future<TemplateState> build() async {
    final result = await LoadTemplateReceiptUseCase(_repository)(
      track: ProjectTrack.engineering,
      seats: 3,
    );

    return switch (result) {
      Ok(value: final receipt) => TemplateState.fromReceipt(receipt),
      Err(failure: final failure) => throw failure,
    };
  }

  Future<void> setTrack(ProjectTrack? track) async {
    final previous = state.value ?? const TemplateState.initial();
    await _loadReceipt(track: track, seats: previous.seats);
  }

  Future<void> setSeats(int seats) async {
    final previous = state.value ?? const TemplateState.initial();
    await _loadReceipt(
      track: previous.track,
      seats: seats.clamp(minSeats, maxSeats),
    );
  }

  Future<void> incrementSeats() async {
    final previous = state.value ?? const TemplateState.initial();
    await setSeats(previous.seats + 1);
  }

  Future<void> decrementSeats() async {
    final previous = state.value ?? const TemplateState.initial();
    await setSeats(previous.seats - 1);
  }

  Future<void> confirmReceipt() async {
    final current = state.value;
    if (current == null) {
      return;
    }

    // The framework re-attaches the previous data to loading/error states, so
    // the UI keeps showing the receipt while this runs.
    state = const AsyncLoading<TemplateState>();

    final result = await ConfirmTemplateReceiptUseCase(_repository)(
      current.receipt,
    );

    switch (result) {
      case Ok<void, Failure>():
        state = AsyncData(current); // count is owned by the stream provider
      case Err<void, Failure>(failure: final failure):
        ref
            .read(loggerProvider)
            .warn('Template receipt confirmation failed', error: failure);
        state = AsyncError<TemplateState>(failure, StackTrace.current);
    }
  }

  Future<void> _loadReceipt({
    required ProjectTrack? track,
    required int seats,
  }) async {
    final previous = state.value ?? const TemplateState.initial();
    state = const AsyncLoading<TemplateState>();

    final result = await LoadTemplateReceiptUseCase(_repository)(
      track: track,
      seats: seats,
    );

    state = switch (result) {
      Ok(value: final receipt) => AsyncData(
        previous.copyWith(track: receipt.track, seats: receipt.seats),
      ),
      Err(failure: final failure) => AsyncError<TemplateState>(
        failure,
        StackTrace.current,
      ),
    };
  }
}
