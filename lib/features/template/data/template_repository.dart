import 'package:flutter_foundation_kit/core/data/data.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_receipt.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_track.dart';

/// Hive-backed store of confirmed receipts.
///
/// The entire data layer for a plain CRUD feature is this one declaration —
/// no interface, no impl class, no codec class, no `main()` wiring. The box
/// opens lazily and `Hive.initFlutter()` runs once automatically. Serialization
/// is the three inline functions below.
///
/// The controller depends on the [CrudRepository] surface this exposes via
/// `LocalCrudNotifier`; only reach for a `HiveLocalRepository` subclass when a
/// feature needs queries beyond plain CRUD.
final templateRepositoryProvider = localRepository<ProjectReceipt>(
  box: 'template_receipts',
  id: (receipt) => receipt.id,
  toJson: (receipt) => {
    'id': receipt.id,
    'track': receipt.track?.name,
    'seats': receipt.seats,
    'confirmedAt': receipt.confirmedAt?.toIso8601String(),
  },
  fromJson: (json) => ProjectReceipt(
    id: json['id'] as String,
    track: json['track'] == null
        ? null
        : ProjectTrack.values.byName(json['track'] as String),
    seats: json['seats'] as int,
    confirmedAt: json['confirmedAt'] == null
        ? null
        : DateTime.parse(json['confirmedAt'] as String),
  ),
  sort: (a, b) =>
      (b.confirmedAt ?? DateTime(0)).compareTo(a.confirmedAt ?? DateTime(0)),
);
