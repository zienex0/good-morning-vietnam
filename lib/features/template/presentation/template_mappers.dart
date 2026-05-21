import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_track.dart';

IconData projectTrackIcon(ProjectTrack track) => switch (track) {
  ProjectTrack.design => Icons.palette_outlined,
  ProjectTrack.engineering => Icons.code_rounded,
  ProjectTrack.growth => Icons.trending_up_rounded,
};
