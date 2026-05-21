import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_id_generator.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_account_use_case.g.dart';

class CreateAccountUseCase {
  const CreateAccountUseCase({
    required BudgetingRepository repository,
    required BudgetingIdGenerator idGenerator,
  }) : _repository = repository,
       _idGenerator = idGenerator;

  final BudgetingRepository _repository;
  final BudgetingIdGenerator _idGenerator;

  Future<Result<Account, Failure>> call({
    required String tripId,
    required String name,
    required AccountType type,
    required CurrencyCode currency,
    required double openingBalance,
    String? icon,
  }) async {
    final validationFailure = _validate(
      name: name,
      currency: currency,
      openingBalance: openingBalance,
    );
    if (validationFailure != null) {
      return Err(validationFailure);
    }

    final tripResult = await _repository.fetchTrip(tripId: tripId);
    switch (tripResult) {
      case Ok():
        break;
      case Err(failure: final failure):
        return Err(failure);
    }

    final account = Account(
      id: _idGenerator.accountId(),
      tripId: tripId,
      name: name.trim(),
      type: type,
      currency: currency.trim().toUpperCase(),
      openingBalance: openingBalance,
      icon: icon,
    );
    return _repository.createAccount(account);
  }

  ValidationFailure? _validate({
    required String name,
    required CurrencyCode currency,
    required double openingBalance,
  }) {
    if (name.trim().isEmpty) {
      return const ValidationFailure('Account name is required.');
    }
    if (currency.trim().isEmpty) {
      return const ValidationFailure('Account currency is required.');
    }
    if (openingBalance < 0) {
      return const ValidationFailure(
        'Opening balance cannot be negative.',
      );
    }
    return null;
  }
}

@Riverpod(keepAlive: true)
CreateAccountUseCase createAccountUseCase(CreateAccountUseCaseRef ref) {
  return CreateAccountUseCase(
    repository: ref.watch(budgetingRepositoryProvider),
    idGenerator: ref.watch(budgetingIdGeneratorProvider),
  );
}
