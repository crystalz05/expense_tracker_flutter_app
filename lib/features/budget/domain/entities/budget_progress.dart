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
    required double remaining,
    required double percentageUsed,
    required this.isOverBudget,
    required this.shouldAlert,
  }) : remaining = remaining < 0 ? 0 : remaining,
       percentageUsed = percentageUsed > 100 ? 100 : percentageUsed;

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
