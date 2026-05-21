import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/features/template/domain/project_track.dart';
import 'package:flutter_foundation_kit/features/template/presentation/template_formatters.dart';
import 'package:flutter_foundation_kit/features/template/presentation/template_mappers.dart';

class TemplateTrackOption extends StatelessWidget {
  const TemplateTrackOption({required this.track, super.key});

  final ProjectTrack track;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(projectTrackIcon(track), size: AppSizes.iconMd),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Text(formatProjectTrackLabel(track))),
      ],
    );
  }
}
