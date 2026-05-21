import 'package:flutter_foundation_kit/features/budgeting/domain/account.dart';

Map<String, dynamic> accountToJson(Account account) {
  return <String, dynamic>{
    'id': account.id,
    'tripId': account.tripId,
    'name': account.name,
    'type': account.type.name,
    'currency': account.currency,
    'openingBalance': account.openingBalance,
    'icon': account.icon,
    'archived': account.archived,
  };
}

Account accountFromJson(Map<String, dynamic> json) {
  return Account(
    id: json['id'] as String,
    tripId: json['tripId'] as String,
    name: json['name'] as String,
    type: AccountType.values.firstWhere(
      (type) => type.name == json['type'] as String,
      orElse: () => AccountType.custom,
    ),
    currency: json['currency'] as String,
    openingBalance: (json['openingBalance'] as num).toDouble(),
    icon: json['icon'] as String?,
    archived: (json['archived'] as bool?) ?? false,
  );
}
