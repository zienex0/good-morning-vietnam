import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'load_trips_use_case.g.dart';

class LoadTripsUseCase {
  const LoadTripsUseCase(this._repository);

  final BudgetingRepository _repository;

  Future<Result<List<Trip>, Failure>> call() => _repository.listTrips();
}

@Riverpod(keepAlive: true)
LoadTripsUseCase loadTripsUseCase(LoadTripsUseCaseRef ref) {
  return LoadTripsUseCase(ref.watch(budgetingRepositoryProvider));
}
