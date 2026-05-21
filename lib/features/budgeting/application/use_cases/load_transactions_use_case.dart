import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'load_transactions_use_case.g.dart';

class LoadTransactionsUseCase {
  const LoadTransactionsUseCase(this._repository);

  final BudgetingRepository _repository;

  Future<Result<List<Transaction>, Failure>> call({required String tripId}) {
    if (tripId.trim().isEmpty) {
      return Future.value(const Err(ValidationFailure('Trip id is required.')));
    }
    return _repository.fetchTransactions(tripId: tripId);
  }
}

@Riverpod(keepAlive: true)
LoadTransactionsUseCase loadTransactionsUseCase(
  LoadTransactionsUseCaseRef ref,
) {
  return LoadTransactionsUseCase(ref.watch(budgetingRepositoryProvider));
}
