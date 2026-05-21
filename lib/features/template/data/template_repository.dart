import 'dart:async';

import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_receipt.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_track.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'template_repository.g.dart';

abstract interface class TemplateRepository {
  Future<Result<ProjectReceipt, Failure>> fetchReceipt({
    required ProjectTrack? track,
    required int seats,
  });

  Future<Result<void, Failure>> confirmReceipt(ProjectReceipt receipt);

  /// Emits the running count of confirmed receipts for this session.
  /// Emits the current count immediately on subscription, then again after
  /// each successful [confirmReceipt] call.
  Stream<int> watchConfirmedCount();
}

class FakeTemplateRepository implements TemplateRepository {
  FakeTemplateRepository();

  int _confirmedCount = 0;
  final _countController = StreamController<int>.broadcast();

  void dispose() => _countController.close();

  @override
  Future<Result<ProjectReceipt, Failure>> fetchReceipt({
    required ProjectTrack? track,
    required int seats,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return Ok(ProjectReceipt(track: track, seats: seats));
  }

  @override
  Future<Result<void, Failure>> confirmReceipt(ProjectReceipt receipt) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    _confirmedCount++;
    _countController.add(_confirmedCount);
    return const Ok(null);
  }

  @override
  Stream<int> watchConfirmedCount() async* {
    yield _confirmedCount;
    yield* _countController.stream;
  }
}

@Riverpod(keepAlive: true)
TemplateRepository templateRepository(TemplateRepositoryRef ref) {
  final repo = FakeTemplateRepository();
  ref.onDispose(repo.dispose);
  return repo;
}

