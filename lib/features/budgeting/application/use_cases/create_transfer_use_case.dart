import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_id_generator.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_transfer_use_case.g.dart';

class CreateTransferUseCase {
  const CreateTransferUseCase({
    required BudgetingRepository repository,
    required ConvertToHomeCurrencyUseCase convertToHomeCurrency,
    required BudgetingIdGenerator idGenerator,
  }) : _repository = repository,
       _convertToHomeCurrency = convertToHomeCurrency,
       _idGenerator = idGenerator;

  final BudgetingRepository _repository;
  final ConvertToHomeCurrencyUseCase _convertToHomeCurrency;
  final BudgetingIdGenerator _idGenerator;

  Future<Result<Transaction, Failure>> call({
    required String tripId,
    required String sourceAccountId,
    required String destAccountId,
    required double amount,
    required DateTime occurredAt,
    String? note,
    DateTime? createdAt,
  }) async {
    if (amount <= 0) {
      return const Err(ValidationFailure('Transfer amount must be positive.'));
    }
    if (sourceAccountId == destAccountId) {
      return const Err(
        ValidationFailure('Choose two different accounts to transfer between.'),
      );
    }

    final tripResult = await _repository.fetchTrip(tripId: tripId);
    final Trip trip;
    switch (tripResult) {
      case Ok(value: final value):
        trip = value;
      case Err(failure: final failure):
        return Err(failure);
    }

    final sourceResult = await _repository.fetchAccountById(
      accountId: sourceAccountId,
    );
    final Account sourceAccount;
    switch (sourceResult) {
      case Ok(value: final value):
        sourceAccount = value;
      case Err(failure: final failure):
        return Err(failure);
    }

    final destResult = await _repository.fetchAccountById(
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

    final conversionResult = await _convertToHomeCurrency(
      amount: amount,
      sourceCurrency: sourceAccount.currency,
      homeCurrency: trip.homeCurrency,
      date: occurredAt,
    );
    final ({double amountHome, double fxRate}) conversion;
    switch (conversionResult) {
      case Ok(value: final value):
        conversion = value;
      case Err(failure: final failure):
        return Err(failure);
    }

    final transaction = Transaction(
      id: _idGenerator.transactionId(),
      tripId: trip.id,
      type: TransactionType.transfer,
      occurredAt: occurredAt,
      sourceAccountId: sourceAccount.id,
      destAccountId: destAccount.id,
      amount: amount,
      currency: sourceAccount.currency,
      amountHome: conversion.amountHome,
      fxRate: conversion.fxRate,
      note: note,
      createdAt: createdAt ?? DateTime.now(),
    );

    return _repository.createTransaction(transaction);
  }
}

@Riverpod(keepAlive: true)
CreateTransferUseCase createTransferUseCase(CreateTransferUseCaseRef ref) {
  return CreateTransferUseCase(
    repository: ref.watch(budgetingRepositoryProvider),
    convertToHomeCurrency: ref.watch(convertToHomeCurrencyUseCaseProvider),
    idGenerator: ref.watch(budgetingIdGeneratorProvider),
  );
}
