import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/accounts/data/account_repository.dart';
import 'package:flutter_foundation_kit/features/transactions/data/transaction_repository.dart';

/// Deletes an account and every transaction that touches it, coordinating the
/// account and transaction repositories.
class DeleteAccountWithTransactionsUseCase {
  const DeleteAccountWithTransactionsUseCase({
    required AccountRepository accountRepository,
    required TransactionRepository transactionRepository,
  }) : _accountRepository = accountRepository,
       _transactionRepository = transactionRepository;

  final AccountRepository _accountRepository;
  final TransactionRepository _transactionRepository;

  Future<Result<void, Failure>> call({required String accountId}) async {
    final transactionsResult = await _transactionRepository
        .deleteTransactionsForAccount(accountId: accountId);
    if (transactionsResult case Err(failure: final failure)) {
      return Err(failure);
    }
    return _accountRepository.deleteAccount(accountId: accountId);
  }
}
