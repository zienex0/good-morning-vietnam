import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_transaction_by_id_use_case.g.dart';

class GetTransactionByIdUseCase {
  const GetTransactionByIdUseCase(this._repository);

  final BudgetingRepository _repository;

  Future<Result<Transaction, Failure>> call({required String transactionId}) {
    if (transactionId.trim().isEmpty) {
      return Future.value(
        const Err(ValidationFailure('Transaction id is required.')),
      );
    }
    return _repository.fetchTransactionById(transactionId: transactionId);
  }
}

@Riverpod(keepAlive: true)
GetTransactionByIdUseCase getTransactionByIdUseCase(
  GetTransactionByIdUseCaseRef ref,
) {
  return GetTransactionByIdUseCase(ref.watch(budgetingRepositoryProvider));
}
