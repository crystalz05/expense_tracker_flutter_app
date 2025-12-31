import 'package:equatable/equatable.dart';

class CategoryComparison extends Equatable {
  final String category;
  final double currentAmount;
  final double previousAmount;
  final double percentageChange;
  final bool isIncrease;

  const CategoryComparison({
    required this.category,
    required this.currentAmount,
    required this.previousAmount,
    required this.percentageChange,
    required this.isIncrease,
  });

  @override
  List<Object?> get props => [
    category,
    currentAmount,
    previousAmount,
    percentageChange,
    isIncrease,
  ];
}