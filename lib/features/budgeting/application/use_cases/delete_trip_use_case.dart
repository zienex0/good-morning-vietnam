import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/account_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/transaction_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/trip_repository.dart';

/// Deletes a trip and everything that belongs to it, coordinating the three
/// repositories. Clears the active trip when it was the one removed.
class DeleteTripUseCase {
  const DeleteTripUseCase({
    required TripRepository tripRepository,
    required AccountRepository accountRepository,
    required TransactionRepository transactionRepository,
  }) : _tripRepository = tripRepository,
       _accountRepository = accountRepository,
       _transactionRepository = transactionRepository;

  final TripRepository _tripRepository;
  final AccountRepository _accountRepository;
  final TransactionRepository _transactionRepository;

  Future<Result<void, Failure>> call({required String tripId}) async {
    final transactionsResult = await _transactionRepository
        .deleteTransactionsForTrip(tripId: tripId);
    if (transactionsResult case Err(failure: final failure)) {
      return Err(failure);
    }

    final accountsResult = await _accountRepository.deleteAccountsForTrip(
      tripId: tripId,
    );
    if (accountsResult case Err(failure: final failure)) {
      return Err(failure);
    }

    final tripResult = await _tripRepository.deleteTrip(tripId: tripId);
    if (tripResult case Err(failure: final failure)) {
      return Err(failure);
    }

    if (_tripRepository.getActiveTripId() == tripId) {
      await _tripRepository.setActiveTripId(null);
    }
    return const Ok(null);
  }
}
