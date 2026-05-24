abstract interface class AccountIdGenerator {
  String newAccountId();
}

class TimestampAccountIdGenerator implements AccountIdGenerator {
  const TimestampAccountIdGenerator();

  @override
  String newAccountId() => 'acct-${DateTime.now().microsecondsSinceEpoch}';
}
