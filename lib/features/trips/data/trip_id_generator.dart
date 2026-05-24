abstract interface class TripIdGenerator {
  String newTripId();
}

class TimestampTripIdGenerator implements TripIdGenerator {
  const TimestampTripIdGenerator();

  @override
  String newTripId() => 'trip-${DateTime.now().microsecondsSinceEpoch}';
}
