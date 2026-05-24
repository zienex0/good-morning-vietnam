abstract interface class TransactionIdGenerator {
  String newTransactionId();
}

class TimestampTransactionIdGenerator implements TransactionIdGenerator {
  const TimestampTransactionIdGenerator();

  @override
  String newTransactionId() => 'txn-${DateTime.now().microsecondsSinceEpoch}';
}
