import 'package:equatable/equatable.dart';

import 'monthly_spending.dart';

class SpendingTrend extends Equatable {
  final List<MonthlySpending> monthlyData;
  final String topCategory;
  final double averageMonthlySpending;
  final TrendDirection overallTrend;

  const SpendingTrend({
    required this.monthlyData,
    required this.topCategory,
    required this.averageMonthlySpending,
    required this.overallTrend,
  });

  @override
  List<Object?> get props => [
    monthlyData,
    topCategory,
    averageMonthlySpending,
    overallTrend,
  ];
}
