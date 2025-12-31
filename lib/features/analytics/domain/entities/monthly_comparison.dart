import 'package:equatable/equatable.dart';

import 'category_comparison.dart';

class MonthlyComparison extends Equatable {
  final DateTime currentMonth;
  final DateTime previousMonth;
  final double currentTotal;
  final double previousTotal;
  final double percentageChange;
  final bool isIncrease;
  final Map<String, CategoryComparison> categoryComparisons;

  const MonthlyComparison({
    required this.currentMonth,
    required this.previousMonth,
    required this.currentTotal,
    required this.previousTotal,
    required this.percentageChange,
    required this.isIncrease,
    required this.categoryComparisons,
  });

  @override
  List<Object?> get props => [
    currentMonth,
    previousMonth,
    currentTotal,
    previousTotal,
    percentageChange,
    isIncrease,
    categoryComparisons,
  ];
}