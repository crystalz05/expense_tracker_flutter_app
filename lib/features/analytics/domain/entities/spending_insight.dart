import 'package:equatable/equatable.dart';

class SpendingInsight extends Equatable {
  final String id;
  final InsightType type;
  final String category;
  final String message;
  final String description;
  final InsightSeverity severity;
  final double? amount;
  final double? percentage;
  final DateTime generatedAt;

  const SpendingInsight({
    required this.id,
    required this.type,
    required this.category,
    required this.message,
    required this.description,
    required this.severity,
    this.amount,
    this.percentage,
    required this.generatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    category,
    message,
    description,
    severity,
    amount,
    percentage,
    generatedAt,
  ];
}

enum InsightType {
  budgetExceeded,
  budgetWarning,
  spendingIncrease,
  spendingDecrease,
  unusualSpending,
  categoryDominating,
  savingsOpportunity,
}

enum InsightSeverity { info, warning, critical }
