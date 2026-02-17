import 'package:equatable/equatable.dart';
import 'package:expenses_tracker_app/features/analytics/domain/entities/spending_insight.dart';
import 'package:expenses_tracker_app/features/analytics/domain/entities/spending_trend.dart';

import 'category_spending.dart';
import 'monthly_comparison.dart';

class AnalyticsSummary extends Equatable {
  final DateTime periodStart;
  final DateTime periodEnd;
  final double totalSpending;
  final List<CategorySpending> categoryBreakdown;
  final MonthlyComparison? monthComparison;
  final List<SpendingInsight> insights;
  final SpendingTrend trend;

  const AnalyticsSummary({
    required this.periodStart,
    required this.periodEnd,
    required this.totalSpending,
    required this.categoryBreakdown,
    this.monthComparison,
    required this.insights,
    required this.trend,
  });

  @override
  List<Object?> get props => [
    periodStart,
    periodEnd,
    totalSpending,
    categoryBreakdown,
    monthComparison,
    insights,
    trend,
  ];
}
