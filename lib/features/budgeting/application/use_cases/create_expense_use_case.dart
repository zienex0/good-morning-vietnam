import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_id_generator.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/amortization.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_expense_use_case.g.dart';

class CreateExpenseUseCase {
  const CreateExpenseUseCase({
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
    required String accountId,
    required String categoryId,
    required double amount,
    required DateTime occurredAt,
    CurrencyCode? amountCurrency,
    String? note,
    Amortization? amortization,
    DateTime? createdAt,
  }) async {
    if (amount <= 0) {
      return const Err(ValidationFailure('Expense amount must be positive.'));
    }
    if (categoryId.trim().isEmpty) {
      return const Err(ValidationFailure('Expense category is required.'));
    }

    final tripResult = await _repository.fetchTrip(tripId: tripId);
    final Trip trip;
    switch (tripResult) {
      case Ok(value: final value):
        trip = value;
      case Err(failure: final failure):
        return Err(failure);
    }

    final accountResult = await _repository.fetchAccountById(
      accountId: accountId,
    );
    final Account account;
    switch (accountResult) {
      case Ok(value: final value):
        account = value;
      case Err(failure: final failure):
        return Err(failure);
    }
    if (account.tripId != trip.id) {
      return const Err(ValidationFailure('Account does not belong to trip.'));
    }

    final enteredCurrency = amountCurrency?.trim().toUpperCase();
    final transactionCurrency = enteredCurrency?.isEmpty ?? true
        ? account.currency
        : enteredCurrency!;

    final accountConversionResult = await _convertToHomeCurrency(
      amount: amount,
      sourceCurrency: transactionCurrency,
      homeCurrency: account.currency,
      date: occurredAt,
    );
    final ({double amountHome, double fxRate}) accountConversion;
    switch (accountConversionResult) {
      case Ok(value: final value):
        accountConversion = value;
      case Err(failure: final failure):
        return Err(failure);
    }

    final conversionResult = await _convertToHomeCurrency(
      amount: accountConversion.amountHome,
      sourceCurrency: account.currency,
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
      type: TransactionType.expense,
      occurredAt: occurredAt,
      sourceAccountId: account.id,
      categoryId: categoryId,
      amount: accountConversion.amountHome,
      currency: account.currency,
      amountHome: conversion.amountHome,
      fxRate: conversion.fxRate,
      enteredAmount: transactionCurrency == account.currency ? null : amount,
      enteredCurrency: transactionCurrency == account.currency
          ? null
          : transactionCurrency,
      enteredFxRate: transactionCurrency == account.currency
          ? null
          : accountConversion.fxRate,
      note: note,
      amortization: amortization,
      createdAt: createdAt ?? DateTime.now(),
    );

    return _repository.createTransaction(transaction);
  }
}

@Riverpod(keepAlive: true)
CreateExpenseUseCase createExpenseUseCase(CreateExpenseUseCaseRef ref) {
  return CreateExpenseUseCase(
    repository: ref.watch(budgetingRepositoryProvider),
    convertToHomeCurrency: ref.watch(convertToHomeCurrencyUseCaseProvider),
    idGenerator: ref.watch(budgetingIdGeneratorProvider),
  );
}
