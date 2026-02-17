import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/analytics_summary.dart';
import '../entities/category_spending.dart';
import '../entities/monthly_comparison.dart';
import '../entities/spending_insight.dart';
import '../entities/spending_trend.dart';

abstract class AnalyticsRepository {
  /// Get category spending breakdown for a date range
  Future<Either<Failure, List<CategorySpending>>> getCategorySpending({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get month-to-month comparison
  Future<Either<Failure, MonthlyComparison?>> getMonthlyComparison({
    required DateTime currentMonth,
    required DateTime previousMonth,
  });

  /// Get spending insights based on rules
  Future<Either<Failure, List<SpendingInsight>>> getSpendingInsights({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get spending trends over time
  Future<Either<Failure, SpendingTrend>> getSpendingTrend({
    required int monthsBack,
  });

  /// Get complete analytics summary
  Future<Either<Failure, AnalyticsSummary>> getAnalyticsSummary({
    required DateTime startDate,
    required DateTime endDate,
  });
}
