import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/account_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_id_generator.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/trip_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';

class CreateAccountUseCase {
  const CreateAccountUseCase({
    required AccountRepository accountRepository,
    required TripRepository tripRepository,
    required BudgetingIdGenerator idGenerator,
  }) : _accountRepository = accountRepository,
       _tripRepository = tripRepository,
       _idGenerator = idGenerator;

  final AccountRepository _accountRepository;
  final TripRepository _tripRepository;
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

    final tripResult = await _tripRepository.fetchTrip(tripId: tripId);
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
    return _accountRepository.createAccount(account);
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
      return const ValidationFailure('Opening balance cannot be negative.');
    }
    return null;
  }
}
