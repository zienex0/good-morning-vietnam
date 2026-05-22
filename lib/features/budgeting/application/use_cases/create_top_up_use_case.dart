import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_id_generator.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_top_up_use_case.g.dart';

class CreateTopUpUseCase {
  const CreateTopUpUseCase({
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
    required double amount,
    required DateTime occurredAt,
    CurrencyCode? paidCurrency,
    String? categoryId,
    String? note,
    DateTime? createdAt,
  }) async {
    if (amount <= 0) {
      return const Err(ValidationFailure('Top-up amount must be positive.'));
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

    final enteredCurrency = paidCurrency?.trim().toUpperCase();
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

    final transaction = Transaction(
      id: _idGenerator.transactionId(),
      tripId: trip.id,
      type: TransactionType.income,
      occurredAt: occurredAt,
      destAccountId: account.id,
      categoryId: categoryId,
      paidAmount: amount,
      paidCurrency: transactionCurrency,
      accountAmount: accountConversion.amountHome,
      accountCurrency: account.currency,
      note: note,
      createdAt: createdAt ?? DateTime.now(),
    );

    return _repository.createTransaction(transaction);
  }
}

@Riverpod(keepAlive: true)
CreateTopUpUseCase createTopUpUseCase(CreateTopUpUseCaseRef ref) {
  return CreateTopUpUseCase(
    repository: ref.watch(budgetingRepositoryProvider),
    convertToHomeCurrency: ref.watch(convertToHomeCurrencyUseCaseProvider),
    idGenerator: ref.watch(budgetingIdGeneratorProvider),
  );
}
