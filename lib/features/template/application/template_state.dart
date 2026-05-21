import 'package:flutter_foundation_kit/features/template/domain/project_receipt.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_track.dart';

class TemplateState {
  const TemplateState({required this.track, required this.seats});

  const TemplateState.initial() : track = ProjectTrack.engineering, seats = 3;

  TemplateState.fromReceipt(ProjectReceipt receipt)
    : track = receipt.track,
      seats = receipt.seats;

  final ProjectTrack? track;
  final int seats;

  ProjectReceipt get receipt => ProjectReceipt(track: track, seats: seats);

  // Sentinel distinguishes "leave track unchanged" from "set track to null".
  // Pass track: null to clear the selection; omit track to keep the current one.
  static const _kUnset = Object();

  TemplateState copyWith({Object? track = _kUnset, int? seats}) {
    return TemplateState(
      track: identical(track, _kUnset) ? this.track : track as ProjectTrack?,
      seats: seats ?? this.seats,
    );
  }
}
