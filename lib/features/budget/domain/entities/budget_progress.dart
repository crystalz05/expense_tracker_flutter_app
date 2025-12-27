import 'package:equatable/equatable.dart';

import 'budget.dart';

class BudgetProgress extends Equatable {
  final Budget budget;
  final double spent;
  final double remaining;
  final double percentageUsed;
  final bool isOverBudget;
  final bool shouldAlert;

  const BudgetProgress({
    required this.budget,
    required this.spent,
    required this.remaining,
    required this.percentageUsed,
    required this.isOverBudget,
    required this.shouldAlert,
  });

  @override
  List<Object?> get props => [
    budget,
    spent,
    remaining,
    percentageUsed,
    isOverBudget,
    shouldAlert,
  ];
}