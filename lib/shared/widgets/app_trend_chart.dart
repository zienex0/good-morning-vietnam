import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foundation_kit/core/theme/theme.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_chart_data.dart';
import 'package:flutter_foundation_kit/shared/widgets/app_formatters.dart';

class AppTrendChart extends StatelessWidget {
  const AppTrendChart({
    required this.points,
    this.color,
    this.showCumulativeValue = false,
    super.key,
  });

  final List<AppTrendPoint> points;
  final Color? color;
  final bool showCumulativeValue;

  @override
  Widget build(BuildContext context) {
    final chartPoints = _chartPoints;

    if (chartPoints.isEmpty) {
      return const SizedBox(
        height: AppSizes.chartTrendHeight,
        child: Center(child: _EmptyChart()),
      );
    }

    final values = chartPoints.map((point) => point.value).toList();
    final bounds = _ChartBounds.from(values);
    final labelIndexes = _labelIndexes(chartPoints.length);
    final baseline = bounds.minY;
    final palette = context.colors;
    final lineColor = color ?? palette.accent;
    final tooltipTitleStyle = context.inverseText.labelSmall!;
    final tooltipValueStyle = context.inverseText.labelSmall!;

    return SizedBox(
      height: AppSizes.chartTrendHeight,
      child: TweenAnimationBuilder<double>(
        duration: AppDurations.chartEntrance,
        curve: AppCurves.standard,
        tween: Tween(begin: AppSpacing.none, end: 1),
        builder: (context, progress, child) {
          final spots = [
            for (final (index, point) in chartPoints.indexed)
              FlSpot(
                index.toDouble(),
                baseline + ((point.value - baseline) * progress),
              ),
          ];

          return LineChart(
            LineChartData(
              minX: AppSpacing.none,
              maxX: math.max(chartPoints.length - 1, 1).toDouble(),
              minY: bounds.minY,
              maxY: bounds.maxY,
              clipData: const FlClipData.vertical(),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  tooltipBorderRadius: const BorderRadius.all(AppRadii.md),
                  getTooltipColor: (_) => palette.inverseSurface,
                  getTooltipItems: (spots) => [
                    for (final spot in spots)
                      LineTooltipItem(
                        formatFullDate(chartPoints[spot.spotIndex].date),
                        tooltipTitleStyle,
                        children: [
                          TextSpan(
                            text:
                                '\n${formatChartNumber(chartPoints[spot.spotIndex].value)}',
                            style: tooltipValueStyle,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: bounds.interval,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: palette.border,
                  strokeWidth: AppSizes.chartHairline,
                  dashArray: const [4, 4],
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: AppSpacing.xl,
                    interval: bounds.interval,
                    minIncluded: false,
                    maxIncluded: false,
                    getTitlesWidget: (value, meta) =>
                        _ValueTitle(value: value, meta: meta, bounds: bounds),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: AppSpacing.xl,
                    getTitlesWidget: (value, meta) {
                      final index = value.round();
                      if (value != index || !labelIndexes.contains(index)) {
                        return const SizedBox.shrink();
                      }

                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          formatMonth(chartPoints[index].date),
                          style: context.mutedText.labelSmall,
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: lineColor.withValues(alpha: progress),
                  barWidth: AppSizes.chartStroke,
                  isStrokeCapRound: true,
                  isStrokeJoinRound: true,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        lineColor.withValues(alpha: 0.2 * progress),
                        lineColor.withValues(alpha: AppSpacing.none),
                      ],
                    ),
                  ),
                  dotData: FlDotData(
                    getDotPainter: (_, _, _, _) => FlDotCirclePainter(
                      radius: AppSizes.chartDot * progress,
                      color: palette.surface,
                      strokeColor: lineColor.withValues(alpha: progress),
                      strokeWidth: AppSizes.chartHairline,
                    ),
                  ),
                ),
              ],
            ),
            duration: Duration.zero,
          );
        },
      ),
    );
  }

  List<AppTrendPoint> get _chartPoints {
    final sortedPoints = [...points]..sort((a, b) => a.date.compareTo(b.date));

    if (!showCumulativeValue) {
      return sortedPoints;
    }

    var total = 0.0;
    return [
      for (final point in sortedPoints)
        AppTrendPoint(date: point.date, value: total += point.value),
    ];
  }

  Set<int> _labelIndexes(int length) {
    if (length <= 1) return const {0};
    if (length <= 3) {
      return {for (var index = 0; index < length; index++) index};
    }
    final midpoint = math.max(0, (length ~/ 2) - 2);
    return {0, midpoint, length - 1};
  }
}

class _EmptyChart extends StatelessWidget {
  const _EmptyChart();

  @override
  Widget build(BuildContext context) {
    return Text('No data yet', style: context.mutedText.bodySmall);
  }
}

class _ValueTitle extends StatelessWidget {
  const _ValueTitle({
    required this.value,
    required this.meta,
    required this.bounds,
  });

  final double value;
  final TitleMeta meta;
  final _ChartBounds bounds;

  @override
  Widget build(BuildContext context) {
    final isEdgeValue = value == bounds.minValue || value == bounds.maxValue;
    if (!isEdgeValue) {
      return const SizedBox.shrink();
    }

    return SideTitleWidget(
      meta: meta,
      space: AppSpacing.xs,
      child: Text(_formatValue(value), style: context.mutedText.labelSmall),
    );
  }
}

class _ChartBounds {
  const _ChartBounds({
    required this.minY,
    required this.maxY,
    required this.minValue,
    required this.maxValue,
    required this.interval,
  });

  final double minY;
  final double maxY;
  final double minValue;
  final double maxValue;
  final double interval;

  factory _ChartBounds.from(List<double> values) {
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final range = math.max(maxValue - minValue, 1.0);
    final padding = range * 0.16;

    return _ChartBounds(
      minY: minValue - padding,
      maxY: maxValue + padding,
      minValue: minValue,
      maxValue: maxValue,
      interval: range,
    );
  }
}

String _formatValue(double value) {
  if (value.abs() >= 1000) {
    return '${(value / 1000).toStringAsFixed(1)}k';
  }
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(1);
}
