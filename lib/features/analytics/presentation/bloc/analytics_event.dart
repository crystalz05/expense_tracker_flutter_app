// analytics_event.dart
import 'package:equatable/equatable.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAnalyticsSummaryEvent extends AnalyticsEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LoadAnalyticsSummaryEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class LoadCategorySpendingEvent extends AnalyticsEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LoadCategorySpendingEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class LoadMonthlyComparisonEvent extends AnalyticsEvent {
  final DateTime currentMonth;
  final DateTime previousMonth;

  const LoadMonthlyComparisonEvent({
    required this.currentMonth,
    required this.previousMonth,
  });

  @override
  List<Object?> get props => [currentMonth, previousMonth];
}

class LoadSpendingInsightsEvent extends AnalyticsEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LoadSpendingInsightsEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class LoadSpendingTrendEvent extends AnalyticsEvent {
  final int monthsBack;

  const LoadSpendingTrendEvent({this.monthsBack = 6});

  @override
  List<Object?> get props => [monthsBack];
}
