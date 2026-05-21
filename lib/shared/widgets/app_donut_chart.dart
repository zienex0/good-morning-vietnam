import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';

class AppDonutChart extends StatefulWidget {
  const AppDonutChart({required this.values, super.key});

  final List<({String label, double value, String detail, Color color})> values;

  @override
  State<AppDonutChart> createState() => _AppDonutChartState();
}

class _AppDonutChartState extends State<AppDonutChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    final chartValues = widget.values
        .where((item) => item.value > AppSpacing.none)
        .toList();
    final touchedItem =
        _touchedIndex == null || _touchedIndex! >= chartValues.length
        ? null
        : chartValues[_touchedIndex!];

    return Row(
      children: [
        SizedBox.square(
          dimension: AppSizes.chartRingSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              TweenAnimationBuilder<double>(
                duration: AppDurations.chartEntrance,
                curve: AppCurves.standard,
                tween: Tween(begin: AppSpacing.none, end: 1),
                builder: (context, progress, child) {
                  final sections = chartValues.isEmpty
                      ? [
                          PieChartSectionData(
                            value: 1,
                            color: AppColors.surfaceRaised,
                            radius: AppSizes.chartRingStroke * progress,
                            showTitle: false,
                            cornerRadius: AppSpacing.sm,
                          ),
                        ]
                      : [
                          for (final (index, item) in chartValues.indexed)
                            PieChartSectionData(
                              value: item.value,
                              color: item.color.withValues(alpha: progress),
                              radius:
                                  (AppSizes.chartRingStroke +
                                      (index == _touchedIndex
                                          ? AppSpacing.xs
                                          : AppSpacing.none)) *
                                  progress,
                              showTitle: false,
                              cornerRadius: AppSpacing.sm,
                            ),
                        ];

                  return PieChart(
                    PieChartData(
                      startDegreeOffset: -90,
                      sectionsSpace: AppSizes.chartHairline * 2,
                      centerSpaceRadius:
                          (AppSizes.chartRingSize / 2) -
                          AppSizes.chartRingStroke,
                      centerSpaceColor: AppColors.canvas,
                      pieTouchData: PieTouchData(
                        touchCallback: (event, response) {
                          final sectionIndex =
                              response?.touchedSection?.touchedSectionIndex;
                          final nextIndex =
                              event.isInterestedForInteractions &&
                                  sectionIndex != null &&
                                  sectionIndex >= 0
                              ? sectionIndex
                              : null;
                          if (nextIndex != _touchedIndex) {
                            setState(() => _touchedIndex = nextIndex);
                          }
                        },
                      ),
                      sections: sections,
                    ),
                    duration: Duration.zero,
                  );
                },
              ),
              IgnorePointer(
                child: AnimatedOpacity(
                  opacity: touchedItem == null ? AppSpacing.none : 1,
                  duration: AppDurations.dropdownExpand,
                  curve: AppCurves.standard,
                  child: SizedBox.square(
                    dimension:
                        AppSizes.chartRingSize -
                        (AppSizes.chartRingStroke * 2) -
                        AppSpacing.md,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              touchedItem?.detail ?? '',
                              style: context.text.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              touchedItem?.label ?? '',
                              maxLines: 1,
                              style: context.mutedText.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            children: [
              for (final item in widget.values) ...[
                _LegendRow(item: item),
                if (item != widget.values.last)
                  const SizedBox(height: AppSpacing.md),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.item});

  final ({String label, double value, String detail, Color color}) item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: const BorderRadius.all(AppRadii.pill),
          ),
          child: const SizedBox.square(dimension: AppSizes.chartDot * 2),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.secondaryText.labelMedium,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(item.detail, style: context.text.labelMedium),
      ],
    );
  }
}
