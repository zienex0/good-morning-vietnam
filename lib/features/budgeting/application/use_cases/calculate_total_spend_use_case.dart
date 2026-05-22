import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/application/use_cases/convert_to_home_currency_use_case.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/budgeting_repository.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calculate_total_spend_use_case.g.dart';

class CalculateTotalSpendUseCase {
  const CalculateTotalSpendUseCase({
    required BudgetingRepository repository,
    required ConvertToHomeCurrencyUseCase convertToHomeCurrency,
  }) : _repository = repository,
       _convertToHomeCurrency = convertToHomeCurrency;

  final BudgetingRepository _repository;
  final ConvertToHomeCurrencyUseCase _convertToHomeCurrency;

  Future<Result<double, Failure>> call({required String tripId}) async {
    final tripResult = await _repository.fetchTrip(tripId: tripId);
    switch (tripResult) {
      case Ok(value: final trip):
        final transactionsResult = await _repository.fetchTransactions(
          tripId: trip.id,
        );
        switch (transactionsResult) {
          case Ok(value: final transactions):
            var total = 0.0;
            for (final transaction in transactions) {
              if (transaction.type != TransactionType.expense) {
                continue;
              }
              final conversionResult = await _convertToHomeCurrency(
                amount: transaction.paidAmount,
                sourceCurrency: transaction.paidCurrency,
                homeCurrency: trip.homeCurrency,
                date: transaction.occurredAt,
              );
              switch (conversionResult) {
                case Ok(value: final conversion):
                  total += conversion.amountHome;
                case Err(failure: final failure):
                  return Err(failure);
              }
            }
            return Ok(total);
          case Err(failure: final failure):
            return Err(failure);
        }
      case Err(failure: final failure):
        return Err(failure);
    }
  }
}

@Riverpod(keepAlive: true)
CalculateTotalSpendUseCase calculateTotalSpendUseCase(
  CalculateTotalSpendUseCaseRef ref,
) {
  return CalculateTotalSpendUseCase(
    repository: ref.watch(budgetingRepositoryProvider),
    convertToHomeCurrency: ref.watch(convertToHomeCurrencyUseCaseProvider),
  );
}
