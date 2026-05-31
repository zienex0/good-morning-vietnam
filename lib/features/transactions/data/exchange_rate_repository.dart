import 'dart:convert';
import 'dart:io';

import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/exchange_rate.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Live exchange-rate source. Network-backed, so it is a plain provider rather
/// than a `localRepository`. Override in tests with a fake.
final exchangeRateRepositoryProvider = Provider<ExchangeRateRepository>(
  (ref) => const FrankfurterExchangeRateRepository(),
);

abstract interface class ExchangeRateRepository {
  Future<Result<ExchangeRate>> fetchRate({
    required CurrencyCode base,
    required CurrencyCode quote,
    required DateTime date,
  });
}

class FrankfurterExchangeRateRepository implements ExchangeRateRepository {
  const FrankfurterExchangeRateRepository({HttpClient? client})
    : _client = client;

  final HttpClient? _client;

  @override
  Future<Result<ExchangeRate>> fetchRate({
    required CurrencyCode base,
    required CurrencyCode quote,
    required DateTime date,
  }) async {
    if (base == quote) {
      return Ok(ExchangeRate(base: base, quote: quote, rate: 1, date: date));
    }

    final client = _client ?? HttpClient();
    try {
      final uri = Uri.https('api.frankfurter.dev', '/v2/rate/$base/$quote', {
        'date': _formatApiDate(date),
      });
      final request = await client.getUrl(uri);
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode == HttpStatus.notFound) {
        return const Err(NotFoundFailure());
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return const Err(NetworkFailure());
      }

      final decoded = jsonDecode(body);
      if (decoded case {
        'rate': final num rate,
        'date': final String exchangeDate,
      }) {
        return Ok(
          ExchangeRate(
            base: base,
            quote: quote,
            rate: rate.toDouble(),
            date: DateTime.parse(exchangeDate),
          ),
        );
      }

      return Err(UnknownFailure(body));
    } on FormatException catch (error) {
      return Err(UnknownFailure(error));
    } on SocketException {
      return const Err(NetworkFailure());
    } on HttpException {
      return const Err(NetworkFailure());
    }
  }
}

String _formatApiDate(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
