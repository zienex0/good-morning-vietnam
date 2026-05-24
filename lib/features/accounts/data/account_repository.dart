import 'dart:convert';

import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/accounts/data/mappers/account_mapper.dart';
import 'package:flutter_foundation_kit/features/accounts/domain/account.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

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
  HiveAccountRepository({required this.accountsBox});

  final Box<String> accountsBox;

  Account _decode(String raw) =>
      accountFromJson(jsonDecode(raw) as Map<String, dynamic>);

  @override
  Future<Result<List<Account>, Failure>> fetchAccounts({
    required String tripId,
    bool includeArchived = false,
  }) async {
    final accounts =
        accountsBox.values
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
    yield* accountsBox.watch().asyncMap((_) => read());
  }

  @override
  Future<Result<Account, Failure>> fetchAccountById({
    required String accountId,
  }) async {
    final raw = accountsBox.get(accountId);
    if (raw == null) {
      return const Err(NotFoundFailure());
    }
    return Ok(_decode(raw));
  }

  @override
  Future<Result<Account, Failure>> createAccount(Account account) async {
    await accountsBox.put(account.id, jsonEncode(accountToJson(account)));
    return Ok(account);
  }

  @override
  Future<Result<Account, Failure>> updateAccount(Account account) async {
    if (!accountsBox.containsKey(account.id)) {
      return const Err(NotFoundFailure());
    }
    await accountsBox.put(account.id, jsonEncode(accountToJson(account)));
    return Ok(account);
  }

  @override
  Future<Result<void, Failure>> deleteAccount({
    required String accountId,
  }) async {
    if (!accountsBox.containsKey(accountId)) {
      return const Err(NotFoundFailure());
    }
    await accountsBox.delete(accountId);
    return const Ok(null);
  }

  @override
  Future<Result<void, Failure>> deleteAccountsForTrip({
    required String tripId,
  }) async {
    final ids = <dynamic>[];
    for (final key in accountsBox.keys) {
      final raw = accountsBox.get(key);
      if (raw == null) {
        continue;
      }
      if (_decode(raw).tripId == tripId) {
        ids.add(key);
      }
    }
    await accountsBox.deleteAll(ids);
    return const Ok(null);
  }
}
