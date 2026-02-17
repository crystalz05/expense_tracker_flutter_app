import 'package:equatable/equatable.dart';

import '../../domain/entities/analytics_summary.dart';
import '../../domain/entities/category_spending.dart';
import '../../domain/entities/monthly_comparison.dart';
import '../../domain/entities/spending_insight.dart';
import '../../domain/entities/spending_trend.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {
  const AnalyticsInitial();
}

class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}

class AnalyticsSummaryLoaded extends AnalyticsState {
  final AnalyticsSummary summary;

  const AnalyticsSummaryLoaded(this.summary);

  @override
  List<Object?> get props => [summary];
}

class CategorySpendingLoaded extends AnalyticsState {
  final List<CategorySpending> categorySpending;

  const CategorySpendingLoaded(this.categorySpending);

  @override
  List<Object?> get props => [categorySpending];
}

class MonthlyComparisonLoaded extends AnalyticsState {
  final MonthlyComparison comparison;

  const MonthlyComparisonLoaded(this.comparison);

  @override
  List<Object?> get props => [comparison];
}

class SpendingInsightsLoaded extends AnalyticsState {
  final List<SpendingInsight> insights;

  const SpendingInsightsLoaded(this.insights);

  @override
  List<Object?> get props => [insights];
}

class SpendingTrendLoaded extends AnalyticsState {
  final SpendingTrend trend;

  const SpendingTrendLoaded(this.trend);

  @override
  List<Object?> get props => [trend];
}
