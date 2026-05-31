import 'package:flutter_foundation_kit/core/data/data.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';

/// Hive-backed store of trips — the whole data layer in one declaration.
///
/// Validation, the make-active-on-create behaviour, and the delete-trip cascade
/// (accounts + transactions + clearing the active trip) live in the trips
/// controller. The "which trip is active" setting is a single value, not a
/// collection, so it lives in [ActiveTripIdRepository] instead.
final tripRepositoryProvider = localRepository<Trip>(
  box: 'trips',
  id: (trip) => trip.id,
  toJson: (trip) => {
    'id': trip.id,
    'name': trip.name,
    'homeCurrency': trip.homeCurrency,
    'startDate': trip.startDate.toIso8601String(),
    'endDate': trip.endDate?.toIso8601String(),
    'budgetTotal': trip.budgetTotal,
    'status': trip.status.name,
    'createdAt': trip.createdAt.toIso8601String(),
  },
  fromJson: (json) => Trip(
    id: json['id'] as String,
    name: json['name'] as String,
    homeCurrency: json['homeCurrency'] as String,
    startDate: DateTime.parse(json['startDate'] as String),
    endDate: json['endDate'] == null
        ? null
        : DateTime.parse(json['endDate'] as String),
    budgetTotal: (json['budgetTotal'] as num?)?.toDouble(),
    status: TripStatus.values.firstWhere(
      (status) => status.name == json['status'] as String,
      orElse: () => TripStatus.planning,
    ),
    createdAt: DateTime.parse(json['createdAt'] as String),
  ),
  sort: (a, b) => b.createdAt.compareTo(a.createdAt),
);
