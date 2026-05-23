import 'dart:convert';

import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/hive_budgeting_boxes.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/mappers/account_mapper.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';

abstract interface class AccountRepository {
  Future<Result<List<Account>, Failure>> fetchAccounts({
    required String tripId,
    bool includeArchived = false,
  });

  Stream<List<Account>> watchAccounts({
    required String tripId,
    bool includeArchived = false,
  });

  Future<Result<Account, Failure>> fetchAccountById({
    required String accountId,
  });

  Future<Result<Account, Failure>> createAccount(Account account);

  Future<Result<Account, Failure>> updateAccount(Account account);

  Future<Result<void, Failure>> deleteAccount({required String accountId});

  /// Removes every account belonging to [tripId] (used by the delete-trip
  /// cascade).
  Future<Result<void, Failure>> deleteAccountsForTrip({required String tripId});
}

class HiveAccountRepository implements AccountRepository {
  HiveAccountRepository({required this.boxes});

  final HiveBudgetingBoxes boxes;

  Account _decode(String raw) =>
      accountFromJson(jsonDecode(raw) as Map<String, dynamic>);

  @override
  Future<Result<List<Account>, Failure>> fetchAccounts({
    required String tripId,
    bool includeArchived = false,
  }) async {
    final accounts =
        boxes.accounts.values
            .map(_decode)
            .where((account) => account.tripId == tripId)
            .where((account) => includeArchived || !account.archived)
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));
    return Ok(accounts);
  }

  @override
  Stream<List<Account>> watchAccounts({
    required String tripId,
    bool includeArchived = false,
  }) async* {
    Future<List<Account>> read() async {
      final result = await fetchAccounts(
        tripId: tripId,
        includeArchived: includeArchived,
      );
      return switch (result) {
        Ok(value: final value) => value,
        Err(failure: final failure) => throw failure,
      };
    }

    yield await read();
    yield* boxes.accounts.watch().asyncMap((_) => read());
  }

  @override
  Future<Result<Account, Failure>> fetchAccountById({
    required String accountId,
  }) async {
    final raw = boxes.accounts.get(accountId);
    if (raw == null) {
      return const Err(NotFoundFailure());
    }
    return Ok(_decode(raw));
  }

  @override
  Future<Result<Account, Failure>> createAccount(Account account) async {
    await boxes.accounts.put(account.id, jsonEncode(accountToJson(account)));
    return Ok(account);
  }

  @override
  Future<Result<Account, Failure>> updateAccount(Account account) async {
    if (!boxes.accounts.containsKey(account.id)) {
      return const Err(NotFoundFailure());
    }
    await boxes.accounts.put(account.id, jsonEncode(accountToJson(account)));
    return Ok(account);
  }

  @override
  Future<Result<void, Failure>> deleteAccount({
    required String accountId,
  }) async {
    if (!boxes.accounts.containsKey(accountId)) {
      return const Err(NotFoundFailure());
    }
    await boxes.accounts.delete(accountId);
    return const Ok(null);
  }

  @override
  Future<Result<void, Failure>> deleteAccountsForTrip({
    required String tripId,
  }) async {
    final ids = <dynamic>[];
    for (final key in boxes.accounts.keys) {
      final raw = boxes.accounts.get(key);
      if (raw == null) {
        continue;
      }
      if (_decode(raw).tripId == tripId) {
        ids.add(key);
      }
    }
    await boxes.accounts.deleteAll(ids);
    return const Ok(null);
  }
}
