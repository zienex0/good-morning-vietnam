import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_account_with_transactions_use_case.g.dart';

class DeleteAccountWithTransactionsUseCase {
  const DeleteAccountWithTransactionsUseCase(this._repository);

  final BudgetingRepository _repository;

  Future<Result<void, Failure>> call({required String accountId}) {
    return _repository.deleteAccountWithTransactions(accountId: accountId);
  }
}

@Riverpod(keepAlive: true)
DeleteAccountWithTransactionsUseCase deleteAccountWithTransactionsUseCase(
  DeleteAccountWithTransactionsUseCaseRef ref,
) {
  return DeleteAccountWithTransactionsUseCase(
    ref.watch(budgetingRepositoryProvider),
  );
}
