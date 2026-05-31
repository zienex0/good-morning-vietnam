import 'package:flutter_foundation_kit/core/application/local_crud_notifier.dart';
import 'package:flutter_foundation_kit/core/data/repository_capabilities.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/accounts/data/account_repository.dart';
import 'package:flutter_foundation_kit/features/accounts/domain/account.dart';
import 'package:flutter_foundation_kit/features/transactions/data/transaction_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounts_controller.g.dart';

/// Owns every account (across all trips) plus account writes.
///
/// The UI watches trip-scoped read providers built on top of this list, so the
/// controller stays a plain CRUD store: validation in [beforeCreate] /
/// [beforeUpdate]; the delete-account cascade (its transactions) in
/// [afterDelete]. No use cases.
@riverpod
class AccountsController extends _$AccountsController
    with LocalCrudNotifier<Account> {
  @override
  CrudRepository<Account, String> get repository =>
      ref.read(accountRepositoryProvider);

  @override
  Stream<List<Account>> build() => watchAll();

  @override
  Future<Result<Account>> beforeCreate(Account draft) async {
    final normalized = _normalize(draft);
    final failure = _validate(normalized);
    if (failure != null) {
      return Err(failure);
    }
    final id = draft.id.isEmpty
        ? 'acct-${DateTime.now().microsecondsSinceEpoch}'
        : draft.id;
    return Ok(normalized.copyWith(id: id));
  }

  @override
  Future<Result<Account>> beforeUpdate(Account draft) async {
    final normalized = _normalize(draft);
    final failure = _validate(normalized);
    return failure != null ? Err(failure) : Ok(normalized);
  }

  /// Deleting an account removes every transaction that touches it.
  @override
  Future<void> afterDelete(String id, Result<void> result) async {
    if (result is! Ok<void>) {
      return;
    }
    final transactions = ref.read(transactionRepositoryProvider);
    for (final transaction in await transactions.watchAll().first) {
      if (transaction.sourceAccountId == id ||
          transaction.destAccountId == id) {
        await transactions.deleteById(transaction.id);
      }
    }
  }

  Account _normalize(Account account) => account.copyWith(
    name: account.name.trim(),
    currency: account.currency.trim().toUpperCase(),
  );

  Failure? _validate(Account account) {
    if (account.name.isEmpty) {
      return const ValidationFailure('Account name is required.');
    }
    if (account.currency.isEmpty) {
      return const ValidationFailure('Account currency is required.');
    }
    if (account.openingBalance < 0) {
      return const ValidationFailure('Opening balance cannot be negative.');
    }
    return null;
  }
}
