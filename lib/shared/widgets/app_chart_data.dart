import 'package:flutter/material.dart';

/// A single categorical data point for [AppDonutChart] and [AppRoundedBarChart].
///
/// Provide [label] and [value]; everything else is optional. [detail] defaults
/// to a formatted [value], and [color] is auto-assigned from the theme palette.
class AppChartDatum {
  const AppChartDatum({
    required this.label,
    required this.value,
    this.detail,
    this.color,
  });

  final String label;
  final double value;
  final String? detail;
  final Color? color;
}

/// A single point on a time series for [AppTrendChart].
class AppTrendPoint {
  const AppTrendPoint({required this.date, required this.value});

  final DateTime date;
  final double value;
}
