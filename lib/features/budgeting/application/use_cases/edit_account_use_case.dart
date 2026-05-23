import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/account_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';

class EditAccountUseCase {
  const EditAccountUseCase(this._repository);

  final AccountRepository _repository;

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
