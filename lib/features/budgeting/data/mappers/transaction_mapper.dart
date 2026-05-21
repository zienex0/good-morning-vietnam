import 'package:flutter_foundation_kit/features/budgeting/domain/transaction.dart';

Map<String, dynamic> transactionToJson(Transaction transaction) {
  return <String, dynamic>{
    'id': transaction.id,
    'tripId': transaction.tripId,
    'type': transaction.type.name,
    'occurredAt': transaction.occurredAt.toIso8601String(),
    'sourceAccountId': transaction.sourceAccountId,
    'destAccountId': transaction.destAccountId,
    'categoryId': transaction.categoryId,
    'amount': transaction.amount,
    'currency': transaction.currency,
    'amountHome': transaction.amountHome,
    'fxRate': transaction.fxRate,
    'enteredAmount': transaction.enteredAmount,
    'enteredCurrency': transaction.enteredCurrency,
    'enteredFxRate': transaction.enteredFxRate,
    'note': transaction.note,
    'createdAt': transaction.createdAt.toIso8601String(),
  };
}

Transaction transactionFromJson(Map<String, dynamic> json) {
  return Transaction(
    id: json['id'] as String,
    tripId: json['tripId'] as String,
    type: TransactionType.values.firstWhere(
      (type) => type.name == json['type'] as String,
      orElse: () => TransactionType.expense,
    ),
    occurredAt: DateTime.parse(json['occurredAt'] as String),
    sourceAccountId: json['sourceAccountId'] as String?,
    destAccountId: json['destAccountId'] as String?,
    categoryId: json['categoryId'] as String?,
    amount: (json['amount'] as num).toDouble(),
    currency: json['currency'] as String,
    amountHome: (json['amountHome'] as num).toDouble(),
    fxRate: (json['fxRate'] as num).toDouble(),
    enteredAmount: (json['enteredAmount'] as num?)?.toDouble(),
    enteredCurrency: json['enteredCurrency'] as String?,
    enteredFxRate: (json['enteredFxRate'] as num?)?.toDouble(),
    note: json['note'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}
