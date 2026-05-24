import 'dart:convert';

import 'package:flutter_foundation_kit/core/result/result.dart';
import 'package:flutter_foundation_kit/features/trips/data/mappers/trip_mapper.dart';
import 'package:flutter_foundation_kit/features/trips/domain/trip.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

/// Key under which the active trip id is stored in the settings box.
const String settingsActiveTripIdKey = 'activeTripId';

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
  HiveTripRepository({required this.tripsBox, required this.settingsBox});

  final Box<String> tripsBox;
  final Box<String> settingsBox;

  Trip _decode(String raw) =>
      tripFromJson(jsonDecode(raw) as Map<String, dynamic>);

  @override
  Future<Result<List<Trip>, Failure>> listTrips() async {
    final trips = tripsBox.values.map(_decode).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Ok(trips);
  }

  @override
  Stream<List<Trip>> watchTrips() async* {
    yield await _trips();
    yield* tripsBox.watch().asyncMap((_) => _trips());
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
    final raw = tripsBox.get(tripId);
    if (raw == null) {
      return const Err(NotFoundFailure());
    }
    return Ok(_decode(raw));
  }

  @override
  Future<Result<Trip, Failure>> createTrip(Trip trip) async {
    await tripsBox.put(trip.id, jsonEncode(tripToJson(trip)));
    return Ok(trip);
  }

  @override
  Future<Result<Trip, Failure>> updateTrip(Trip trip) async {
    if (!tripsBox.containsKey(trip.id)) {
      return const Err(NotFoundFailure());
    }
    await tripsBox.put(trip.id, jsonEncode(tripToJson(trip)));
    return Ok(trip);
  }

  @override
  Future<Result<void, Failure>> deleteTrip({required String tripId}) async {
    if (!tripsBox.containsKey(tripId)) {
      return const Err(NotFoundFailure());
    }
    await tripsBox.delete(tripId);
    return const Ok(null);
  }

  @override
  String? getActiveTripId() => settingsBox.get(settingsActiveTripIdKey);

  @override
  Future<void> setActiveTripId(String? tripId) async {
    if (tripId == null) {
      await settingsBox.delete(settingsActiveTripIdKey);
    } else {
      await settingsBox.put(settingsActiveTripIdKey, tripId);
    }
  }

  @override
  Stream<String?> watchActiveTripId() async* {
    yield getActiveTripId();
    yield* settingsBox
        .watch(key: settingsActiveTripIdKey)
        .map((_) => getActiveTripId());
  }
}
