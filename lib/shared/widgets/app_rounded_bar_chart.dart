import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_chart_data.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_formatters.dart';

class AppRoundedBarChart extends StatelessWidget {
  const AppRoundedBarChart({required this.values, super.key});

  final List<AppChartDatum> values;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxValue = values.fold<double>(
      AppSpacing.none,
      (max, item) => math.max(max, item.value),
    );
    final chartMaxY = maxValue == AppSpacing.none ? 1.0 : maxValue * 1.12;
    final palette = context.colors;
    final tooltipTitleStyle = context.inverseText.labelSmall!;
    final tooltipValueStyle = context.inverseText.labelSmall!;

    return SizedBox(
      height: AppSizes.chartBarChartHeight,
      child: TweenAnimationBuilder<double>(
        duration: AppDurations.chartEntrance,
        curve: AppCurves.standard,
        tween: Tween(begin: AppSpacing.none, end: 1),
        builder: (context, progress, child) {
          return BarChart(
            BarChartData(
              minY: AppSpacing.none,
              maxY: chartMaxY,
              alignment: BarChartAlignment.spaceAround,
              groupsSpace: AppSpacing.lg,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  tooltipBorderRadius: const BorderRadius.all(AppRadii.md),
                  tooltipPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  tooltipMargin: AppSpacing.md,
                  getTooltipColor: (_) => palette.inverseSurface,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final item = values[groupIndex];
                    return BarTooltipItem(
                      item.label,
                      tooltipTitleStyle,
                      children: [
                        TextSpan(
                          text:
                              '\n${item.detail ?? formatChartNumber(item.value)}',
                          style: tooltipValueStyle,
                        ),
                      ],
                    );
                  },
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: AppSpacing.xl,
                    getTitlesWidget: (value, meta) {
                      final index = value.round();
                      if (value != index ||
                          index < 0 ||
                          index >= values.length) {
                        return const SizedBox.shrink();
                      }

                      return SideTitleWidget(
                        meta: meta,
                        fitInside: SideTitleFitInsideData.fromTitleMeta(
                          meta,
                          distanceFromEdge: AppSpacing.none,
                        ),
                        child: SizedBox(
                          width: AppSizes.buttonMinWidth,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              values[index].label,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: context.secondaryText.labelSmall,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: [
                for (final (index, item) in values.indexed)
                  BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: item.value * progress,
                        width: AppSizes.chartBarWidth,
                        color:
                            (item.color ??
                                    palette.chartPalette[index %
                                        palette.chartPalette.length])
                                .withValues(alpha: progress),
                        borderRadius: const BorderRadius.vertical(
                          top: AppRadii.pill,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            duration: Duration.zero,
          );
        },
      ),
    );
  }
}
