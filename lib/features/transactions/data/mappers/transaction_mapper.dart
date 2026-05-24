import 'package:flutter_foundation_kit/features/transactions/data/mappers/amortization_mapper.dart';
import 'package:flutter_foundation_kit/features/transactions/domain/transaction.dart';

Map<String, dynamic> transactionToJson(Transaction transaction) {
  return <String, dynamic>{
    'id': transaction.id,
    'tripId': transaction.tripId,
    'type': transaction.type.name,
    'occurredAt': transaction.occurredAt.toIso8601String(),
    'sourceAccountId': transaction.sourceAccountId,
    'destAccountId': transaction.destAccountId,
    'categoryId': transaction.categoryId,
    'paidAmount': transaction.paidAmount,
    'paidCurrency': transaction.paidCurrency,
    'accountAmount': transaction.accountAmount,
    'accountCurrency': transaction.accountCurrency,
    'destAmount': transaction.destAmount,
    'destCurrency': transaction.destCurrency,
    'note': transaction.note,
    'amortization': transaction.amortization == null
        ? null
        : amortizationToJson(transaction.amortization!),
    'createdAt': transaction.createdAt.toIso8601String(),
  };
}

Transaction transactionFromJson(Map<String, dynamic> json) {
  final type = TransactionType.values.firstWhere(
    (value) => value.name == json['type'] as String,
    orElse: () => TransactionType.expense,
  );
  return Transaction(
    id: json['id'] as String,
    tripId: json['tripId'] as String,
    type: type,
    occurredAt: DateTime.parse(json['occurredAt'] as String),
    sourceAccountId: json['sourceAccountId'] as String?,
    destAccountId: json['destAccountId'] as String?,
    categoryId: json['categoryId'] as String?,
    paidAmount: (json['paidAmount'] as num).toDouble(),
    paidCurrency: json['paidCurrency'] as String,
    accountAmount: (json['accountAmount'] as num).toDouble(),
    accountCurrency: json['accountCurrency'] as String,
    destAmount: (json['destAmount'] as num?)?.toDouble(),
    destCurrency: json['destCurrency'] as String?,
    note: json['note'] as String?,
    amortization: json['amortization'] == null
        ? null
        : amortizationFromJson(json['amortization'] as Map<String, dynamic>),
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}
