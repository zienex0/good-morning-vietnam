import 'package:flutter_foundation_kit/core/logging/logger.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/template/application/template_state.dart';
import 'package:flutter_foundation_kit/features/template/application/use_cases/confirm_template_receipt_use_case.dart';
import 'package:flutter_foundation_kit/features/template/application/use_cases/load_template_receipt_use_case.dart';
import 'package:flutter_foundation_kit/features/template/application/use_cases/watch_confirmed_count_use_case.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_track.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'template_controller.g.dart';

@riverpod
class TemplateController extends _$TemplateController {
  static const int minSeats = 1;
  static const int maxSeats = 12;

  @override
  Future<TemplateState> build() async {
    final loadReceipt = ref.watch(loadTemplateReceiptUseCaseProvider);
    final result = await loadReceipt(track: ProjectTrack.engineering, seats: 3);

    return switch (result) {
      Ok(value: final receipt) => TemplateState.fromReceipt(receipt),
      Err(failure: final failure) => throw failure,
    };
  }

  Future<void> setTrack(ProjectTrack? track) async {
    final previous = state.valueOrNull ?? const TemplateState.initial();
    await _loadReceipt(track: track, seats: previous.seats);
  }

  Future<void> setSeats(int seats) async {
    final previous = state.valueOrNull ?? const TemplateState.initial();
    await _loadReceipt(
      track: previous.track,
      seats: seats.clamp(minSeats, maxSeats),
    );
  }

  Future<void> incrementSeats() async {
    final previous = state.valueOrNull ?? const TemplateState.initial();
    await setSeats(previous.seats + 1);
  }

  Future<void> decrementSeats() async {
    final previous = state.valueOrNull ?? const TemplateState.initial();
    await setSeats(previous.seats - 1);
  }

  Future<void> confirmReceipt() async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }

    state = AsyncLoading<TemplateState>().copyWithPrevious(state);

    final confirmReceipt = ref.read(confirmTemplateReceiptUseCaseProvider);
    final result = await confirmReceipt(current.receipt);

    switch (result) {
      case Ok<void, Failure>():
        state = AsyncData(current); // count is owned by the stream provider
      case Err<void, Failure>(failure: final failure):
        ref
            .read(loggerProvider)
            .warn('Template receipt confirmation failed', error: failure);
        state = AsyncError<TemplateState>(
          failure,
          StackTrace.current,
        ).copyWithPrevious(AsyncData(current));
    }
  }

  Future<void> _loadReceipt({
    required ProjectTrack? track,
    required int seats,
  }) async {
    final previous = state.valueOrNull ?? const TemplateState.initial();
    state = AsyncLoading<TemplateState>().copyWithPrevious(state);

    final loadReceipt = ref.read(loadTemplateReceiptUseCaseProvider);
    final result = await loadReceipt(track: track, seats: seats);

    state = switch (result) {
      Ok(value: final receipt) => AsyncData(
        previous.copyWith(track: receipt.track, seats: receipt.seats),
      ),
      Err(failure: final failure) => AsyncError<TemplateState>(
        failure,
        StackTrace.current,
      ).copyWithPrevious(AsyncData(previous)),
    };
  }
}

/// Streams the running count of confirmed receipts for this session.
/// Backed by [WatchConfirmedCountUseCase]; updates automatically after each
/// [TemplateController.confirmReceipt] call without any local state tracking.
@riverpod
Stream<int> templateConfirmedCount(TemplateConfirmedCountRef ref) {
  return ref.watch(watchConfirmedCountUseCaseProvider).call();
}
