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
    'destAmount': transaction.destAmount,
    'destCurrency': transaction.destCurrency,
    'destFxRate': transaction.destFxRate,
    'note': transaction.note,
    'createdAt': transaction.createdAt.toIso8601String(),
  };
}

Transaction transactionFromJson(Map<String, dynamic> json) {
  final type = TransactionType.values.firstWhere(
    (value) => value.name == json['type'] as String,
    orElse: () => TransactionType.expense,
  );
  final amount = (json['amount'] as num).toDouble();
  final currency = json['currency'] as String;
  final amountHome = (json['amountHome'] as num).toDouble();
  final fxRate = (json['fxRate'] as num).toDouble();

  var destAmount = (json['destAmount'] as num?)?.toDouble();
  var destCurrency = json['destCurrency'] as String?;
  var destFxRate = (json['destFxRate'] as num?)?.toDouble();

  // Backfill: pre-dest-snapshot transfer rows are mirrored from the source
  // side so the new assertions don't reject them on load.
  if (type == TransactionType.transfer && destAmount == null) {
    destAmount = amount;
    destCurrency = currency;
    destFxRate = fxRate;
  }

  return Transaction(
    id: json['id'] as String,
    tripId: json['tripId'] as String,
    type: type,
    occurredAt: DateTime.parse(json['occurredAt'] as String),
    sourceAccountId: json['sourceAccountId'] as String?,
    destAccountId: json['destAccountId'] as String?,
    categoryId: json['categoryId'] as String?,
    amount: amount,
    currency: currency,
    amountHome: amountHome,
    fxRate: fxRate,
    enteredAmount: (json['enteredAmount'] as num?)?.toDouble(),
    enteredCurrency: json['enteredCurrency'] as String?,
    enteredFxRate: (json['enteredFxRate'] as num?)?.toDouble(),
    destAmount: destAmount,
    destCurrency: destCurrency,
    destFxRate: destFxRate,
    note: json['note'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}
