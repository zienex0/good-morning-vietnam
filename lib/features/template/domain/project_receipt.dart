import 'package:flutter_foundation_kit/features/template/domain/project_track.dart';

class ProjectReceipt {
  const ProjectReceipt({
    this.id = '',
    required this.track,
    required this.seats,
    this.confirmedAt,
  });

  /// Creates a confirmed receipt with a unique id and timestamp for storage.
  factory ProjectReceipt.confirmed({
    required ProjectTrack? track,
    required int seats,
  }) {
    final now = DateTime.now();
    return ProjectReceipt(
      id: now.microsecondsSinceEpoch.toString(),
      track: track,
      seats: seats,
      confirmedAt: now,
    );
  }

  static const int seatPrice = 48;
  static const int platformFee = 96;
  static const int prioritySupport = 24;
  static const int templateCredit = 32;

  final String id;
  final ProjectTrack? track;
  final int seats;
  final DateTime? confirmedAt;

  int get seatSubtotal => seats * seatPrice;

  int get trackAddOn => switch (track) {
    ProjectTrack.design => 36,
    ProjectTrack.engineering => 72,
    ProjectTrack.growth => 56,
    null => 0,
  };

  int get subtotal => seatSubtotal + platformFee + trackAddOn + prioritySupport;

  int get taxableSubtotal => subtotal - templateCredit;

  int get tax => (taxableSubtotal * 0.08).round();

  int get total => taxableSubtotal + tax;
}
