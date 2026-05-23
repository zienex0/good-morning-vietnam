import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_account_use_case.g.dart';

class EditAccountUseCase {
  const EditAccountUseCase(this._repository);

  final BudgetingRepository _repository;

  Future<Result<Account, Failure>> call({
    required String accountId,
    required String name,
  }) async {
    if (name.trim().isEmpty) {
      return const Err(ValidationFailure('Account name is required.'));
    }

    final accountResult = await _repository.fetchAccountById(
      accountId: accountId,
    );
    switch (accountResult) {
      case Ok(value: final account):
        return _repository.updateAccount(account.copyWith(name: name.trim()));
      case Err(failure: final failure):
        return Err(failure);
    }
  }
}

@Riverpod(keepAlive: true)
EditAccountUseCase editAccountUseCase(EditAccountUseCaseRef ref) {
  return EditAccountUseCase(ref.watch(budgetingRepositoryProvider));
}
