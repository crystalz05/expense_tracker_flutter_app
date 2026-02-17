import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_analytics_summary.dart';
import '../../domain/usecases/get_category_spending.dart';
import '../../domain/usecases/get_monthly_comparison.dart';
import '../../domain/usecases/get_spending_insights.dart';
import '../../domain/usecases/get_spending_trend.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetCategorySpending getCategorySpending;
  final GetMonthlyComparison getMonthlyComparison;
  final GetSpendingInsights getSpendingInsights;
  final GetSpendingTrend getSpendingTrend;
  final GetAnalyticsSummary getAnalyticsSummary;

  AnalyticsBloc({
    required this.getCategorySpending,
    required this.getMonthlyComparison,
    required this.getSpendingInsights,
    required this.getSpendingTrend,
    required this.getAnalyticsSummary,
  }) : super(const AnalyticsInitial()) {
    on<LoadAnalyticsSummaryEvent>(_onLoadAnalyticsSummary);
    on<LoadCategorySpendingEvent>(_onLoadCategorySpending);
    on<LoadMonthlyComparisonEvent>(_onLoadMonthlyComparison);
    on<LoadSpendingInsightsEvent>(_onLoadSpendingInsights);
    on<LoadSpendingTrendEvent>(_onLoadSpendingTrend);
  }

  Future<void> _onLoadAnalyticsSummary(
    LoadAnalyticsSummaryEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());

    final result = await getAnalyticsSummary(
      DateRangeParams(start: event.startDate, end: event.endDate),
    );

    result.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (summary) => emit(AnalyticsSummaryLoaded(summary)),
    );
  }

  Future<void> _onLoadCategorySpending(
    LoadCategorySpendingEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());

    final result = await getCategorySpending(
      DateRangeParams(start: event.startDate, end: event.endDate),
    );

    result.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (categorySpending) => emit(CategorySpendingLoaded(categorySpending)),
    );
  }

  Future<void> _onLoadMonthlyComparison(
    LoadMonthlyComparisonEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());

    final result = await getMonthlyComparison(
      MonthComparisonParams(
        currentMonth: event.currentMonth,
        previousMonth: event.previousMonth,
      ),
    );

    result.fold((failure) => emit(AnalyticsError(failure.message)), (
      comparison,
    ) {
      if (comparison != null) {
        emit(MonthlyComparisonLoaded(comparison));
      }
    });
  }

  Future<void> _onLoadSpendingInsights(
    LoadSpendingInsightsEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());

    final result = await getSpendingInsights(
      DateRangeParams(start: event.startDate, end: event.endDate),
    );

    result.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (insights) => emit(SpendingInsightsLoaded(insights)),
    );
  }

  Future<void> _onLoadSpendingTrend(
    LoadSpendingTrendEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());

    final result = await getSpendingTrend(
      TrendParams(monthsBack: event.monthsBack),
    );

    result.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (trend) => emit(SpendingTrendLoaded(trend)),
    );
  }
}
