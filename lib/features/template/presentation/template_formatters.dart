import 'package:flutter_foundation_kit/features/template/domain/project_track.dart';

String formatProjectTrackLabel(ProjectTrack? track) => switch (track) {
  ProjectTrack.design => 'Design system',
  ProjectTrack.engineering => 'Engineering platform',
  ProjectTrack.growth => 'Growth workspace',
  null => 'Not selected',
};

String formatTemplateMoney(int amount) => '\$$amount';
