import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';

Map<String, dynamic> tripToJson(Trip trip) {
  return <String, dynamic>{
    'id': trip.id,
    'name': trip.name,
    'homeCurrency': trip.homeCurrency,
    'startDate': trip.startDate.toIso8601String(),
    'endDate': trip.endDate?.toIso8601String(),
    'budgetTotal': trip.budgetTotal,
    'status': trip.status.name,
    'createdAt': trip.createdAt.toIso8601String(),
  };
}

Trip tripFromJson(Map<String, dynamic> json) {
  return Trip(
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
  );
}
