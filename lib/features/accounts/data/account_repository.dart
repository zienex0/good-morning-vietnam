import 'package:flutter_foundation_kit/core/data/data.dart';
import 'package:flutter_foundation_kit/features/accounts/domain/account.dart';

/// Hive-backed store of accounts — the whole data layer in one declaration.
///
/// Accounts are scoped to a trip and filtered in the read providers. Validation
/// and the delete-account cascade (its transactions) live in the accounts
/// controller, not here.
final accountRepositoryProvider = localRepository<Account>(
  box: 'accounts',
  id: (account) => account.id,
  toJson: (account) => {
    'id': account.id,
    'tripId': account.tripId,
    'name': account.name,
    'type': account.type.name,
    'currency': account.currency,
    'openingBalance': account.openingBalance,
    'icon': account.icon,
    'archived': account.archived,
  },
  fromJson: (json) => Account(
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
  ),
  sort: (a, b) => a.name.compareTo(b.name),
);
