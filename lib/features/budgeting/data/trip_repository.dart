import 'dart:convert';

import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/hive_budgeting_boxes.dart';
import 'package:flutter_foundation_kit/features/budgeting/data/mappers/trip_mapper.dart';
import 'package:flutter_foundation_kit/features/budgeting/domain/trip.dart';

abstract interface class TripRepository {
  Future<Result<List<Trip>, Failure>> listTrips();

  Stream<List<Trip>> watchTrips();

  Future<Result<Trip, Failure>> fetchTrip({required String tripId});

  Future<Result<Trip, Failure>> createTrip(Trip trip);

  Future<Result<Trip, Failure>> updateTrip(Trip trip);

  /// Deletes only the trip record. Cascading to accounts/transactions is the
  /// job of a use case that coordinates the three repositories.
  Future<Result<void, Failure>> deleteTrip({required String tripId});

  String? getActiveTripId();

  Future<void> setActiveTripId(String? tripId);

  Stream<String?> watchActiveTripId();
}

class HiveTripRepository implements TripRepository {
  HiveTripRepository({required this.boxes});

  final HiveBudgetingBoxes boxes;

  Trip _decode(String raw) =>
      tripFromJson(jsonDecode(raw) as Map<String, dynamic>);

  @override
  Future<Result<List<Trip>, Failure>> listTrips() async {
    final trips = boxes.trips.values.map(_decode).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Ok(trips);
  }

  @override
  Stream<List<Trip>> watchTrips() async* {
    yield await _trips();
    yield* boxes.trips.watch().asyncMap((_) => _trips());
  }

  Future<List<Trip>> _trips() async {
    final result = await listTrips();
    return switch (result) {
      Ok(value: final value) => value,
      Err(failure: final failure) => throw failure,
    };
  }

  @override
  Future<Result<Trip, Failure>> fetchTrip({required String tripId}) async {
    final raw = boxes.trips.get(tripId);
    if (raw == null) {
      return const Err(NotFoundFailure());
    }
    return Ok(_decode(raw));
  }

  @override
  Future<Result<Trip, Failure>> createTrip(Trip trip) async {
    await boxes.trips.put(trip.id, jsonEncode(tripToJson(trip)));
    return Ok(trip);
  }

  @override
  Future<Result<Trip, Failure>> updateTrip(Trip trip) async {
    if (!boxes.trips.containsKey(trip.id)) {
      return const Err(NotFoundFailure());
    }
    await boxes.trips.put(trip.id, jsonEncode(tripToJson(trip)));
    return Ok(trip);
  }

  @override
  Future<Result<void, Failure>> deleteTrip({required String tripId}) async {
    if (!boxes.trips.containsKey(tripId)) {
      return const Err(NotFoundFailure());
    }
    await boxes.trips.delete(tripId);
    return const Ok(null);
  }

  @override
  String? getActiveTripId() => boxes.settings.get(settingsActiveTripIdKey);

  @override
  Future<void> setActiveTripId(String? tripId) async {
    if (tripId == null) {
      await boxes.settings.delete(settingsActiveTripIdKey);
    } else {
      await boxes.settings.put(settingsActiveTripIdKey, tripId);
    }
  }

  @override
  Stream<String?> watchActiveTripId() async* {
    yield getActiveTripId();
    yield* boxes.settings
        .watch(key: settingsActiveTripIdKey)
        .map((_) => getActiveTripId());
  }
}
