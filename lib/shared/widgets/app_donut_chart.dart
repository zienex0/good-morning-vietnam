import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_chart_data.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_formatters.dart';

class AppDonutChart extends StatefulWidget {
  const AppDonutChart({required this.values, super.key});

  final List<AppChartDatum> values;

  @override
  State<AppDonutChart> createState() => _AppDonutChartState();
}

class _AppDonutChartState extends State<AppDonutChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    final chartValues = widget.values.indexed
        .where((entry) => entry.$2.value > AppSpacing.none)
        .toList();
    final touchedItem =
        _touchedIndex == null || _touchedIndex! >= chartValues.length
        ? null
        : chartValues[_touchedIndex!].$2;
    final detailText = touchedItem == null
        ? ''
        : touchedItem.detail ?? formatChartNumber(touchedItem.value);

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
                            color: context.colors.surfaceRaised,
                            radius: AppSizes.chartRingStroke * progress,
                            showTitle: false,
                            cornerRadius: AppSpacing.sm,
                          ),
                        ]
                      : [
                          for (final (position, (index, item))
                              in chartValues.indexed)
                            PieChartSectionData(
                              value: item.value,
                              color: _resolveColor(
                                index,
                                item,
                                context.colors,
                              ).withValues(alpha: progress),
                              radius:
                                  (AppSizes.chartRingStroke +
                                      (position == _touchedIndex
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
                      centerSpaceColor: context.colors.canvas,
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
                            Text(detailText, style: context.text.titleMedium),
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
              for (final (index, item) in widget.values.indexed) ...[
                _LegendRow(
                  item: item,
                  color: _resolveColor(index, item, context.colors),
                ),
                if (index != widget.values.length - 1)
                  const SizedBox(height: AppSpacing.md),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

Color _resolveColor(int index, AppChartDatum item, AppPalette palette) =>
    item.color ?? palette.chartPalette[index % palette.chartPalette.length];

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.item, required this.color});

  final AppChartDatum item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: color,
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
        Text(
          item.detail ?? formatChartNumber(item.value),
          style: context.text.labelMedium,
        ),
      ],
    );
  }
}
