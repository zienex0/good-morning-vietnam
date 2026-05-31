import 'package:flutter_foundation_kit/core/application/local_crud_notifier.dart';
import 'package:flutter_foundation_kit/core/data/repository_capabilities.dart';
import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/accounts/data/account_repository.dart';
import 'package:flutter_foundation_kit/features/accounts/domain/account.dart';
import 'package:flutter_foundation_kit/features/transactions/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/transactions/data/exchange_rate_repository.dart';
import 'package:flutter_foundation_kit/features/transactions/data/transaction_repository.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/amortization.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/categories.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_controller.g.dart';

/// Owns every transaction (across all trips) plus the money-movement flows.
///
/// Plain deletes/reads come from [LocalCrudNotifier]; the four creation flows
/// ([createExpense] / [createTopUp] / [createTransfer] / [setAccountBalances])
/// build a fully-formed [Transaction] from form inputs — looking up the trip
/// and accounts and converting currency via [ConvertToHomeCurrencyUseCase] —
/// then persist it through [create]. The shared conversion logic stays a use
/// case because the spend read providers use it too.
@riverpod
class TransactionsController extends _$TransactionsController
    with LocalCrudNotifier<Transaction> {
  @override
  CrudRepository<Transaction, String> get repository =>
      ref.read(transactionRepositoryProvider);

  @override
  Stream<List<Transaction>> build() => watchAll();

  ConvertToHomeCurrencyUseCase get _convert =>
      ConvertToHomeCurrencyUseCase(ref.read(exchangeRateRepositoryProvider));

  String _newId() => 'txn-${DateTime.now().microsecondsSinceEpoch}';

  /// Records an expense paid from [accountId].
  Future<Result<Transaction>> createExpense({
    required String tripId,
    required String accountId,
    required String categoryId,
    required double amount,
    String? paidCurrency,
    Amortization? amortization,
  }) async {
    if (amount <= 0) {
      return const Err(ValidationFailure('Expense amount must be positive.'));
    }
    if (categoryId.trim().isEmpty) {
      return const Err(ValidationFailure('Expense category is required.'));
    }
    final context = await _resolveAccount(tripId, accountId);
    if (context case Err(failure: final failure)) {
      return Err(failure);
    }
    final account = (context as Ok<Account>).value;
    final occurredAt = DateTime.now();
    final currency = _currencyOr(paidCurrency, account.currency);

    final converted = await _convert(
      amount: amount,
      sourceCurrency: currency,
      homeCurrency: account.currency,
      date: occurredAt,
    );
    if (converted case Err(failure: final failure)) {
      return Err(failure);
    }

    return create(
      Transaction(
        id: _newId(),
        tripId: tripId,
        type: TransactionType.expense,
        occurredAt: occurredAt,
        sourceAccountId: account.id,
        categoryId: categoryId,
        paidAmount: amount,
        paidCurrency: currency,
        accountAmount: (converted as Ok<({double amountHome, double fxRate})>).value.amountHome,
        accountCurrency: account.currency,
        amortization: amortization,
        createdAt: occurredAt,
      ),
    );
  }

  /// Records money added to [accountId].
  Future<Result<Transaction>> createTopUp({
    required String tripId,
    required String accountId,
    required double amount,
    String? paidCurrency,
  }) async {
    if (amount <= 0) {
      return const Err(ValidationFailure('Top-up amount must be positive.'));
    }
    final context = await _resolveAccount(tripId, accountId);
    if (context case Err(failure: final failure)) {
      return Err(failure);
    }
    final account = (context as Ok<Account>).value;
    final occurredAt = DateTime.now();
    final currency = _currencyOr(paidCurrency, account.currency);

    final converted = await _convert(
      amount: amount,
      sourceCurrency: currency,
      homeCurrency: account.currency,
      date: occurredAt,
    );
    if (converted case Err(failure: final failure)) {
      return Err(failure);
    }

    return create(
      Transaction(
        id: _newId(),
        tripId: tripId,
        type: TransactionType.income,
        occurredAt: occurredAt,
        destAccountId: account.id,
        paidAmount: amount,
        paidCurrency: currency,
        accountAmount: (converted as Ok<({double amountHome, double fxRate})>).value.amountHome,
        accountCurrency: account.currency,
        createdAt: occurredAt,
      ),
    );
  }

  /// Records a transfer between two accounts of the active trip.
  Future<Result<Transaction>> createTransfer({
    required String tripId,
    required String sourceAccountId,
    required String destAccountId,
    required double amount,
    double? destAmount,
  }) async {
    if (amount <= 0) {
      return const Err(ValidationFailure('Transfer amount must be positive.'));
    }
    if (destAmount != null && destAmount <= 0) {
      return const Err(ValidationFailure('Received amount must be positive.'));
    }
    if (sourceAccountId == destAccountId) {
      return const Err(
        ValidationFailure('Choose two different accounts to transfer between.'),
      );
    }

    final source = await _resolveAccount(tripId, sourceAccountId);
    if (source case Err(failure: final failure)) {
      return Err(failure);
    }
    final dest = await _resolveAccount(tripId, destAccountId);
    if (dest case Err(failure: final failure)) {
      return Err(failure);
    }
    final sourceAccount = (source as Ok<Account>).value;
    final destAccount = (dest as Ok<Account>).value;
    final occurredAt = DateTime.now();

    final double resolvedDestAmount;
    if (sourceAccount.currency == destAccount.currency) {
      resolvedDestAmount = destAmount ?? amount;
    } else if (destAmount != null) {
      resolvedDestAmount = destAmount;
    } else {
      final cross = await _convert(
        amount: amount,
        sourceCurrency: sourceAccount.currency,
        homeCurrency: destAccount.currency,
        date: occurredAt,
      );
      if (cross case Err(failure: final failure)) {
        return Err(failure);
      }
      resolvedDestAmount = (cross as Ok<({double amountHome, double fxRate})>).value.amountHome;
    }

    return create(
      Transaction(
        id: _newId(),
        tripId: tripId,
        type: TransactionType.transfer,
        occurredAt: occurredAt,
        sourceAccountId: sourceAccount.id,
        destAccountId: destAccount.id,
        paidAmount: amount,
        paidCurrency: sourceAccount.currency,
        accountAmount: amount,
        accountCurrency: sourceAccount.currency,
        destAmount: resolvedDestAmount,
        destCurrency: destAccount.currency,
        createdAt: occurredAt,
      ),
    );
  }

  /// Reconciles account balances by writing adjustment transactions for each
  /// account whose target differs from its current balance.
  Future<Result<void>> setAccountBalances({
    required String tripId,
    required Map<String, double> balancesByAccountId,
  }) async {
    if (balancesByAccountId.isEmpty) {
      return const Ok(null);
    }
    for (final value in balancesByAccountId.values) {
      if (value < 0) {
        return const Err(
          ValidationFailure('Account balance cannot be negative.'),
        );
      }
    }

    final accounts = await ref
        .read(accountRepositoryProvider)
        .watchAll()
        .first;
    final tripAccounts = {
      for (final account in accounts)
        if (account.tripId == tripId) account.id: account,
    };
    for (final accountId in balancesByAccountId.keys) {
      if (!tripAccounts.containsKey(accountId)) {
        return const Err(ValidationFailure('Account does not belong to trip.'));
      }
    }

    final transactions = await watchAll().first;
    final occurredAt = DateTime.now();
    for (final entry in balancesByAccountId.entries) {
      final account = tripAccounts[entry.key]!;
      final delta = entry.value - account.balanceFrom(transactions);
      if (delta.abs() < 0.000001) {
        continue;
      }
      final adjustment = delta > 0
          ? Transaction(
              id: _newId(),
              tripId: tripId,
              type: TransactionType.income,
              occurredAt: occurredAt,
              destAccountId: account.id,
              paidAmount: delta,
              paidCurrency: account.currency,
              accountAmount: delta,
              accountCurrency: account.currency,
              note: 'Set balance',
              createdAt: occurredAt,
            )
          : Transaction(
              id: _newId(),
              tripId: tripId,
              type: TransactionType.expense,
              occurredAt: occurredAt,
              sourceAccountId: account.id,
              categoryId: kBudgetingBalanceAdjustmentCategoryId,
              paidAmount: delta.abs(),
              paidCurrency: account.currency,
              accountAmount: delta.abs(),
              accountCurrency: account.currency,
              note: 'Set balance',
              createdAt: occurredAt,
            );
      final result = await create(adjustment);
      if (result case Err(failure: final failure)) {
        return Err(failure);
      }
    }
    return const Ok(null);
  }

  /// Fetches [accountId] and confirms it belongs to [tripId].
  Future<Result<Account>> _resolveAccount(
    String tripId,
    String accountId,
  ) async {
    final accounts = await ref
        .read(accountRepositoryProvider)
        .watchAll()
        .first;
    for (final account in accounts) {
      if (account.id == accountId) {
        if (account.tripId != tripId) {
          return const Err(
            ValidationFailure('Account does not belong to trip.'),
          );
        }
        return Ok(account);
      }
    }
    return const Err(NotFoundFailure());
  }

  CurrencyCode _currencyOr(String? entered, CurrencyCode fallback) {
    final trimmed = entered?.trim().toUpperCase();
    return (trimmed == null || trimmed.isEmpty) ? fallback : trimmed;
  }
}
