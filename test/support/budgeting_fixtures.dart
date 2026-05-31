import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/transactions/data/exchange_rate_repository.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/amortization.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/exchange_rate.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/transaction.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';
import 'package:flutter_test/flutter_test.dart';

Trip testTrip() {
  return Trip(
    id: 'trip-1',
    name: 'Japan 2026',
    homeCurrency: 'USD',
    startDate: DateTime(2026, 5, 9),
    endDate: DateTime(2026, 6, 8),
    budgetTotal: 1500,
    status: TripStatus.active,
    createdAt: DateTime(2026),
  );
}

Transaction testExpense({
  String id = 'txn-1',
  String sourceAccountId = 'usd',
  double paidAmount = 10,
  String paidCurrency = 'USD',
  double? accountAmount,
  String accountCurrency = 'USD',
  DateTime? occurredAt,
  Amortization? amortization,
}) {
  return Transaction(
    id: id,
    tripId: 'trip-1',
    type: TransactionType.expense,
    occurredAt: occurredAt ?? DateTime(2026, 5, 9),
    sourceAccountId: sourceAccountId,
    categoryId: 'food',
    paidAmount: paidAmount,
    paidCurrency: paidCurrency,
    accountAmount: accountAmount ?? paidAmount,
    accountCurrency: accountCurrency,
    amortization: amortization,
    createdAt: DateTime(2026),
  );
}

Transaction testTopUp({
  String id = 'txn-top-up',
  String destAccountId = 'usd',
  double paidAmount = 10,
  String paidCurrency = 'USD',
  double? accountAmount,
  String accountCurrency = 'USD',
}) {
  return Transaction(
    id: id,
    tripId: 'trip-1',
    type: TransactionType.income,
    occurredAt: DateTime(2026, 5, 9),
    destAccountId: destAccountId,
    paidAmount: paidAmount,
    paidCurrency: paidCurrency,
    accountAmount: accountAmount ?? paidAmount,
    accountCurrency: accountCurrency,
    createdAt: DateTime(2026),
  );
}

Transaction testTransfer({
  double paidAmount = 10,
  String paidCurrency = 'USD',
  double? accountAmount,
  String accountCurrency = 'USD',
  double? destAmount,
  String destCurrency = 'USD',
}) {
  return Transaction(
    id: 'txn-transfer',
    tripId: 'trip-1',
    type: TransactionType.transfer,
    occurredAt: DateTime(2026, 5, 9),
    sourceAccountId: 'usd',
    destAccountId: 'jpy',
    paidAmount: paidAmount,
    paidCurrency: paidCurrency,
    accountAmount: accountAmount ?? paidAmount,
    accountCurrency: accountCurrency,
    destAmount: destAmount ?? paidAmount,
    destCurrency: destCurrency,
    createdAt: DateTime(2026),
  );
}

T expectOk<T>(Result<T> result) {
  return switch (result) {
    Ok(value: final value) => value,
    Err(failure: final failure) => throw TestFailure(
      'Expected Ok, got $failure',
    ),
  };
}

class FakeExchangeRateRepository implements ExchangeRateRepository {
  const FakeExchangeRateRepository({required this.rate});

  final double rate;

  @override
  Future<Result<ExchangeRate>> fetchRate({
    required CurrencyCode base,
    required CurrencyCode quote,
    required DateTime date,
  }) async {
    return Ok(ExchangeRate(base: base, quote: quote, rate: rate, date: date));
  }
}

class PairExchangeRateRepository implements ExchangeRateRepository {
  const PairExchangeRateRepository(this.rates);

  final Map<String, double> rates;

  @override
  Future<Result<ExchangeRate>> fetchRate({
    required CurrencyCode base,
    required CurrencyCode quote,
    required DateTime date,
  }) async {
    final rate = rates['$base:$quote'];
    if (rate == null) {
      return const Err(NotFoundFailure());
    }
    return Ok(ExchangeRate(base: base, quote: quote, rate: rate, date: date));
  }
}
