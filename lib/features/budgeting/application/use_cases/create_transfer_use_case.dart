import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/account_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_id_generator.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/transaction_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/trip_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';

class CreateTransferUseCase {
  const CreateTransferUseCase({
    required TripRepository tripRepository,
    required AccountRepository accountRepository,
    required TransactionRepository transactionRepository,
    required ConvertToHomeCurrencyUseCase convertToHomeCurrency,
    required BudgetingIdGenerator idGenerator,
  }) : _tripRepository = tripRepository,
       _accountRepository = accountRepository,
       _transactionRepository = transactionRepository,
       _convertToHomeCurrency = convertToHomeCurrency,
       _idGenerator = idGenerator;

  final TripRepository _tripRepository;
  final AccountRepository _accountRepository;
  final TransactionRepository _transactionRepository;
  final ConvertToHomeCurrencyUseCase _convertToHomeCurrency;
  final BudgetingIdGenerator _idGenerator;

  /// Records a transfer between two accounts.
  ///
  /// [amount] is in the source account's currency. For cross-currency
  /// transfers, [destAmount] is the amount actually credited to the
  /// destination account in its native currency — pass the bank's effective
  /// figure when known. When omitted, the use case derives it via market FX.
  Future<Result<Transaction, Failure>> call({
    required String tripId,
    required String sourceAccountId,
    required String destAccountId,
    required double amount,
    required DateTime occurredAt,
    double? destAmount,
    String? note,
    DateTime? createdAt,
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

    final tripResult = await _tripRepository.fetchTrip(tripId: tripId);
    final Trip trip;
    switch (tripResult) {
      case Ok(value: final value):
        trip = value;
      case Err(failure: final failure):
        return Err(failure);
    }

    final sourceResult = await _accountRepository.fetchAccountById(
      accountId: sourceAccountId,
    );
    final Account sourceAccount;
    switch (sourceResult) {
      case Ok(value: final value):
        sourceAccount = value;
      case Err(failure: final failure):
        return Err(failure);
    }

    final destResult = await _accountRepository.fetchAccountById(
      accountId: destAccountId,
    );
    final Account destAccount;
    switch (destResult) {
      case Ok(value: final value):
        destAccount = value;
      case Err(failure: final failure):
        return Err(failure);
    }

    if (sourceAccount.tripId != trip.id || destAccount.tripId != trip.id) {
      return const Err(ValidationFailure('Accounts do not belong to trip.'));
    }

    // Resolve the destination-side amount (user-supplied or market-converted).
    final double resolvedDestAmount;
    if (sourceAccount.currency == destAccount.currency) {
      resolvedDestAmount = destAmount ?? amount;
    } else if (destAmount != null) {
      resolvedDestAmount = destAmount;
    } else {
      final crossResult = await _convertToHomeCurrency(
        amount: amount,
        sourceCurrency: sourceAccount.currency,
        homeCurrency: destAccount.currency,
        date: occurredAt,
      );
      switch (crossResult) {
        case Ok(value: final value):
          resolvedDestAmount = value.amountHome;
        case Err(failure: final failure):
          return Err(failure);
      }
    }

    final transaction = Transaction(
      id: _idGenerator.transactionId(),
      tripId: trip.id,
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
      note: note,
      createdAt: createdAt ?? DateTime.now(),
    );

    return _transactionRepository.createTransaction(transaction);
  }
}
