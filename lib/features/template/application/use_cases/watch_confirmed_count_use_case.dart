import 'package:flutter_foundation_kit/features/template/data/template_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'watch_confirmed_count_use_case.g.dart';

/// Streams the running count of confirmed receipts for this session.
///
/// Emits the current count immediately on subscription, then again after each
/// confirmation. The controller never needs to track this value locally — the
/// stream delivers it reactively to any widget that watches the provider.
class WatchConfirmedCountUseCase {
  const WatchConfirmedCountUseCase(this._repository);

  final TemplateRepository _repository;

  Stream<int> call() => _repository.watchConfirmedCount();
}

@Riverpod(keepAlive: true)
WatchConfirmedCountUseCase watchConfirmedCountUseCase(
  WatchConfirmedCountUseCaseRef ref,
) {
  return WatchConfirmedCountUseCase(ref.watch(templateRepositoryProvider));
}
